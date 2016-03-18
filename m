Return-path: <linux-media-owner@vger.kernel.org>
Received: from swift.blarg.de ([78.47.110.205]:45221 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708AbcCRVix (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Mar 2016 17:38:53 -0400
Subject: [PATCH 2/2] media/dvb-core: forward media_create_pad_links() return
 value
From: Max Kellermann <max@duempel.org>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Date: Fri, 18 Mar 2016 22:31:35 +0100
Message-ID: <145833669510.2935.9687369819709306057.stgit@woodpecker.blarg.de>
In-Reply-To: <145833668973.2935.1789623774430960345.stgit@woodpecker.blarg.de>
References: <145833668973.2935.1789623774430960345.stgit@woodpecker.blarg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Max Kellermann <max@duempel.org>
---
 drivers/media/dvb-core/dvbdev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index c756d4b..96de2fa 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -677,13 +677,13 @@ int dvb_create_media_graph(struct dvb_adapter *adap,
 					     demux, 0, MEDIA_LNK_FL_ENABLED,
 					     false);
 		if (ret)
-			return -ENOMEM;
+			return ret;
 	}
 	if (demux && ca) {
 		ret = media_create_pad_link(demux, 1, ca,
 					    0, MEDIA_LNK_FL_ENABLED);
 		if (ret)
-			return -ENOMEM;
+			return ret;
 	}
 
 	/* Create demux links for each ringbuffer/pad */

