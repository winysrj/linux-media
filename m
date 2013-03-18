Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33299 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824Ab3CRXQv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 19:16:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Andy Walls <awalls@md.metrocast.net>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Alexey Klimov <klimov.linux@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Brian Johnson <brijohn@gmail.com>,
	Mike Isely <isely@pobox.com>,
	Ezequiel Garcia <elezegarcia@gmail.com>,
	Huang Shijie <shijie8@gmail.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Takashi Iwai <tiwai@suse.de>,
	Ondrej Zary <linux@rainbow-software.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv2 PATCH 1/6] v4l2: add const to argument of write-only s_frequency ioctl.
Date: Tue, 19 Mar 2013 00:17:32 +0100
Message-ID: <38963986.sdyc1budE1@avalon>
In-Reply-To: <1363615925-19507-2-git-send-email-hverkuil@xs4all.nl>
References: <1363615925-19507-1-git-send-email-hverkuil@xs4all.nl> <1363615925-19507-2-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Monday 18 March 2013 15:12:00 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This ioctl is defined as IOW, so pass the argument as const.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---

[snip]

> diff --git a/drivers/media/radio/radio-keene.c
> b/drivers/media/radio/radio-keene.c index 296941a..a598852 100644
> --- a/drivers/media/radio/radio-keene.c
> +++ b/drivers/media/radio/radio-keene.c
> @@ -82,9 +82,12 @@ static inline struct keene_device *to_keene_dev(struct
> v4l2_device *v4l2_dev) /* Set frequency (if non-0), PA, mute and turn
> on/off the FM transmitter. */ static int keene_cmd_main(struct keene_device
> *radio, unsigned freq, bool play) {
> -	unsigned short freq_send = freq ? (freq - 76 * 16000) / 800 : 0;
> +	unsigned short freq_send;
>  	int ret;
> 
> +	if (freq)
> +		freq = clamp(freq, FREQ_MIN * FREQ_MUL, FREQ_MAX * FREQ_MUL);
> +	freq_send = freq ? (freq - 76 * 16000) / 800 : 0;
>  	radio->buffer[0] = 0x00;
>  	radio->buffer[1] = 0x50;
>  	radio->buffer[2] = (freq_send >> 8) & 0xff;
> @@ -215,15 +218,15 @@ static int vidioc_s_modulator(struct file *file, void
> *priv, }
> 
>  static int vidioc_s_frequency(struct file *file, void *priv,
> -				struct v4l2_frequency *f)
> +				const struct v4l2_frequency *f)
>  {
>  	struct keene_device *radio = video_drvdata(file);
> 
>  	if (f->tuner != 0 || f->type != V4L2_TUNER_RADIO)
>  		return -EINVAL;
> -	f->frequency = clamp(f->frequency,
> -			FREQ_MIN * FREQ_MUL, FREQ_MAX * FREQ_MUL);
> -	return keene_cmd_main(radio, f->frequency, true);
> +	/* Take care: keene_cmd_main handles a frequency of 0 as a
> +	 * special case, so make sure we never give that from here. */
> +	return keene_cmd_main(radio, f->frequency ? f->frequency : 1, true);

Can't you keep the clamp() here ? That looks easier.

>  }
> 
>  static int vidioc_g_frequency(struct file *file, void *priv,

-- 
Regards,

Laurent Pinchart

