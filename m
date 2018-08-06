Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor3.renesas.com ([210.160.252.173]:35922 "EHLO
        relmlie2.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726338AbeHFFZ1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Aug 2018 01:25:27 -0400
Message-ID: <878t5knq7e.wl-kuninori.morimoto.gx@renesas.com>
From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: [PATCH 6/8] drm: panel-lvds: convert to SPDX identifiers
To: "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        "Ramesh Shanmugasundaram" <ramesh.shanmugasundaram@bp.renesas.com>,
        "Hans Verkuil" <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: =?ISO-8859-1?Q?=22Niklas_S=F6derlund=22?=
        <niklas.soderlund@ragnatech.se>,
        "Kieran Bingham" <kieran@ksquared.org.uk>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
In-Reply-To: <87h8k8nqcf.wl-kuninori.morimoto.gx@renesas.com>
References: <87h8k8nqcf.wl-kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
Date: Mon, 6 Aug 2018 03:18:22 +0000
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
---
 drivers/gpu/drm/panel/panel-lvds.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-lvds.c b/drivers/gpu/drm/panel/panel-lvds.c
index 8a16878..3f6550e 100644
--- a/drivers/gpu/drm/panel/panel-lvds.c
+++ b/drivers/gpu/drm/panel/panel-lvds.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * Generic LVDS panel driver
  *
@@ -5,11 +6,6 @@
  * Copyright (C) 2016 Renesas Electronics Corporation
  *
  * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <linux/backlight.h>
-- 
2.7.4
