Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.159])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <albert.comerma@gmail.com>) id 1JbhRy-0001dJ-PH
	for linux-dvb@linuxtv.org; Tue, 18 Mar 2008 20:26:21 +0100
Received: by fg-out-1718.google.com with SMTP id 22so32955fge.25
	for <linux-dvb@linuxtv.org>; Tue, 18 Mar 2008 12:26:12 -0700 (PDT)
Message-ID: <ea4209750803181226k6132671avf860a94632010063@mail.gmail.com>
Date: Tue, 18 Mar 2008 20:26:12 +0100
From: "Albert Comerma" <albert.comerma@gmail.com>
To: linux-dvb@linuxtv.org, "olivier danet" <odanet@caramail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="----=_Part_664_2406295.1205868372238"
Subject: [linux-dvb] PATCH Yuan EC372S support added
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

------=_Part_664_2406295.1205868372238
Content-Type: multipart/alternative;
	boundary="----=_Part_665_23570230.1205868372239"

------=_Part_665_23570230.1205868372239
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi, here is a patch which adds support for Yuan EC372S card. According to
Michel, it works perfectly, according to Antti it gives timeouts.
Please olivier sign-off-by this patch since you did most of the work with
the stk7700p2 modification.

Signed-off-by: Albert Comerma <albert.comerma@gmail.com>

Albert

------=_Part_665_23570230.1205868372239
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi, here is a patch which adds support for Yuan EC372S card. According to Michel, it works perfectly, according to Antti it gives timeouts.<br>Please olivier sign-off-by this patch since you did most of the work with the stk7700p2 modification.<br>
<br>Signed-off-by: Albert Comerma &lt;<a href="mailto:albert.comerma@gmail.com" target="_blank" onclick="return top.js.OpenExtLink(window,event,this)">albert.comerma@gmail.com</a>&gt; <br><br>Albert<br>

------=_Part_665_23570230.1205868372239--

------=_Part_664_2406295.1205868372238
Content-Type: text/x-patch; name=YuanEC372S.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fdyuvqip
Content-Disposition: attachment; filename=YuanEC372S.patch

ZGlmZiAtY3JCIHY0bC1kdmItb3JpZy9saW51eC9kcml2ZXJzL21lZGlhL2R2Yi9kdmItdXNiL2Rp
YjA3MDBfZGV2aWNlcy5jIHY0bC15dWFuL2xpbnV4L2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11c2Iv
ZGliMDcwMF9kZXZpY2VzLmMKKioqIHY0bC1kdmItb3JpZy9saW51eC9kcml2ZXJzL21lZGlhL2R2
Yi9kdmItdXNiL2RpYjA3MDBfZGV2aWNlcy5jCTIwMDgtMDMtMTggMTg6NDk6NDUuMDAwMDAwMDAw
ICswMTAwCi0tLSB2NGwteXVhbi9saW51eC9kcml2ZXJzL21lZGlhL2R2Yi9kdmItdXNiL2RpYjA3
MDBfZGV2aWNlcy5jCTIwMDgtMDMtMTggMjA6MTQ6MjguMDAwMDAwMDAwICswMTAwCioqKioqKioq
KioqKioqKgoqKiogOTA1LDkxMCAqKioqCi0tLSA5MDUsOTExIC0tLS0KICAJCXsgVVNCX0RFVklD
RShVU0JfVklEX0FTVVMsICAgICAgVVNCX1BJRF9BU1VTX1UzMTAwKSB9LAogIC8qIDI1ICovCXsg
VVNCX0RFVklDRShVU0JfVklEX0hBVVBQQVVHRSwgVVNCX1BJRF9IQVVQUEFVR0VfTk9WQV9UX1NU
SUNLXzMpIH0sCiAgCQl7IFVTQl9ERVZJQ0UoVVNCX1ZJRF9IQVVQUEFVR0UsIFVTQl9QSURfSEFV
UFBBVUdFX01ZVFZfVCkgfSwKKyAJCXsgVVNCX0RFVklDRShVU0JfVklEX1lVQU4sIFVTQl9QSURf
WVVBTl9FQzM3MlMpIH0sCiAgCQl7IDAgfQkJLyogVGVybWluYXRpbmcgZW50cnkgKi8KICB9Owog
IE1PRFVMRV9ERVZJQ0VfVEFCTEUodXNiLCBkaWIwNzAwX3VzYl9pZF90YWJsZSk7CioqKioqKioq
KioqKioqKgoqKiogMTA2OSwxMDgwICoqKioKICAJCQl9LAogIAkJfSwKICAKISAJCS5udW1fZGV2
aWNlX2Rlc2NzID0gMSwKICAJCS5kZXZpY2VzID0gewogIAkJCXsgICAiQVNVUyBNeSBDaW5lbWEg
VTMwMDAgTWluaSBEVkJUIFR1bmVyIiwKICAJCQkJeyAmZGliMDcwMF91c2JfaWRfdGFibGVbMjNd
LCBOVUxMIH0sCiAgCQkJCXsgTlVMTCB9LAogIAkJCX0sCiAgCQl9CiAgCX0sIHsgRElCMDcwMF9E
RUZBVUxUX0RFVklDRV9QUk9QRVJUSUVTLAogIAotLS0gMTA3MCwxMDg1IC0tLS0KICAJCQl9LAog
IAkJfSwKICAKISAJCS5udW1fZGV2aWNlX2Rlc2NzID0gMiwKICAJCS5kZXZpY2VzID0gewogIAkJ
CXsgICAiQVNVUyBNeSBDaW5lbWEgVTMwMDAgTWluaSBEVkJUIFR1bmVyIiwKICAJCQkJeyAmZGli
MDcwMF91c2JfaWRfdGFibGVbMjNdLCBOVUxMIH0sCiAgCQkJCXsgTlVMTCB9LAogIAkJCX0sCisg
ICAgICAgICAgICAgICAgICAgICAgICAgeyAgICJZdWFuIEVDMzcyUyIsCisgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICB7ICZkaWIwNzAwX3VzYl9pZF90YWJsZVsyN10sIE5VTEwgfSwK
KyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHsgTlVMTCB9LAorICAgICAgICAgICAg
ICAgICAgICAgICAgIH0KICAJCX0KICAJfSwgeyBESUIwNzAwX0RFRkFVTFRfREVWSUNFX1BST1BF
UlRJRVMsCiAgCmRpZmYgLWNyQiB2NGwtZHZiLW9yaWcvbGludXgvZHJpdmVycy9tZWRpYS9kdmIv
ZHZiLXVzYi9kdmItdXNiLWlkcy5oIHY0bC15dWFuL2xpbnV4L2RyaXZlcnMvbWVkaWEvZHZiL2R2
Yi11c2IvZHZiLXVzYi1pZHMuaAoqKiogdjRsLWR2Yi1vcmlnL2xpbnV4L2RyaXZlcnMvbWVkaWEv
ZHZiL2R2Yi11c2IvZHZiLXVzYi1pZHMuaAkyMDA4LTAzLTE4IDE4OjQ5OjQ1LjAwMDAwMDAwMCAr
MDEwMAotLS0gdjRsLXl1YW4vbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVzYi9kdmItdXNi
LWlkcy5oCTIwMDgtMDMtMTggMjA6MTA6MjguMDAwMDAwMDAwICswMTAwCioqKioqKioqKioqKioq
KgoqKiogNDYsNTMgKioqKgogICNkZWZpbmUgVVNCX1ZJRF9VTFRJTUFfRUxFQ1RST05JQwkJMHgw
NWQ4CiAgI2RlZmluZSBVU0JfVklEX1VOSVdJTEwJCQkJMHgxNTg0CiAgI2RlZmluZSBVU0JfVklE
X1dJREVWSUVXCQkJMHgxNGFhCi0gLyogZG9tIDogcG91ciBnaWdhYnl0ZSB1NzAwMCAqLwogICNk
ZWZpbmUgVVNCX1ZJRF9HSUdBQllURQkJCTB4MTA0NAogIAogIAogIC8qIFByb2R1Y3QgSURzICov
Ci0tLSA0Niw1NCAtLS0tCiAgI2RlZmluZSBVU0JfVklEX1VMVElNQV9FTEVDVFJPTklDCQkweDA1
ZDgKICAjZGVmaW5lIFVTQl9WSURfVU5JV0lMTAkJCQkweDE1ODQKICAjZGVmaW5lIFVTQl9WSURf
V0lERVZJRVcJCQkweDE0YWEKICAjZGVmaW5lIFVTQl9WSURfR0lHQUJZVEUJCQkweDEwNDQKKyAj
ZGVmaW5lIFVTQl9WSURfWVVBTiAgICAgICAgICAgICAgICAgICAgICAgICAgICAweDExNjQKKyAK
ICAKICAKICAvKiBQcm9kdWN0IElEcyAqLwoqKioqKioqKioqKioqKioKKioqIDE4MywxOTEgKioq
KgogICNkZWZpbmUgVVNCX1BJRF9PUEVSQTFfV0FSTQkJCQkweDM4MjkKICAjZGVmaW5lIFVTQl9Q
SURfTElGRVZJRVdfVFZfV0FMS0VSX1RXSU5fQ09MRAkJMHgwNTE0CiAgI2RlZmluZSBVU0JfUElE
X0xJRkVWSUVXX1RWX1dBTEtFUl9UV0lOX1dBUk0JCTB4MDUxMwotIC8qIGRvbSBwb3VyIGdpZ2Fi
eXRlIHU3MDAwICovCiAgI2RlZmluZSBVU0JfUElEX0dJR0FCWVRFX1U3MDAwCQkJCTB4NzAwMQog
ICNkZWZpbmUgVVNCX1BJRF9BU1VTX1UzMDAwCQkJCTB4MTcxZgogICNkZWZpbmUgVVNCX1BJRF9B
U1VTX1UzMTAwCQkJCTB4MTczZgogIAogICNlbmRpZgotLS0gMTg0LDE5MyAtLS0tCiAgI2RlZmlu
ZSBVU0JfUElEX09QRVJBMV9XQVJNCQkJCTB4MzgyOQogICNkZWZpbmUgVVNCX1BJRF9MSUZFVklF
V19UVl9XQUxLRVJfVFdJTl9DT0xECQkweDA1MTQKICAjZGVmaW5lIFVTQl9QSURfTElGRVZJRVdf
VFZfV0FMS0VSX1RXSU5fV0FSTQkJMHgwNTEzCiAgI2RlZmluZSBVU0JfUElEX0dJR0FCWVRFX1U3
MDAwCQkJCTB4NzAwMQogICNkZWZpbmUgVVNCX1BJRF9BU1VTX1UzMDAwCQkJCTB4MTcxZgogICNk
ZWZpbmUgVVNCX1BJRF9BU1VTX1UzMTAwCQkJCTB4MTczZgorICNkZWZpbmUgVVNCX1BJRF9ZVUFO
X0VDMzcyUyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgMHgxZWRjCisgCiAgCiAgI2VuZGlm
Cg==
------=_Part_664_2406295.1205868372238
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_Part_664_2406295.1205868372238--
