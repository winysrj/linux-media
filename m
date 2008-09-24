Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web52908.mail.re2.yahoo.com ([206.190.49.18])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <rankincj@yahoo.com>) id 1KiavK-0003IT-AP
	for linux-dvb@linuxtv.org; Wed, 24 Sep 2008 22:25:23 +0200
Date: Wed, 24 Sep 2008 13:24:47 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-374600220-1222287887=:36358"
Message-ID: <573008.36358.qm@web52908.mail.re2.yahoo.com>
Subject: [linux-dvb] [PATCH] Add remote control support to Nova-TD (52009)
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

--0-374600220-1222287887=:36358
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

This patch is against the 2.6.26.5 kernel, and adds remote control support =
for the Hauppauge WinTV Nova-TD (Diversity) model. (That's the 52009 versio=
n.) It also adds the key-codes for the credit-card style remote control tha=
t comes with this particular adapter.

Cheers,
Chris

Signed-off-by: Chris Rankin <rankincj@yahoo.com>
=0A=0A=0A      
--0-374600220-1222287887=:36358
Content-Type: text/x-patch; name="NOVA-TD-RC.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="NOVA-TD-RC.diff"

LS0tIGxpbnV4LTIuNi4yNi9kcml2ZXJzL21lZGlhL2R2Yi9kdmItdXNiL2Rp
YjA3MDBfZGV2aWNlcy5jLm9yaWcJMjAwOC0wOS0yMCAyMjo1ODoxNS4wMDAw
MDAwMDAgKzAxMDAKKysrIGxpbnV4LTIuNi4yNi9kcml2ZXJzL21lZGlhL2R2
Yi9kdmItdXNiL2RpYjA3MDBfZGV2aWNlcy5jCTIwMDgtMDktMjQgMTM6MDY6
NDMuMDAwMDAwMDAwICswMTAwCkBAIC02NzcsNiArNjc3LDQzIEBACiAJeyAw
eDAxLCAweDdkLCBLRVlfVk9MVU1FRE9XTiB9LAogCXsgMHgwMiwgMHg0Miwg
S0VZX0NIQU5ORUxVUCB9LAogCXsgMHgwMCwgMHg3ZCwgS0VZX0NIQU5ORUxE
T1dOIH0sCisKKwkvKiBLZXkgY29kZXMgZm9yIE5vdmEtVEQgImNyZWRpdCBj
YXJkIiByZW1vdGUgY29udHJvbC4gKi8KKwl7IDB4MWQsIDB4MDAsIEtFWV8w
IH0sCisJeyAweDFkLCAweDAxLCBLRVlfMSB9LAorCXsgMHgxZCwgMHgwMiwg
S0VZXzIgfSwKKwl7IDB4MWQsIDB4MDMsIEtFWV8zIH0sCisJeyAweDFkLCAw
eDA0LCBLRVlfNCB9LAorCXsgMHgxZCwgMHgwNSwgS0VZXzUgfSwKKwl7IDB4
MWQsIDB4MDYsIEtFWV82IH0sCisJeyAweDFkLCAweDA3LCBLRVlfNyB9LAor
CXsgMHgxZCwgMHgwOCwgS0VZXzggfSwKKwl7IDB4MWQsIDB4MDksIEtFWV85
IH0sCisJeyAweDFkLCAweDBhLCBLRVlfVEVYVCB9LAorCXsgMHgxZCwgMHgw
ZCwgS0VZX01FTlUgfSwKKwl7IDB4MWQsIDB4MGYsIEtFWV9NVVRFIH0sCisJ
eyAweDFkLCAweDEwLCBLRVlfVk9MVU1FVVAgfSwKKwl7IDB4MWQsIDB4MTEs
IEtFWV9WT0xVTUVET1dOIH0sCisJeyAweDFkLCAweDEyLCBLRVlfQ0hBTk5F
TCB9LAorCXsgMHgxZCwgMHgxNCwgS0VZX1VQIH0sCisJeyAweDFkLCAweDE1
LCBLRVlfRE9XTiB9LAorCXsgMHgxZCwgMHgxNiwgS0VZX0xFRlQgfSwKKwl7
IDB4MWQsIDB4MTcsIEtFWV9SSUdIVCB9LAorCXsgMHgxZCwgMHgxYywgS0VZ
X1RWIH0sCisJeyAweDFkLCAweDFlLCBLRVlfTkVYVCB9LAorCXsgMHgxZCwg
MHgxZiwgS0VZX0JBQ0sgfSwKKwl7IDB4MWQsIDB4MjAsIEtFWV9DSEFOTkVM
VVAgfSwKKwl7IDB4MWQsIDB4MjEsIEtFWV9DSEFOTkVMRE9XTiB9LAorCXsg
MHgxZCwgMHgyNCwgS0VZX0xBU1QgfSwKKwl7IDB4MWQsIDB4MjUsIEtFWV9P
SyB9LAorCXsgMHgxZCwgMHgzMCwgS0VZX1BBVVNFIH0sCisJeyAweDFkLCAw
eDMyLCBLRVlfUkVXSU5EIH0sCisJeyAweDFkLCAweDM0LCBLRVlfRkFTVEZP
UldBUkQgfSwKKwl7IDB4MWQsIDB4MzUsIEtFWV9QTEFZIH0sCisJeyAweDFk
LCAweDM2LCBLRVlfU1RPUCB9LAorCXsgMHgxZCwgMHgzNywgS0VZX1JFQ09S
RCB9LAorCXsgMHgxZCwgMHgzYiwgS0VZX0dPVE8gfSwKKwl7IDB4MWQsIDB4
M2QsIEtFWV9QT1dFUiB9LAogfTsKIAogLyogU1RLNzcwMFA6IEhhdXBwYXVn
ZSBOb3ZhLVQgU3RpY2ssIEFWZXJNZWRpYSBWb2xhciAqLwpAQCAtMTM4Nyw3
ICsxNDI0LDEyIEBACiAJCQkJeyAmZGliMDcwMF91c2JfaWRfdGFibGVbMzVd
LCBOVUxMIH0sCiAJCQkJeyBOVUxMIH0sCiAJCQl9Ci0JCX0KKwkJfSwKKwor
CQkucmNfaW50ZXJ2YWwgICAgICA9IERFRkFVTFRfUkNfSU5URVJWQUwsCisJ
CS5yY19rZXlfbWFwICAgICAgID0gZGliMDcwMF9yY19rZXlzLAorCQkucmNf
a2V5X21hcF9zaXplICA9IEFSUkFZX1NJWkUoZGliMDcwMF9yY19rZXlzKSwK
KwkJLnJjX3F1ZXJ5ICAgICAgICAgPSBkaWIwNzAwX3JjX3F1ZXJ5CiAJfSwg
eyBESUIwNzAwX0RFRkFVTFRfREVWSUNFX1BST1BFUlRJRVMsCiAKIAkJLm51
bV9hZGFwdGVycyA9IDEsCg==

--0-374600220-1222287887=:36358
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--0-374600220-1222287887=:36358--
