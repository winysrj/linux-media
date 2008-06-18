Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5I1ku66030642
	for <video4linux-list@redhat.com>; Tue, 17 Jun 2008 21:46:56 -0400
Received: from psmtp.com (exprod8ob111.obsmtp.com [64.18.3.21])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m5I1kceL008115
	for <video4linux-list@redhat.com>; Tue, 17 Jun 2008 21:46:39 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="----_=_NextPart_001_01C8D0E4.FBCDCF97"
Date: Tue, 17 Jun 2008 18:45:26 -0700
Message-ID: <1822849CB0478545ADCFB217EF4A340584E53A@sedah.startrac.com>
From: "Dan Taylor" <dtaylor@startrac.com>
To: <video4linux-list@redhat.com>
Subject: [PATCH] Avermedia A16D composite input
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

This is a multi-part message in MIME format.

------_=_NextPart_001_01C8D0E4.FBCDCF97
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

This is a patch against 78442352b885.  It adds composite support for the
included Composite->S-video adapter that comes with the Avermedia A16D.
The work that went into DVB support for the card made this much simpler
than my earlier version.

=20

As before, it has been tested with a signal generator and an iPod.

=20

I appreciate the DVB work and hope to be testing it early next week.
Does anyone have a sample mplayer config file for DVB-T?

=20

diff -upr linux-2.6.26-v4l/drivers/media/video/saa7134/saa7134-cards.c
linux-2.6.26-v4lc/drivers/media/video/saa7134/saa7134-cards.c
--- linux-2.6.26-v4l/drivers/media/video/saa7134/saa7134-cards.c
2008-06-15 05:33:42.000000000 -0800
+++ linux-2.6.26-v4lc/drivers/media/video/saa7134/saa7134-cards.c
2008-06-17 16:19:14.000000000 -0800
@@ -4269,6 +4269,10 @@ struct saa7134_board saa7134_boards[] =3D=20
                  .name =3D name_svideo,
                  .vmux =3D 8,
                  .amux =3D LINE1,
+           }, {
+                 .name =3D name_comp,
+                 .vmux =3D 0,
+                 .amux =3D LINE1,
            } },
            .radio =3D {
                  .name =3D name_radio,
=20

=20

=20

=20


------_=_NextPart_001_01C8D0E4.FBCDCF97
Content-Type: application/octet-stream;
	name="A16D-composite.patch"
Content-Transfer-Encoding: base64
Content-Description: A16D-composite.patch
Content-Disposition: attachment;
	filename="A16D-composite.patch"

ZGlmZiAtdXByIGxpbnV4LTIuNi4yNi12NGwvZHJpdmVycy9tZWRpYS92aWRlby9zYWE3MTM0L3Nh
YTcxMzQtY2FyZHMuYyBsaW51eC0yLjYuMjYtdjRsYy9kcml2ZXJzL21lZGlhL3ZpZGVvL3NhYTcx
MzQvc2FhNzEzNC1jYXJkcy5jCi0tLSBsaW51eC0yLjYuMjYtdjRsL2RyaXZlcnMvbWVkaWEvdmlk
ZW8vc2FhNzEzNC9zYWE3MTM0LWNhcmRzLmMJMjAwOC0wNi0xNSAwNTozMzo0Mi4wMDAwMDAwMDAg
LTA4MDAKKysrIGxpbnV4LTIuNi4yNi12NGxjL2RyaXZlcnMvbWVkaWEvdmlkZW8vc2FhNzEzNC9z
YWE3MTM0LWNhcmRzLmMJMjAwOC0wNi0xNyAxNjoxOToxNC4wMDAwMDAwMDAgLTA4MDAKQEAgLTQy
NjksNiArNDI2OSwxMCBAQCBzdHJ1Y3Qgc2FhNzEzNF9ib2FyZCBzYWE3MTM0X2JvYXJkc1tdID0g
CiAJCQkubmFtZSA9IG5hbWVfc3ZpZGVvLAogCQkJLnZtdXggPSA4LAogCQkJLmFtdXggPSBMSU5F
MSwKKwkJfSwgeworCQkJLm5hbWUgPSBuYW1lX2NvbXAsCisJCQkudm11eCA9IDAsCisJCQkuYW11
eCA9IExJTkUxLAogCQl9IH0sCiAJCS5yYWRpbyA9IHsKIAkJCS5uYW1lID0gbmFtZV9yYWRpbywK

------_=_NextPart_001_01C8D0E4.FBCDCF97
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
------_=_NextPart_001_01C8D0E4.FBCDCF97--
