Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:47823 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320Ab1GNVvq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2011 17:51:46 -0400
Date: Fri, 15 Jul 2011 00:51:42 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES FOR 3.1] s5p-fimc and noon010pc30 drivers
 conversion? to media controller API
Message-ID: <20110714215142.GI27451@valkosipuli.localdomain>
References: <4E17216F.7030200@samsung.com>
 <4E1F18E5.9050703@redhat.com>
 <almarsoft.8585519850362298955@news.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <almarsoft.8585519850362298955@news.gmane.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 14, 2011 at 10:07:03PM +0300, Sylwester Nawrocki wrote:
> Hi Mauro,

Hi Sylwester and Mauro,

> On Thu, 14 Jul 2011 13:27:17 -0300, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
> >Em 08-07-2011 12:25, Sylwester Nawrocki escreveu:
...
> >>       s5p-fimc: Remove sclk_cam clock handling
> >>       s5p-fimc: Limit number of available inputs to one
> 
> 
> >Camera sensors at FIMC input are no longer selected with S_INPUT
> ioctl.
> >They will be attached to required FIMC entity through pipeline
> >re-configuration at the media device level.
> 
> 
> >Why? The proper way to select an input is via S_INPUT. The driver
> may also
> >optionally allow changing it via the media device, but it should
> not be
> >a mandatory requirement, as the media device API is optional.
> 
> The problem I'm trying to solve here is sharing the sensors and
> mipi-csi receivers between multiple FIMC H/W instances. Previously
> the driver supported attaching a sensor to only one selected FIMC at
> compile time. You could, for instance, specify all sensors as the
> selected FIMC's platform data and then use S_INPUT to choose between
> them. The sensor could not be used together with any other FIMC. But
> this is desired due to different capabilities of the FIMC IP
> instances. And now, instead of hardcoding a sensor assigment to
> particular video node, the sensors are bound to the media device.
> The media device driver takes the list of sensors and attaches them
> one by one to subsequent FIMC instances when it is initializing.
> Each sensor has a link to each FIMC but only one of them is active
> by default. That said an user application can use selected camera by
> opening corresponding video node. Which camera is at which node can
> be queried with G_INPUT.
> 
> I could try to implement the previous S_INPUT behaviour, but IMHO
> this would lead to considerable and unnecessary driver code
> complication due to supporting overlapping APIs.

This sounds quite familiar and similar to OMAP 3 ISP. There's more to
configure than an S_INPUT ioctl can do. Selecting sensor using S_INPUT
involves a number of other decisions as well if I'm not mistaken.

Sylwester: could you provide an MC graph of the device with possibly a few
sensors attached? AFAIR media-ctl -p and dotfile.

Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi
