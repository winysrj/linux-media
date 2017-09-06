Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:59864 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750832AbdIFIsP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 6 Sep 2017 04:48:15 -0400
Subject: Re: [PATCH v8 16/21] dt: bindings: Add lens-focus binding for image
 sensors
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
References: <20170905130553.1332-1-sakari.ailus@linux.intel.com>
 <20170905130553.1332-17-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2701f7b1-9e17-b5fd-f5ec-77ec8d557c66@xs4all.nl>
Date: Wed, 6 Sep 2017 10:48:10 +0200
MIME-Version: 1.0
In-Reply-To: <20170905130553.1332-17-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/05/2017 03:05 PM, Sakari Ailus wrote:
> The lens-focus property contains a phandle to the lens voice coil driver
> that is associated to the sensor; typically both are contained in the same
> camera module.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>
> Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
> Acked-by: Rob Herring <robh@kernel.org>


Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  Documentation/devicetree/bindings/media/video-interfaces.txt | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
> index efc67161e389..39b19d9d8426 100644
> --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
> +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
> @@ -74,6 +74,8 @@ Optional properties
>  - flash: An array of phandles, each referring to a flash LED, a sub-node
>    of the LED driver device node.
>  
> +- lens-focus: A phandle to the node of the focus lens controller.
> +
>  
>  Optional endpoint properties
>  ----------------------------
> 
