Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4983 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbaCaOje (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Mar 2014 10:39:34 -0400
Message-ID: <53397DCE.3060404@xs4all.nl>
Date: Mon, 31 Mar 2014 16:38:06 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mikhail Domrachev <mihail.domrychev@comexp.ru>
CC: linux-media@vger.kernel.org,
	Aleksey Igonin <aleksey.igonin@comexp.ru>
Subject: Re: [PATCH v2 1/3] saa7134: add vidioc_querystd
References: <1396264417.4328.9.camel@localhost.localdomain>
In-Reply-To: <1396264417.4328.9.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mikhail,

Some comments below:

On 03/31/2014 01:13 PM, Mikhail Domrachev wrote:
> Signed-off-by: Mikhail Domrachev <mihail.domrychev@comexp.ru>
> ---
>  drivers/media/pci/saa7134/saa7134-empress.c |  1 +
>  drivers/media/pci/saa7134/saa7134-reg.h     |  6 ++++
>  drivers/media/pci/saa7134/saa7134-video.c   | 53 ++++++++++++++++++++++++++---
>  drivers/media/pci/saa7134/saa7134.h         |  1 +
>  4 files changed, 57 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
> index 0a9047e..a150deb 100644
> --- a/drivers/media/pci/saa7134/saa7134-empress.c
> +++ b/drivers/media/pci/saa7134/saa7134-empress.c
> @@ -262,6 +262,7 @@ static const struct v4l2_ioctl_ops ts_ioctl_ops = {
>  	.vidioc_s_input			= saa7134_s_input,
>  	.vidioc_s_std			= saa7134_s_std,
>  	.vidioc_g_std			= saa7134_g_std,
> +	.vidioc_querystd		= saa7134_querystd,
>  	.vidioc_log_status		= v4l2_ctrl_log_status,
>  	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
>  	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
> diff --git a/drivers/media/pci/saa7134/saa7134-reg.h b/drivers/media/pci/saa7134/saa7134-reg.h
> index e7e0af1..9681d31 100644
> --- a/drivers/media/pci/saa7134/saa7134-reg.h
> +++ b/drivers/media/pci/saa7134/saa7134-reg.h
> @@ -369,6 +369,12 @@
>  #define SAA7135_DSP_RWCLEAR_RERR		    1
>  
>  #define SAA7133_I2S_AUDIO_CONTROL               0x591
> +
> +#define SAA7134_STDDETECT_AUFD                  (1 << 7)
> +#define SAA7134_STDDETECT_FCTC                  (1 << 2)
> +#define SAA7134_STDDETECT_LDEL                  (1 << 5)
> +#define SAA7134_STDDETECT_AUTO0                 (1 << 1)
> +#define SAA7134_STDDETECT_AUTO1                 (1 << 2)

These flags belong to different registers. Can you move them to the corresponding
registers? See e.g. SAA7134_MAIN_CTRL on how it should be done.

>  /* ------------------------------------------------------------------ */
>  /*
>   * Local variables:
> diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
> index eb472b5..bc85d84 100644
> --- a/drivers/media/pci/saa7134/saa7134-video.c
> +++ b/drivers/media/pci/saa7134/saa7134-video.c
> @@ -452,19 +452,29 @@ static void video_mux(struct saa7134_dev *dev, int input)
>  
>  static void saa7134_set_decoder(struct saa7134_dev *dev)
>  {
> -	int luma_control, sync_control, mux;
> +	int luma_control, sync_control, chroma_ctrl1,
> +	    analog_adc, vgate_misc, mux;
>  
>  	struct saa7134_tvnorm *norm = dev->tvnorm;
>  	mux = card_in(dev, dev->ctl_input).vmux;
>  
>  	luma_control = norm->luma_control;
>  	sync_control = norm->sync_control;
> +	chroma_ctrl1 = norm->chroma_ctrl1;
> +	analog_adc = 0x01;
> +	vgate_misc = norm->vgate_misc;

Why change the way analog_adc and vgate_misc are set? They are not
affected by the autodetect changes, so there is no need to make
modifications.

>  
>  	if (mux > 5)
>  		luma_control |= 0x80; /* svideo */
>  	if (noninterlaced || dev->nosignal)
>  		sync_control |= 0x20;
>  
> +	/* switch on auto standard detection */
> +	sync_control |= SAA7134_STDDETECT_AUFD;
> +	chroma_ctrl1 |= SAA7134_STDDETECT_AUTO0;
> +	chroma_ctrl1 &= ~SAA7134_STDDETECT_FCTC;
> +	luma_control &= ~SAA7134_STDDETECT_LDEL;
> +
>  	/* setup video decoder */
>  	saa_writeb(SAA7134_INCR_DELAY,            0x08);
>  	saa_writeb(SAA7134_ANALOG_IN_CTRL1,       0xc0 | mux);
> @@ -487,16 +497,16 @@ static void saa7134_set_decoder(struct saa7134_dev *dev)
>  		dev->ctl_invert ? -dev->ctl_saturation : dev->ctl_saturation);
>  
>  	saa_writeb(SAA7134_DEC_CHROMA_HUE,        dev->ctl_hue);
> -	saa_writeb(SAA7134_CHROMA_CTRL1,          norm->chroma_ctrl1);
> +	saa_writeb(SAA7134_CHROMA_CTRL1,          chroma_ctrl1);
>  	saa_writeb(SAA7134_CHROMA_GAIN,           norm->chroma_gain);
>  
>  	saa_writeb(SAA7134_CHROMA_CTRL2,          norm->chroma_ctrl2);
>  	saa_writeb(SAA7134_MODE_DELAY_CTRL,       0x00);
>  
> -	saa_writeb(SAA7134_ANALOG_ADC,            0x01);
> +	saa_writeb(SAA7134_ANALOG_ADC,            analog_adc);
>  	saa_writeb(SAA7134_VGATE_START,           0x11);
>  	saa_writeb(SAA7134_VGATE_STOP,            0xfe);
> -	saa_writeb(SAA7134_MISC_VGATE_MSB,        norm->vgate_misc);
> +	saa_writeb(SAA7134_MISC_VGATE_MSB,        vgate_misc);
>  	saa_writeb(SAA7134_RAW_DATA_GAIN,         0x40);
>  	saa_writeb(SAA7134_RAW_DATA_OFFSET,       0x80);
>  }
> @@ -1686,6 +1696,40 @@ int saa7134_g_std(struct file *file, void *priv, v4l2_std_id *id)
>  }
>  EXPORT_SYMBOL_GPL(saa7134_g_std);
>  
> +static v4l2_std_id saa7134_read_std(struct saa7134_dev *dev)
> +{
> +	static v4l2_std_id stds[] = {
> +		V4L2_STD_ALL,
> +		V4L2_STD_NTSC,
> +		V4L2_STD_PAL,
> +		V4L2_STD_SECAM };
> +
> +	v4l2_std_id result = 0;
> +
> +	u8 st1 = saa_readb(SAA7134_STATUS_VIDEO1);
> +	u8 st2 = saa_readb(SAA7134_STATUS_VIDEO2);
> +
> +	if (!(st2 & 0x1)) /* RDCAP == 0 */
> +		result = V4L2_STD_ALL;

That's wrong: if there is no signal, then the result should be 0.
The V4L2 API spec used to be ambiguous which led to drivers doing different
things, but this has been changed so all drivers return 0 if there is
no signal.

> +	else
> +		result = stds[st1 & 0x03];
> +
> +	return result;
> +}
> +
> +int saa7134_querystd(struct file *file, void *priv, v4l2_std_id *std)
> +{
> +	struct saa7134_dev *dev = video_drvdata(file);
> +
> +	v4l2_std_id dcstd = saa7134_read_std(dev);
> +	if (dcstd != V4L2_STD_ALL)
> +		*std &= dcstd;
> +	else
> +		*std = dcstd;

This can be replaced by:

	*std &= saa7134_read_std(dev);

> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(saa7134_querystd);
> +
>  static int saa7134_cropcap(struct file *file, void *priv,
>  					struct v4l2_cropcap *cap)
>  {
> @@ -2084,6 +2128,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
>  	.vidioc_dqbuf			= saa7134_dqbuf,
>  	.vidioc_s_std			= saa7134_s_std,
>  	.vidioc_g_std			= saa7134_g_std,
> +	.vidioc_querystd		= saa7134_querystd,
>  	.vidioc_enum_input		= saa7134_enum_input,
>  	.vidioc_g_input			= saa7134_g_input,
>  	.vidioc_s_input			= saa7134_s_input,
> diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
> index 2474e84..9c2249b 100644
> --- a/drivers/media/pci/saa7134/saa7134.h
> +++ b/drivers/media/pci/saa7134/saa7134.h
> @@ -779,6 +779,7 @@ extern struct video_device saa7134_radio_template;
>  
>  int saa7134_s_std(struct file *file, void *priv, v4l2_std_id id);
>  int saa7134_g_std(struct file *file, void *priv, v4l2_std_id *id);
> +int saa7134_querystd(struct file *file, void *priv, v4l2_std_id *std);
>  int saa7134_enum_input(struct file *file, void *priv, struct v4l2_input *i);
>  int saa7134_g_input(struct file *file, void *priv, unsigned int *i);
>  int saa7134_s_input(struct file *file, void *priv, unsigned int i);
> 

Regards,

	Hans
