Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:56836
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751427AbdFHLlY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Jun 2017 07:41:24 -0400
Date: Thu, 8 Jun 2017 08:41:10 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Helen Koike <helen.koike@collabora.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC PATCH] [media] v4l2-subdev: check colorimetry in link
 validate
Message-ID: <20170608084110.1ac282c5@vento.lan>
In-Reply-To: <847518b4-ad8f-afc3-29b7-7f1b3a16f57e@collabora.com>
References: <1496171288-28656-1-git-send-email-helen.koike@collabora.com>
        <20170531063116.GE1019@valkosipuli.retiisi.org.uk>
        <847518b4-ad8f-afc3-29b7-7f1b3a16f57e@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 6 Jun 2017 19:15:34 -0300
Helen Koike <helen.koike@collabora.com> escreveu:

> Hi Sakari,
> 
> 
> Thanks for replying
> 
> On 2017-05-31 03:31 AM, Sakari Ailus wrote:
> > Hi Helen,
> >
> > On Tue, May 30, 2017 at 04:08:08PM -0300, Helen Koike wrote:  
> >> colorspace, ycbcr_enc, quantization and xfer_func must match across the
> >> link.
> >> Check if they match in v4l2_subdev_link_validate_default unless they are
> >> set as _DEFAULT.
> >>
> >> Signed-off-by: Helen Koike <helen.koike@collabora.com>
> >>
> >> ---
> >>
> >> Hi,
> >>
> >> I think we should validate colorimetry as having different colorimetry
> >> across a link doesn't make sense.
> >> But I am confused about what to do when they are set to _DEFAULT, what
> >> do you think?  
> >
> > These fields were added at various points over the course of the past three
> > years or so. User space code that was written before that will certainly not
> > set anything and I'm not sure many drivers care about these fields nor they
> > are relevant for many formats. In practice that means that they are very
> > likely zero in many cases.  
> 
> If they are set to zero then they won't be affected by this patch.
> 
> >
> > Driver changes will probably be necessary for removing the explicit checks
> > for the default value.  
> 
> At least in the drivers/media tree I couldn't find many drivers that 
> implement its own link_validate, there is only 
> platform/omap3isp/ispccdc.c and platform/omap3isp/ispresizer.c that 
> implements a custom value, but from a quick look it doesn't seems that 
> they will be affected.
> 
> >
> > The same applies to checking the colour space: drivers should enforce using
> > the correct colour space before the check can be merged. I might move that
> > to a separate patch.  
> 
> I am not sure if I got what you mean. If driver don't care about 
> colourspace then probably it will be set to zero and won't be affected 
> by this patch, if colourspace is different across the link then the user 
> space must set both ends to the same colourspace.

I guess what Sakari is concerned about is to avoid regressions.

Colorimetry properties were added after the addition of most of
the drivers. Adding a mandatory link validation may break drivers
that don't set it right. Even on new drivers, this may not be ok.

Just to give you an example, this week I just applied a patch fixing
colorimetry handling at the coda driver:
	https://git.linuxtv.org/media_tree.git/commit/?id=b14ac545688d8cc4b2b707d71d106799ad476964

If a change like that would have been applied before such fix, it 
could be breaking coda.

So, before adding such patch, we need to check how existing drivers are
setting colorimetry fields, to be sure that the ones that don't
touch it won't break.

Perhaps one alternative would be to write a patchset that would,
instead, print a warning at dmesg, and let it be upstream for a
while, to give people time to check if the colorimetry logic is
ok at the subdevs.

Thanks,
Mauro
