Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9BK8imR024337
	for <video4linux-list@redhat.com>; Sat, 11 Oct 2008 16:08:44 -0400
Received: from smtp4-g19.free.fr (smtp4-g19.free.fr [212.27.42.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9BK8W5K007028
	for <video4linux-list@redhat.com>; Sat, 11 Oct 2008 16:08:32 -0400
Message-ID: <48F107D1.2020902@free.fr>
Date: Sat, 11 Oct 2008 22:08:49 +0200
From: Thierry Merle <thierry.merle@free.fr>
MIME-Version: 1.0
To: Linux DVB Mailing List <linux-dvb@linuxtv.org>,
	Linux and Kernel Video <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: 
Subject: [PATCH] em28xx-dvb: dvb_init() code factorization
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

Hello all,
here is a trivial patch that does code factorization between cases in dvb_init() function of the em28xx-dvb component.
Is there a reason not to do that?

Cheers,
Thierry

patch description:

In dvb_init(),
        case EM2880_BOARD_TERRATEC_HYBRID_XS:
        case EM2880_BOARD_KWORLD_DVB_310U:
can be put in the same case than EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900
since they do the same thing.

Priority: normal

Signed-off-by: Thierry MERLE <thierry.merle@free.fr>

diff -r 1e7e0b56d97b -r 5da1a92af6a1 linux/drivers/media/video/em28xx/em28xx-dvb.c
--- a/linux/drivers/media/video/em28xx/em28xx-dvb.c	Sat Oct 11 12:44:38 2008 -0300
+++ b/linux/drivers/media/video/em28xx/em28xx-dvb.c	Sat Oct 11 21:56:13 2008 +0200
@@ -422,6 +422,8 @@
 		}
 		break;
 	case EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900:
+	case EM2880_BOARD_TERRATEC_HYBRID_XS:
+	case EM2880_BOARD_KWORLD_DVB_310U:
 		dvb->frontend = dvb_attach(zl10353_attach,
 					   &em28xx_zl10353_with_xc3028,
 					   &dev->i2c_adap);
@@ -443,24 +445,6 @@
 		}
 		break;
 #endif
-	case EM2880_BOARD_TERRATEC_HYBRID_XS:
-		dvb->frontend = dvb_attach(zl10353_attach,
-						&em28xx_zl10353_with_xc3028,
-						&dev->i2c_adap);
-		if (attach_xc3028(0x61, dev) < 0) {
-			 result = -EINVAL;
-			goto out_free;
-		}
-		break;
-	case EM2880_BOARD_KWORLD_DVB_310U:
-		dvb->frontend = dvb_attach(zl10353_attach,
-						&em28xx_zl10353_with_xc3028,
-						&dev->i2c_adap);
-		if (attach_xc3028(0x61, dev) < 0) {
-			result = -EINVAL;
-			goto out_free;
-		}
-		break;
 	default:
 		printk(KERN_ERR "%s/2: The frontend of your DVB/ATSC card"
 				" isn't supported yet\n",

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
