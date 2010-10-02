Return-path: <mchehab@pedra>
Received: from d1.icnet.pl ([212.160.220.21]:48368 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755312Ab0JBLtb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Oct 2010 07:49:31 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v3 3/6] SoC Camera: add driver for OV6650 sensor
Date: Sat, 2 Oct 2010 13:48:33 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"Discussion of the Amstrad E3 emailer hardware/software"
	<e3-hacking@earth.li>
References: <201009270514.01865.jkrzyszt@tis.icnet.pl> <Pine.LNX.4.64.1010020538500.14599@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1010020538500.14599@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201010021348.34560.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Saturday 02 October 2010 07:47:47 Guennadi Liakhovetski napisał(a):
> Ok, let's take this one, but, please, address the below couple of minor
> issues in an incremental patch.
>
> On Mon, 27 Sep 2010, Janusz Krzysztofik wrote:
> > +/* write a register */
> > +static int ov6650_reg_write(struct i2c_client *client, u8 reg, u8 val)
> > +{
> > +	int ret;
> > +	unsigned char data[2] = { reg, val };
> > +	struct i2c_msg msg = {
> > +		.addr	= client->addr,
> > +		.flags	= 0,
> > +		.len	= 2,
> > +		.buf	= data,
> > +	};
> > +
> > +	ret = i2c_transfer(client->adapter, &msg, 1);
> > +	usleep_range(100, 1000);
>
> So, 100us are enough? Then I'd just go with udelay(100).

Guennadi,
I already tried with udelay(100), as you had suggested before, and it worked, 
but then checkpatch.pl --sctirct told me:

"CHECK: usleep_range is preferred over udelay; see 
Documentation/timers/timers-howto.txt
+       udelay(100);"

So, I had read Documentation/timers/timers-howto.txt again and switched to 
usleep_range, as it suggested.

Please confirm if you still prefere udelay(100) over usleep_range(), and I'll 
change it back.

> > static bool is_unscaled_ok(int width, int height, struct v4l2_rect *rect)
> > +{
> > +	return (width > rect->width >> 1 || height > rect->height >> 1);
> > +}
>
> Ok, just one more pair of brackets to remove;)

OK.

> > +
> > +static u8 to_clkrc(struct v4l2_fract *timeperframe,
> > +		unsigned long pclk_limit, unsigned long pclk_max)
> > +{
> > +	unsigned long pclk;
> > +
> > +	if (timeperframe->numerator && timeperframe->denominator)
> > +		pclk = pclk_max * timeperframe->denominator /
> > +				(FRAME_RATE_MAX * timeperframe->numerator);
> > +	else
> > +		pclk = pclk_max;
> > +
> > +	if (pclk_limit && pclk_limit < pclk)
> > +		pclk = pclk_limit;
> > +
> > +	return (pclk_max - 1) / pclk;
> > +}
> > +
> > +/* set the format we will capture in */
> > +static int ov6650_s_fmt(struct v4l2_subdev *sd, struct
> > v4l2_mbus_framefmt *mf) +{
> > +	struct i2c_client *client = sd->priv;
> > +	struct soc_camera_device *icd = client->dev.platform_data;
> > +	struct soc_camera_sense *sense = icd->sense;
> > +	struct ov6650 *priv = to_ov6650(client);
> > +	bool half_scale = !is_unscaled_ok(mf->width, mf->height, &priv->rect);
> > +	struct v4l2_crop a = {
> > +		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
> > +		.c = {
> > +			.left	= priv->rect.left + (priv->rect.width >> 1) -
> > +					(mf->width >> (1 - half_scale)),
> > +			.top	= priv->rect.top + (priv->rect.height >> 1) -
> > +					(mf->height >> (1 - half_scale)),
> > +			.width	= mf->width << half_scale,
> > +			.height	= mf->height << half_scale,
> > +		},
> > +	};
>
> Hm, this seems wrong to me... You calculate left and top to preserve the
> center, right? 

Exactly.

> This is good, but: if output is unscaled, you want 
>
> 	.left = priv->rect.left + (priv->rect.width - mf->width) / 2;

	== priv->rect.left +  priv->rect.width  / 2  -   mf->width        /  2
	== priv->rect.left + (priv->rect.width >> 1) - ( mf->width       >>  1)
	== priv->rect.left + (priv->rect.width >> 1) - ( mf->width       >> (1 - 0))
>
> in this case half_scale = 0 and the above is correct. Now, is the output
> is scaled, you want
>
> 	.left = priv->rect.left + (priv->rect.width - mf->width * 2) / 2;

	== priv->rect.left +  priv->rect.width  / 2  -   mf->width  * 2   /  2
	== priv->rect.left + (priv->rect.width >> 1) - ((mf->width << 1) >>  1)
	== priv->rect.left + (priv->rect.width >> 1) - ( mf->width       >> (1 - 1))

> which is not, what you have above. Am I missing anything?

One of us must be ;).

> > +	case V4L2_MBUS_FMT_UYVY8_2X8:
> > +		dev_dbg(&client->dev, "pixel format YUYV8_2X8_BE\n");
> > +		if (half_scale) {
> > +			coma_mask |= COMA_RGB | COMA_BW | COMA_WORD_SWAP;
> > +			coma_set |= COMA_BYTE_SWAP;
> > +		} else {
> > +			coma_mask |= COMA_RGB | COMA_BW;
> > +			coma_set |= COMA_BYTE_SWAP | COMA_WORD_SWAP;
> > +		}
> > +		break;
> > +	case V4L2_MBUS_FMT_VYUY8_2X8:
> > +		dev_dbg(&client->dev, "pixel format YVYU8_2X8_BE (untested)\n");
> > +		if (half_scale) {
> > +			coma_mask |= COMA_RGB | COMA_BW;
> > +			coma_set |= COMA_BYTE_SWAP | COMA_WORD_SWAP;
> > +		} else {
> > +			coma_mask |= COMA_RGB | COMA_BW | COMA_WORD_SWAP;
> > +			coma_set |= COMA_BYTE_SWAP;
> > +		}
> > +		break;
>
> ...since there anyway will be an incremental patch . what does
> word-swapping have to do with scaling?...

A hardware (firmware) bug perhaps? All I can say is that I had found out it 
worked like this for me before, and I've just ensured it still does.

> > +	case V4L2_MBUS_FMT_SBGGR8_1X8:
> > +		dev_dbg(&client->dev, "pixel format SBGGR8_1X8 (untested)\n");
> > +		coma_mask |= COMA_BW | COMA_BYTE_SWAP | COMA_WORD_SWAP;
> > +		coma_set |= COMA_RAW_RGB | COMA_RGB;
> > +		break;
> > +	case 0:
> > +		break;
>
> 0 is defined as reserved... What for do you need it here?

This I have mentioned in my v2 -> v3 changes list:

> - add support for geometry only change to s_fmt, 

I've tried to follow a pattern copied from mt9v022.c:

+        case 0:
+		/* No format change, only geometry */
+		break;

but now I see I've missed the comment unfortunately. Please specify if you 
prefere to have it dropped or documented.

Thanks,
Janusz

> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
