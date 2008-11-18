Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAIJSsYi026434
	for <video4linux-list@redhat.com>; Tue, 18 Nov 2008 14:28:54 -0500
Received: from pne-smtpout1-sn2.hy.skanova.net
	(pne-smtpout1-sn2.hy.skanova.net [81.228.8.83])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAIJSdWv030377
	for <video4linux-list@redhat.com>; Tue, 18 Nov 2008 14:28:39 -0500
Message-ID: <4923175A.10908@gmail.com>
Date: Tue, 18 Nov 2008 20:28:26 +0100
From: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
MIME-Version: 1.0
To: Hans de Goede <j.w.r.degoede@hhs.nl>, ospite@studenti.unina.it
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, noodles@earth.li,
	qce-ga-devel-request@lists.sourceforge.net
Subject: [gspca-stv06xx]First bits of the new stv0600/stv0610 pushed
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,

As I've written in an earlier mail I've taken a stab at porting over
the old qc-usb driver to the gspca framework.
The driver is nowhere complete but I've gotten it to work on my
Quickcam Web using the vv6410 sensor. There is some untested support
for the HDCS sensors but I need some testing on it (and probably
some bug squashing).

Right now the camera streams a raw bayer image that is converted by
the libv4l, the bridge supposedly suports some kind of bastardizes
jpeg implementation. It's probably not impossible to implement this
 together with libv4l but I'm unsure on how much I'm willing to
spend on this.

This is _not_ a pull request. My current plan is to finish support
for the hdcs and pb0100 sensors before submitting it mainline.

The mercurial source repository is located at
http://linuxtv.org/hg/~eandren/gspca-stv06xx/
please have a look and let me know how it works for you and/or if
you have any comments regarding the style and code.

Best regards,
Erik
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkjF1oACgkQN7qBt+4UG0EGKQCdHBb+qfFUDqhQx/TwX94VzB+T
9FkAnRmVdWrRCMBP4GcY2yYPCZJfLZ8M
=Ylc+
-----END PGP SIGNATURE-----

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
