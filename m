Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:36811 "EHLO
        mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755338AbdETO36 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 20 May 2017 10:29:58 -0400
Received: by mail-lf0-f42.google.com with SMTP id h4so12902126lfj.3
        for <linux-media@vger.kernel.org>; Sat, 20 May 2017 07:29:57 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Sat, 20 May 2017 16:29:54 +0200
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 02/16] rcar-vin: use rvin_reset_format() in S_DV_TIMINGS
Message-ID: <20170520142954.GB1229@bigcity.dyn.berto.se>
References: <20170314185957.25253-1-niklas.soderlund+renesas@ragnatech.se>
 <20170314185957.25253-3-niklas.soderlund+renesas@ragnatech.se>
 <5932754.eWeQtlWCiC@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5932754.eWeQtlWCiC@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for your feedback.

On 2017-05-10 16:22:16 +0300, Laurent Pinchart wrote:
> Hi Niklas,
> 
> Thank you for the patch.
> 
> On Tuesday 14 Mar 2017 19:59:43 Niklas Söderlund wrote:
> > Use rvin_reset_format() in rvin_s_dv_timings() instead of just resetting
> > a few fields. This fixes an issue where the field format was not
> > properly set after S_DV_TIMINGS.
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-v4l2.c | 8 ++------
> >  1 file changed, 2 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> > 69bc4cfea6a8aeb5..7ca27599b9982ffc 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > @@ -573,12 +573,8 @@ static int rvin_s_dv_timings(struct file *file, void
> > *priv_fh, if (ret)
> >  		return ret;
> > 
> > -	vin->source.width = timings->bt.width;
> > -	vin->source.height = timings->bt.height;
> > -	vin->format.width = timings->bt.width;
> > -	vin->format.height = timings->bt.height;
> > -
> > -	return 0;
> > +	/* Changing the timings will change the width/height */
> > +	return rvin_reset_format(vin);
> 
> vin->source won't be updated anymore. Is this intentional ?

Yes this is intentional. vin->source cache the frame width and height 
from the source subdevice, and this is done in .vidioc_s_fmt_vid_cap().  

This cacheing was due to a misunderstanding on my part in the port from 
soc_camera and the whole vin->source caching is removed in later patch 
when cleaning up the scaling code in the Gen3 enablement series.

> 
> >  }
> > 
> >  static int rvin_g_dv_timings(struct file *file, void *priv_fh,
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 

-- 
Regards,
Niklas Söderlund
