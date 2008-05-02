Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from viefep18-int.chello.at ([213.46.255.22]
	helo=viefep23-int.chello.at)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rscheidegger_lists@hispeed.ch>) id 1Js28B-0002yz-Qm
	for linux-dvb@linuxtv.org; Fri, 02 May 2008 22:45:25 +0200
Received: from [192.168.1.157] (really [77.57.60.184])
	by viefep23-int.chello.at
	(InterMail vM.7.08.02.00 201-2186-121-20061213) with ESMTP
	id <20080502204448.FHS14978.viefep23-int.chello.at@[192.168.1.157]>
	for <linux-dvb@linuxtv.org>; Fri, 2 May 2008 22:44:48 +0200
Message-ID: <481B7D43.2050200@hispeed.ch>
Date: Fri, 02 May 2008 22:44:51 +0200
From: Roland Scheidegger <rscheidegger_lists@hispeed.ch>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="------------090406000801010408020202"
Subject: [linux-dvb] mantis crash...
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

This is a multi-part message in MIME format.
--------------090406000801010408020202
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This was reported before, the current mantis driver will cause a page
fault in mantis_dvb_start_feed.
The reason for this is commit f5b1f9d491bfabbd23ec415e647f3d65ea1930eb
"Implement HIF Mem Read/Write operations". I don't know how HIF memory
reads/writes are supposed to work, but there seems to be some mixup
between register contents and register addresses. Clearly, 0xfffffff is
not a valid mmaped reg address and as such writing to it blows up
accordingly.
The attached patch fixes that (reverts part of the above commit). The
same bug also seems to be present in the hif.c file, though I don't know
how it should work there (and it looks like that code won't get touched
here).

Roland



--------------090406000801010408020202
Content-Type: application/mbox;
 name="mantisdma.diff"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="mantisdma.diff"

LS0tIGEvbGludXgvZHJpdmVycy9tZWRpYS9kdmIvbWFudGlzL21hbnRpc19kbWEuYwlXZWQg
QXByIDE2IDE1OjIyOjE2IDIwMDggKzA0MDAKKysrIGIvbGludXgvZHJpdmVycy9tZWRpYS9k
dmIvbWFudGlzL21hbnRpc19kbWEuYwlUdWUgQXByIDIyIDE5OjQyOjQ2IDIwMDggKzAyMDAK
QEAgLTE5MCw3ICsxOTAsNyBAQCB2b2lkIG1hbnRpc19kbWFfc3RhcnQoc3RydWN0IG1hbnRp
c19wY2kgCiAKIAltYW50aXNfcmlzY19wcm9ncmFtKG1hbnRpcyk7CiAJbW13cml0ZShtYW50
aXMtPnJpc2NfZG1hLCBNQU5USVNfUklTQ19TVEFSVCk7Ci0JbW13cml0ZShtbXJlYWQoTUFO
VElTX0dQSUZfSElGQUREUikgfCBNQU5USVNfR1BJRl9ISUZSRFdSTiwgTUFOVElTX0dQSUZf
SElGQUREUik7CisJbW13cml0ZShtbXJlYWQoTUFOVElTX0dQSUZfQUREUikgfCBNQU5USVNf
R1BJRl9ISUZSRFdSTiwgTUFOVElTX0dQSUZfQUREUik7CiAKIAltbXdyaXRlKDAsIE1BTlRJ
U19ETUFfQ1RMKTsKIAltYW50aXMtPmxhc3RfYmxvY2sgPSBtYW50aXMtPmZpbmlzaGVkX2Js
b2NrID0gMDsKQEAgLTIxMCw3ICsyMTAsNyBAQCB2b2lkIG1hbnRpc19kbWFfc3RvcChzdHJ1
Y3QgbWFudGlzX3BjaSAqCiAJbWFzayA9IG1tcmVhZChNQU5USVNfSU5UX01BU0spOwogCWRw
cmludGsodmVyYm9zZSwgTUFOVElTX0RFQlVHLCAxLCAiTWFudGlzIFN0b3AgRE1BIGVuZ2lu
ZSIpOwogCi0JbW13cml0ZSgobW1yZWFkKE1BTlRJU19HUElGX0hJRkFERFIpICYgKH4oTUFO
VElTX0dQSUZfSElGUkRXUk4pKSksIE1BTlRJU19HUElGX0hJRkFERFIpOworCW1td3JpdGUo
KG1tcmVhZChNQU5USVNfR1BJRl9BRERSKSAmICh+KE1BTlRJU19HUElGX0hJRlJEV1JOKSkp
LCBNQU5USVNfR1BJRl9BRERSKTsKIAogCW1td3JpdGUoKG1tcmVhZChNQU5USVNfRE1BX0NU
TCkgJiB+KE1BTlRJU19GSUZPX0VOIHwKIAkJCQkJICAgIE1BTlRJU19EQ0FQX0VOIHwK
--------------090406000801010408020202
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------090406000801010408020202--
