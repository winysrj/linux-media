Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBDL31Ou007914
	for <video4linux-list@redhat.com>; Sat, 13 Dec 2008 16:03:01 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBDL2kOL005793
	for <video4linux-list@redhat.com>; Sat, 13 Dec 2008 16:02:47 -0500
Date: Sat, 13 Dec 2008 22:02:47 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
In-Reply-To: <utz9bmtgn.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0812132131410.10954@axis700.grange>
References: <utz9bmtgn.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: Re: [PATCH] Add tw9910 driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Kuninori-san,

On Thu, 11 Dec 2008, Kuninori Morimoto wrote:

> This patch adds tw9910 driver that use soc_camera framework.
> It was tested on SH Migo-r board.

interesting, that'd be the first non-sensor video client driver under 
soc-camera then:-) Looks good in general, but we can improve it a bit:

> +static const struct tw9910_scale_ctrl tw9910_pal_scales[] = {
> +	{
> +		.name   = "PAL SQ",
> +		.width  = 768,
> +		.height = 576,
> +		.hscale = 0x0100,
> +		.vscale = 0x0100,
> +	},
> +	{
> +		.name   = "PAL CCIR601",
> +		.width  = 720,
> +		.height = 576,
> +		.hscale = 0x0100,
> +		.vscale = 0x0100,
> +	},
> +	{
> +		.name   = "PAL SQ (CIF)",
> +		.width  = 384,
> +		.height = 288,
> +		.hscale = 0x0200,
> +		.vscale = 0x0200,
> +	},
> +	{
> +		.name   = "PAL CCIR601 (CIF)",
> +		.width  = 360,
> +		.height = 288,
> +		.hscale = 0x0200,
> +		.vscale = 0x0200,
> +	},
> +	{
> +		.name   = "PAL SQ (QCIF)",
> +		.width  = 192,
> +		.height = 144,
> +		.hscale = 0x0400,
> +		.vscale = 0x0400,
> +	},
> +	{
> +		.name   = "PAL CCIR601 (QCIF)",
> +		.width  = 180,
> +		.height = 144,
> +		.hscale = 0x0400,
> +		.vscale = 0x0400,
> +	},
> +};

At the moment there's no way to switch to any of these PAL norms, as 
soc-camera doesn't support s_std yet. I suspect, we shall expect a patch 
for that soon?:-)

> +	ret = i2c_smbus_write_byte_data(client, HSCALE_LO,
> +					(scale->hscale & 0x00FF));
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = i2c_smbus_write_byte_data(client, VSCALE_LO,
> +					(scale->vscale & 0x00FF));

No need for parenthesis in these two.

> +	return ret;
> +
> +}

Please, remove this empty line, as well as in tw9910_set_hsync.

> +static int tw9910_start_capture(struct soc_camera_device *icd)
> +{
> +	struct tw9910_priv *priv = container_of(icd, struct tw9910_priv, icd);
> +	int                 ret;
> +	u8                  val;
> +
> +	/*
> +	 * select current norm
> +	 */
> +	priv->scale = tw9910_select_norm(icd);
> +	if (!priv->scale)
> +		priv->scale = &tw9910_ntsc_scales[0];

Now, this is the actual reason why I'd like an improved version of this 
driver. Your try_fmt() method only limits frame width and height to lie 
within a supported range. Your set_fmt() and set_bus_param() just return 
0. But here what you do in your tw9910_select_norm(), you check the 
currently set width and height against a fixed set of your scales matching 
various tv-norms, and if no exact match found you take default. This 
means, it can happen, that a user requests a format, which you don't 
support, you return no error on try_fmt and on s_fmt, but on streamon you 
silently change it to your default... I think it would be better to check 
requested format in your try_fmt() and select the nearest if no exact 
match is found, perform your select_norm not in start_capture(), but in 
set_fmt().

> +
> +	/*
> +	 * reset hardware
> +	 */
> +	tw9910_reset(priv->client);
> +	ret = tw9910_write_array(priv->client, tw9910_default_regs);
> +	if (ret < 0)
> +		goto start_capture_end;
> +
> +	/*
> +	 * set bus width
> +	 */
> +	val = 0x00;
> +	if (SOCAM_DATAWIDTH_16 == priv->info->buswidth)
> +		val = LEN;
> +
> +	ret = tw9910_mask_set(priv->client, OPFORM, LEN, val);
> +	if (ret < 0)
> +		goto start_capture_end;
> +
> +	/*
> +	 * select MPOUT behavior
> +	 */
> +	switch (priv->info->mpout) {
> +	case MPO_VLOSS:
> +		val = RTSEL_VLOSS; break;
> +	case MPO_HLOCK:
> +		val = RTSEL_HLOCK; break;
> +	case MPO_SLOCK:
> +		val = RTSEL_SLOCK; break;
> +	case MPO_VLOCK:
> +		val = RTSEL_VLOCK; break;
> +	case MPO_MONO:
> +		val = RTSEL_MONO;  break;
> +	case MPO_DET50:
> +		val = RTSEL_DET50; break;
> +	case MPO_FIELD:
> +		val = RTSEL_FIELD; break;
> +	case MPO_RTCO:
> +		val = RTSEL_RTCO;  break;
> +	default:
> +		val = 0;
> +	}
> +
> +	ret = tw9910_mask_set(priv->client, VBICNTL, RTSEL_MASK, val);
> +	if (ret < 0)
> +		goto start_capture_end;
> +
> +	/*
> +	 * set scale
> +	 */
> +	ret = tw9910_set_scale(priv->client, priv->scale);
> +	if (ret < 0)
> +		goto start_capture_end;
> +
> +	/*
> +	 * set cropping
> +	 */
> +	ret = tw9910_set_cropping(priv->client, &tw9910_cropping_ctrl);
> +	if (ret < 0)
> +		goto start_capture_end;
> +
> +	/*
> +	 * set hsync
> +	 */
> +	ret = tw9910_set_hsync(priv->client, &tw9910_hsync_ctrl);
> +	if (ret < 0)
> +		goto start_capture_end;

I think, it would also be better to move all this configuration into 
set_fmt().

> +
> +	dev_info(&icd->dev, "scale : %s\n", priv->scale->name);

Wouldn't dev_dbg be enough?

> +
> +start_capture_end:
> +	priv->scale = NULL;
> +	icd->vdev->current_norm = V4L2_STD_NTSC;

You probably do not want to do this in ok-case, although, it doesn't hurt 
ATM - priv->scale is not used outside of this function, and current_norm 
is anyway constant ATM, but you'll want to remove them as you move 
configuration into set_fmt().

> +static int tw9910_stop_capture(struct soc_camera_device *icd)
> +{
> +	return 0;
> +}

Is there really no way to stop the engine?

> +	icd->formats     = &tw9910_color_fmt;
> +	icd->num_formats = 1;

...still better to use ARRAY_SIZE - costs nothing at runtime anyway.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
