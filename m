Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2839 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab3LLH4J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Dec 2013 02:56:09 -0500
Message-ID: <52A96C00.8060607@xs4all.nl>
Date: Thu, 12 Dec 2013 08:55:44 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH RFC 4/4] v4l: 1 Hz resolution flag for tuners
References: <1386806043-5331-1-git-send-email-crope@iki.fi> <1386806043-5331-5-git-send-email-crope@iki.fi>
In-Reply-To: <1386806043-5331-5-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/12/2013 12:54 AM, Antti Palosaari wrote:
> Add V4L2_TUNER_CAP_1HZ for 1 Hz resolution.
> 
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  include/uapi/linux/videodev2.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 6c6a601..1bac6c4 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -1349,6 +1349,7 @@ struct v4l2_modulator {
>  #define V4L2_TUNER_CAP_RDS_CONTROLS	0x0200
>  #define V4L2_TUNER_CAP_FREQ_BANDS	0x0400
>  #define V4L2_TUNER_CAP_HWSEEK_PROG_LIM	0x0800
> +#define V4L2_TUNER_CAP_1HZ		0x1000
>  
>  /*  Flags for the 'rxsubchans' field */
>  #define V4L2_TUNER_SUB_MONO		0x0001
> 

I was wondering, do the band modulation systems (V4L2_BAND_MODULATION_VSB etc.) cover SDR?

Anyway, I'm happy with this patch series. As far as I am concerned, the next step would
be to add documention and I would also recommend updating v4l2-compliance. Writing docs
and adding compliance tests has proven useful in the past to discover ambiguous API specs.

Regards,

	Hans
