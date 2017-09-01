Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:32803 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751864AbdIAKqU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Sep 2017 06:46:20 -0400
Subject: Re: [PATCH v6 3/5] docs-rst: v4l: Include Qualcomm CAMSS in
 documentation build
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <20170830114946.17743-1-sakari.ailus@linux.intel.com>
 <20170830114946.17743-4-sakari.ailus@linux.intel.com>
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <7fdb19c5-331e-39f3-adb4-3c6fdeafbbda@xs4all.nl>
Date: Fri, 1 Sep 2017 12:46:18 +0200
MIME-Version: 1.0
In-Reply-To: <20170830114946.17743-4-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 30/08/17 13:49, Sakari Ailus wrote:
> Qualcomm CAMSS was left out from documentation build. Fix this.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans


> ---
>  Documentation/media/v4l-drivers/index.rst | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/media/v4l-drivers/index.rst
> index 10f2ce42ece2..5c202e23616b 100644
> --- a/Documentation/media/v4l-drivers/index.rst
> +++ b/Documentation/media/v4l-drivers/index.rst
> @@ -50,6 +50,7 @@ For more details see the file COPYING in the source distribution of Linux.
>  	philips
>  	pvrusb2
>  	pxa_camera
> +	qcom_camss
>  	radiotrack
>  	rcar-fdp1
>  	saa7134
> 
