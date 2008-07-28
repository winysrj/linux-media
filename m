Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6SJxFUJ028242
	for <video4linux-list@redhat.com>; Mon, 28 Jul 2008 15:59:15 -0400
Received: from smtp6.pp.htv.fi (smtp6.pp.htv.fi [213.243.153.40])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6SJx1fa025198
	for <video4linux-list@redhat.com>; Mon, 28 Jul 2008 15:59:02 -0400
Date: Mon, 28 Jul 2008 22:58:19 +0300
From: Adrian Bunk <bunk@kernel.org>
To: mchehab@infradead.org
Message-ID: <20080728195819.GB7713@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
	linux-kernel@vger.kernel.org
Subject: [2.6 patch] fix drivers/media/video/arv.c compilation
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

This patch fixes the following compile errors:

<--  snip  -->

...
  CC [M]  drivers/media/video/arv.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/media/video/arv.c: In function 'ar_ioctl':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/media/video/arv.c:544: error: implicit declaration of function 'video_usercopy'
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/media/video/arv.c: At top level:
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/media/video/arv.c:758: error: unknown field 'type' specified in initializer
make[4]: *** [drivers/media/video/arv.o] Error 1

<--  snip  -->

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/media/video/arv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

0745b77aceec2e450f4d4ca4c8e59f1bfbacd977 
diff --git a/drivers/media/video/arv.c b/drivers/media/video/arv.c
index 56ebfd5..9e436ad 100644
--- a/drivers/media/video/arv.c
+++ b/drivers/media/video/arv.c
@@ -29,6 +29,7 @@
 #include <linux/sched.h>
 #include <linux/videodev.h>
 #include <media/v4l2-common.h>
+#include <media/v4l2-ioctl.h>
 #include <linux/mutex.h>
 
 #include <asm/uaccess.h>
@@ -755,7 +756,6 @@ static const struct file_operations ar_fops = {
 
 static struct video_device ar_template = {
 	.name		= "Colour AR VGA",
-	.type		= VID_TYPE_CAPTURE,
 	.fops		= &ar_fops,
 	.release	= ar_release,
 	.minor		= -1,

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
