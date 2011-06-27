Return-path: <mchehab@pedra>
Received: from smtp1-g21.free.fr ([212.27.42.1]:55316 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757432Ab1F0Koh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2011 06:44:37 -0400
Date: Mon, 27 Jun 2011 12:45:58 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 00/14] Remove linux/version.h from most drivers/media
Message-ID: <20110627124558.08cd8684@tele>
In-Reply-To: <4E07808C.9060105@redhat.com>
References: <20110626130620.4b5ed679@pedra>
	<20110626201420.018490cd@tele>
	<4E07808C.9060105@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 26 Jun 2011 15:55:08 -0300
Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> I'll move it to the right changeset at the version 2 of this series.

Hi Mauro,

I have some changes to the gspca.c patch
- the version must stay 2.12.0
- the 'info' may be simplified:

diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index e526aa3..1aa6ae2 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -24,7 +24,6 @@
 #define MODULE_NAME "gspca"
 
 #include <linux/init.h>
-#include <linux/version.h>
 #include <linux/fs.h>
 #include <linux/vmalloc.h>
 #include <linux/sched.h>
@@ -51,11 +50,12 @@
 #error "DEF_NURBS too big"
 #endif
 
+#define DRIVER_VERSION_NUMBER	"2.12.0"
+
 MODULE_AUTHOR("Jean-François Moine <http://moinejf.free.fr>");
 MODULE_DESCRIPTION("GSPCA USB Camera Driver");
 MODULE_LICENSE("GPL");
-
-#define DRIVER_VERSION_NUMBER	KERNEL_VERSION(2, 12, 0)
+MODULE_VERSION(DRIVER_VERSION_NUMBER);
 
 #ifdef GSPCA_DEBUG
 int gspca_debug = D_ERR | D_PROBE;
@@ -1291,7 +1291,6 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	}
 	usb_make_path(gspca_dev->dev, (char *) cap->bus_info,
 			sizeof(cap->bus_info));
-	cap->version = DRIVER_VERSION_NUMBER;
 	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE
 			  | V4L2_CAP_STREAMING
 			  | V4L2_CAP_READWRITE;
@@ -2478,10 +2477,7 @@ EXPORT_SYMBOL(gspca_auto_gain_n_exposure);
 /* -- module insert / remove -- */
 static int __init gspca_init(void)
 {
-	info("v%d.%d.%d registered",
-		(DRIVER_VERSION_NUMBER >> 16) & 0xff,
-		(DRIVER_VERSION_NUMBER >> 8) & 0xff,
-		DRIVER_VERSION_NUMBER & 0xff);
+	info("v" DRIVER_VERSION_NUMBER " registered");
 	return 0;
 }
 static void __exit gspca_exit(void)


-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
