Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34025 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757023AbdACUkT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Jan 2017 15:40:19 -0500
Date: Tue, 3 Jan 2017 14:38:54 -0600
From: Rob Herring <robh@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: devicetree@vger.kernel.org, ivo.g.dimitrov.75@gmail.com,
        sakari.ailus@iki.fi, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] dt: bindings: Add support for CSI1 bus
Message-ID: <20170103203854.gyyfzxbnnxl3flov@rob-hp-laptop>
References: <20161228183036.GA13139@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161228183036.GA13139@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 28, 2016 at 07:30:36PM +0100, Pavel Machek wrote:
> From: Sakari Ailus <sakari.ailus@iki.fi>
> 
> In the vast majority of cases the bus type is known to the driver(s)
> since a receiver or transmitter can only support a single one. There
> are cases however where different options are possible.

What cases specifically?

> Document the CSI1/CCP2 properties strobe_clk_inv and strobe_clock
> properties. The former tells whether the strobe/clock signal is
> inverted, while the latter signifies the clock or strobe mode.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
> index 9cd2a36..f0523f7 100644
> --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
> +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
> @@ -76,6 +76,10 @@ Optional endpoint properties
>    mode horizontal and vertical synchronization signals are provided to the
>    slave device (data source) by the master device (data sink). In the master
>    mode the data source device is also the source of the synchronization signals.
> +- bus-type: data bus type. Possible values are:
> +  0 - CSI2

As in MIPI CSI2?

> +  1 - parallel / Bt656
> +  2 - CCP2
>  - bus-width: number of data lines actively used, valid for the parallel busses.
>  - data-shift: on the parallel data busses, if bus-width is used to specify the
>    number of data lines, data-shift can be used to specify which data lines are
> @@ -110,9 +114,10 @@ Optional endpoint properties
>    lane and followed by the data lanes in the same order as in data-lanes.
>    Valid values are 0 (normal) and 1 (inverted). The length of the array
>    should be the combined length of data-lanes and clock-lanes properties.
> -  If the lane-polarities property is omitted, the value must be interpreted
> -  as 0 (normal). This property is valid for serial busses only.

Why is this removed?

> -
> +- clock-inv: Clock or strobe signal inversion.
> +  Possible values: 0 -- not inverted; 1 -- inverted

"invert" assumes I know what is normal and I do not. Define what is 
"normal" and name the property the opposite of that. If normal is data 
shifted on clock rising edge, then call the the property 
"clock-shift-falling-edge" for example..

> +- strobe: Whether the clock signal is used as clock or strobe. Used
> +  with CCP2, for instance.
>  
>  Example
>  -------
> 
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html


