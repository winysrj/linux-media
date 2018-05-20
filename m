Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:60250 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750914AbeETHYS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 May 2018 03:24:18 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        Nobuhiro Iwamatsu <iwamatsu@debian.org>
Subject: [PATCH v2] v4l: vsp1: Fix vsp1_regs.h license header
Date: Sun, 20 May 2018 10:24:37 +0300
Message-Id: <20180520072437.9686-1-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All source files of the vsp1 driver are licensed under the GPLv2+ except
for vsp1_regs.h which is licensed under GPLv2. This is caused by a bad
copy&paste that dates back from the initial version of the driver. Fix
it.

Cc: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Acked-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Acked-by: Sergei Shtylyov<sergei.shtylyov@cogentembedded.com>
Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Acked-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
Iwamatsu-san,

While working on the VSP1 driver I noticed that all source files are
licensed under the GPLv2+ except for vsp1_regs.h which is licensed under
GPLv2. I'd like to fix this inconsistency. As you have contributed to
that file, could you please provide your explicit ack if you agree to
this change ?
---
 drivers/media/platform/vsp1/vsp1_regs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
index 0d249ff9f564..e82661216c1d 100644
--- a/drivers/media/platform/vsp1/vsp1_regs.h
+++ b/drivers/media/platform/vsp1/vsp1_regs.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0 */
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * vsp1_regs.h  --  R-Car VSP1 Registers Definitions
  *
-- 
Regards,

Laurent Pinchart
