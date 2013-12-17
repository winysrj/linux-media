Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2156 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab3LQHcV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Dec 2013 02:32:21 -0500
Message-ID: <52AFFDE6.6080908@xs4all.nl>
Date: Tue, 17 Dec 2013 08:31:50 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH RFC v3 2/7] v4l: 1 Hz resolution flag for tuners
References: <1387231688-8647-1-git-send-email-crope@iki.fi> <1387231688-8647-3-git-send-email-crope@iki.fi>
In-Reply-To: <1387231688-8647-3-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/16/2013 11:08 PM, Antti Palosaari wrote:
> Add V4L2_TUNER_CAP_1HZ for 1 Hz resolution.
> 
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  include/uapi/linux/videodev2.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 3fff116..97a5e50 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -1341,6 +1341,7 @@ struct v4l2_modulator {
>  #define V4L2_TUNER_CAP_RDS_CONTROLS	0x0200
>  #define V4L2_TUNER_CAP_FREQ_BANDS	0x0400
>  #define V4L2_TUNER_CAP_HWSEEK_PROG_LIM	0x0800
> +#define V4L2_TUNER_CAP_1HZ		0x1000
>  
>  /*  Flags for the 'rxsubchans' field */
>  #define V4L2_TUNER_SUB_MONO		0x0001
> 

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans
