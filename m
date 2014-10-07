Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3035 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbaJGL7d (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Oct 2014 07:59:33 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr1.xs4all.nl (8.13.8/8.13.8) with ESMTP id s97BxTrM003983
	for <linux-media@vger.kernel.org>; Tue, 7 Oct 2014 13:59:31 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [10.54.92.107] (173-38-208-169.cisco.com [173.38.208.169])
	by tschai.lan (Postfix) with ESMTPSA id BEE392A009F
	for <linux-media@vger.kernel.org>; Tue,  7 Oct 2014 13:59:26 +0200 (CEST)
Message-ID: <5433D57F.5080307@xs4all.nl>
Date: Tue, 07 Oct 2014 13:58:55 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: [PATCH for v3.18] vivid: fix buffer overrun
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The random_line buffer must be twice the maximum width, but it only allocated
the maximum width, so it was only half the size it needed to be.

Surprisingly I never saw the kernel fail on this, but the same TPG code used in
qv4l2 crashed and valgrind helped me track this bug down.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index 0c6fa53..cbcd625 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -136,7 +136,7 @@ int tpg_alloc(struct tpg_data *tpg, unsigned max_w)
 		tpg->black_line[plane] = vzalloc(max_w * pixelsz);
 		if (!tpg->black_line[plane])
 			return -ENOMEM;
-		tpg->random_line[plane] = vzalloc(max_w * pixelsz);
+		tpg->random_line[plane] = vzalloc(max_w * 2 * pixelsz);
 		if (!tpg->random_line[plane])
 			return -ENOMEM;
 	}
