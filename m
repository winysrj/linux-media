Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4SKG6pY005051
	for <video4linux-list@redhat.com>; Wed, 28 May 2008 16:16:06 -0400
Received: from QMTA04.emeryville.ca.mail.comcast.net
	(qmta04.emeryville.ca.mail.comcast.net [76.96.30.40])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4SKFqPP001915
	for <video4linux-list@redhat.com>; Wed, 28 May 2008 16:15:53 -0400
Message-ID: <483DBD67.8090508@personnelware.com>
Date: Wed, 28 May 2008 15:15:35 -0500
From: Carl Karsten <carl@personnelware.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <47C8A0C9.4020107@personnelware.com>
	<20080304112519.6f4c748c@gaivota>
In-Reply-To: <20080304112519.6f4c748c@gaivota>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
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

I posted a week ago and haven't heard anything.  How long should I wait before 
posting this? :)

Carl K

Mauro Carvalho Chehab wrote:
> Carl,
> 
> On Fri, 29 Feb 2008 18:18:17 -0600
> Carl Karsten <carl@personnelware.com> wrote:
> 
>> Now that vivi can be something other than /dev/video0, it should tell us what it 
>>   is.  This works for n_devs>1.
>>
>> sudo modprobe vivi n_devs=3
>>
>> [115041.616401] vivi: V4L2 device registered as /dev/video0
>> [115041.616445] vivi: V4L2 device registered as /dev/video1
>> [115041.616481] vivi: V4L2 device registered as /dev/video2
>> [115041.616486] Video Technology Magazine Virtual Video Capture Board 
>> successfully loaded.
> 
> Please, re-send your patches, adding your SOB. Please numberate them with something like 
> [PATCH 1/3] for me to apply at the proper order.
> 

------------------------------------------------------
Patch 1:

diff -r 9d04bba82511 linux/drivers/media/video/vivi.c
--- a/linux/drivers/media/video/vivi.c	Wed May 14 23:14:04 2008 +0000
+++ b/linux/drivers/media/video/vivi.c	Tue May 20 01:51:56 2008 -0500
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
@@ -1086,10 +1088,14 @@ static int vivi_release(void)
  		list_del(list);
  		dev = list_entry(list, struct vivi_dev, vivi_devlist);

-		if (-1 != dev->vfd->minor)
+		if (-1 != dev->vfd->minor) {
  			video_unregister_device(dev->vfd);
-		else
+            printk(KERN_INFO "%s: /dev/video%d unregistered.\n", MODULE_NAME,
dev->vfd->minor);
+        }
+		else {
  			video_device_release(dev->vfd);
+            printk(KERN_INFO "%s: /dev/video%d released.\n", MODULE_NAME,
dev->vfd->minor);
+        }

  		kfree(dev);
  	}
@@ -1202,6 +1208,7 @@ static int __init vivi_init(void)
  			video_nr++;

  		dev->vfd = vfd;
+        printk(KERN_INFO "%s: V4L2 device registered as /dev/video%d\n",
MODULE_NAME, vfd->minor);
  	}

  	if (ret < 0) {
@@ -1209,7 +1216,8 @@ static int __init vivi_init(void)
  		printk(KERN_INFO "Error %d while loading vivi driver\n", ret);
  	} else
  		printk(KERN_INFO "Video Technology Magazine Virtual Video "
-				 "Capture Board successfully loaded.\n");
+                 "Capture Board ver %u.%u.%u successfully loaded.\n",
+        (VIVI_VERSION >> 16) & 0xFF, (VIVI_VERSION >> 8) & 0xFF, VIVI_VERSION &
0xFF);
  	return ret;
  }

------------------------------------------------------
Signed-off-by: Carl Karsten  <carl@personnelware.com>


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
