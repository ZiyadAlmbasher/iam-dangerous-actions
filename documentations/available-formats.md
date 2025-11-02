# Available formats

```iam-dangerous-actions``` is available in the following different formats, or "sub-lists":


1. A single [list](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/blob/main/lists/iam-dangerous-actions.txt) with **all** the dangerous IAM actions. This list is available as a text file.  

2. A single [list](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/blob/main/lists/iam-actions-all-risks.txt) containing **all** the dangerous IAM actions, where each IAM action is categorised by all the **security risks** combined. This list is available as a text file.

3. A single [list](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/blob/main/lists/explicit-deny-all-actions.txt) of multiple **explicit-deny**  IAM policies. These explicit-deny IAM policies are split to fit IAM policy size limits, and they collectively contain **all** the dangerous IAM actions. The IAM policies are available in JSON format. 

4. Multiple different lists of dangerous IAM actions. **Each** individual list is categorised by a **single security risk**: [PE](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/blob/main/lists/iam-actions-PE-risk.txt), [DC](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/blob/main/lists/iam-actions-DC-risk.txt), [DE](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/blob/main/lists/iam-actions-DE-risk.txt) and [HT](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/blob/main/lists/iam-actions-HT-risk.txt). These lists are available as text files.


5. Multiple **explicit-deny** IAM policies. **Each** individual explicit-deny IAM policy is categorised by a **single security risk**: [PE](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/blob/main/lists/explicit-deny-PE-risk.txt), [DC](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/blob/main/lists/explicit-deny-DC-risk.txt), [DE](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/blob/main/lists/explicit-deny-DE-risk.txt) and [HT](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/blob/main/lists/explicit-deny-HT-risk.txt). These IAM policies are available in JSON format. 

6. A single [list](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/blob/main/lists/iam-actions-NA-risk.txt) of IAM actions labelled as "NA", with **no** security risks. It exists because some important IAM actions only pose security risks when **combined** with other IAM actions. This list will be used in a future project called ```iam-security-risks```. The list is available as a text file.  

<br />
<br />

Back to the main [iam-dangerous-actions page](https://github.com/ZiyadAlmbasher/iam-dangerous-actions).