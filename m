Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54036 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbaCKQXO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 12:23:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH v3 27/48] v4l: Validate fields in the core code for subdev EDID ioctls
Date: Tue, 11 Mar 2014 17:24:49 +0100
Message-ID: <2281895.rql8Q6dghx@avalon>
In-Reply-To: <531F359B.9010103@xs4all.nl>
References: <1394493359-14115-28-git-send-email-laurent.pinchart@ideasonboard.com> <3176580.C10mxSGlFc@avalon> <531F359B.9010103@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tuesday 11 March 2014 17:11:07 Hans Verkuil wrote:
> On 03/11/2014 05:08 PM, Laurent Pinchart wrote:
> > Hi Hans,
> > 
> > On Tuesday 11 March 2014 16:44:27 Hans Verkuil wrote:
> >> On 03/11/2014 04:09 PM, Laurent Pinchart wrote:
> >>> The subdev EDID ioctls receive a pad field that must reference an
> >>> existing pad and an EDID field that must point to a buffer. Validate
> >>> both fields in the core code instead of duplicating validation in all
> >>> drivers.
> >>> 
> >>> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >>> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> >> 
> >> Here is my:
> >> 
> >> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> 
> >> But take note: the adv7604 driver does not handle a get_edid with
> >> edid->blocks == 0 correctly: it should fill in the blocks field with the
> >> real number of blocks and return 0 instead of returning EINVAL.
> > 
> > Should it also set edid->start_block to 0 ?
> 
> I don't think so. It makes sense to just set blocks to the total number of
> available blocks - edid->start_block.

OK.

> Note that if edid->start_block >= total number of EDID blocks, then -ENODATA
> should be returned.

What if S_EDID hasn't been called yet ? Should the driver set edid->blocks to 
0 and return success ? Or should it return -ENODATA ?

There's quite a few possible combinations, we should probably start by 
clarifying the spec.

-- 
Regards,

Laurent Pinchart

