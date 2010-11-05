Return-path: <mchehab@gaivota>
Received: from smtp206.alice.it ([82.57.200.102]:50266 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476Ab0KEWJK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Nov 2010 18:09:10 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: stable@kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	=?UTF-8?q?Jean-Fran=C3=A7ois=20Moine?= <moinejf@free.fr>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: [PATCH] [media] gspca - main: Fix a regression with the PS3 Eye webcam
Date: Fri,  5 Nov 2010 23:08:12 +0100
Message-Id: <1288994892-6681-1-git-send-email-ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: =?UTF-8?q?Jean-Fran=C3=A7ois=20Moine?= <moinejf@free.fr>

commit f43402fa55bf5e7e190c176343015122f694857c upstream.

When audio is present, some alternate settings were skipped.
This prevented some webcams to work, especially when bulk transfer was used.
This patch permits to use the last or only alternate setting.

Reported-by: Antonio Ospite <ospite@studenti.unina.it>
Tested-by: Antonio Ospite <ospite@studenti.unina.it>
Signed-off-by: Jean-François Moine <moinejf@free.fr>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---

This is to be applied to 2.6.36 only, as the regression was introduced there.
I don't know how many distributors are shipping 2.6.36 and how urgent this can
be, but FYI without this change video capture on the Playstation Eye (gspca
ov534 driver) does not work at all.

Regards,
   Antonio

 drivers/media/video/gspca/gspca.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index 0fb48c0..c64299d 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -652,7 +652,7 @@ static struct usb_host_endpoint *get_ep(struct gspca_dev *gspca_dev)
 				   : USB_ENDPOINT_XFER_ISOC;
 	i = gspca_dev->alt;			/* previous alt setting */
 	if (gspca_dev->cam.reverse_alts) {
-		if (gspca_dev->audio)
+		if (gspca_dev->audio && i < gspca_dev->nbalt - 2)
 			i++;
 		while (++i < gspca_dev->nbalt) {
 			ep = alt_xfer(&intf->altsetting[i], xfer);
@@ -660,7 +660,7 @@ static struct usb_host_endpoint *get_ep(struct gspca_dev *gspca_dev)
 				break;
 		}
 	} else {
-		if (gspca_dev->audio)
+		if (gspca_dev->audio && i > 1)
 			i--;
 		while (--i >= 0) {
 			ep = alt_xfer(&intf->altsetting[i], xfer);
-- 
1.7.2.3

