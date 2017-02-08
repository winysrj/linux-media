Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:35733 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752014AbdBHWK1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Feb 2017 17:10:27 -0500
Date: Wed, 8 Feb 2017 15:36:09 -0600
From: Rob Herring <robh@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, devicetree@vger.kernel.org,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] devicetree: Add video bus switch
Message-ID: <20170208213609.lnemfbzitee5iur2@rob-hp-laptop>
References: <20161023200355.GA5391@amd>
 <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd>
 <20161222100104.GA30917@amd>
 <20161222133938.GA30259@amd>
 <20161224152031.GA8420@amd>
 <20170203123508.GA10286@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170203123508.GA10286@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 03, 2017 at 01:35:08PM +0100, Pavel Machek wrote:
> 
> N900 contains front and back camera, with a switch between the
> two. This adds support for the switch component, and it is now
> possible to select between front and back cameras during runtime.
> 
> This adds documentation for the devicetree binding.
> 
> Signed-off-by: Sebastian Reichel <sre@kernel.org>
> Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> 
> diff --git a/Documentation/devicetree/bindings/media/video-bus-switch.txt b/Documentation/devicetree/bindings/media/video-bus-switch.txt
> new file mode 100644
> index 0000000..1b9f8e0
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/video-bus-switch.txt
> @@ -0,0 +1,63 @@
> +Video Bus Switch Binding
> +========================

I'd call it a mux rather than switch.

BTW, there's a new mux-controller binding under review you might look 
at. It would only be needed here if the mux ctrl also controls other 
things.

> +
> +This is a binding for a gpio controlled switch for camera interfaces. Such a
> +device is used on some embedded devices to connect two cameras to the same
> +interface of a image signal processor.
> +
> +Required properties
> +===================
> +
> +compatible	: must contain "video-bus-switch"

video-bus-gpio-mux

> +switch-gpios	: GPIO specifier for the gpio, which can toggle the

mux-gpios to align with existing GPIO controlled muxes.

> +		  selected camera. The GPIO should be configured, so
> +		  that a disabled GPIO means, that the first port is
> +		  selected.
> +
> +Required Port nodes
> +===================
> +
> +More documentation on these bindings is available in
> +video-interfaces.txt in the same directory.
> +
> +reg		: The interface:
> +		  0 - port for image signal processor
> +		  1 - port for first camera sensor
> +		  2 - port for second camera sensor

This could be used for display side as well. So describe these just as 
inputs and outputs.

Rob
