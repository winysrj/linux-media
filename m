Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118Ab3AUMoe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jan 2013 07:44:34 -0500
Message-ID: <50FD38D1.5020104@redhat.com>
Date: Mon, 21 Jan 2013 13:47:13 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Peter Senna Tschudin <peter.senna@gmail.com>
CC: mchehab@redhat.com, hans.verkuil@cisco.com, jrnieder@gmail.com,
	emilgoode@gmail.com, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 01/24] use IS_ENABLED() macro
References: <1358613206-4274-1-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1358613206-4274-1-git-send-email-peter.senna@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks for the patches I'll pick up 5 - 21 and add them to
my tree for Mauro.

Regards,

Hans


On 01/19/2013 05:33 PM, Peter Senna Tschudin wrote:
> replace:
>   #if defined(CONFIG_VIDEO_CX88_DVB) || \
>       defined(CONFIG_VIDEO_CX88_DVB_MODULE)
> with:
>   #if IS_ENABLED(CONFIG_VIDEO_CX88_DVB)
>
> This change was made for: CONFIG_VIDEO_CX88_DVB,
> CONFIG_VIDEO_CX88_BLACKBIRD, CONFIG_VIDEO_CX88_VP3054
>
> Reported-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> ---
>   drivers/media/pci/cx88/cx88.h | 10 ++++------
>   1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/media/pci/cx88/cx88.h b/drivers/media/pci/cx88/cx88.h
> index ba0dba4..feff53c 100644
> --- a/drivers/media/pci/cx88/cx88.h
> +++ b/drivers/media/pci/cx88/cx88.h
> @@ -363,7 +363,7 @@ struct cx88_core {
>   	unsigned int               tuner_formats;
>
>   	/* config info -- dvb */
> -#if defined(CONFIG_VIDEO_CX88_DVB) || defined(CONFIG_VIDEO_CX88_DVB_MODULE)
> +#if IS_ENABLED(CONFIG_VIDEO_CX88_DVB)
>   	int 			   (*prev_set_voltage)(struct dvb_frontend *fe, fe_sec_voltage_t voltage);
>   #endif
>   	void			   (*gate_ctrl)(struct cx88_core  *core, int open);
> @@ -562,8 +562,7 @@ struct cx8802_dev {
>
>   	/* for blackbird only */
>   	struct list_head           devlist;
> -#if defined(CONFIG_VIDEO_CX88_BLACKBIRD) || \
> -    defined(CONFIG_VIDEO_CX88_BLACKBIRD_MODULE)
> +#if IS_ENABLED(CONFIG_VIDEO_CX88_BLACKBIRD)
>   	struct video_device        *mpeg_dev;
>   	u32                        mailbox;
>   	int                        width;
> @@ -574,13 +573,12 @@ struct cx8802_dev {
>   	struct cx2341x_handler     cxhdl;
>   #endif
>
> -#if defined(CONFIG_VIDEO_CX88_DVB) || defined(CONFIG_VIDEO_CX88_DVB_MODULE)
> +#if IS_ENABLED(CONFIG_VIDEO_CX88_DVB)
>   	/* for dvb only */
>   	struct videobuf_dvb_frontends frontends;
>   #endif
>
> -#if defined(CONFIG_VIDEO_CX88_VP3054) || \
> -    defined(CONFIG_VIDEO_CX88_VP3054_MODULE)
> +#if IS_ENABLED(CONFIG_VIDEO_CX88_VP3054)
>   	/* For VP3045 secondary I2C bus support */
>   	struct vp3054_i2c_state	   *vp3054;
>   #endif
>
