Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:53485 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755444Ab2IYLoB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Sep 2012 07:44:01 -0400
From: Hans Verkuil <hansverk@cisco.com>
To: Prabhakar <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH] media: davinci: vpif: set device capabilities
Date: Tue, 25 Sep 2012 13:43:36 +0200
Cc: LMML <linux-media@vger.kernel.org>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	VGER <linux-kernel@vger.kernel.org>,
	"Lad, Prabhakar" <prabhakar.lad@ti.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1348571784-4237-1-git-send-email-prabhakar.lad@ti.com>
In-Reply-To: <1348571784-4237-1-git-send-email-prabhakar.lad@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201209251343.36240.hansverk@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue 25 September 2012 13:16:24 Prabhakar wrote:
> From: Lad, Prabhakar <prabhakar.lad@ti.com>
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/davinci/vpif_capture.c |    4 +++-
>  drivers/media/platform/davinci/vpif_display.c |    4 +++-
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
> index 4828888..faeca98 100644
> --- a/drivers/media/platform/davinci/vpif_capture.c
> +++ b/drivers/media/platform/davinci/vpif_capture.c
> @@ -1630,7 +1630,9 @@ static int vpif_querycap(struct file *file, void  *priv,
>  {
>  	struct vpif_capture_config *config = vpif_dev->platform_data;
>  
> -	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> +	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
> +			V4L2_CAP_READWRITE;
> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
>  	strlcpy(cap->driver, "vpif capture", sizeof(cap->driver));

This should be the real driver name which is 'vpif_capture'.

>  	strlcpy(cap->bus_info, "VPIF Platform", sizeof(cap->bus_info));

For bus_info I would use: "platform:vpif_capture".

The 'platform:' prefix is going to be the standard for platform drivers.

>  	strlcpy(cap->card, config->card_name, sizeof(cap->card));
> diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
> index d94b8a2..171e449 100644
> --- a/drivers/media/platform/davinci/vpif_display.c
> +++ b/drivers/media/platform/davinci/vpif_display.c
> @@ -827,7 +827,9 @@ static int vpif_querycap(struct file *file, void  *priv,
>  {
>  	struct vpif_display_config *config = vpif_dev->platform_data;
>  
> -	cap->capabilities = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
> +	cap->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING |
> +			    V4L2_CAP_READWRITE;
> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
>  	strlcpy(cap->driver, "vpif display", sizeof(cap->driver));

vpif_driver

>  	strlcpy(cap->bus_info, "Platform", sizeof(cap->bus_info));

Ditto: "platform:vpif_driver".

>  	strlcpy(cap->card, config->card_name, sizeof(cap->card));
> 

Regards,

	Hans
