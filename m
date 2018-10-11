Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:44922 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbeJKQ7y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Oct 2018 12:59:54 -0400
Subject: Re: [PATCH] media: intel-ipu3: cio2: Remove redundant definitions
To: Rajmohan Mani <rajmohan.mani@intel.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Yong Zhi <yong.zhi@intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>,
        Tian Shu Qiu <tian.shu.qiu@intel.com>,
        Jian Xu Zheng <jian.xu.zheng@intel.com>
Cc: tfiga@chromium.org
References: <20181009234245.25830-1-rajmohan.mani@intel.com>
Reply-To: kieran.bingham+renesas@ideasonboard.com
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <33c53caf-633a-f359-4312-9c2dc317efc5@ideasonboard.com>
Date: Thu, 11 Oct 2018 10:33:21 +0100
MIME-Version: 1.0
In-Reply-To: <20181009234245.25830-1-rajmohan.mani@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rajmohan

Thank you for the patch,

On 10/10/18 00:42, Rajmohan Mani wrote:
> Removed redundant CIO2_IMAGE_MAX_* definitions
> 
> Fixes: c2a6a07afe4a ("media: intel-ipu3: cio2: add new MIPI-CSI2 driver")
> 
> Signed-off-by: Rajmohan Mani <rajmohan.mani@intel.com>

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Looks like this {sh,c}ould be bundled in with
 "[PATCH 0/2] Trivial CIO2 patches" from Sakari at integration.

--
Regards

Kieran Bingham

> ---
>  drivers/media/pci/intel/ipu3/ipu3-cio2.h | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.h b/drivers/media/pci/intel/ipu3/ipu3-cio2.h
> index 240635be7a31..7caab9b8c2b9 100644
> --- a/drivers/media/pci/intel/ipu3/ipu3-cio2.h
> +++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.h
> @@ -10,8 +10,6 @@
>  #define CIO2_PCI_ID					0x9d32
>  #define CIO2_PCI_BAR					0
>  #define CIO2_DMA_MASK					DMA_BIT_MASK(39)
> -#define CIO2_IMAGE_MAX_WIDTH				4224
> -#define CIO2_IMAGE_MAX_LENGTH				3136
>  
>  #define CIO2_IMAGE_MAX_WIDTH				4224
>  #define CIO2_IMAGE_MAX_LENGTH				3136
> 
