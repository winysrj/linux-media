Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:25057 "EHLO
	aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbbHRIjN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2015 04:39:13 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu,
	kamil@wypas.org, linux@arm.linux.org.uk,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv8 04/15] input.h: add BUS_CEC type
Date: Tue, 18 Aug 2015 10:26:29 +0200
Message-Id: <31694c97c9030cb8cfadf3b1dbe1ef1c642dce02.1439886203.git.hans.verkuil@cisco.com>
In-Reply-To: <cover.1439886203.git.hans.verkuil@cisco.com>
References: <cover.1439886203.git.hans.verkuil@cisco.com>
In-Reply-To: <cover.1439886203.git.hans.verkuil@cisco.com>
References: <cover.1439886203.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Inputs can come in over the HDMI CEC bus, so add a new type for this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 include/uapi/linux/input.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/input.h b/include/uapi/linux/input.h
index 731417c..a32bff1 100644
--- a/include/uapi/linux/input.h
+++ b/include/uapi/linux/input.h
@@ -972,6 +972,7 @@ struct input_keymap_entry {
 #define BUS_GSC			0x1A
 #define BUS_ATARI		0x1B
 #define BUS_SPI			0x1C
+#define BUS_CEC			0x1D
 
 /*
  * MT_TOOL types
-- 
2.1.4

