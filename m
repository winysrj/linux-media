Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:27401 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933233AbcCROQl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Mar 2016 10:16:41 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
	linux-input@vger.kernel.org, lars@opdenkamp.eu,
	linux@arm.linux.org.uk, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv13 04/17] input.h: add BUS_CEC type
Date: Fri, 18 Mar 2016 15:07:03 +0100
Message-Id: <1458310036-19252-5-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <1458310036-19252-1-git-send-email-hans.verkuil@cisco.com>
References: <1458310036-19252-1-git-send-email-hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Inputs can come in over the HDMI CEC bus, so add a new type for this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 include/uapi/linux/input.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/input.h b/include/uapi/linux/input.h
index 2758687..4f8c813 100644
--- a/include/uapi/linux/input.h
+++ b/include/uapi/linux/input.h
@@ -246,6 +246,7 @@ struct input_mask {
 #define BUS_GSC			0x1A
 #define BUS_ATARI		0x1B
 #define BUS_SPI			0x1C
+#define BUS_CEC			0x1D
 
 /*
  * MT_TOOL types
-- 
2.7.0

