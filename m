Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B91AC282CB
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 09:41:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52EBF20844
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 09:41:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbfBEJlw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 04:41:52 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36946 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726731AbfBEJlw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Feb 2019 04:41:52 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id E2E55634C7E;
        Tue,  5 Feb 2019 11:40:32 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1gqxDV-0002xz-UT; Tue, 05 Feb 2019 11:40:33 +0200
Date:   Tue, 5 Feb 2019 11:40:33 +0200
From:   Sakari Ailus <sakari.ailus@iki.fi>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     linux-media@vger.kernel.org, Pawel Osciak <posciak@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: Re: [PATCH] media: vb2: Fix compilation warning
Message-ID: <20190205094033.5kozzptzwlcsscs2@valkosipuli.retiisi.org.uk>
References: <20190201145135.20038-1-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190201145135.20038-1-laurent.pinchart@ideasonboard.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,

On Fri, Feb 01, 2019 at 04:51:35PM +0200, Laurent Pinchart wrote:
> Commit 2cc1802f62e5 removed code without removing a local variable that
> ended up being unused. This results in a compilation warning, fix it.
> 
> Fixes: 2cc1802f62e5 ("media: vb2: Keep dma-buf buffers mapped until they are freed")
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/common/videobuf2/videobuf2-core.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> I wonder how the offending commit got merged without the warning being
> noticed. Sakari, as a useful exercise, could you check whether this
> would have been caught by the automatic build system you're
> experimenting with ?

Certainly. It compiles each new patch in a branch separately and looks up
for new warnings or errors.

That said, it's not quite usable yet. I'll let you know when I have
something to show...

> 
> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> index e07b6bdb6982..34cc87ca8d59 100644
> --- a/drivers/media/common/videobuf2/videobuf2-core.c
> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> @@ -1769,7 +1769,6 @@ EXPORT_SYMBOL_GPL(vb2_wait_for_all_buffers);
>  static void __vb2_dqbuf(struct vb2_buffer *vb)
>  {
>  	struct vb2_queue *q = vb->vb2_queue;
> -	unsigned int i;
>  
>  	/* nothing to do if the buffer is already dequeued */
>  	if (vb->state == VB2_BUF_STATE_DEQUEUED)

-- 
Sakari Ailus
