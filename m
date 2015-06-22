Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:51070 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753790AbbFVHWE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2015 03:22:04 -0400
Date: Mon, 22 Jun 2015 09:21:46 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org, william.towle@codethink.co.uk,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 04/14] tw9910: init priv->scale and update standard
In-Reply-To: <5587B39A.4050805@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1506220920280.13683@axis700.grange>
References: <1434368021-7467-1-git-send-email-hverkuil@xs4all.nl>
 <1434368021-7467-5-git-send-email-hverkuil@xs4all.nl>
 <Pine.LNX.4.64.1506211855010.7745@axis700.grange> <5587B39A.4050805@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, 22 Jun 2015, Hans Verkuil wrote:

> On 06/21/2015 07:23 PM, Guennadi Liakhovetski wrote:
> > On Mon, 15 Jun 2015, Hans Verkuil wrote:
> > 
> >> From: Hans Verkuil <hans.verkuil@cisco.com>
> >>
> >> When the standard changes the VACTIVE and VDELAY values need to be updated.
> >>
> >> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> ---
> >>  drivers/media/i2c/soc_camera/tw9910.c | 29 ++++++++++++++++++++++++++++-
> >>  1 file changed, 28 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/media/i2c/soc_camera/tw9910.c b/drivers/media/i2c/soc_camera/tw9910.c
> >> index df66417..e939c24 100644
> >> --- a/drivers/media/i2c/soc_camera/tw9910.c
> >> +++ b/drivers/media/i2c/soc_camera/tw9910.c
> >> @@ -510,13 +510,39 @@ static int tw9910_s_std(struct v4l2_subdev *sd, v4l2_std_id norm)
> >>  {
> >>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
> >>  	struct tw9910_priv *priv = to_tw9910(client);
> >> +	const unsigned hact = 720;
> >> +	const unsigned hdelay = 15;
> >> +	unsigned vact;
> >> +	unsigned vdelay;
> >> +	int ret;
> >>  
> >>  	if (!(norm & (V4L2_STD_NTSC | V4L2_STD_PAL)))
> >>  		return -EINVAL;
> >>  
> >>  	priv->norm = norm;
> >> +	if (norm & V4L2_STD_525_60) {
> >> +		vact = 240;
> >> +		vdelay = 18;
> >> +		ret = tw9910_mask_set(client, VVBI, 0x10, 0x10);
> >> +	} else {
> >> +		vact = 288;
> >> +		vdelay = 24;
> >> +		ret = tw9910_mask_set(client, VVBI, 0x10, 0x00);
> >> +	}
> >> +	if (!ret)
> >> +		ret = i2c_smbus_write_byte_data(client, CROP_HI,
> >> +			((vdelay >> 2) & 0xc0) |
> >> +			((vact >> 4) & 0x30) |
> >> +			((hdelay >> 6) & 0x0c) |
> >> +			((hact >> 8) & 0x03));
> > 
> > I personally would find ((x & 0xc0) >> {2,4,6,8}) a bit easier for the 
> > eyes, but this works as well for me:)
> > 
> >> +	if (!ret)
> >> +		ret = i2c_smbus_write_byte_data(client, VDELAY_LO,
> >> +			vdelay & 0xff);
> >> +	if (!ret)
> >> +		ret = i2c_smbus_write_byte_data(client, VACTIVE_LO,
> >> +			vact & 0xff);
> >>  
> >> -	return 0;
> >> +	return ret;
> >>  }
> >>  
> >>  #ifdef CONFIG_VIDEO_ADV_DEBUG
> >> @@ -820,6 +846,7 @@ static int tw9910_video_probe(struct i2c_client *client)
> >>  		 "tw9910 Product ID %0x:%0x\n", id, priv->revision);
> >>  
> >>  	priv->norm = V4L2_STD_NTSC;
> >> +	priv->scale = &tw9910_ntsc_scales[0];
> > 
> > Why do you need this? So far everywhere in the code priv->scale is either 
> > checked or set before use. Don't see why an additional initialisation is 
> > needed.
> 
> If you just start streaming without explicitly setting up formats (which is
> allowed), then priv->scale is still NULL.

Yes, it can well be NULL, but it is also unused. Before it is used it will 
be set, while it is unused it is allowed to stay NULL.

Thanks
Guennadi

> V4L2 always assumes that there is some initial format configured, and this line
> enables that for this driver (NTSC).
> 
> Regards,
> 
> 	Hans
> 
> > 
> > Thanks
> > Guennadi
> > 
> >>  
> >>  done:
> >>  	tw9910_s_power(&priv->subdev, 0);
> >> -- 
> >> 2.1.4
> >>
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > 
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
