Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m226YSAg025229
	for <video4linux-list@redhat.com>; Sun, 2 Mar 2008 01:34:28 -0500
Received: from QMTA07.emeryville.ca.mail.comcast.net
	(qmta07.emeryville.ca.mail.comcast.net [76.96.30.64])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m226Xu4M021278
	for <video4linux-list@redhat.com>; Sun, 2 Mar 2008 01:33:56 -0500
Message-ID: <47CA4A58.3020203@personnelware.com>
Date: Sun, 02 Mar 2008 00:34:00 -0600
From: Carl Karsten <carl@personnelware.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <47C8A0C9.4020107@personnelware.com>
In-Reply-To: <47C8A0C9.4020107@personnelware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [patch] vivi: registered as /dev/video%d
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

added un registered messages.

Carl K


diff -r 127f67dea087 linux/drivers/media/video/vivi.c
--- a/linux/drivers/media/video/vivi.c	Tue Feb 26 20:43:56 2008 +0000
+++ b/linux/drivers/media/video/vivi.c	Sun Mar 02 00:33:27 2008 -0600
@@ -48,6 +48,8 @@
  #include <linux/freezer.h>
  #endif

+#define MODULE_NAME "vivi"
+
  /* Wake up at about 30 fps */
  #define WAKE_NUMERATOR 30
  #define WAKE_DENOMINATOR 1001
@@ -56,7 +58,7 @@
  #include "font.h"

  #define VIVI_MAJOR_VERSION 0
-#define VIVI_MINOR_VERSION 4
+#define VIVI_MINOR_VERSION 5
  #define VIVI_RELEASE 0
  #define VIVI_VERSION \
  	KERNEL_VERSION(VIVI_MAJOR_VERSION, VIVI_MINOR_VERSION, VIVI_RELEASE)
@@ -1220,10 +1222,14 @@ static int vivi_release(void)
  		list_del(list);
  		dev = list_entry(list, struct vivi_dev, vivi_devlist);

-		if (-1 != dev->vfd->minor)
+		if (-1 != dev->vfd->minor) {
  			video_unregister_device(dev->vfd);
-		else
+			printk(KERN_INFO "%s: /dev/video%d unregistered.\n", MODULE_NAME, 
dev->vfd->minor);
+		}
+		else {
  			video_device_release(dev->vfd);
+			printk(KERN_INFO "%s: /dev/video%d released.\n", MODULE_NAME, dev->vfd->minor);
+		}

  		kfree(dev);
  	}
@@ -1338,6 +1344,7 @@ static int __init vivi_init(void)
  			video_nr++;

  		dev->vfd = vfd;
+		printk(KERN_INFO "%s: V4L2 device registered as /dev/video%d\n", MODULE_NAME, 
vfd->minor);
  	}

  	if (ret < 0) {
@@ -1345,7 +1352,8 @@ static int __init vivi_init(void)
  		printk(KERN_INFO "Error %d while loading vivi driver\n", ret);
  	} else
  		printk(KERN_INFO "Video Technology Magazine Virtual Video "
-				 "Capture Board successfully loaded.\n");
+				 "Capture Board ver %u.%u.%u successfully loaded.\n",
+        (VIVI_VERSION >> 16) & 0xFF, (VIVI_VERSION >> 8) & 0xFF, VIVI_VERSION & 
0xFF);
  	return ret;
  }


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
