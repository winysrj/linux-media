Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:54268 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab2GAUP4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Jul 2012 16:15:56 -0400
Received: by mail-qc0-f174.google.com with SMTP id o28so2600569qcr.19
        for <linux-media@vger.kernel.org>; Sun, 01 Jul 2012 13:15:56 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 3/6] cx25840: fix regression in HVR-1800 analog audio
Date: Sun,  1 Jul 2012 16:15:11 -0400
Message-Id: <1341173714-23627-4-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1341173714-23627-1-git-send-email-dheitmueller@kernellabs.com>
References: <1341173714-23627-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The refactoring of the cx25840 driver to support the cx23888 caused breakage
with the existing support for cx23885/cx23887 analog audio support.  Tweak
the code so that it only uses the code if it really is a cx23888 instead of
applying it to all cx2388x based devices.

Validated with the following boards:

HVR-1800 retail (0070:7801)
HVR-1800 OEM (0070:7809)
HVR_1850 retail	(0070:8541)

Thanks to Steven Toth and Hauppauge for	loaning	me various boards to
regression test with.

Reported-by: Jonathan <sitten74490@mypacks.net>
Thanks-to: Steven Toth <stoth@kernellabs.com>
Signed-off-by: Devin Heitmueler <dheitmueller@kernellabs.com>
---
 drivers/media/video/cx25840/cx25840-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/cx25840/cx25840-core.c b/drivers/media/video/cx25840/cx25840-core.c
index e12b3b0..7dc7bb1 100644
--- a/drivers/media/video/cx25840/cx25840-core.c
+++ b/drivers/media/video/cx25840/cx25840-core.c
@@ -1250,7 +1250,7 @@ static int set_input(struct i2c_client *client, enum cx25840_video_input vid_inp
 		cx25840_write4(client, 0x8d0, 0x1f063870);
 	}
 
-	if (is_cx2388x(state)) {
+	if (is_cx23888(state)) {
 		/* HVR1850 */
 		/* AUD_IO_CTRL - I2S Input, Parallel1*/
 		/*  - Channel 1 src - Parallel1 (Merlin out) */
-- 
1.7.1

