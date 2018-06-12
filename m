Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.osadl.org ([62.245.132.105]:58253 "EHLO www.osadl.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754209AbeFLRXf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 13:23:35 -0400
From: Nicholas Mc Guire <hofrat@osadl.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Niklas Soderlund <niklas.soderlund+renesas@ragnatech.se>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH 2/2] media: stm32-dcmi: add mandatory of_node_put() in success path
Date: Tue, 12 Jun 2018 19:22:18 +0200
Message-Id: <1528824138-19089-2-git-send-email-hofrat@osadl.org>
In-Reply-To: <1528824138-19089-1-git-send-email-hofrat@osadl.org>
References: <1528824138-19089-1-git-send-email-hofrat@osadl.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The endpoint allocated by of_graph_get_next_endpoint() needs an of_node_put()
in both error and success path. As  ep  is not used the refcount decrement
can be right after the last use of  ep.

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
Fixes: commit 37404f91ef8b ("[media] stm32-dcmi: STM32 DCMI camera interface driver")
---

Problem located with an experimental coccinelle script

Patch was compile tested with: x86_64_defconfig, MEDIA_SUPPORT=y
MEDIA_CAMERA_SUPPORT=y, V4L_PLATFORM_DRIVERS=y, OF=y, COMPILE_TEST=y
CONFIG_VIDEO_STM32_DCMI=y
(There are a number of sparse warnings - not related to the changes though)

Patch is on top of "[PATCH 1/2] media: stm32-dcmi: drop unneceeary while(1)
loop" against 4.17.0 (localversion-next is next-20180608)

 drivers/media/platform/stm32/stm32-dcmi.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index 70b81d2..542d148 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -1610,10 +1610,9 @@ static int dcmi_graph_parse(struct stm32_dcmi *dcmi, struct device_node *node)
 		return -EINVAL;
 
 	remote = of_graph_get_remote_port_parent(ep);
-	if (!remote) {
-		of_node_put(ep);
+	of_node_put(ep);
+	if (!remote)
 		return -EINVAL;
-	}
 
 	/* Remote node to connect */
 	dcmi->entity.node = remote;
-- 
2.1.4
