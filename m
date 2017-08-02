Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:36971 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751988AbdHBSlP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Aug 2017 14:41:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCHv3 4/4] drm/bridge: dw-hdmi: remove CEC engine register definitions
Date: Wed,  2 Aug 2017 20:41:08 +0200
Message-Id: <20170802184108.7913-5-hverkuil@xs4all.nl>
In-Reply-To: <20170802184108.7913-1-hverkuil@xs4all.nl>
References: <20170802184108.7913-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Russell King <rmk+kernel@armlinux.org.uk>

We don't need the CEC engine register definitions, so let's remove them.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.h | 45 -------------------------------
 1 file changed, 45 deletions(-)

diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.h b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.h
index 69644c83a0f8..9d90eb9c46e5 100644
--- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.h
+++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.h
@@ -478,51 +478,6 @@
 #define HDMI_A_PRESETUP                         0x501A
 #define HDMI_A_SRM_BASE                         0x5020
 
-/* CEC Engine Registers */
-#define HDMI_CEC_CTRL                           0x7D00
-#define HDMI_CEC_STAT                           0x7D01
-#define HDMI_CEC_MASK                           0x7D02
-#define HDMI_CEC_POLARITY                       0x7D03
-#define HDMI_CEC_INT                            0x7D04
-#define HDMI_CEC_ADDR_L                         0x7D05
-#define HDMI_CEC_ADDR_H                         0x7D06
-#define HDMI_CEC_TX_CNT                         0x7D07
-#define HDMI_CEC_RX_CNT                         0x7D08
-#define HDMI_CEC_TX_DATA0                       0x7D10
-#define HDMI_CEC_TX_DATA1                       0x7D11
-#define HDMI_CEC_TX_DATA2                       0x7D12
-#define HDMI_CEC_TX_DATA3                       0x7D13
-#define HDMI_CEC_TX_DATA4                       0x7D14
-#define HDMI_CEC_TX_DATA5                       0x7D15
-#define HDMI_CEC_TX_DATA6                       0x7D16
-#define HDMI_CEC_TX_DATA7                       0x7D17
-#define HDMI_CEC_TX_DATA8                       0x7D18
-#define HDMI_CEC_TX_DATA9                       0x7D19
-#define HDMI_CEC_TX_DATA10                      0x7D1a
-#define HDMI_CEC_TX_DATA11                      0x7D1b
-#define HDMI_CEC_TX_DATA12                      0x7D1c
-#define HDMI_CEC_TX_DATA13                      0x7D1d
-#define HDMI_CEC_TX_DATA14                      0x7D1e
-#define HDMI_CEC_TX_DATA15                      0x7D1f
-#define HDMI_CEC_RX_DATA0                       0x7D20
-#define HDMI_CEC_RX_DATA1                       0x7D21
-#define HDMI_CEC_RX_DATA2                       0x7D22
-#define HDMI_CEC_RX_DATA3                       0x7D23
-#define HDMI_CEC_RX_DATA4                       0x7D24
-#define HDMI_CEC_RX_DATA5                       0x7D25
-#define HDMI_CEC_RX_DATA6                       0x7D26
-#define HDMI_CEC_RX_DATA7                       0x7D27
-#define HDMI_CEC_RX_DATA8                       0x7D28
-#define HDMI_CEC_RX_DATA9                       0x7D29
-#define HDMI_CEC_RX_DATA10                      0x7D2a
-#define HDMI_CEC_RX_DATA11                      0x7D2b
-#define HDMI_CEC_RX_DATA12                      0x7D2c
-#define HDMI_CEC_RX_DATA13                      0x7D2d
-#define HDMI_CEC_RX_DATA14                      0x7D2e
-#define HDMI_CEC_RX_DATA15                      0x7D2f
-#define HDMI_CEC_LOCK                           0x7D30
-#define HDMI_CEC_WKUPCTRL                       0x7D31
-
 /* I2C Master Registers (E-DDC) */
 #define HDMI_I2CM_SLAVE                         0x7E00
 #define HDMI_I2CM_ADDRESS                       0x7E01
-- 
2.13.2
