Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:34241 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727076AbeGaXOa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jul 2018 19:14:30 -0400
Date: Tue, 31 Jul 2018 15:32:10 -0600
From: Rob Herring <robh@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        slongerbeam@gmail.com, niklas.soderlund@ragnatech.se
Subject: Re: [PATCH 05/21] dt-bindings: media: Specify bus type for MIPI
 D-PHY, others, explicitly
Message-ID: <20180731213210.GA28374@rob-hp-laptop>
References: <20180723134706.15334-1-sakari.ailus@linux.intel.com>
 <20180723134706.15334-6-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180723134706.15334-6-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 23, 2018 at 04:46:50PM +0300, Sakari Ailus wrote:
> Allow specifying the bus type explicitly for MIPI D-PHY, parallel and
> Bt.656 busses. This is useful for devices that can make use of different
> bus types. There are CSI-2 transmitters and receivers but the PHY
> selection needs to be made between C-PHY and D-PHY; many devices also
> support parallel and Bt.656 interfaces but the means to pass that
> information to software wasn't there.
> 
> Autodetection (value 0) is removed as an option as the property could be
> simply omitted in that case.

Presumably there are users, so you can't remove it. But documenting 
behavior when absent would be good.

> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  Documentation/devicetree/bindings/media/video-interfaces.txt | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
> index baf9d9756b3c..f884ada0bffc 100644
> --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
> +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
> @@ -100,10 +100,12 @@ Optional endpoint properties
>    slave device (data source) by the master device (data sink). In the master
>    mode the data source device is also the source of the synchronization signals.
>  - bus-type: data bus type. Possible values are:
> -  0 - autodetect based on other properties (MIPI CSI-2 D-PHY, parallel or Bt656)
>    1 - MIPI CSI-2 C-PHY
>    2 - MIPI CSI1
>    3 - CCP2
> +  4 - MIPI CSI-2 D-PHY
> +  5 - Parallel

Is that really specific enough to be useful?

> +  6 - Bt.656
>  - bus-width: number of data lines actively used, valid for the parallel busses.
>  - data-shift: on the parallel data busses, if bus-width is used to specify the
>    number of data lines, data-shift can be used to specify which data lines are
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
