Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:39399 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727850AbeIFRfI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Sep 2018 13:35:08 -0400
Message-ID: <1536238781.5357.10.camel@pengutronix.de>
Subject: Re: [PATCH v2] [RFC v2] v4l2: add support for colorspace conversion
 for video capture
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hansverk@cisco.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Date: Thu, 06 Sep 2018 14:59:41 +0200
In-Reply-To: <1a7f54dc-15e5-9bbe-b684-ba441e1b9c7a@cisco.com>
References: <20180905170932.14370-1-p.zabel@pengutronix.de>
         <2cf2e7e5-f79a-4717-a04f-87eff7d8f3e6@xs4all.nl>
         <1536227404.5357.5.camel@pengutronix.de>
         <1a7f54dc-15e5-9bbe-b684-ba441e1b9c7a@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2018-09-06 at 12:54 +0200, Hans Verkuil wrote:
[...]
> > The application usually doesn't need to know whether the driver changed
> > the requested ycbcr_enc because it doesn't have CSC matrix support at
> > all, or because it doesn't implement a specific conversion. And if the
> > application needs to know for some reason, it can always check
> > VIDIOC_ENUM_FMT.
> > 
> > > I don't think so, but I think that
> > > is already true for the existing flag V4L2_PIX_FMT_FLAG_PREMUL_ALPHA.
> > 
> > The only drivers using V4L2_PIX_FMT_FLAG_PREMUL_ALPHA I can see are
> > vsp1_brx and vsp1_rpf. They never write to the v4l2_pix_format flags
> > field.
> 
> But they honor it. The problem is that I can set this flag and call S_FMT
> on e.g. the vivid driver, and S_FMT will return the flag. But it actually
> doesn't use the flag at all, so userspace has no way of knowing if the
> flag is actually used.

Userspace can see if its requested colorspace, etc. were changed by the
driver, though.

> Although it can call G_FMT and then the flag is cleared.

So if drivers were to clear the flag, would they clear it if they don't
support the flag at all, or also if they support the flag in principle,
but can't convert into the specific requested value?

Would all drivers have to be modified to clear those flags? I suppose
rather the framework should be extended to set the flags on ENUM_FMT and
to mask the TRY/S_FMT flags with those.

> > > I wonder if V4L2_PIX_FMT_FLAG_PREMUL_ALPHA should also get an equivalent
> > > flag for v4l2_fmtdesc.
> > 
> > Isn't this useless to introduce after the fact, if there are already
> > applications that use this feature? They can't depend on the existence
> > of this flag to check for support anyway.
> 
> Those applications are already hardcoded for the vsp1. So they won't break
> by adding v4l2_fmtdesc flags.
> 
> But apps like gstreamer and friends can start using these flags and deduce
> what the HW is capable of.

I see. In that case I agree.

regards
Philipp
