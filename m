Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1980 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaBNPDK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Feb 2014 10:03:10 -0500
Message-ID: <52FE3004.7000700@xs4all.nl>
Date: Fri, 14 Feb 2014 16:02:28 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [REVIEW PATCH 13/16] rtl2832_sdr: expose e4000 controls to user
References: <1392084299-16549-1-git-send-email-crope@iki.fi> <1392084299-16549-14-git-send-email-crope@iki.fi>
In-Reply-To: <1392084299-16549-14-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/11/2014 03:04 AM, Antti Palosaari wrote:
> E4000 tuner driver provides now some controls. Expose those to
> userland.
> 
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
> index 9265424..18f8c56 100644
> --- a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
> +++ b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
> @@ -25,6 +25,7 @@
>  #include "dvb_frontend.h"
>  #include "rtl2832_sdr.h"
>  #include "dvb_usb.h"
> +#include "e4000.h"
>  
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-ioctl.h>
> @@ -1347,6 +1348,7 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
>  	struct rtl2832_sdr_state *s;
>  	const struct v4l2_ctrl_ops *ops = &rtl2832_sdr_ctrl_ops;
>  	struct dvb_usb_device *d = i2c_get_adapdata(i2c);
> +	struct v4l2_ctrl_handler *hdl;
>  
>  	s = kzalloc(sizeof(struct rtl2832_sdr_state), GFP_KERNEL);
>  	if (s == NULL) {
> @@ -1386,10 +1388,10 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
>  	/* Register controls */
>  	switch (s->cfg->tuner) {
>  	case RTL2832_TUNER_E4000:
> -		v4l2_ctrl_handler_init(&s->hdl, 2);
> -		s->bandwidth_auto = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_BANDWIDTH_AUTO, 0, 1, 1, 1);
> -		s->bandwidth = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_BANDWIDTH, 4300000, 11000000, 100000, 4300000);
> -		v4l2_ctrl_auto_cluster(2, &s->bandwidth_auto, 0, false);
> +		hdl = e4000_get_ctrl_handler(fe);
> +		v4l2_ctrl_handler_init(&s->hdl, 0);

Use the same number as is used in e4000: 8.

It's a hint of the number of controls that the handler will contain and it affects
the number of buckets used for the hash table. Putting in a 0 will result in a single
bucket which means that all controls end up in a single linked list. Changing it to
8 will result in two buckets, which performs a bit better.

Regards,

	Hans

> +		if (hdl)
> +			v4l2_ctrl_add_handler(&s->hdl, hdl, NULL);
>  		break;
>  	case RTL2832_TUNER_R820T:
>  		v4l2_ctrl_handler_init(&s->hdl, 2);
> 

