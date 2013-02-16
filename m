Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2355 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917Ab3BPJ2v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Feb 2013 04:28:51 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 06/18] davinci: replace V4L2_OUT_CAP_CUSTOM_TIMINGS by V4L2_OUT_CAP_DV_TIMINGS
Date: Sat, 16 Feb 2013 10:28:09 +0100
Message-Id: <697f2939eac3755e4b5d74433d160d44672ab7ca.1361006882.git.hans.verkuil@cisco.com>
In-Reply-To: <1361006901-16103-1-git-send-email-hverkuil@xs4all.nl>
References: <1361006901-16103-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <a9599acc7829c431d88b547de87c500968ccb86a.1361006882.git.hans.verkuil@cisco.com>
References: <a9599acc7829c431d88b547de87c500968ccb86a.1361006882.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The use of V4L2_OUT_CAP_CUSTOM_TIMINGS is deprecated, use DV_TIMINGS instead.
Note that V4L2_OUT_CAP_CUSTOM_TIMINGS is just a #define for
V4L2_OUT_CAP_DV_TIMINGS.

At some point in the future these CUSTOM_TIMINGS defines might be removed.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>
---
 arch/arm/mach-davinci/board-dm646x-evm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
index 6e2f163..43f35d6 100644
--- a/arch/arm/mach-davinci/board-dm646x-evm.c
+++ b/arch/arm/mach-davinci/board-dm646x-evm.c
@@ -514,7 +514,7 @@ static const struct vpif_output dm6467_ch0_outputs[] = {
 			.index = 1,
 			.name = "Component",
 			.type = V4L2_OUTPUT_TYPE_ANALOG,
-			.capabilities = V4L2_OUT_CAP_CUSTOM_TIMINGS,
+			.capabilities = V4L2_OUT_CAP_DV_TIMINGS,
 		},
 		.subdev_name = "adv7343",
 		.output_route = ADV7343_COMPONENT_ID,
-- 
1.7.10.4

