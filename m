Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3812 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbaHTW7r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 18:59:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 24/29] pwc: fix sparse warning
Date: Thu, 21 Aug 2014 00:59:23 +0200
Message-Id: <1408575568-20562-25-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
References: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/usb/pwc/pwc-v4l.c:55:12: warning: symbol 'pwc_auto_whitebal_qmenu' was not declared. Should it be static?

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/pwc/pwc-v4l.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/pwc/pwc-v4l.c b/drivers/media/usb/pwc/pwc-v4l.c
index aa7449e..3d98798 100644
--- a/drivers/media/usb/pwc/pwc-v4l.c
+++ b/drivers/media/usb/pwc/pwc-v4l.c
@@ -52,7 +52,7 @@ enum { custom_autocontour, custom_contour, custom_noise_reduction,
 	custom_awb_speed, custom_awb_delay,
 	custom_save_user, custom_restore_user, custom_restore_factory };
 
-const char * const pwc_auto_whitebal_qmenu[] = {
+static const char * const pwc_auto_whitebal_qmenu[] = {
 	"Indoor (Incandescant Lighting) Mode",
 	"Outdoor (Sunlight) Mode",
 	"Indoor (Fluorescent Lighting) Mode",
-- 
2.1.0.rc1

