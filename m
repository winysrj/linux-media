Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752104AbdGFLCF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Jul 2017 07:02:05 -0400
From: Kieran Bingham <kbingham@kernel.org>
To: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, kieran.bingham@ideasonboard.com,
        niklas.soderlund@ragnatech.se, hans.verkuil@cisco.com,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v7 3/3] MAINTAINERS: Add ADV748x driver
Date: Thu,  6 Jul 2017 12:01:17 +0100
Message-Id: <7ce1f6aac00cd9c7d503412a7aab6655abb8c340.1499336175.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.f44897c9f4c2d4555dfa156cc24a755477e409bf.1499336175.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.f44897c9f4c2d4555dfa156cc24a755477e409bf.1499336175.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.f44897c9f4c2d4555dfa156cc24a755477e409bf.1499336175.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.f44897c9f4c2d4555dfa156cc24a755477e409bf.1499336175.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

The ADV7481 is an integrated video decoder and combined HDMI/MHL
receiver.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c4be6d4af7d2..741da59b133a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -770,6 +770,12 @@ W:	http://ez.analog.com/community/linux-device-drivers
 S:	Supported
 F:	drivers/media/i2c/adv7180.c
 
+ANALOG DEVICES INC ADV748X DRIVER
+M:	Kieran Bingham <kieran.bingham@ideasonboard.com>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/i2c/adv748x/*
+
 ANALOG DEVICES INC ADV7511 DRIVER
 M:	Hans Verkuil <hans.verkuil@cisco.com>
 L:	linux-media@vger.kernel.org
-- 
git-series 0.9.1
