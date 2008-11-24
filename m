Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAOL31im022487
	for <video4linux-list@redhat.com>; Mon, 24 Nov 2008 16:03:01 -0500
Received: from pne-smtpout1-sn1.fre.skanova.net
	(pne-smtpout1-sn1.fre.skanova.net [81.228.11.98])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAOL2sSM032506
	for <video4linux-list@redhat.com>; Mon, 24 Nov 2008 16:02:54 -0500
Message-ID: <492B15E1.2080207@gmail.com>
Date: Mon, 24 Nov 2008 22:00:17 +0100
From: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
MIME-Version: 1.0
To: Hans de Goede <j.w.r.degoede@hhs.nl>, noodles@earth.li
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, qce-ga-devel@lists.sourceforge.net
Subject: Please test the gspca-stv06xx branch
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

I've reworked the driver somewhat and added initial support for th
pb0100.
Please test with the latest version of the gspca-stv06xx tree and
see if you can get an image. Ekiga works best for me at the moment.

If it doesn't please enable full debug output by supplying the debug
parameter to the gspca_main kernel module and send me the output.
Patches fixing problems are of course even more welcome :)

Regards,
Erik
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkrFeEACgkQN7qBt+4UG0FqDACffx7ziaiOfcMX8EpOjGN+nBM+
iecAnRHR+ab6XwxrOabKCblJWoFH7Oo5
=L1hW
-----END PGP SIGNATURE-----

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
