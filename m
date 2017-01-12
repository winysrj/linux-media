Return-path: <linux-media-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:55700 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750815AbdALMGT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Jan 2017 07:06:19 -0500
Date: Thu, 12 Jan 2017 14:06:03 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Pavel Machek <pavel@ucw.cz>
Cc: robh+dt@kernel.org, devicetree@vger.kernel.org,
        ivo.g.dimitrov.75@gmail.com, sakari.ailus@iki.fi, sre@kernel.org,
        pali.rohar@gmail.com, linux-media@vger.kernel.org
Subject: Re: [PATCHv2] dt: bindings: Add support for CSI1 bus
Message-ID: <20170112120603.6gwtpwhyuaynvlj3@tarshish>
References: <20161228183036.GA13139@amd>
 <20170111225335.GA21553@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170111225335.GA21553@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Wed, Jan 11, 2017 at 11:53:35PM +0100, Pavel Machek wrote:
> From: Sakari Ailus <sakari.ailus@iki.fi>
> 
> In the vast majority of cases the bus type is known to the driver(s)
> since a receiver or transmitter can only support a single one. There
> are cases however where different options are possible.
> 
> The existing V4L2 OF support tries to figure out the bus type and
> parse the bus parameters based on that. This does not scale too well
> as there are multiple serial busses that share common properties.
> 
> Some hardware also supports multiple types of busses on the same
> interfaces.
> 
> Document the CSI1/CCP2 property strobe. It signifies the clock or
> strobe mode.
>  
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
> index 9cd2a36..08c4498 100644
> --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
> +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
> @@ -76,6 +76,11 @@ Optional endpoint properties
>    mode horizontal and vertical synchronization signals are provided to the
>    slave device (data source) by the master device (data sink). In the master
>    mode the data source device is also the source of the synchronization signals.
> +- bus-type: data bus type. Possible values are:
> +  0 - MIPI CSI2
> +  1 - parallel / Bt656

Why not have separate values for parallel and BT.656?

baruch

> +  2 - MIPI CSI1
> +  3 - CCP2
>  - bus-width: number of data lines actively used, valid for the parallel busses.
>  - data-shift: on the parallel data busses, if bus-width is used to specify the
>    number of data lines, data-shift can be used to specify which data lines are
> @@ -112,7 +117,8 @@ Optional endpoint properties
>    should be the combined length of data-lanes and clock-lanes properties.
>    If the lane-polarities property is omitted, the value must be interpreted
>    as 0 (normal). This property is valid for serial busses only.
> -
> +- strobe: Whether the clock signal is used as clock or strobe. Used
> +  with CCP2, for instance.
>  
>  Example
>  -------

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
