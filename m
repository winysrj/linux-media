Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4960 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab0EINzd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 May 2010 09:55:33 -0400
Message-Id: <d64f7ef97d6dea1b87619f32c60da7cf8cdaf557.1273413060.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1273413060.git.hverkuil@xs4all.nl>
References: <cover.1273413060.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Sun, 09 May 2010 15:57:03 +0200
Subject: [PATCH 2/6] [RFC] tvp514x: make std_list const
To: linux-media@vger.kernel.org
Cc: hvaibhav@ti.com
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/tvp514x.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/tvp514x.c b/drivers/media/video/tvp514x.c
index 1ca1247..9d8d5c8 100644
--- a/drivers/media/video/tvp514x.c
+++ b/drivers/media/video/tvp514x.c
@@ -110,7 +110,7 @@ struct tvp514x_decoder {
 
 	enum tvp514x_std current_std;
 	int num_stds;
-	struct tvp514x_std_info *std_list;
+	const struct tvp514x_std_info *std_list;
 	/* Input and Output Routing parameters */
 	u32 input;
 	u32 output;
@@ -222,7 +222,7 @@ static const struct v4l2_fmtdesc tvp514x_fmt_list[] = {
  * Currently supports two standards only, need to add support for rest of the
  * modes, like SECAM, etc...
  */
-static struct tvp514x_std_info tvp514x_std_list[] = {
+static const struct tvp514x_std_info tvp514x_std_list[] = {
 	/* Standard: STD_NTSC_MJ */
 	[STD_NTSC_MJ] = {
 	 .width = NTSC_NUM_ACTIVE_PIXELS,
-- 
1.6.4.2

