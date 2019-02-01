Return-Path: <SRS0=EV+/=QI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CF3DC282D8
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 14:54:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CD0B21872
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 14:54:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728326AbfBAOyj convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Feb 2019 09:54:39 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:51211 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726446AbfBAOyj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Feb 2019 09:54:39 -0500
Received: from [100.86.130.104] ([31.161.159.117])
        by smtp-cloud8.xs4all.net with ESMTPSA
        id paDDgUAEQNR5ypaDEgWqhI; Fri, 01 Feb 2019 15:54:37 +0100
Date:   Fri, 01 Feb 2019 15:54:33 +0100
User-Agent: K-9 Mail for Android
In-Reply-To: <20190201145135.20038-1-laurent.pinchart@ideasonboard.com>
References: <20190201145135.20038-1-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: Re: [PATCH] media: vb2: Fix compilation warning
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
CC:     Pawel Osciak <posciak@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sakari Ailus <sakari.ailus@iki.fi>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <C841D3FA-90BF-48BD-89F0-D9ED6ADF9DC0@xs4all.nl>
X-CMAE-Envelope: MS4wfLvKNnaabVpq8RvVike8aUKbv6OReYlesxTcWEmU1nEjNXCsG0ZcsotpqqOFwG2rRZWJG2k/2ppXoWf6uoJK8GrT5qv3Ccm8vXyiHjvC1Fp5m4oKpDed
 UW4gxZ7+/njY2eqR+Up8nQz2YtFTzRNLWynpop7tJzeiD9Ijm4jad4lItfcj9+PdGbsumhbLdGNl0fEdVo+HJ73iGZuz0k12jqf7vlA4u/ZqLtGGo/0TXP93
 jDYxAkvhoLKmJ2t1LsYUTw8MP4+SW+n154olmSPJnxwB9vIqykoUC+TYQvpm93tXk5m7cqn8enpA1NINbTYE3UbNRRe8FPxGc2gqE/UeipAX3dS6OeDFlRbG
 xYEo4SsHeuFCKtr8HqTiYqFaGJMgYw==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This is already fixed in a pending pull request.

Hans

On February 1, 2019 3:51:35 PM GMT+01:00, Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
>Commit 2cc1802f62e5 removed code without removing a local variable that
>ended up being unused. This results in a compilation warning, fix it.
>
>Fixes: 2cc1802f62e5 ("media: vb2: Keep dma-buf buffers mapped until
>they are freed")
>Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>---
> drivers/media/common/videobuf2/videobuf2-core.c | 1 -
> 1 file changed, 1 deletion(-)
>
>I wonder how the offending commit got merged without the warning being
>noticed. Sakari, as a useful exercise, could you check whether this
>would have been caught by the automatic build system you're
>experimenting with ?
>
>diff --git a/drivers/media/common/videobuf2/videobuf2-core.c
>b/drivers/media/common/videobuf2/videobuf2-core.c
>index e07b6bdb6982..34cc87ca8d59 100644
>--- a/drivers/media/common/videobuf2/videobuf2-core.c
>+++ b/drivers/media/common/videobuf2/videobuf2-core.c
>@@ -1769,7 +1769,6 @@ EXPORT_SYMBOL_GPL(vb2_wait_for_all_buffers);
> static void __vb2_dqbuf(struct vb2_buffer *vb)
> {
> 	struct vb2_queue *q = vb->vb2_queue;
>-	unsigned int i;
> 
> 	/* nothing to do if the buffer is already dequeued */
> 	if (vb->state == VB2_BUF_STATE_DEQUEUED)

-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity.
