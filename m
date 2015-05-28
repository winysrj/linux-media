Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:34073 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbbE1M7x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 08:59:53 -0400
From: Yoshihiro Kaneko <ykaneko0929@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: [PATCH v2] v4l: vsp1: Align crop rectangle to even boundary for YUV formats
Date: Thu, 28 May 2015 21:59:39 +0900
Message-Id: <1432817979-2929-1-git-send-email-ykaneko0929@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Damian Hobson-Garcia <dhobsong@igel.co.jp>

Make sure that there are valid values in the crop rectangle to ensure
that the color plane doesn't get shifted when cropping.
Since there is no distinction between 12bit and 16bit YUV formats in
at the subdev level, use the more restrictive 12bit limits for all YUV
formats.

Signed-off-by: Damian Hobson-Garcia <dhobsong@igel.co.jp>
Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
---

This patch is based on the master branch of linuxtv.org/media_tree.git.

v2 [Yoshihiro Kaneko]
* As suggested by Laurent Pinchart
  - remove the change to add a restriction to the left and top
  - use round_down() to align the width and height
* As suggested by Sergei Shtylyov
  - use ALIGN() to align the left and top
  - correct a misspelling of the commit message
* Compile tested only

 drivers/media/platform/vsp1/vsp1_rwpf.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.c b/drivers/media/platform/vsp1/vsp1_rwpf.c
index fa71f46..32687c7 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.c
@@ -197,6 +197,14 @@ int vsp1_rwpf_set_selection(struct v4l2_subdev *subdev,
 	 */
 	format = vsp1_entity_get_pad_format(&rwpf->entity, cfg, RWPF_PAD_SINK,
 					    sel->which);
+
+	if (format->code == MEDIA_BUS_FMT_AYUV8_1X32) {
+		sel->r.left = ALIGN(sel->r.left, 2);
+		sel->r.top = ALIGN(sel->r.top, 2);
+		sel->r.width = round_down(sel->r.width, 2);
+		sel->r.height = round_down(sel->r.height, 2);
+	}
+
 	sel->r.left = min_t(unsigned int, sel->r.left, format->width - 2);
 	sel->r.top = min_t(unsigned int, sel->r.top, format->height - 2);
 	if (rwpf->entity.type == VSP1_ENTITY_WPF) {
-- 
1.9.1

