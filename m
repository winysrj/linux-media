Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay112.isp.belgacom.be ([195.238.20.139]:8244 "EHLO
        mailrelay112.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753946AbdA3S5N (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jan 2017 13:57:13 -0500
From: Fabian Frederick <fabf@skynet.be>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 05/14] omap3isp: use atomic_dec_not_zero()
Date: Mon, 30 Jan 2017 19:54:54 +0100
Message-Id: <20170130185454.22887-1-fabf@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

instead of atomic_add_unless(value, -1, 0)

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/media/platform/omap3isp/ispstat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
index 47cbc7e..462b1d1 100644
--- a/drivers/media/platform/omap3isp/ispstat.c
+++ b/drivers/media/platform/omap3isp/ispstat.c
@@ -620,7 +620,7 @@ static int isp_stat_buf_process(struct ispstat *stat, int buf_state)
 {
 	int ret = STAT_NO_BUF;
 
-	if (!atomic_add_unless(&stat->buf_err, -1, 0) &&
+	if (!atomic_dec_not_zero(&stat->buf_err) &&
 	    buf_state == STAT_BUF_DONE && stat->state == ISPSTAT_ENABLED) {
 		ret = isp_stat_buf_queue(stat);
 		isp_stat_buf_next(stat);
-- 
2.9.3

