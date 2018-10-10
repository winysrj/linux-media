Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:53382 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726600AbeJJUDm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 Oct 2018 16:03:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Sam Bobrowicz <sam@elite-embedded.com>,
        linux-media@vger.kernel.org,
        Hugues Fruchet <hugues.fruchet@st.com>,
        loic.poulain@linaro.org, slongerbeam@gmail.com, daniel@zonque.org,
        maxime.ripard@bootlin.com
Subject: Re: [PATCH 1/4] media: ov5640: fix resolution update
Date: Wed, 10 Oct 2018 15:41:41 +0300
Message-ID: <5292714.SW9firoZdu@avalon>
In-Reply-To: <20181010105804.GD7677@w540>
References: <1539067682-60604-1-git-send-email-sam@elite-embedded.com> <1539067682-60604-2-git-send-email-sam@elite-embedded.com> <20181010105804.GD7677@w540>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Wednesday, 10 October 2018 13:58:04 EEST jacopo mondi wrote:
> Hi Sam,
>    thanks for the patch, I see the same issue you reported, but I
> think this patch can be improved.
> 
> (expanding the Cc list to all people involved in recent ov5640
> developemts, not just for this patch, but for the whole series to look
> at. Copying names from another series cover letter, hope it is
> complete.)
> 
> On Mon, Oct 08, 2018 at 11:47:59PM -0700, Sam Bobrowicz wrote:
> > set_fmt was not properly triggering a mode change when
> > a new mode was set that happened to have the same format
> > as the previous mode (for example, when only changing the
> > frame dimensions). Fix this.
> > 
> > Signed-off-by: Sam Bobrowicz <sam@elite-embedded.com>
> > ---
> > 
> >  drivers/media/i2c/ov5640.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> > index eaefdb5..5031aab 100644
> > --- a/drivers/media/i2c/ov5640.c
> > +++ b/drivers/media/i2c/ov5640.c
> > @@ -2045,12 +2045,12 @@ static int ov5640_set_fmt(struct v4l2_subdev *sd,
> > 
> >  		goto out;
> >  	
> >  	}
> > 
> > -	if (new_mode != sensor->current_mode) {
> > +
> > +	if (new_mode != sensor->current_mode ||
> > +	    mbus_fmt->code != sensor->fmt.code) {
> > +		sensor->fmt = *mbus_fmt;
> > 
> >  		sensor->current_mode = new_mode;
> >  		sensor->pending_mode_change = true;
> > 
> > -	}
> > -	if (mbus_fmt->code != sensor->fmt.code) {
> > -		sensor->fmt = *mbus_fmt;
> > 
> >  		sensor->pending_fmt_change = true;
> >  	
> >  	}
> 
> How I did reproduce the issue:
> 
> # Set 1024x768 on ov5640 without changing the image format
> # (default image size at startup is 640x480)
> $ media-ctl --set-v4l2 "'ov5640 2-003c':0[fmt:UYVY2X8/1024x768 field:none]"
>   sensor->pending_mode_change = true; //verified this flag gets set
> 
> # Start streaming, after having configured the whole pipeline to work
> # with 1024x768
> $  yavta -c10 -n4 -f UYVY -s 1024x768 /dev/video4
>    Unable to start streaming: Broken pipe (32).
> 
> # Inspect which part of pipeline validation went wrong
> # Turns out the sensor->fmt field is not updated, and when get_fmt()
> # is called, the old one is returned.
> $ media-ctl -e "ov5640 2-003c" -p
>   ...
>   [fmt:UYVY8_2X8/640x480@1/30 field:none colorspace:srgb xfer:srgb ycbcr:601
> quantization:full-range] ^^^ ^^^
> 
> So yes, sensor->fmt is not udapted as it should be when only image
> resolution is changed.
> 
> Although I still see value in having two separate flags for the
> 'mode_change' (which in ov5640 lingo is resolution) and 'fmt_change' (which
> in ov5640 lingo is the image format), and write their configuration to
> registers only when they get actually changed.
> 
> For this reasons I would like to propse the following patch which I
> have tested by:
> 1) changing resolution only
> 2) changing format only
> 3) change both
> 
> What do you and others think?

I think that the format setting code should be completely rewritten, it's 
pretty much unmaintainable as-is.

> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index eaefdb5..e392b9d 100644
> --- a/drivers/media/i2c/ov5640.c
> +++ b/drivers/media/i2c/ov5640.c
> @@ -2020,6 +2020,7 @@ static int ov5640_set_fmt(struct v4l2_subdev *sd,
>         struct ov5640_dev *sensor = to_ov5640_dev(sd);
>         const struct ov5640_mode_info *new_mode;
>         struct v4l2_mbus_framefmt *mbus_fmt = &format->format;
> +       struct v4l2_mbus_framefmt *fmt;
>         int ret;
> 
>         if (format->pad != 0)
> @@ -2037,22 +2038,19 @@ static int ov5640_set_fmt(struct v4l2_subdev *sd,
>         if (ret)
>                 goto out;
> 
> -       if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
> -               struct v4l2_mbus_framefmt *fmt =
> -                       v4l2_subdev_get_try_format(sd, cfg, 0);
> +       if (format->which == V4L2_SUBDEV_FORMAT_TRY)
> +               fmt = v4l2_subdev_get_try_format(sd, cfg, 0);
> +       else
> +               fmt = &sensor->fmt;
> 
> -               *fmt = *mbus_fmt;
> -               goto out;
> -       }
> +       *fmt = *mbus_fmt;
> 
>         if (new_mode != sensor->current_mode) {
>                 sensor->current_mode = new_mode;
>                 sensor->pending_mode_change = true;
>         }
> -       if (mbus_fmt->code != sensor->fmt.code) {
> -               sensor->fmt = *mbus_fmt;
> +       if (mbus_fmt->code != sensor->fmt.code)
>                 sensor->pending_fmt_change = true;
> -       }
>  out:
>         mutex_unlock(&sensor->lock);
>         return ret;
> 
> >  out:
> > --
> > 2.7.4


-- 
Regards,

Laurent Pinchart
