Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:38130 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751885AbeCCPT2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 3 Mar 2018 10:19:28 -0500
Received: by mail-lf0-f68.google.com with SMTP id i80so17361549lfg.5
        for <linux-media@vger.kernel.org>; Sat, 03 Mar 2018 07:19:28 -0800 (PST)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Sat, 3 Mar 2018 16:19:25 +0100
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v11 22/32] rcar-vin: force default colorspace for media
 centric mode
Message-ID: <20180303151924.GH12470@bigcity.dyn.berto.se>
References: <20180302015751.25596-1-niklas.soderlund+renesas@ragnatech.se>
 <20180302015751.25596-23-niklas.soderlund+renesas@ragnatech.se>
 <17480633.KWnsIYxeaE@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <17480633.KWnsIYxeaE@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for your feedback.

On 2018-03-02 11:59:14 +0200, Laurent Pinchart wrote:
> Hi Niklas,
> 
> Thank you for the patch.
> 
> On Friday, 2 March 2018 03:57:41 EET Niklas Söderlund wrote:
> > When the VIN driver is running in media centric mode (on Gen3) the
> > colorspace is not retrieved from the video source instead the user is
> > expected to set it as part of the format. There is no way for the VIN
> > driver to validated the colorspace requested by user-space, this creates
> > a problem where validation tools fail. Until the user requested
> > colorspace can be validated lets force it to the driver default.
> 
> The problem here is that the V4L2 specification clearly documents the 
> colorspace fields as being set by drivers for capture devices. Using the 
> values supplied by userspace thus wouldn't comply with the API. The API has to 
> be updated to allow us to implement this feature, but until then Hans wants 
> the userspace to be set by the driver to a fixed value. Could you update the 
> commit message accordingly, as well as the comment below ?

Yes, your description of the issue is better I will rephrase my commit 
message and comment.

> 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-v4l2.c | 16 ++++++++++++++--
> >  1 file changed, 14 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> > 8d92710efffa7276..02f3100ed30db63c 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > @@ -675,12 +675,24 @@ static const struct v4l2_ioctl_ops rvin_ioctl_ops = {
> >   * V4L2 Media Controller
> >   */
> > 
> > +static int rvin_mc_try_format(struct rvin_dev *vin, struct v4l2_pix_format
> > *pix) +{
> > +	/*
> > +	 * There is no way to validate the colorspace provided by the
> > +	 * user. Until it can be validated force colorspace to the
> > +	 * driver default.
> > +	 */
> > +	pix->colorspace = RVIN_DEFAULT_COLORSPACE;
> 
> Should you also set the xfer_func, quantization and ycbcr_enc ?

You are correct, I will set these fields as well.

> 
> Apart from that,
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thank you. As I have rewritten the commit message and set more fields 
then just the colorspace I have not picked up this tag for the next 
version.

> 
> > +
> > +	return rvin_format_align(vin, pix);
> > +}
> > +
> >  static int rvin_mc_try_fmt_vid_cap(struct file *file, void *priv,
> >  				   struct v4l2_format *f)
> >  {
> >  	struct rvin_dev *vin = video_drvdata(file);
> > 
> > -	return rvin_format_align(vin, &f->fmt.pix);
> > +	return rvin_mc_try_format(vin, &f->fmt.pix);
> >  }
> > 
> >  static int rvin_mc_s_fmt_vid_cap(struct file *file, void *priv,
> > @@ -692,7 +704,7 @@ static int rvin_mc_s_fmt_vid_cap(struct file *file, void
> > *priv, if (vb2_is_busy(&vin->queue))
> >  		return -EBUSY;
> > 
> > -	ret = rvin_format_align(vin, &f->fmt.pix);
> > +	ret = rvin_mc_try_format(vin, &f->fmt.pix);
> >  	if (ret)
> >  		return ret;
> 
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 

-- 
Regards,
Niklas Söderlund
