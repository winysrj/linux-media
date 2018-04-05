Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:38915 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751332AbeDEVS3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2018 17:18:29 -0400
Received: by mail-wm0-f50.google.com with SMTP id f125so10972595wme.4
        for <linux-media@vger.kernel.org>; Thu, 05 Apr 2018 14:18:28 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Thu, 5 Apr 2018 23:18:26 +0200
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v13 16/33] rcar-vin: simplify how formats are set and
 reset
Message-ID: <20180405211826.GF15406@bigcity.dyn.berto.se>
References: <20180326214456.6655-1-niklas.soderlund+renesas@ragnatech.se>
 <20180326214456.6655-17-niklas.soderlund+renesas@ragnatech.se>
 <1544952.AcMr2TBica@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1544952.AcMr2TBica@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for your feedback.

I have incorporated your suggestions for the next and hopefully last 
version of this patch-set, a few followups on your review bellow.

On 2018-04-04 01:09:29 +0300, Laurent Pinchart wrote:
> Hi Niklas,
> 
> Thank you for the patch.
> 
> On Tuesday, 27 March 2018 00:44:39 EEST Niklas Söderlund wrote:
> > With the recent cleanup of the format code to prepare for Gen3 it's
> > possible to simplify the Gen2 format code path as well. Clean up the
> > process by defining two functions to handle the set format and reset of
> > format when the standard is changed.
> > 
> > While at it replace the driver local struct rvin_source_fmt with a
> > struct v4l2_rect as all it's used for is keep track of the source
> > dimensions.
> 
> I wonder whether we should introduce v4l2_size (or <insert your preferred name 
> here>) when all we need is width and height, as v4l2_rect stores the top and 
> left offsets too. This doesn't have to be fixed here though.

Yes that would have been useful for this change. I have added this to my 
ever growing TODO list :-)

[snip]

> 
> > -	vin->format.bytesperline = rvin_format_bytesperline(&vin->format);
> > -	vin->format.sizeimage = rvin_format_sizeimage(&vin->format);
> > +	vin->source.top = vin->crop.top = 0;
> > +	vin->source.left = vin->crop.left = 0;
> > +	vin->source.width = vin->crop.width = vin->format.width;
> > +	vin->source.height = vin->crop.height = vin->format.height;
> 
> I find multiple assignations on the same line hard to read. How about
> 
> 	vin->source.top = 0;
> 	vin->source.left = 0;
> 	vin->source.width = vin->format.width;
> 	vin->source.height = vin->format.height;
> 
> 	vin->crop = vin->source;
> 	vin->compose = vin->source;

This looks much better and I will use it, thanks !

[snip]

> 
> > +	/*
> > +	 * If source is ALTERNATE the driver will use the VIN hardware
> > +	 * to INTERLACE it. The crop height then needs to be doubled.
> > +	 */
> > +	if (pix->field == V4L2_FIELD_ALTERNATE)
> > +		crop->height *= 2;
> 
> You're duplicating this logic in rvin_format_align() so it makes me feel that 
> there's still room for some simplification, but that can be done in a separate 
> patch (or I could simply be wrong).

I'm sure someone more clever then me can simplify this more. In this 
particular case rvin_format_align() deals with the video device format 
while here we deal with the crop rectangle. I will keep this in mind for 
future work and see if this can be unified in simpler way.

[snip]

> > -	return __rvin_try_format(vin, V4L2_SUBDEV_FORMAT_TRY, 
> > &f->fmt.pix,
> > -				 &source);
> > +	return rvin_try_format(vin, V4L2_SUBDEV_FORMAT_TRY, &f->fmt.pix, &crop,
> > +			       &compose);
> 
> How about making crop and compose optional in rvin_try_format() to avoid a 
> need for the two local variables here ?

Great suggestion, I have incorporated this for the next version.

> 
> Apart from these small issues, I think this is a nice simplification,
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks!

-- 
Regards,
Niklas Söderlund
