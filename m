Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:3927 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab3CDJFq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2013 04:05:46 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Sekhar Nori <nsekhar@ti.com>,
	davinci-linux-open-source@linux.davincidsp.com,
	linux@arm.linux.org.uk, Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 06/11] davinci: replace V4L2_OUT_CAP_CUSTOM_TIMINGS by V4L2_OUT_CAP_DV_TIMINGS
Date: Mon,  4 Mar 2013 10:05:00 +0100
Message-Id: <bdfb122423321391d94a788794f4c353dc4e79ca.1362387265.git.hans.verkuil@cisco.com>
In-Reply-To: <1362387905-3666-1-git-send-email-hverkuil@xs4all.nl>
References: <1362387905-3666-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <b14bb5bd725678bc0fadfa241b462b5d6487f099.1362387265.git.hans.verkuil@cisco.com>
References: <b14bb5bd725678bc0fadfa241b462b5d6487f099.1362387265.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The use of V4L2_OUT_CAP_CUSTOM_TIMINGS is deprecated, use DV_TIMINGS instead.
Note that V4L2_OUT_CAP_CUSTOM_TIMINGS is just a #define for
V4L2_OUT_CAP_DV_TIMINGS.

At some point in the future these CUSTOM_TIMINGS defines might be removed.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Acked-by: Sekhar Nori <nsekhar@ti.com>
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

