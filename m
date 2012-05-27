Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246Ab2E0R4g (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 May 2012 13:56:36 -0400
Message-ID: <4FC26AD8.6060303@redhat.com>
Date: Sun, 27 May 2012 19:56:40 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	halli manjunatha <hallimanju@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 1/5] videodev2.h: add new hwseek capability bits.
References: <1338119425-17274-1-git-send-email-hverkuil@xs4all.nl> <04a877e6f6310b83c3980cd6963f52d3b9ae658f.1338118975.git.hans.verkuil@cisco.com>
In-Reply-To: <04a877e6f6310b83c3980cd6963f52d3b9ae658f.1338118975.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Looks good:

Acked-by: Hans de Goede <hdegoede@redhat.com>

On 05/27/2012 01:50 PM, Hans Verkuil wrote:
> From: Hans Verkuil<hans.verkuil@cisco.com>
>
> Tell the application whether the hardware seek is bounded and/or wraps around.
>
> Signed-off-by: Hans Verkuil<hans.verkuil@cisco.com>
> ---
>   include/linux/videodev2.h |    2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 370d111..2339678 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -2039,6 +2039,8 @@ struct v4l2_modulator {
>   /*  Flags for the 'capability' field */
>   #define V4L2_TUNER_CAP_LOW		0x0001
>   #define V4L2_TUNER_CAP_NORM		0x0002
> +#define V4L2_TUNER_CAP_HWSEEK_BOUNDED	0x0004
> +#define V4L2_TUNER_CAP_HWSEEK_WRAP	0x0008
>   #define V4L2_TUNER_CAP_STEREO		0x0010
>   #define V4L2_TUNER_CAP_LANG2		0x0020
>   #define V4L2_TUNER_CAP_SAP		0x0020
