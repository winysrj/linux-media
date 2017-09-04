Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:39559 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753633AbdIDOb4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Sep 2017 10:31:56 -0400
Subject: Re: [PATCH v7 13/18] dt: bindings: Add a binding for flash devices
 associated to a sensor
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
References: <20170903174958.27058-1-sakari.ailus@linux.intel.com>
 <20170903174958.27058-14-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <9a68a9a6-0949-f1c2-f029-8045d7d688b0@xs4all.nl>
Date: Mon, 4 Sep 2017 16:31:51 +0200
MIME-Version: 1.0
In-Reply-To: <20170903174958.27058-14-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/03/2017 07:49 PM, Sakari Ailus wrote:
> Camera flash drivers (and LEDs) are separate from the sensor devices in
> DT. In order to make an association between the two, provide the
> association information to the software.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Rob Herring <robh@kernel.org>
> ---
>  Documentation/devicetree/bindings/media/video-interfaces.txt | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
> index 852041a7480c..fee73cf2a714 100644
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
> +- flash: An array of phandles referring to the flash LED, a sub-node
> +  of the LED driver device node.

If it is an array, then I guess it should say: "An array of phandles, each referring to
a flash LED,"

Regards,

	Hans

> +
> +
>  Optional endpoint properties
>  ----------------------------
>  
> 
