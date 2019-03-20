Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69C7AC43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 13:10:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28FF72184D
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 13:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553087406;
	bh=NlnvZr5zc87PRi9QMGCOOKgciquK6Orvr6euflYbilo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=U/Xxy5Sx/y5ceSd34Hw6uhvMLOD82OAI00OPC9ya+Sb+zeqKfw4hRjfAaAl1IUlba
	 8fbUf4t3hTPFX595xIvCrSR1aaSWhrcdvCUphfqK+PtSDr0DvekRGZ98yCzpEgkqRv
	 3rZcubsaGywdj81nTQLpi2AOGx+YjXYERYa1Rn8c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfCTNKF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 09:10:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:34214 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726939AbfCTNKF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 09:10:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=VpKkoYO1EhkujR5Eu/WRA6hOE3g0+vDV8M6bxtwtaSE=; b=aO898U9GD/PvbjQnHCQU/nEm6b
        LLUFhaxyp7Tf64iN6k7EfchckRMSajTlCRzkKjhbM88qUiujufMx8lY1++xZT+zwAtsxC12R4SnaA
        DS+pc2er458g6HLHxoRHwA3kJYQ6UcX8GFbPLIdN67A+kYdmVCUJQyKmNaWamKMLxIW+L5yhoI/iX
        iQJflmvjybTiYxeGzRR42JJ4mAjStifIY5wSYeU0yv//KPCunyR4T6I/ac65cXSOgQantVtIH9NNQ
        TOdp9ifjcM3JYV8M+sKqewuWAUVpCrRxZuHe6b78CkQSmWp7ub7r6zojTs6L0F+igkJxGis5PvXXf
        c0tYwJ1Q==;
Received: from [179.95.24.146] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1h6ayo-0006yU-N8; Wed, 20 Mar 2019 13:10:03 +0000
Date:   Wed, 20 Mar 2019 10:09:58 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org,
        helen.koike@collabora.com, Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: Re: [PATCH v5 02/23] videodev2.h: add
 V4L2_BUF_CAP_REQUIRES_REQUESTS
Message-ID: <20190320100958.019fb382@coco.lan>
In-Reply-To: <10b33081-7b79-bae9-6325-1904d76f3717@xs4all.nl>
References: <20190306211343.15302-1-dafna3@gmail.com>
        <20190306211343.15302-3-dafna3@gmail.com>
        <20190320071112.4ed71c54@coco.lan>
        <ca97c48b-3b7f-3c97-ec19-54469604fe79@xs4all.nl>
        <20190320084239.7e58aa05@coco.lan>
        <fe5b914b-1775-496a-20cc-c7fb01eb01d1@xs4all.nl>
        <20190320093754.5992c89e@coco.lan>
        <10b33081-7b79-bae9-6325-1904d76f3717@xs4all.nl>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Wed, 20 Mar 2019 13:41:42 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 3/20/19 1:37 PM, Mauro Carvalho Chehab wrote:
> > Em Wed, 20 Mar 2019 13:20:07 +0100
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >   
> >>>> The only affected driver is the staging cedrus driver. And that will
> >>>> actually crash if you try to use it without requests.
> >>>>
> >>>> If you look at patch 3 you'll see that it just sets the flag and doesn't
> >>>> remove any code that was supposed to check for use-without-requests.
> >>>> That's because there never was a check and the driver would just crash.
> >>>>
> >>>> So we're safe here.    
> >>>
> >>> Making it mandatory for the cedrus driver makes sense, but no other
> >>> current driver should ever use it.     
> >>
> >> The only other drivers that implement the request API are vivid and vim2m.
> >>
> >> For both the request API is optional.
> >>
> >> And of course this patch series that adds the stateless decoder support to
> >> vicodec, so vicodec is the only other driver besides the cedrus driver that
> >> sets this flag.  
> > 
> > The current vicodec implementation is only stateless?  
> 
> vicodec before this series is only stateful. After this series a new video node
> is added which is for the stateless decoder. And that device will require
> requests.

I see. see below.

> 
> >   
> >>> The problem I see is that, as we advance on improving the requests API,
> >>> non-stateless-codec drivers may end supporting the request API. 
> >>> That's perfectly fine, but such other drivers should *never* be
> >>> changed to use V4L2_BUF_CAP_REQUIRES_REQUESTS. This also applies to any
> >>> new driver that it is not implementing a stateless codec.
> >>>
> >>> Btw, as this seems to be a requirement only for stateless codec drivers,
> >>> perhaps we should (at least in Kernelspace) to use, instead, a
> >>> V4L2_BUF_CAP_STATELESS_CODEC_ONLY flag, with the V4L2 core would
> >>> translate it to V4L2_BUF_CAP_REQUIRES_REQUESTS before returning it to
> >>> userspace, and have a special #ifdef at the userspace header, in order
> >>> to prevent this flag to be set directly by a random driver.    
> >>
> >> I don't think this makes sense. Requiring requests is not something you
> >> can miss since you have to code for it.
> >>
> >> However, there is something else that we need to think about and that is
> >> that V4L2_BUF_CAP_REQUIRES_REQUESTS can be format specific. E.g. a stateless
> >> codec driver can also support a JPEG codec, and for that format requests
> >> are most likely not required at all. So this capability might actually be
> >> format-specific.  
> > 
> > Yes, on formats that don't have temporal compression, there's no sense
> > to make request API mandatory.
> > 
> > For formats that have temporal compression, the codec driver can either 
> > be stateless or stateful (or even support both modes).
> > 
> > It sounds to me that a flag like that should be returned by S_FMT and
> > TRY_FMT or on a separate ioctl.
> > 
> > It also seems to make sense if userspace could select between stateless
> > and stateful modes, if the driver supports both modes for the same
> > fourcc.  
> 
> That can't happen. The stateless formats have their own fourcc. It really
> is a different format.

Well, if we're already defining different fourcc for the stateless
codecs, then I think that your proposed patch:

	[PATCH v5.1 2/2] cedrus: set requires_requests

Is not the best way to implement it.

	Instead, I would have a helper function like:

static int v4l2_format_requires_request_api(uint32 fourcc)
{
	switch(fourcc) {
	case V4L2_PIX_FMT_MPEG2_SLICE:
		return 1;
	default:
		return 0;
	}
}

called by V4L2 core at S_FMT handler in order to set vq->requires_requests.

Also, in this case, I would add a V4L2_FMT_FLAG_REQUIRE_REQUEST_API or
V4L2_FMT_FLAG_STATELESS_CODEC flag at VIDIOC_ENUM_FMT in order to
indicate it.

Thanks,
Mauro
