Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:58238 "EHLO
	aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192AbaJVKHz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Oct 2014 06:07:55 -0400
Message-ID: <544781F6.4070409@cisco.com>
Date: Wed, 22 Oct 2014 12:07:50 +0200
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>,
	Hans Verkuil <hans.verkuil@cisco.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 1/5] [media] vivid: select CONFIG_FB_CFB_FILLRECT/COPYAREA/IMAGEBLIT
References: <1413972221-13669-1-git-send-email-p.zabel@pengutronix.de> <1413972221-13669-2-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1413972221-13669-2-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Superseded. Already part of a pull request for 3.18.

But thanks anyway :-)

	Hans

On 10/22/2014 12:03 PM, Philipp Zabel wrote:
> The OSD simulation uses the framebuffer core functions, so vivid needs to
> select the corresponding configuration options.
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>   drivers/media/platform/vivid/Kconfig | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/drivers/media/platform/vivid/Kconfig b/drivers/media/platform/vivid/Kconfig
> index d71139a..3bfda25 100644
> --- a/drivers/media/platform/vivid/Kconfig
> +++ b/drivers/media/platform/vivid/Kconfig
> @@ -4,6 +4,9 @@ config VIDEO_VIVID
>   	select FONT_SUPPORT
>   	select FONT_8x16
>   	select VIDEOBUF2_VMALLOC
> +	select FB_CFB_FILLRECT
> +	select FB_CFB_COPYAREA
> +	select FB_CFB_IMAGEBLIT
>   	default n
>   	---help---
>   	  Enables a virtual video driver. This driver emulates a webcam,
>

