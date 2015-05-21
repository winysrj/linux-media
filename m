Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47903 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753649AbbEUOUy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 10:20:54 -0400
Date: Thu, 21 May 2015 17:20:19 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>,
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, devicetree@vger.kernel.org, sre@kernel.org
Subject: Re: [PATCH v8 8/8] DT: samsung-fimc: Add examples for
 samsung,flash-led property
Message-ID: <20150521142018.GK8601@valkosipuli.retiisi.org.uk>
References: <1432131015-22397-1-git-send-email-j.anaszewski@samsung.com>
 <1432131015-22397-9-git-send-email-j.anaszewski@samsung.com>
 <20150520220018.GE8601@valkosipuli.retiisi.org.uk>
 <555DA119.9030904@samsung.com>
 <20150521113213.GI8601@valkosipuli.retiisi.org.uk>
 <555DDD88.8080601@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <555DDD88.8080601@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Thu, May 21, 2015 at 03:28:40PM +0200, Sylwester Nawrocki wrote:
> On 21/05/15 13:32, Sakari Ailus wrote:
> >>>> @@ -147,6 +149,8 @@ Example:
> >>>> > >>  			clocks = <&camera 0>;
> >>>> > >>  			clock-names = "mclk";
> >>>> > >>
> >>>> > >>+			samsung,flash-led = <&rear_cam_flash>;
> >>>> > >>+
> >>>> > >>  			port {
> >>>> > >>  				s5c73m3_1: endpoint {
> >>>> > >>  					data-lanes = <1 2 3 4>;
> >>> > >
> >>> > >Oops. I missed this property would have ended to the sensor's DT node. I
> >>> > >don't think we should have properties here that are parsed by another
> >>> > >driver --- let's discuss this tomorrow.
> >> > 
> >> > exynos4-is driver already parses sensor nodes (at least their 'port'
> >> > sub-nodes).
> >
> > If you read the code and the comment, it looks like something that should be
> > done better but hasn't been done yet. :-) That's something we should avoid.
> > Also, flash devices are by far more common than external ISPs I presume.
> 
> Yes, especially let's not require any samsung specific properties in
> other vendors' sensor bindings.
> 
> One way of modelling [flash led]/[image sensor] association I imagine
> would be to put, e.g. 'flash-leds' property in the SoC camera host
> interface/ISP DT node. This property would then contain pairs of phandles,
> first to the led node and the second to the sensor node, e.g.
> 
> i2c_controller {
> 	...
> 	flash_xx@NN {
> 		...
> 		led_a {
> 			...		
> 		}
> 	};
> 
> 	image_sensor_x@NN {
> 		...
> 	};
> };
> 
> flash-leds = <&flash_xx &image_sensor_x>, <...>;

Maybe a stupid question, but how do you access this in a driver? I have to
admit I'm no DT expert.

> 
> For the purpose of this patch set presumably just samsung specific
> property name could be used (i.e. samsung,flash-leds).

I agree. I'll add similar support for the omap3isp driver in the near future
though. Let's see how the camera modules will get modelled, if they will,
and if this property still fits to the picture by that time, then we make it
more generic.

What do you think?

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
