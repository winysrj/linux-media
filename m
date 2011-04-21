Return-path: <mchehab@pedra>
Received: from smtp204.alice.it ([82.57.200.100]:44511 "EHLO smtp204.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858Ab1DUJvw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Apr 2011 05:51:52 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Drew Fisher <drew.m.fisher@gmail.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Antonio Ospite <ospite@studenti.unina.it>
Subject: [PATCH 1/3] gspca - kinect: move communications buffers out of stack
Date: Thu, 21 Apr 2011 11:51:34 +0200
Message-Id: <1303379496-12899-2-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1303379496-12899-1-git-send-email-ospite@studenti.unina.it>
References: <4DADF1CB.4050504@redhat.com>
 <1303379496-12899-1-git-send-email-ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Drew Fisher <drew.m.fisher@gmail.com>

Move large communications buffers out of stack and into device
structure. This prevents the frame size from being >1kB and fixes a
compiler warning when CONFIG_FRAME_WARN=1024:

drivers/media/video/gspca/kinect.c: In function ‘send_cmd.clone.0’:
drivers/media/video/gspca/kinect.c:202: warning: the frame size of 1548 bytes is larger than 1024 bytes

Reported-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Drew Fisher <drew.m.fisher@gmail.com>
Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 drivers/media/video/gspca/kinect.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/gspca/kinect.c b/drivers/media/video/gspca/kinect.c
index f85e746..79c4ef5 100644
--- a/drivers/media/video/gspca/kinect.c
+++ b/drivers/media/video/gspca/kinect.c
@@ -62,6 +62,8 @@ struct sd {
 	struct gspca_dev gspca_dev; /* !! must be the first item */
 	uint16_t cam_tag;           /* a sequence number for packets */
 	uint8_t stream_flag;        /* to identify different steram types */
+	uint8_t obuf[0x400];        /* output buffer for control commands */
+	uint8_t ibuf[0x200];        /* input buffer for control commands */
 };
 
 /* V4L2 controls supported by the driver */
@@ -133,8 +135,8 @@ static int send_cmd(struct gspca_dev *gspca_dev, uint16_t cmd, void *cmdbuf,
 	struct sd *sd = (struct sd *) gspca_dev;
 	struct usb_device *udev = gspca_dev->dev;
 	int res, actual_len;
-	uint8_t obuf[0x400];
-	uint8_t ibuf[0x200];
+	uint8_t *obuf = sd->obuf;
+	uint8_t *ibuf = sd->ibuf;
 	struct cam_hdr *chdr = (void *)obuf;
 	struct cam_hdr *rhdr = (void *)ibuf;
 
-- 
1.7.4.4

