Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57384 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752693AbdH2Nbo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 09:31:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, hverkuil@xs4all.nl, devicetree@vger.kernel.org
Subject: Re: [PATCH v5 3/5] docs-rst: v4l: Include Qualcomm CAMSS in documentation build
Date: Tue, 29 Aug 2017 16:32:18 +0300
Message-ID: <5454183.OQTL44fLZD@avalon>
In-Reply-To: <20170829110313.19538-4-sakari.ailus@linux.intel.com>
References: <20170829110313.19538-1-sakari.ailus@linux.intel.com> <20170829110313.19538-4-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Tuesday, 29 August 2017 14:03:11 EEST Sakari Ailus wrote:
> Qualcomm CAMSS was left out from documentation build. Fix this.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

I've tested the qcom_camss documentation build and haven't noticed any new 
warning or error, so

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  Documentation/media/v4l-drivers/index.rst | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/media/v4l-drivers/index.rst
> b/Documentation/media/v4l-drivers/index.rst index
> 10f2ce42ece2..5c202e23616b 100644
> --- a/Documentation/media/v4l-drivers/index.rst
> +++ b/Documentation/media/v4l-drivers/index.rst
> @@ -50,6 +50,7 @@ For more details see the file COPYING in the source
> distribution of Linux. philips
>  	pvrusb2
>  	pxa_camera
> +	qcom_camss
>  	radiotrack
>  	rcar-fdp1
>  	saa7134


-- 
Regards,

Laurent Pinchart
