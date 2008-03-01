Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m210Iqj3031106
	for <video4linux-list@redhat.com>; Fri, 29 Feb 2008 19:18:52 -0500
Received: from QMTA02.emeryville.ca.mail.comcast.net
	(qmta02.emeryville.ca.mail.comcast.net [76.96.30.24])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m210IJnd028398
	for <video4linux-list@redhat.com>; Fri, 29 Feb 2008 19:18:20 -0500
Message-ID: <47C8A0C9.4020107@personnelware.com>
Date: Fri, 29 Feb 2008 18:18:17 -0600
From: Carl Karsten <carl@personnelware.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [patch] vivi: registered as /dev/video%d
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

Now that vivi can be something other than /dev/video0, it should tell us what it 
  is.  This works for n_devs>1.

sudo modprobe vivi n_devs=3

[115041.616401] vivi: V4L2 device registered as /dev/video0
[115041.616445] vivi: V4L2 device registered as /dev/video1
[115041.616481] vivi: V4L2 device registered as /dev/video2
[115041.616486] Video Technology Magazine Virtual Video Capture Board 
successfully loaded.

Carl K


diff -r 127f67dea087 linux/drivers/media/video/vivi.c
--- a/linux/drivers/media/video/vivi.c  Tue Feb 26 20:43:56 2008 +0000
+++ b/linux/drivers/media/video/vivi.c  Fri Feb 29 18:15:01 2008 -0600
@@ -47,6 +47,8 @@
  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 20)
  #include <linux/freezer.h>
  #endif
+
+#define MODULE_NAME "vivi"

  /* Wake up at about 30 fps */
  #define WAKE_NUMERATOR 30
@@ -1338,6 +1340,7 @@ static int __init vivi_init(void)
                         video_nr++;

                 dev->vfd = vfd;
+               printk(KERN_INFO "%s: V4L2 device registered as /dev/video%d\n", 
MODULE_NAME, vfd->minor);
         }

         if (ret < 0) {


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
