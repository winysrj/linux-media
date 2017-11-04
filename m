Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0107.hostedemail.com ([216.40.44.107]:40037 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932111AbdKDRXe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 4 Nov 2017 13:23:34 -0400
From: Joe Perches <joe@perches.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: uvcvideo: Make some structs const
Date: Sat,  4 Nov 2017 10:23:29 -0700
Message-Id: <0e85822616b665b20bc5b883d5be4a1265137f87.1509816184.git.joe@perches.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move some data to text

$ size drivers/media/usb/uvc/uvc_ctrl.o*
   text	   data	    bss	    dec	    hex	filename
  34323	   2364	      0	  36687	   8f4f	drivers/media/usb/uvc/uvc_ctrl.o.new
  28659	   8028	      0	  36687	   8f4f	drivers/media/usb/uvc/uvc_ctrl.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/usb/uvc/uvc_ctrl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index 20397aba6849..44a0554bf62d 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -37,7 +37,7 @@
  * Controls
  */
 
-static struct uvc_control_info uvc_ctrls[] = {
+static const struct uvc_control_info uvc_ctrls[] = {
 	{
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_BRIGHTNESS_CONTROL,
@@ -420,7 +420,7 @@ static void uvc_ctrl_set_rel_speed(struct uvc_control_mapping *mapping,
 	data[first+1] = min_t(int, abs(value), 0xff);
 }
 
-static struct uvc_control_mapping uvc_ctrl_mappings[] = {
+static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	{
 		.id		= V4L2_CID_BRIGHTNESS,
 		.name		= "Brightness",
-- 
2.15.0
