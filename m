Return-path: <mchehab@gaivota>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:65324 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab1AAJgS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Jan 2011 04:36:18 -0500
Message-ID: <4d1ef590.cc7e0e0a.7c81.08b4@mx.google.com>
From: "Igor M. Liplianin" <liplianin@me.by>
Date: Fri, 31 Dec 2010 13:37:00 +0200
Subject: [PATCH 14/18] cx25840: Fix subdev registration in cx25840-core.c
To: <mchehab@infradead.org>, <linux-media@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On my system, cx23885 based card reports default volume value above 70000.
So, register cx25840 subdev fails. Although, the card don't have a/v inputs
it needs a/v firmware to be loaded.

Signed-off-by: Igor M. Liplianin <liplianin@netup.ru>
---
 drivers/media/video/cx25840/cx25840-core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/cx25840/cx25840-core.c b/drivers/media/video/cx25840/cx25840-core.c
index dfb198d..dc0cec7 100644
--- a/drivers/media/video/cx25840/cx25840-core.c
+++ b/drivers/media/video/cx25840/cx25840-core.c
@@ -1991,6 +1991,8 @@ static int cx25840_probe(struct i2c_client *client,
 	if (!is_cx2583x(state)) {
 		default_volume = 228 - cx25840_read(client, 0x8d4);
 		default_volume = ((default_volume / 2) + 23) << 9;
+		if (default_volume > 65535)
+			default_volume = 65535;
 
 		state->volume = v4l2_ctrl_new_std(&state->hdl,
 			&cx25840_audio_ctrl_ops, V4L2_CID_AUDIO_VOLUME,
-- 
1.7.1

