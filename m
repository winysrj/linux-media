Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45578 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752069AbdBCNHr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Feb 2017 08:07:47 -0500
Date: Fri, 3 Feb 2017 15:07:40 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: robh+dt@kernel.org, devicetree@vger.kernel.org,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] devicetree: Add video bus switch
Message-ID: <20170203130740.GB12291@valkosipuli.retiisi.org.uk>
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

Hi Pavel,

My apologies for the delays in reviewing. Feel free to ping me in the future
if this happens. :-)

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
> +
> +This is a binding for a gpio controlled switch for camera interfaces. Such a
> +device is used on some embedded devices to connect two cameras to the same
> +interface of a image signal processor.
> +
> +Required properties
> +===================
> +
> +compatible	: must contain "video-bus-switch"

How generic is this? Should we have e.g. nokia,video-bus-switch? And if so,
change the file name accordingly.

> +switch-gpios	: GPIO specifier for the gpio, which can toggle the
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

I'd say this must be pretty much specific to the one in N900. You could have
more ports. Or you could say that ports beyond 0 are camera sensors. I guess
this is good enough for now though, it can be changed later on with the
source if a need arises.

Btw. was it still considered a problem that the endpoint properties for the
sensors can be different? With the g_routing() pad op which is to be added,
the ISP driver (should actually go to a framework somewhere) could parse the
graph and find the proper endpoint there.

I don't think we need to wait for that now, but this is how the problem
could be solved going forward.

> +
> +Example
> +=======
> +
> +video-bus-switch {
> +	compatible = "video-bus-switch"
> +	switch-gpios = <&gpio1 1 GPIO_ACTIVE_HIGH>;
> +
> +	ports {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		port@0 {
> +			reg = <0>;
> +
> +			csi_switch_in: endpoint {
> +				remote-endpoint = <&csi_isp>;
> +			};
> +		};
> +
> +		port@1 {
> +			reg = <1>;
> +
> +			csi_switch_out1: endpoint {
> +				remote-endpoint = <&csi_cam1>;
> +			};
> +		};
> +
> +		port@2 {
> +			reg = <2>;
> +
> +			csi_switch_out2: endpoint {
> +				remote-endpoint = <&csi_cam2>;
> +			};
> +		};
> +	};
> +};
> 
> 
> 

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
