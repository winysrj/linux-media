Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33290 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S940610AbdAGCMU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2017 21:12:20 -0500
From: Steve Longerbeam <slongerbeam@gmail.com>
To: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v3 14/24] UAPI: Add media UAPI Kbuild file
Date: Fri,  6 Jan 2017 18:11:32 -0800
Message-Id: <1483755102-24785-15-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add an empty UAPI Kbuild file for media UAPI headers.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 include/uapi/Kbuild       | 1 +
 include/uapi/media/Kbuild | 1 +
 2 files changed, 2 insertions(+)
 create mode 100644 include/uapi/media/Kbuild

diff --git a/include/uapi/Kbuild b/include/uapi/Kbuild
index 245aa6e..9a51957 100644
--- a/include/uapi/Kbuild
+++ b/include/uapi/Kbuild
@@ -6,6 +6,7 @@
 header-y += asm-generic/
 header-y += linux/
 header-y += sound/
+header-y += media/
 header-y += mtd/
 header-y += rdma/
 header-y += video/
diff --git a/include/uapi/media/Kbuild b/include/uapi/media/Kbuild
new file mode 100644
index 0000000..aafaa5a
--- /dev/null
+++ b/include/uapi/media/Kbuild
@@ -0,0 +1 @@
+# UAPI Header export list
-- 
2.7.4

