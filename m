Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBU7wrnU031969
	for <video4linux-list@redhat.com>; Tue, 30 Dec 2008 02:58:53 -0500
Received: from pne-smtpout1-sn2.hy.skanova.net
	(pne-smtpout1-sn2.hy.skanova.net [81.228.8.83])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBU7wd6T010581
	for <video4linux-list@redhat.com>; Tue, 30 Dec 2008 02:58:39 -0500
Message-ID: <4959D4AC.2010007@gmail.com>
Date: Tue, 30 Dec 2008 08:58:36 +0100
From: =?UTF-8?B?RXJpayBBbmRyw6lu?= <erik.andren@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
References: <20081229203513.13b6b1ca@pedra.chehab.org>
In-Reply-To: <20081229203513.13b6b1ca@pedra.chehab.org>
Content-Type: multipart/mixed; boundary="------------090106070803010507000505"
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: Warning on stv06xx
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
--------------090106070803010507000505
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1



Mauro Carvalho Chehab wrote:
> Hi Erik,
> 
> Could you please take a look on this?
> 
> drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c: In function ‘hdcs_set_size’:
> drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c:301: warning: ‘y’ may be used uninitialized in this function
> 
> By looking on that function, it seems that this condition can happen.
> 
> Cheers,
> Mauro
> 

Thanks for the heads up.
The attached patch should fix it.

Signed-off-by: Erik Andrén <erik.andren@gmail.com>




-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklZ1KwACgkQN7qBt+4UG0HZGgCdE5xskMxhhD/l/a1oRQE+NwFk
3h0An38PySqZ17FkZKFCb8XbX05n/P93
=rNh+
-----END PGP SIGNATURE-----

--------------090106070803010507000505
Content-Type: text/x-diff;
 name="fix_y_related_warn.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix_y_related_warn.diff"

diff -r 75aa52e36cc9 linux/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c
--- a/linux/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c	Tue Dec 30 01:31:59 2008 -0200
+++ b/linux/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c	Tue Dec 30 08:54:10 2008 +0100
@@ -317,8 +317,10 @@
 
 		y = (hdcs->array.height - HDCS_1020_BOTTOM_Y_SKIP - height) / 2
 				+ hdcs->array.top;
-	} else if (height > hdcs->array.height) {
-		height = hdcs->array.height;
+	} else {
+		if (height > hdcs->array.height)
+			height = hdcs->array.height;
+
 		y = hdcs->array.top + (hdcs->array.height - height) / 2;
 	}
 

--------------090106070803010507000505
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------090106070803010507000505--
