Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE3CDC67839
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 13:07:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2E6A20849
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 13:07:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="of/NSE3j"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B2E6A20849
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ideasonboard.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729218AbeLMNHr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 08:07:47 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:55470 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729175AbeLMNHr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 08:07:47 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id CC2AE549;
        Thu, 13 Dec 2018 14:07:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1544706465;
        bh=6LCiEnjTK4Knp4IdjdbDYkuc0rlJEI9hiQnQRGrqBT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=of/NSE3jexzEg+h1DT/ZBKcaoDxtsYI+6UPB38XYAHOL7VBn1NtIYwFjF6LgkrVSW
         RmCfpxS+UKSCx92dC3tryn7FGkaZOmIPcrr6LA5px3NO7CtyyoGYWl6pcwXCOPco6j
         Q0lu/zQYGlYsYxSNYuKvpplsmf7qcBeZjoqghL3Y=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     linux-media@vger.kernel.org, hverkuil@xs4all.nl, mchehab@kernel.org
Subject: Re: [PATCH 3/3] videobuf2-core.h: Document the alloc memop size argument as page aligned
Date:   Thu, 13 Dec 2018 15:08:32 +0200
Message-ID: <1577929.OiQQvTjWSZ@avalon>
Organization: Ideas on Board Oy
In-Reply-To: <20181213130203.jzjltl6hxlwlp5wk@paasikivi.fi.intel.com>
References: <20181213104006.401-1-sakari.ailus@linux.intel.com> <2569261.dXsbqdVbdC@avalon> <20181213130203.jzjltl6hxlwlp5wk@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sakari,

On Thursday, 13 December 2018 15:02:03 EET Sakari Ailus wrote:
> On Thu, Dec 13, 2018 at 02:59:50PM +0200, Laurent Pinchart wrote:
> > On Thursday, 13 December 2018 12:40:06 EET Sakari Ailus wrote:
> > > The size argument of the alloc memop, which allocates buffer memory, is
> > > page aligned. Document it as such, as code elsewhere has not taken this
> > > into account.
> > > 
> > > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > ---
> > > 
> > >  include/media/videobuf2-core.h | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/include/media/videobuf2-core.h
> > > b/include/media/videobuf2-core.h index e86981d615ae4..68b9fe660e4f1
> > > 100644
> > > --- a/include/media/videobuf2-core.h
> > > +++ b/include/media/videobuf2-core.h
> > > @@ -54,7 +54,8 @@ struct vb2_threadio_data;
> > >   *		will then be passed as @buf_priv argument to other ops in this
> > >   *		structure. Additional gfp_flags to use when allocating the
> > >   *		are also passed to this operation. These flags are from the
> > > - *		gfp_flags field of vb2_queue.
> > > + *		gfp_flags field of vb2_queue. The size argument to this function
> > > + *		shall be *page aligned*.
> > >   * @put:	inform the allocator that the buffer will no longer be used;
> > >   *		usually will result in the allocator freeing the buffer (if
> > >   *		no other users of this buffer are present); the @buf_priv
> > 
> > I wonder if a WARN_ON() to ensure this would make sense. In any case,
> 
> There's a single place where the alloc() op is called. I thought it'd be
> silly to put a check after the line of code that performs the alignment.

I was thinking about WARN_ON in the memory allocators, but if it's called from 
a single place, I agree it may not be needed. A comment in the dma-sg 
allocator would be useful though.

> Perhaps a comment right there?
> 
> I'm open to other ideas that don't seem silly. :-)

Stop calling my ideas silly :-)

> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart



