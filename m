Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917Ab2J0Ulv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:41:51 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKfpd7004729
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:41:51 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 26/68] [media] au0828: get rid of warning: no previous prototype
Date: Sat, 27 Oct 2012 18:40:44 -0200
Message-Id: <1351370486-29040-27-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/usb/au0828/au0828-cards.c:28:6: warning: no previous prototype for 'hvr950q_cs5340_audio' [-Wmissing-prototypes]
drivers/media/usb/au0828/au0828-video.c:161:6: warning: no previous prototype for 'au0828_uninit_isoc' [-Wmissing-prototypes]
drivers/media/usb/au0828/au0828-video.c:200:5: warning: no previous prototype for 'au0828_init_isoc' [-Wmissing-prototypes]
drivers/media/usb/au0828/au0828-video.c:786:5: warning: no previous prototype for 'au0828_analog_stream_enable' [-Wmissing-prototypes]
drivers/media/usb/au0828/au0828-video.c:813:6: warning: no previous prototype for 'au0828_analog_stream_reset' [-Wmissing-prototypes]
drivers/media/usb/au0828/au0828-video.c:916:6: warning: no previous prototype for 'au0828_vid_buffer_timeout' [-Wmissing-prototypes]
drivers/media/usb/au0828/au0828-video.c:940:6: warning: no previous prototype for 'au0828_vbi_buffer_timeout' [-Wmissing-prototypes]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/au0828/au0828-cards.c |  2 +-
 drivers/media/usb/au0828/au0828-video.c | 16 ++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-cards.c b/drivers/media/usb/au0828/au0828-cards.c
index 448361c..0cb7c28 100644
--- a/drivers/media/usb/au0828/au0828-cards.c
+++ b/drivers/media/usb/au0828/au0828-cards.c
@@ -25,7 +25,7 @@
 #include "media/tuner.h"
 #include "media/v4l2-common.h"
 
-void hvr950q_cs5340_audio(void *priv, int enable)
+static void hvr950q_cs5340_audio(void *priv, int enable)
 {
 	/* Because the HVR-950q shares an i2s bus between the cs5340 and the
 	   au8522, we need to hold cs5340 in reset when using the au8522 */
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 8705855..45387aa 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -158,7 +158,7 @@ static void au0828_irq_callback(struct urb *urb)
 /*
  * Stop and Deallocate URBs
  */
-void au0828_uninit_isoc(struct au0828_dev *dev)
+static void au0828_uninit_isoc(struct au0828_dev *dev)
 {
 	struct urb *urb;
 	int i;
@@ -197,9 +197,9 @@ void au0828_uninit_isoc(struct au0828_dev *dev)
 /*
  * Allocate URBs and start IRQ
  */
-int au0828_init_isoc(struct au0828_dev *dev, int max_packets,
-		     int num_bufs, int max_pkt_size,
-		     int (*isoc_copy) (struct au0828_dev *dev, struct urb *urb))
+static int au0828_init_isoc(struct au0828_dev *dev, int max_packets,
+			    int num_bufs, int max_pkt_size,
+			    int (*isoc_copy) (struct au0828_dev *dev, struct urb *urb))
 {
 	struct au0828_dmaqueue *dma_q = &dev->vidq;
 	int i;
@@ -783,7 +783,7 @@ static int au0828_i2s_init(struct au0828_dev *dev)
  * Auvitek au0828 analog stream enable
  * Please set interface0 to AS5 before enable the stream
  */
-int au0828_analog_stream_enable(struct au0828_dev *d)
+static int au0828_analog_stream_enable(struct au0828_dev *d)
 {
 	dprintk(1, "au0828_analog_stream_enable called\n");
 	au0828_writereg(d, AU0828_SENSORCTRL_VBI_103, 0x00);
@@ -810,7 +810,7 @@ int au0828_analog_stream_disable(struct au0828_dev *d)
 	return 0;
 }
 
-void au0828_analog_stream_reset(struct au0828_dev *dev)
+static void au0828_analog_stream_reset(struct au0828_dev *dev)
 {
 	dprintk(1, "au0828_analog_stream_reset called\n");
 	au0828_writereg(dev, AU0828_SENSORCTRL_100, 0x0);
@@ -913,7 +913,7 @@ static int get_ressource(struct au0828_fh *fh)
 /* This function ensures that video frames continue to be delivered even if
    the ITU-656 input isn't receiving any data (thereby preventing applications
    such as tvtime from hanging) */
-void au0828_vid_buffer_timeout(unsigned long data)
+static void au0828_vid_buffer_timeout(unsigned long data)
 {
 	struct au0828_dev *dev = (struct au0828_dev *) data;
 	struct au0828_dmaqueue *dma_q = &dev->vidq;
@@ -937,7 +937,7 @@ void au0828_vid_buffer_timeout(unsigned long data)
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
 
-void au0828_vbi_buffer_timeout(unsigned long data)
+static void au0828_vbi_buffer_timeout(unsigned long data)
 {
 	struct au0828_dev *dev = (struct au0828_dev *) data;
 	struct au0828_dmaqueue *dma_q = &dev->vbiq;
-- 
1.7.11.7

