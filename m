Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46321 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754101AbbFAVRV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jun 2015 17:17:21 -0400
Date: Tue, 2 Jun 2015 00:17:17 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>,
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, devicetree@vger.kernel.org, sre@kernel.org
Subject: Re: [PATCH v8 8/8] DT: samsung-fimc: Add examples for
 samsung,flash-led property
Message-ID: <20150601211717.GI25595@valkosipuli.retiisi.org.uk>
References: <1432131015-22397-1-git-send-email-j.anaszewski@samsung.com>
 <1432131015-22397-9-git-send-email-j.anaszewski@samsung.com>
 <20150520220018.GE8601@valkosipuli.retiisi.org.uk>
 <555DA119.9030904@samsung.com>
 <20150521113213.GI8601@valkosipuli.retiisi.org.uk>
 <555DDD88.8080601@samsung.com>
 <20150523120348.GA3170@valkosipuli.retiisi.org.uk>
 <55630EE1.90307@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55630EE1.90307@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Mon, May 25, 2015 at 02:00:33PM +0200, Sylwester Nawrocki wrote:
> Hi,
> 
> On 23/05/15 14:03, Sakari Ailus wrote:
> > On Thu, May 21, 2015 at 03:28:40PM +0200, Sylwester Nawrocki wrote:
> >> flash-leds = <&flash_xx &image_sensor_x>, <...>;
> > 
> > One more matter to consider: xenon flash devices.
> > 
> > How about samsung,camera-flashes (and ti,camera-flashes)? After pondering
> > this awhile, I'm ok with removing the vendor prefix as well.
> > 
> > Let me know what you think.
> 
> I thought about it a bit more and I have some doubts about semantics
> as above. I'm fine with 'camera-flashes' as far as name is concerned.
> 
> Perhaps we should put only phandles to leds or xenon flash devices
> in the 'camera-flashes' property. I think it would be more future
> proof in case there is more nodes needed to describe the camera flash
> (or a camera module) than the above two. And phandles to corresponding
> image sensor device nodes would be put in a separate property.
> 
> camera-flashes = <&flash_xx>, ...
> camera-flash-masters = <&image_sensor_x>, ...
> 
> Then pairs at same index would describe a single flash, 0 would indicate
> a null entry if needed.
> Similarly we could create properties for other sub-devices of a camera
> module, like lenses, etc.

This arrangement would be advantageous compared to a single property when
adding modules (or lenses) to the equation, and probably more future proof
than "samsung,camera-flashes" / "ti,camera-flashes" I believe.

I'm also ok with keeping it as-is though.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
