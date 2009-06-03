Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f182.google.com ([209.85.216.182]:36379 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbZFCCJl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Jun 2009 22:09:41 -0400
Received: by pxi12 with SMTP id 12so409576pxi.33
        for <linux-media@vger.kernel.org>; Tue, 02 Jun 2009 19:09:42 -0700 (PDT)
Subject: [PATCH]videobuf-core.c: add pointer check
From: "Figo.zhang" <figo1802@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Trent Piepho <xyzzy@speakeasy.org>
Content-Type: text/plain
Date: Wed, 03 Jun 2009 10:01:04 +0800
Message-Id: <1243994465.3459.9.camel@myhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

add poiter check for videobuf_queue_core_init().

any guys who write a v4l driver, pass a NULL pointer or a non-inintial
pointer to the first parameter such as videobuf_queue_sg_init() , it 
would be crashed.

Signed-off-by: Figo.zhang <figo1802@gmail.com>
--- 
drivers/media/video/videobuf-core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
index b7b0584..5f41fd9 100644
--- a/drivers/media/video/videobuf-core.c
+++ b/drivers/media/video/videobuf-core.c
@@ -118,6 +118,7 @@ void videobuf_queue_core_init(struct videobuf_queue *q,
 			 void *priv,
 			 struct videobuf_qtype_ops *int_ops)
 {
+	BUG_ON(!q);
 	memset(q, 0, sizeof(*q));
 	q->irqlock   = irqlock;
 	q->dev       = dev;


