Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34803 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755143AbdCJEyr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Mar 2017 23:54:47 -0500
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
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v5 21/39] UAPI: Add media UAPI Kbuild file
Date: Thu,  9 Mar 2017 20:53:01 -0800
Message-Id: <1489121599-23206-22-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
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
