Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07303C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 13:22:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4AC6213F2
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 13:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553088168;
	bh=jkfPPHpA59evVRqaF9NrvK+hxc2shyIsLbW07Pubsaw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=1+UJAEv0f6mE0QTlX9taxVkfqmKgeoc+eBFLRZqExt+4SKatyMQX7Kdbog6Pz0kB8
	 CQCSStLUP9mvqcY8R5UsqqBPGVq9X8bVBtUCMhYhXUGxq5r694VTANtXQDXlcAw6wG
	 hh95EsC4XDISfYeMJ6HOemrYxM+WjaqHyyrhZt9A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727172AbfCTNWs (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 09:22:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:35194 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbfCTNWs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 09:22:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=deUQmf0Y2gHIUUsUH9ZsCNfqc9S3s5MrTbwnN1Do5tc=; b=Nftrnf7piCTaPqtx99Fmgaqz3P
        NkUTIALsGNbPJ7imQxpZ+a0DAXkZjYy3PhLm2UOD/q4dX10fhhHGruXyh4JiKmnTVwsv6BuVYvh2H
        9rcnNoNEpbpIIDsEvs3Dv+61V9O8yiXOn3RdOTnIVziUmG/wXrJRbKGkIoaxHt9gMvkVUmgxuLLUa
        4QASk18jdn4ExFKLoC3AUnL0FZSuoIAAUJoslHVxTo9uGFsy7WBq6Tdy/kpZzzbQOSjAwG5AC/8hE
        R9nC/IGUOdsQ3/EegdqgTLF3tX2tUj5Anm+CT/6ilNmnnjTmmNmvfFCDKBYdFg0QXcX1Fq0vHiQ+L
        dOgaQvjg==;
Received: from [179.95.24.146] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1h6bB7-0007My-Ti; Wed, 20 Mar 2019 13:22:46 +0000
Date:   Wed, 20 Mar 2019 10:22:37 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     linux-media@vger.kernel.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Subject: Re: [PATCH v5.1 1/2] vb2: add requires_requests bit for stateless
 codecs
Message-ID: <20190320102211.30f97366@coco.lan>
In-Reply-To: <2f66860e-8932-3ac6-0ff0-9fc5444d1fe1@xs4all.nl>
References: <20190320123305.5224-1-hverkuil-cisco@xs4all.nl>
        <20190320123305.5224-2-hverkuil-cisco@xs4all.nl>
        <20190320095501.62ff031e@coco.lan>
        <2f66860e-8932-3ac6-0ff0-9fc5444d1fe1@xs4all.nl>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Wed, 20 Mar 2019 14:06:51 +0100
Hans Verkuil <hverkuil-cisco@xs4all.nl> escreveu:

> On 3/20/19 1:55 PM, Mauro Carvalho Chehab wrote:
> > Em Wed, 20 Mar 2019 13:33:04 +0100
> > hverkuil-cisco@xs4all.nl escreveu:
> >   
> >> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> >>
> >> Stateless codecs require the use of the Request API as opposed of it
> >> being optional.
> >>
> >> So add a bit to indicate this and let vb2 check for this.
> >>
> >> If an attempt is made to queue a buffer without an associated request,
> >> then the EBADR error is returned to userspace.
> >>
> >> Doing this check in the vb2 core simplifies drivers, since they
> >> don't have to check for this, they can just set this flag.
> >>
> >> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> >> Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> >> ---
> >>  Documentation/media/uapi/v4l/vidioc-qbuf.rst    | 4 ++++
> >>  drivers/media/common/videobuf2/videobuf2-core.c | 9 +++++++++
> >>  drivers/media/common/videobuf2/videobuf2-v4l2.c | 4 ++++
> >>  include/media/videobuf2-core.h                  | 3 +++
> >>  4 files changed, 20 insertions(+)
> >>
> >> diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> >> index c138d149faea..5739c3676062 100644
> >> --- a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> >> +++ b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> >> @@ -189,6 +189,10 @@ EACCES
> >>      The ``V4L2_BUF_FLAG_REQUEST_FD`` flag was set but the device does not
> >>      support requests for the given buffer type.
> >>  
> >> +EBADR
> >> +    The ``V4L2_BUF_FLAG_REQUEST_FD`` flag was not set but the device requires
> >> +    that the buffer is part of a request.
> >> +  
> > 
> > Hmm... IMO, you should replace the previous text instead:
> > 
> > 	EACCES
> > 	    The ``V4L2_BUF_FLAG_REQUEST_FD`` flag was set but the device does not
> > 	    support requests for the given buffer type.  
> 
> No. This is already being returned, so changing this will be an API change.
> 
> That said, since the only drivers that can return this are vivid, vim2m and cedrus,
> (i.e. test and staging drivers), I am OK to change this to EBADR as well.
> 
> In that case it would become:
> 
> EBADR
> 	The ``V4L2_BUF_FLAG_REQUEST_FD`` flag was set but the device driver does
>         not support requests for the given buffer type, or the
>         ``V4L2_BUF_FLAG_REQUEST_FD`` flag was not set but the device driver
>         requires that the buffer is part of a request.

Ok, let's do that, as, IMHO, it makes it a lot more clear.

> 
> > 
> > Also, I would replace:
> > 
> > 	device -> device driver
> > 
> > As this ia a device driver limitation of the current implementation, 
> > with may or may not reflect a hardware limitation.
> >   
> >>  EBUSY
> >>      The first buffer was queued via a request, but the application now tries
> >>      to queue it directly, or vice versa (it is not permitted to mix the two
> >> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> >> index 678a31a2b549..b98ec6e1a222 100644
> >> --- a/drivers/media/common/videobuf2/videobuf2-core.c
> >> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> >> @@ -1507,6 +1507,12 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
> >>  
> >>  	vb = q->bufs[index];
> >>  
> >> +	if (!req && vb->state != VB2_BUF_STATE_IN_REQUEST &&
> >> +	    q->requires_requests) {
> >> +		dprintk(1, "qbuf requires a request\n");
> >> +		return -EBADR;
> >> +	}
> >> +
> >>  	if ((req && q->uses_qbuf) ||
> >>  	    (!req && vb->state != VB2_BUF_STATE_IN_REQUEST &&
> >>  	     q->uses_requests)) {
> >> @@ -2238,6 +2244,9 @@ int vb2_core_queue_init(struct vb2_queue *q)
> >>  	    WARN_ON(!q->ops->buf_queue))
> >>  		return -EINVAL;
> >>  
> >> +	if (WARN_ON(q->requires_requests && !q->supports_requests))
> >> +		return -EINVAL;
> >> +  
> > 
> > Shouldn't it also be EBADR?  
> 
> No, this checks that the driver doesn't set requires_requests without
> also setting supports_requests. I.e. this indicates a driver bug, hence
> the WARN_ON. Requiring requests, but not supporting them makes obviously
> no sense.

Ok.

Thanks,
Mauro
