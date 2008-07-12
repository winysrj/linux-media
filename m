Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from zeus.freepage.ro ([86.35.4.2] helo=freepage.ro)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <aron@aron.ws>) id 1KHlUu-0000Lg-R7
	for linux-dvb@linuxtv.org; Sat, 12 Jul 2008 22:15:13 +0200
Received: from localhost (zeus.freepage.ro [127.0.0.1])
	by freepage.ro (Postfix) with ESMTP id C5DE0794021
	for <linux-dvb@linuxtv.org>; Sat, 12 Jul 2008 23:15:40 +0300 (EEST)
Received: from freepage.ro ([127.0.0.1])
	by localhost (zeus.freepage.ro [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id N78Q7F636kdn for <linux-dvb@linuxtv.org>;
	Sat, 12 Jul 2008 23:15:32 +0300 (EEST)
Received: from mail.aron.ws (aron.ws [195.70.62.6])
	by freepage.ro (Postfix) with ESMTP id 4D57F794001
	for <linux-dvb@linuxtv.org>; Sat, 12 Jul 2008 23:15:29 +0300 (EEST)
MIME-Version: 1.0
Date: Sat, 12 Jul 2008 22:14:39 +0200
From: <aron@aron.ws>
To: linux-dvb@linuxtv.org
Message-ID: <b41e8f3c4a9cb4d75911359c066dfd90@freepage.ro>
Content-Type: multipart/mixed;
	boundary="=_1058e8157b431b8ad412bf465e251ba9"
Subject: Re: [linux-dvb] em28xx problems
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

--=_1058e8157b431b8ad412bf465e251ba9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi!

I've attached the patch that I've promised!
This is my first patch to a software so if something is wrong please don'=
t
behead me!

:)
Aron

--=_1058e8157b431b8ad412bf465e251ba9
Content-Transfer-Encoding: base64
Content-Type: application/octet-stream; name="em28xx.h.diff"; charset="UTF-8"
Content-Disposition: attachment; filename="em28xx.h.diff"

LS0tIGxpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vZW0yOHh4L2VtMjh4eC5oCTIwMDgtMDctMDYg
MDk6MjI6NDMuMDAwMDAwMDAwICswMjAwCisrKyBsaW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2Vt
Mjh4eC9lbTI4eHguaAkyMDA4LTA3LTA1IDIzOjI4OjQyLjAwMDAwMDAwMCArMDIwMApAQCAtNjEs
NiArNjEsNyBAQAogI2RlZmluZSBFTTI4ODBfQk9BUkRfUElOTkFDTEVfUENUVl9IRF9QUk8JMTcK
ICNkZWZpbmUgRU0yODgwX0JPQVJEX0hBVVBQQVVHRV9XSU5UVl9IVlJfOTAwX1IyCTE4CiAjZGVm
aW5lIEVNMjg2MF9CT0FSRF9QT0lOVE5JWF9JTlRSQU9SQUxfQ0FNRVJBICAxOQorI2RlZmluZSBF
TTI4MDBfQk9BUkRfR1JBQkJFRVhfVVNCMjgwMCAgICAgICAgICAgMjAKIAogLyogTGltaXRzIG1p
bmltdW0gYW5kIGRlZmF1bHQgbnVtYmVyIG9mIGJ1ZmZlcnMgKi8KICNkZWZpbmUgRU0yOFhYX01J
Tl9CVUYgNAo=
--=_1058e8157b431b8ad412bf465e251ba9
Content-Transfer-Encoding: base64
Content-Type: application/octet-stream; name="em28xx-cards.c.diff"; charset="UTF-8"
Content-Disposition: attachment; filename="em28xx-cards.c.diff"

LS0tIGxpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vZW0yOHh4L2VtMjh4eC1jYXJkcy5jCTIwMDgt
MDctMDYgMDk6MjI6NDMuMDAwMDAwMDAwICswMjAwCisrKyBsaW51eC9kcml2ZXJzL21lZGlhL3Zp
ZGVvL2VtMjh4eC9lbTI4eHgtY2FyZHMuYwkyMDA4LTA3LTA2IDA5OjMzOjAzLjAwMDAwMDAwMCAr
MDIwMApAQCAtMzUwLDYgKzM1MCwyMSBAQAogCQkJLmFtdXggICAgID0gMSwKIAkJfSB9LAogCX0s
CisJW0VNMjgwMF9CT0FSRF9HUkFCQkVFWF9VU0IyODAwXSA9IHsKKwkJLm5hbWUgICAgICAgICA9
ICJlTVBJQSBUZWNobm9sb2d5LCBJbmMuIEdyYWJCZWVYKyBWaWRlbyBFbmNvZGVyIiwKKwkJLmlz
X2VtMjgwMCAgICA9IDEsCisJCS52Y2hhbm5lbHMgICAgPSAyLAorCQkuZGVjb2RlciAgICAgID0g
RU0yOFhYX1NBQTcxMTMsCisJCS5pbnB1dCAgICAgICAgICA9IHsgeworCQkJLnR5cGUgICAgID0g
RU0yOFhYX1ZNVVhfQ09NUE9TSVRFMSwKKwkJCS52bXV4ICAgICA9IFNBQTcxMTVfQ09NUE9TSVRF
MCwKKwkJCS5hbXV4ICAgICA9IDEsCisJCX0sIHsKKwkJCS50eXBlICAgICA9IEVNMjhYWF9WTVVY
X1NWSURFTywKKwkJCS52bXV4ICAgICA9IFNBQTcxMTVfU1ZJREVPMywKKwkJCS5hbXV4ICAgICA9
IDEsCisJCX0gfSwKKwl9LAogCVtFTTI4MDBfQk9BUkRfS1dPUkxEX1VTQjI4MDBdID0gewogCQku
bmFtZSAgICAgICAgID0gIkt3b3JsZCBVU0IyODAwIiwKIAkJLmlzX2VtMjgwMCAgICA9IDEsCkBA
IC00OTMsNiArNTA4LDggQEAKIAkJCS5kcml2ZXJfaW5mbyA9IEVNMjg4MF9CT0FSRF9URVJSQVRF
Q19IWUJSSURfWFMgfSwKIAl7IFVTQl9ERVZJQ0UoMHgwY2NkLCAweDAwNDcpLAogCQkJLmRyaXZl
cl9pbmZvID0gRU0yODgwX0JPQVJEX1RFUlJBVEVDX1BST0RJR1lfWFMgfSwKKwl7IFVTQl9ERVZJ
Q0UoMHhlYjFhLCAweDI4MDEpLAorCQkJLmRyaXZlcl9pbmZvID0gRU0yODAwX0JPQVJEX0dSQUJC
RUVYX1VTQjI4MDAgfSwKIAl7IH0sCiB9OwogTU9EVUxFX0RFVklDRV9UQUJMRSh1c2IsIGVtMjh4
eF9pZF90YWJsZSk7CkBAIC04MTAsNiArODI3LDggQEAKIAkJYnJlYWs7CiAJY2FzZSAoRU0yODAw
X0JPQVJEX0tXT1JMRF9VU0IyODAwKToKIAkJYnJlYWs7CisJY2FzZSAoRU0yODAwX0JPQVJEX0dS
QUJCRUVYX1VTQjI4MDApOgorCQlicmVhazsKIAl9CiB9CiAK
--=_1058e8157b431b8ad412bf465e251ba9
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--=_1058e8157b431b8ad412bf465e251ba9--
