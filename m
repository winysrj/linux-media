Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42229 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826Ab1LARYr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Dec 2011 12:24:47 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sergio Aguirre <saaguirre@ti.com>
Subject: Re: [PATCH v2 02/11] mfd: twl6040: Fix wrong TWL6040_GPO3 bitfield value
Date: Thu, 1 Dec 2011 18:24:53 +0100
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	sakari.ailus@iki.fi
References: <1322698500-29924-1-git-send-email-saaguirre@ti.com> <1322698500-29924-3-git-send-email-saaguirre@ti.com>
In-Reply-To: <1322698500-29924-3-git-send-email-saaguirre@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201112011824.54207.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergio,

On Thursday 01 December 2011 01:14:51 Sergio Aguirre wrote:
> The define should be the result of 1 << Bit number.
> 
> Bit number for GPOCTL.GPO3 field is 2, which results
> in 0x4 value.
> 
> Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> ---
>  include/linux/mfd/twl6040.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/mfd/twl6040.h b/include/linux/mfd/twl6040.h
> index 2463c261..2a7ff16 100644
> --- a/include/linux/mfd/twl6040.h
> +++ b/include/linux/mfd/twl6040.h
> @@ -142,7 +142,7 @@
> 
>  #define TWL6040_GPO1			0x01
>  #define TWL6040_GPO2			0x02
> -#define TWL6040_GPO3			0x03
> +#define TWL6040_GPO3			0x04

What about defining the fields as (1 << x) instead then ?

> 
>  /* ACCCTL (0x2D) fields */

-- 
Regards,

Laurent Pinchart
