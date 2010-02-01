Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023Ab0BANf1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Feb 2010 08:35:27 -0500
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o11DZRrb025220
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 1 Feb 2010 08:35:27 -0500
Received: from [10.11.9.119] (vpn-9-119.rdu.redhat.com [10.11.9.119])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o11DZNLF010818
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 1 Feb 2010 08:35:26 -0500
Message-ID: <4B66D89A.2030207@redhat.com>
Date: Mon, 01 Feb 2010 11:35:22 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] Fix the risk of an oops at dvb_dmx_release
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dvb_dmx_init tries to allocate virtual memory for 2 pointers: filter and feed.

If the second vmalloc fails, filter is freed, but the pointer keeps pointing
to the old place. Later, when dvb_dmx_release() is called, it will try to
free an already freed memory, causing an OOPS.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-core/dvb_demux.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_demux.c b/drivers/media/dvb/dvb-core/dvb_demux.c
index b78cfb7..a78408e 100644
--- a/drivers/media/dvb/dvb-core/dvb_demux.c
+++ b/drivers/media/dvb/dvb-core/dvb_demux.c
@@ -1246,6 +1246,7 @@ int dvb_dmx_init(struct dvb_demux *dvbdemux)
 	dvbdemux->feed = vmalloc(dvbdemux->feednum * sizeof(struct dvb_demux_feed));
 	if (!dvbdemux->feed) {
 		vfree(dvbdemux->filter);
+		dvbdemux->filter = NULL;
 		return -ENOMEM;
 	}
 	for (i = 0; i < dvbdemux->filternum; i++) {
-- 
1.6.6.1


