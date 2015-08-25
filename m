Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:60191 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbbHYTmh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2015 15:42:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: g.liakhovetski@gmx.de, mchehab@osg.samsung.com,
	linux-media@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH] rcar_vin: propagate querystd() error upstream
Date: Tue, 25 Aug 2015 22:42:34 +0300
Message-ID: <1809035.RaYVlrkG2V@avalon>
In-Reply-To: <55DB936F.2060008@cogentembedded.com>
References: <1650569.JYNQd5Bi8T@wasted.cogentembedded.com> <2204711.y8psPZeT2j@avalon> <55DB936F.2060008@cogentembedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergei,

On Tuesday 25 August 2015 00:58:07 Sergei Shtylyov wrote:
> On 08/21/2015 12:51 AM, Laurent Pinchart wrote:
> >> rcar_vin_set_fmt() defaults to  PAL when the subdevice's querystd()
> >> method call fails (e.g. due to I2C error). This doesn't work very well
> >> when a camera being used  outputs NTSC which has different order of
> >> fields and resolution. Let us stop pretending and return the actual
> >> error (which would prevent video capture on at least Renesas
> >> Henninger/Porter board where I2C seems particularly buggy).
> >> 
> >> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> >> 
> >> ---
> >> The patch is against the 'media_tree.git' repo's 'fixes' branch.
> >> 
> >>   drivers/media/platform/soc_camera/rcar_vin.c |    2 +-
> >>   1 file changed, 1 insertion(+), 1 deletion(-)
> >> 
> >> Index: media_tree/drivers/media/platform/soc_camera/rcar_vin.c
> >> ===================================================================
> >> --- media_tree.orig/drivers/media/platform/soc_camera/rcar_vin.c
> >> +++ media_tree/drivers/media/platform/soc_camera/rcar_vin.c
> >> @@ -1592,7 +1592,7 @@ static int rcar_vin_set_fmt(struct soc_c
> >> 
> >>   		/* Query for standard if not explicitly mentioned _TB/_BT */
> >>   		ret = v4l2_subdev_call(sd, video, querystd, &std);
> >>   		if (ret < 0)
> >> -			std = V4L2_STD_625_50;
> >> +			return ret;
> > 
> > What if the subdev doesn't implement querystd ? That's the case of camera
> > sensors for instance.
> 
> Indeed.
> 
> > In that case we should default to V4L2_FIELD_NONE.
> 
> Hmm, even if the set_fmt() method is called with V4L2_FIELD_INTERLACED
> already, like in this case?

Yes. If the device doesn't support interlacing then the field passed to 
set_fmt() should be set to V4L2_FIELD_NONE. The V4L2 API requires drivers to 
fix unsupported parameters passed to the VIDIOC_S_FMT ioctl instead of 
returning an error like commonly done in such situation.

> >>   		field = std & V4L2_STD_625_50 ? V4L2_FIELD_INTERLACED_TB :
> >>   						V4L2_FIELD_INTERLACED_BT;

-- 
Regards,

Laurent Pinchart

