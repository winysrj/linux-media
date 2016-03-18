Return-path: <linux-media-owner@vger.kernel.org>
Received: from swift.blarg.de ([78.47.110.205]:36092 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754088AbcCRViy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Mar 2016 17:38:54 -0400
Subject: [PATCH 1/2] media/dvb-core: fix inverted check
From: Max Kellermann <max@duempel.org>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Date: Fri, 18 Mar 2016 22:31:29 +0100
Message-ID: <145833668973.2935.1789623774430960345.stgit@woodpecker.blarg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Breakage caused by commit f50d51661a

Signed-off-by: Max Kellermann <max@duempel.org>
---
 drivers/media/dvb-core/dvbdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 560450a..c756d4b 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -682,7 +682,7 @@ int dvb_create_media_graph(struct dvb_adapter *adap,
 	if (demux && ca) {
 		ret = media_create_pad_link(demux, 1, ca,
 					    0, MEDIA_LNK_FL_ENABLED);
-		if (!ret)
+		if (ret)
 			return -ENOMEM;
 	}
 

