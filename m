Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:44410 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750832AbdIFIr7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 6 Sep 2017 04:47:59 -0400
Subject: Re: [PATCH v8 15/21] dt: bindings: Add a binding for flash devices
 associated to a sensor
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
References: <20170905130553.1332-1-sakari.ailus@linux.intel.com>
 <20170905130553.1332-16-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <03250e06-6e14-8c79-2567-5c2bab10562d@xs4all.nl>
Date: Wed, 6 Sep 2017 10:47:54 +0200
MIME-Version: 1.0
In-Reply-To: <20170905130553.1332-16-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/05/2017 03:05 PM, Sakari Ailus wrote:
> Camera flash drivers (and LEDs) are separate from the sensor devices in
> DT. In order to make an association between the two, provide the
> association information to the software.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Rob Herring <robh@kernel.org>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  Documentation/devicetree/bindings/media/video-interfaces.txt | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
> index 852041a7480c..efc67161e389 100644
> --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
> +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
> @@ -67,6 +67,14 @@ are required in a relevant parent node:
>  		    identifier, should be 1.
>   - #size-cells    : should be zero.
>  
> +
> +Optional properties
> +-------------------
> +
> +- flash: An array of phandles, each referring to a flash LED, a sub-node
> +  of the LED driver device node.
> +
> +
>  Optional endpoint properties
>  ----------------------------
>  
> 
