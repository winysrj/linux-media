Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:48310 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab3AYTyd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jan 2013 14:54:33 -0500
Message-ID: <5102E2F4.80604@gmail.com>
Date: Fri, 25 Jan 2013 20:54:28 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	"Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: Re: [PATCH 1/2] media: add support for decoder subdevs along with
 sensor and others
References: <1359097268-22779-1-git-send-email-prabhakar.lad@ti.com> <1359097268-22779-2-git-send-email-prabhakar.lad@ti.com>
In-Reply-To: <1359097268-22779-2-git-send-email-prabhakar.lad@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prahakar,

On 01/25/2013 08:01 AM, Prabhakar Lad wrote:
> From: Manjunath Hadli<manjunath.hadli@ti.com>
>
> A lot of SOCs including Texas Instruments Davinci family mainly use
> video decoders as input devices. Here the initial subdevice node
> from where the input really comes is this decoder, for which support
> is needed as part of the Media Controller infrastructure. This patch
> adds an additional flag to include the decoders along with others,
> such as the sensor and lens.
>
> Signed-off-by: Manjunath Hadli<manjunath.hadli@ti.com>
> Signed-off-by: Lad, Prabhakar<prabhakar.lad@ti.com>
> ---
>   include/uapi/linux/media.h |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index 0ef8833..fa44ed9 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -56,6 +56,7 @@ struct media_device_info {
>   #define MEDIA_ENT_T_V4L2_SUBDEV_SENSOR	(MEDIA_ENT_T_V4L2_SUBDEV + 1)
>   #define MEDIA_ENT_T_V4L2_SUBDEV_FLASH	(MEDIA_ENT_T_V4L2_SUBDEV + 2)
>   #define MEDIA_ENT_T_V4L2_SUBDEV_LENS	(MEDIA_ENT_T_V4L2_SUBDEV + 3)
> +#define MEDIA_ENT_T_V4L2_SUBDEV_DECODER	(MEDIA_ENT_T_V4L2_SUBDEV + 4)

Such a new entity type needs to be documented in the media DocBook [1].
It probably also deserves a comment here, as DECODER isn't that obvious
like the other already existing entity types. I heard people referring
to a device that encodes analog (composite) video signal into its digital
representation as an ENCODER. :)


[1] http://hverkuil.home.xs4all.nl/spec/media.html#media-ioc-enum-entities

--

Regards,
Sylwester
