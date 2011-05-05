Return-path: <mchehab@pedra>
Received: from claranet-outbound-smtp00.uk.clara.net ([195.8.89.33]:46156 "EHLO
	claranet-outbound-smtp00.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754127Ab1EEMmn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 5 May 2011 08:42:43 -0400
From: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Andy Walls <awalls@md.metrocast.net>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Steven Toth <stoth@kernellabs.com>,
	Simon Farnsworth <simon.farnsworth@onelan.co.uk>
Subject: [PATCH] cx18: Fix warnings introduced during cleanup
Date: Thu,  5 May 2011 13:42:36 +0100
Message-Id: <1304599356-21951-1-git-send-email-simon.farnsworth@onelan.co.uk>
In-Reply-To: <4DC138F7.5050400@infradead.org>
References: <4DC138F7.5050400@infradead.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I misused the ktime API, and failed to remove some traces of the
in-kernel format conversion. Fix these, so the the driver builds
without warnings.

Signed-off-by: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
---
Mauro,

You may want to squash this in with the cleanup patch itself - it's
plain and simple oversight on my part (I should have seen the compiler
warnings), and I should not have sent the cleanup patch to you without
fixing these errors.

Sorry,

Simon

drivers/media/video/cx18/cx18-mailbox.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/cx18/cx18-mailbox.c b/drivers/media/video/cx18/cx18-mailbox.c
index 5ecae93..c07191e 100644
--- a/drivers/media/video/cx18/cx18-mailbox.c
+++ b/drivers/media/video/cx18/cx18-mailbox.c
@@ -164,10 +164,9 @@ static void cx18_mdl_send_to_videobuf(struct cx18_stream *s,
 {
 	struct cx18_videobuf_buffer *vb_buf;
 	struct cx18_buffer *buf;
-	u8 *p, u;
+	u8 *p;
 	u32 offset = 0;
 	int dispatch = 0;
-	int i;
 
 	if (mdl->bytesused == 0)
 		return;
@@ -203,7 +202,7 @@ static void cx18_mdl_send_to_videobuf(struct cx18_stream *s,
 	}
 
 	if (dispatch) {
-		ktime_get_ts(&vb_buf->vb.ts);
+		vb_buf->vb.ts = ktime_to_timeval(ktime_get());
 		list_del(&vb_buf->vb.queue);
 		vb_buf->vb.state = VIDEOBUF_DONE;
 		wake_up(&vb_buf->vb.done);
-- 
1.7.4

