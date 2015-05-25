Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46318 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751174AbbEYU5F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2015 16:57:05 -0400
Date: Mon, 25 May 2015 23:56:59 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>,
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, devicetree@vger.kernel.org, sre@kernel.org
Subject: Re: [PATCH v8 8/8] DT: samsung-fimc: Add examples for
 samsung,flash-led property
Message-ID: <20150525205659.GB4081@valkosipuli.retiisi.org.uk>
References: <1432131015-22397-1-git-send-email-j.anaszewski@samsung.com>
 <1432131015-22397-9-git-send-email-j.anaszewski@samsung.com>
 <20150520220018.GE8601@valkosipuli.retiisi.org.uk>
 <555DA119.9030904@samsung.com>
 <20150521113213.GI8601@valkosipuli.retiisi.org.uk>
 <555DDD88.8080601@samsung.com>
 <20150523120348.GA3170@valkosipuli.retiisi.org.uk>
 <55630EE1.90307@samsung.com>
 <55631AAC.6080507@samsung.com>
 <55633186.1000004@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55633186.1000004@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Mon, May 25, 2015 at 04:28:22PM +0200, Sylwester Nawrocki wrote:
> On 25/05/15 14:50, Jacek Anaszewski wrote:
> >> On 23/05/15 14:03, Sakari Ailus wrote:
> >>> >> On Thu, May 21, 2015 at 03:28:40PM +0200, Sylwester Nawrocki wrote:
> >>>> >>> flash-leds = <&flash_xx &image_sensor_x>, <...>;
> >>> >>
> >>> >> One more matter to consider: xenon flash devices.
> >>> >>
> >>> >> How about samsung,camera-flashes (and ti,camera-flashes)? After pondering
> >>> >> this awhile, I'm ok with removing the vendor prefix as well.
> >>> >>
> >>> >> Let me know what you think.
> >> >
> >> > I thought about it a bit more and I have some doubts about semantics
> >> > as above. I'm fine with 'camera-flashes' as far as name is concerned.
> >> >
> >> > Perhaps we should put only phandles to leds or xenon flash devices
> >> > in the 'camera-flashes' property. I think it would be more future
> >> > proof in case there is more nodes needed to describe the camera flash
> >> > (or a camera module) than the above two. And phandles to corresponding
> >> > image sensor device nodes would be put in a separate property.
> >
> > Could you give examples of the cases you are thinking of?
> 
> I don't have any examples in mind ATM, I just wanted to point out
> the above convention might not be flexible enough. Especially since
> we already know there is more sub-devices within the camera module
> than just flashes and image sensors.

I have to admit I've never seen a camera module with an integrated flash.
The lens is part of the module but typically flash is not. That doesn't say
there aren't such devices though.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
