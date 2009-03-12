Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f178.google.com ([209.85.218.178]:55512 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbZCLUYm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 16:24:42 -0400
MIME-Version: 1.0
In-Reply-To: <200902241700.56099.jarod@redhat.com>
References: <200902241700.56099.jarod@redhat.com>
Date: Thu, 12 Mar 2009 16:24:38 -0400
Message-ID: <37219a840903121324q7b08c8d1ma6d0d3ec4f5eb278@mail.gmail.com>
Subject: Fwd: [stable] [PATCH] 2.6.27.y: fix NULL ptr deref in cx23885
	video_open
From: Michael Krufky <mkrufky@linuxtv.org>
To: stable@kernel.org, LKML <linux-kernel@vger.kernel.org>
Cc: Jarod Wilson <jarod@wilsonet.com>,
	LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Can we have this merged into -stable?  Jarod Wilson sent this last
month, but he left off the cc to stable@kernel.org

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>


---------- Forwarded message ----------
From: Jarod Wilson <jarod@redhat.com>
Date: Tue, Feb 24, 2009 at 6:00 PM
Subject: [stable] [PATCH] 2.6.27.y: fix NULL ptr deref in cx23885 video_open
To: linux-kernel@vger.kernel.org
Cc: Mike Krufky <mkrufky@linuxtv.org>


From: Mark Jenks
https://www.redhat.com/mailman/private/video4linux-list/2009-January/msg00041.html

The Hauppauge WinTV HVR-1800 tv tuner card has both digital and analog
abilities, both of which are supported by v4l/dvb under 2.6.27.y. The analog
side also features a hardware mpeg2 encoder. The HVR-1250 tv tuner card
has both digital and analog abilities, but analog isn't currently supported
under any kernel. These cards both utilize the cx23885 driver, but with
slightly different usage. When the code paths for each card is executed,
they wind up poking a cx23885_devlist, which contains devices from both
of the cards, and access attempts are made to portions of 'struct
cx23885_dev' that aren't valid for that device. Simply add some extra
checks before trying to access these structs.

More gory details:
 http://article.gmane.org/gmane.linux.drivers.dvb/46630

This was triggering on my own system at home w/both cards in it, and
no longer happens with this patch included.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
Reviewed-by: Michael Krufky <mkrufky@linuxtv.org>

---

 drivers/media/video/cx23885/cx23885-417.c   |    2 +-
 drivers/media/video/cx23885/cx23885-video.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-417.c
b/drivers/media/video/cx23885/cx23885-417.c
index 7b0e8c0..19154b6 100644
--- a/drivers/media/video/cx23885/cx23885-417.c
+++ b/drivers/media/video/cx23885/cx23885-417.c
@@ -1585,7 +1585,7 @@ static int mpeg_open(struct inode *inode, struct
file *file)

       list_for_each(list, &cx23885_devlist) {
               h = list_entry(list, struct cx23885_dev, devlist);
-               if (h->v4l_device->minor == minor) {
+               if (h->v4l_device && h->v4l_device->minor == minor) {
                       dev = h;
                       break;
               }
diff --git a/drivers/media/video/cx23885/cx23885-video.c
b/drivers/media/video/cx23885/cx23885-video.c
index 6047c78..a2b5a0c 100644
--- a/drivers/media/video/cx23885/cx23885-video.c
+++ b/drivers/media/video/cx23885/cx23885-video.c
@@ -733,7 +733,7 @@ static int video_open(struct inode *inode, struct
file *file)

       list_for_each(list, &cx23885_devlist) {
               h = list_entry(list, struct cx23885_dev, devlist);
-               if (h->video_dev->minor == minor) {
+               if (h->video_dev && h->video_dev->minor == minor) {
                       dev  = h;
                       type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
               }


--
Jarod Wilson
jarod@redhat.com
