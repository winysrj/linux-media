Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <e5df86c90901051829g382b2ef1tecb57c9f3b17c15f@mail.gmail.com>
Date: Mon, 5 Jan 2009 20:29:27 -0600
From: "Mark Jenks" <mjenks1968@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] [PATCH] cx23885 Fix for oops if you install HVR-1250
	and HVR-1800 in the same computer.
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Analog support for HVR-1250 has not been completed, but does exist for
the HVR-1800.

Since both cards use the same driver, it tries to create the analog
dev for both devices, which is not possible.

This causes a NULL error to show up in video_open and mpeg_open.

-Mark

Signed-off-by: Mark Jenks <mjenks1968@gmail.com>


--- a/linux/drivers/media/video/
cx23885/cx23885-417.c   2009-01-01 14:27:15.000000000 -0600
+++ b/linux/drivers/media/video/cx23885/cx23885-417.c   2009-01-01
14:27:39.000000000 -0600
@@ -1593,7 +1593,8 @@
        lock_kernel();
        list_for_each(list, &cx23885_devlist) {
                h = list_entry(list, struct cx23885_dev, devlist);
-               if (h->v4l_device->minor == minor) {
+               if (h->v4l_device &&
+                   h->v4l_device->minor == minor) {
                        dev = h;
                        break;
                }
--- a/linux/drivers/media/video/cx23885/cx23885-video.c Fri Dec 26
08:07:39 2008 -0200
+++ b/linux/drivers/media/video/cx23885/cx23885-video.c Sun Dec 28
16:34:04 2008 -0500
@@ -786,7 +786,8 @@ static int video_open(struct inode *inod
       lock_kernel();
       list_for_each(list, &cx23885_devlist) {
               h = list_entry(list, struct cx23885_dev, devlist);
-               if (h->video_dev->minor == minor) {
+               if (h->video_dev &&
+                   h->video_dev->minor == minor) {
                       dev  = h;
                       type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
               }

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
