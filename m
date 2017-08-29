Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:37562 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751250AbdH2QnL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 12:43:11 -0400
Date: Tue, 29 Aug 2017 11:43:09 -0500
From: Rob Herring <robh@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, jacek.anaszewski@gmail.com,
        linux-leds@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/1] dt: bindings: Add a binding for flash devices
 associated to a sensor
Message-ID: <20170829164309.shx2v2acucmvrs7y@rob-hp-laptop>
References: <20170818125857.13430-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170818125857.13430-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 18, 2017 at 03:58:57PM +0300, Sakari Ailus wrote:
> Camera flash drivers (and LEDs) are separate from the sensor devices in
> DT. In order to make an association between the two, provide the
> association information to the software.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> Hi Rob and Jacek, others,
> 
> I know I've submitted previous versions of this patch that I have changed
> since getting your acks... that's bad. I realised there will be problems
> due to the vague referencing in the old version.
> 
> Instead of referring to the flash LED controller itself, the references are
> now suggested to be made to the LEDs explicitly.
> 
> While most of the time all LEDs are associated to the same camera sensor,
> there's nothing that suggests that this will always be the case. This will
> work rather nicely with this change to the V4L2 flash class:
> 
> <URL:https://git.linuxtv.org/sailus/media_tree.git/commit/?h=flash&id=ef62781f4468d93ba8328caf7db629add453e01d>
> 
> An alternative to this could be to refer to the LEDs using the LED
> controller node and integer arguments. That would require e.g. #led-cells
> property to tell how many arguments there are. The actual LEDs also have
> device nodes already so I thought using them would probably be a good idea
> so we continue to have a single way to refer to LEDs.

There are some advantages to this approach, but I don't think it fits 
the normal pattern since we do have LED nodes.

> 
> Let me know your thoughts / if you're ok with the patch.

So, I think this patch is the right way to do it.

Acked-by: Rob Herring <robh@kernel.org>

> 
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
> +
> +
>  Optional endpoint properties
>  ----------------------------
>  
> -- 
> 2.11.0
> 
