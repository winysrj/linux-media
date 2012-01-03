Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60883 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab2ACBNy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jan 2012 20:13:54 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kamil Debski <k.debski@samsung.com>
Subject: Re: [PATCH] s5p-mfc: Fix volatile controls setup
Date: Tue, 3 Jan 2012 02:14:05 +0100
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, mchehab@redhat.com
References: <1324994844-9883-1-git-send-email-k.debski@samsung.com>
In-Reply-To: <1324994844-9883-1-git-send-email-k.debski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201201030214.07855.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

On Tuesday 27 December 2011 15:07:24 Kamil Debski wrote:
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/video/s5p-mfc/s5p_mfc_dec.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
> b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c index 844a4d7..c25ec02 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
> @@ -165,7 +165,7 @@ static struct mfc_control controls[] = {
>  		.maximum = 32,
>  		.step = 1,
>  		.default_value = 1,
> -		.flags = V4L2_CTRL_FLAG_VOLATILE,
> +		.is_volatile = 1,
>  	},
>  };

Why so ? is_volatile got removed in commit 
88365105d683187e02a4f75220eaf51fd0c0b6e0.

-- 
Regards,

Laurent Pinchart
