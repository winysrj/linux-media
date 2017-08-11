Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:39062 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752926AbdHKJ5V (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Aug 2017 05:57:21 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Benoit Parrot <bparrot@ti.com>,
        linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 01/20] media.h: add MEDIA_PAD_FL_MUXED flag
Date: Fri, 11 Aug 2017 11:56:44 +0200
Message-Id: <20170811095703.6170-2-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170811095703.6170-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170811095703.6170-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add flag to indicate that a pad can mux more then one stream. The user
can use the pad operation get_frame_desc to query the pad about how the
pad is muxed.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 include/uapi/linux/media.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 4865f1e713398b63..49d692e1182b59a1 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -263,6 +263,7 @@ struct media_entity_desc {
 #define MEDIA_PAD_FL_SINK		(1 << 0)
 #define MEDIA_PAD_FL_SOURCE		(1 << 1)
 #define MEDIA_PAD_FL_MUST_CONNECT	(1 << 2)
+#define MEDIA_PAD_FL_MUXED		(1 << 3)
 
 struct media_pad_desc {
 	__u32 entity;		/* entity ID */
-- 
2.13.3
