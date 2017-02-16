Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:61570 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752854AbdBPCiU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 21:38:20 -0500
Subject: Re: [PATCH v4 32/36] media: imx: csi/fim: add support for frame
 intervals
To: Steve Longerbeam <slongerbeam@gmail.com>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <shawnguo@kernel.org>,
        <kernel@pengutronix.de>, <fabio.estevam@nxp.com>,
        <linux@armlinux.org.uk>, <mchehab@kernel.org>,
        <hverkuil@xs4all.nl>, <nick@shmanahar.org>,
        <markus.heiser@darmarIT.de>, <p.zabel@pengutronix.de>,
        <laurent.pinchart+renesas@ideasonboard.com>, <bparrot@ti.com>,
        <geert@linux-m68k.org>, <arnd@arndb.de>,
        <sudipm.mukherjee@gmail.com>, <minghsiu.tsai@mediatek.com>,
        <tiffany.lin@mediatek.com>, <jean-christophe.trotin@st.com>,
        <horms+renesas@verge.net.au>,
        <niklas.soderlund+renesas@ragnatech.se>, <robert.jarzmik@free.fr>,
        <songjun.wu@microchip.com>, <andrew-ct.chen@mediatek.com>,
        <gregkh@linuxfoundation.org>, <shuah@kernel.org>,
        <sakari.ailus@linux.intel.com>, <pavel@ucw.cz>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <1487211578-11360-33-git-send-email-steve_longerbeam@mentor.com>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-media@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        Russell King <rmk+kernel@armlinux.org.uk>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <4ad7ee56-2620-8055-54d0-6d8b135a61c7@mentor.com>
Date: Wed, 15 Feb 2017 18:38:03 -0800
MIME-Version: 1.0
In-Reply-To: <1487211578-11360-33-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry, I forgot to change authorship on this patch. It should
be authored by Russell King <rmk+kernel@armlinux.org.uk>.

Steve

On 02/15/2017 06:19 PM, Steve Longerbeam wrote:
> Add support to CSI for negotiation of frame intervals, and use this
> information to configure the frame interval monitor.
>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>   drivers/staging/media/imx/imx-media-csi.c | 36 ++++++++++++++++++++++++++++---
>   drivers/staging/media/imx/imx-media-fim.c | 28 +++++++++---------------
>   drivers/staging/media/imx/imx-media.h     |  2 +-
>   3 files changed, 44 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> index b0aac82..040cca6 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -56,6 +56,7 @@ struct csi_priv {
>   
>   	struct v4l2_mbus_framefmt format_mbus[CSI_NUM_PADS];
>   	const struct imx_media_pixfmt *cc[CSI_NUM_PADS];
> +	struct v4l2_fract frame_interval;
>   	struct v4l2_rect crop;
>   
>   	/* the video device at IDMAC output pad */
> @@ -565,7 +566,8 @@ static int csi_start(struct csi_priv *priv)
>   
>   	/* start the frame interval monitor */
>   	if (priv->fim) {
> -		ret = imx_media_fim_set_stream(priv->fim, priv->sensor, true);
> +		ret = imx_media_fim_set_stream(priv->fim,
> +					       &priv->frame_interval, true);
>   		if (ret)
>   			goto idmac_stop;
>   	}
> @@ -580,7 +582,8 @@ static int csi_start(struct csi_priv *priv)
>   
>   fim_off:
>   	if (priv->fim)
> -		imx_media_fim_set_stream(priv->fim, priv->sensor, false);
> +		imx_media_fim_set_stream(priv->fim,
> +					 &priv->frame_interval, false);
>   idmac_stop:
>   	if (priv->dest == IPU_CSI_DEST_IDMAC)
>   		csi_idmac_stop(priv);
> @@ -594,11 +597,36 @@ static void csi_stop(struct csi_priv *priv)
>   
>   	/* stop the frame interval monitor */
>   	if (priv->fim)
> -		imx_media_fim_set_stream(priv->fim, priv->sensor, false);
> +		imx_media_fim_set_stream(priv->fim,
> +					 &priv->frame_interval, false);
>   
>   	ipu_csi_disable(priv->csi);
>   }
>   
> +static int csi_g_frame_interval(struct v4l2_subdev *sd,
> +				struct v4l2_subdev_frame_interval *fi)
> +{
> +	struct csi_priv *priv = v4l2_get_subdevdata(sd);
> +
> +	fi->interval = priv->frame_interval;
> +
> +	return 0;
> +}
> +
> +static int csi_s_frame_interval(struct v4l2_subdev *sd,
> +				struct v4l2_subdev_frame_interval *fi)
> +{
> +	struct csi_priv *priv = v4l2_get_subdevdata(sd);
> +
> +	/* Output pads mirror active input pad, no limits on input pads */
> +	if (fi->pad == CSI_SRC_PAD_IDMAC || fi->pad == CSI_SRC_PAD_DIRECT)
> +		fi->interval = priv->frame_interval;
> +
> +	priv->frame_interval = fi->interval;
> +
> +	return 0;
> +}
> +
>   static int csi_s_stream(struct v4l2_subdev *sd, int enable)
>   {
>   	struct csi_priv *priv = v4l2_get_subdevdata(sd);
> @@ -1187,6 +1215,8 @@ static struct v4l2_subdev_core_ops csi_core_ops = {
>   };
>   
>   static struct v4l2_subdev_video_ops csi_video_ops = {
> +	.g_frame_interval = csi_g_frame_interval,
> +	.s_frame_interval = csi_s_frame_interval,
>   	.s_stream = csi_s_stream,
>   };
>   
> diff --git a/drivers/staging/media/imx/imx-media-fim.c b/drivers/staging/media/imx/imx-media-fim.c
> index acc7e39..a6ed57e 100644
> --- a/drivers/staging/media/imx/imx-media-fim.c
> +++ b/drivers/staging/media/imx/imx-media-fim.c
> @@ -67,26 +67,18 @@ struct imx_media_fim {
>   };
>   
>   static void update_fim_nominal(struct imx_media_fim *fim,
> -			       struct imx_media_subdev *sensor)
> +			       const struct v4l2_fract *fi)
>   {
> -	struct v4l2_streamparm parm;
> -	struct v4l2_fract tpf;
> -	int ret;
> -
> -	parm.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> -	ret = v4l2_subdev_call(sensor->sd, video, g_parm, &parm);
> -	tpf = parm.parm.capture.timeperframe;
> -
> -	if (ret || tpf.denominator == 0) {
> -		dev_dbg(fim->sd->dev, "no tpf from sensor, FIM disabled\n");
> +	if (fi->denominator == 0) {
> +		dev_dbg(fim->sd->dev, "no frame interval, FIM disabled\n");
>   		fim->enabled = false;
>   		return;
>   	}
>   
> -	fim->nominal = DIV_ROUND_CLOSEST(1000 * 1000 * tpf.numerator,
> -					 tpf.denominator);
> +	fim->nominal = DIV_ROUND_CLOSEST_ULL(1000000ULL * (u64)fi->numerator,
> +					     fi->denominator);
>   
> -	dev_dbg(fim->sd->dev, "sensor FI=%lu usec\n", fim->nominal);
> +	dev_dbg(fim->sd->dev, "FI=%lu usec\n", fim->nominal);
>   }
>   
>   static void reset_fim(struct imx_media_fim *fim, bool curval)
> @@ -130,8 +122,8 @@ static void send_fim_event(struct imx_media_fim *fim, unsigned long error)
>   
>   /*
>    * Monitor an averaged frame interval. If the average deviates too much
> - * from the sensor's nominal frame rate, send the frame interval error
> - * event. The frame intervals are averaged in order to quiet noise from
> + * from the nominal frame rate, send the frame interval error event. The
> + * frame intervals are averaged in order to quiet noise from
>    * (presumably random) interrupt latency.
>    */
>   static void frame_interval_monitor(struct imx_media_fim *fim,
> @@ -422,12 +414,12 @@ EXPORT_SYMBOL_GPL(imx_media_fim_set_power);
>   
>   /* Called by the subdev in its s_stream callback */
>   int imx_media_fim_set_stream(struct imx_media_fim *fim,
> -			     struct imx_media_subdev *sensor,
> +			     const struct v4l2_fract *fi,
>   			     bool on)
>   {
>   	if (on) {
>   		reset_fim(fim, true);
> -		update_fim_nominal(fim, sensor);
> +		update_fim_nominal(fim, fi);
>   
>   		if (fim->icap_channel >= 0)
>   			fim_acquire_first_ts(fim);
> diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/media/imx/imx-media.h
> index ae3af0d..7f19739 100644
> --- a/drivers/staging/media/imx/imx-media.h
> +++ b/drivers/staging/media/imx/imx-media.h
> @@ -259,7 +259,7 @@ struct imx_media_fim;
>   void imx_media_fim_eof_monitor(struct imx_media_fim *fim, struct timespec *ts);
>   int imx_media_fim_set_power(struct imx_media_fim *fim, bool on);
>   int imx_media_fim_set_stream(struct imx_media_fim *fim,
> -			     struct imx_media_subdev *sensor,
> +			     const struct v4l2_fract *frame_interval,
>   			     bool on);
>   struct imx_media_fim *imx_media_fim_init(struct v4l2_subdev *sd);
>   void imx_media_fim_free(struct imx_media_fim *fim);

-- 
Steve Longerbeam | Senior Embedded Engineer, ESD Services
Mentor Embedded(tm) | 46871 Bayside Parkway, Fremont, CA 94538
P 510.354.5838 | M 408.410.2735
