Return-path: <mchehab@pedra>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1466 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792Ab1AYV3w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Jan 2011 16:29:52 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Matt Janus <hello@mattjan.us>
Subject: Re: oops cx2341x control handler
Date: Tue, 25 Jan 2011 22:29:35 +0100
Cc: linux-media@vger.kernel.org, Andy Walls <awalls@md.metrocast.net>
References: <9AA38BEC-4364-4F45-968B-E33BA5098C34@mattjan.us>
In-Reply-To: <9AA38BEC-4364-4F45-968B-E33BA5098C34@mattjan.us>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201101252229.35418.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Matt,

On Tuesday, January 25, 2011 03:10:38 Matt Janus wrote:
> A quick test with mplayer didn't error, when i tried to use mythtv the driver crashed and resulted in this:

I could reproduce this and the fix is below. Please test!

Regards,

	Hans

>From 6b7c84508e915f26a9b701ef2f5fa0b92ca62f2f Mon Sep 17 00:00:00 2001
Message-Id: <6b7c84508e915f26a9b701ef2f5fa0b92ca62f2f.1295990866.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Tue, 25 Jan 2011 22:25:39 +0100
Subject: [PATCH] cx18: fix kernel oops when setting MPEG control before capturing.

The cxhdl->priv field was not set initially, only after capturing started.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/cx18/cx18-driver.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/cx18/cx18-driver.c b/drivers/media/video/cx18/cx18-driver.c
index 869690b..877e201 100644
--- a/drivers/media/video/cx18/cx18-driver.c
+++ b/drivers/media/video/cx18/cx18-driver.c
@@ -713,6 +713,7 @@ static int __devinit cx18_init_struct1(struct cx18 *cx)
 	cx->cxhdl.capabilities = CX2341X_CAP_HAS_TS | CX2341X_CAP_HAS_SLICED_VBI;
 	cx->cxhdl.ops = &cx18_cxhdl_ops;
 	cx->cxhdl.func = cx18_api_func;
+	cx->cxhdl.priv = &cx->streams[CX18_ENC_STREAM_TYPE_MPG];
 	ret = cx2341x_handler_init(&cx->cxhdl, 50);
 	if (ret)
 		return ret;
-- 
1.7.0.4


-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
