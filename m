Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:47594 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab1GRJWm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2011 05:22:42 -0400
Date: Mon, 18 Jul 2011 12:22:36 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@redhat.com
Subject: Re: [GIT PATCHES FOR 3.1] s5p-fimc and noon010pc30 drivers
 conversion? to media controller API
Message-ID: <20110718092235.GM27451@valkosipuli.localdomain>
References: <4E17216F.7030200@samsung.com>
 <4E1F18E5.9050703@redhat.com>
 <almarsoft.8585519850362298955@news.gmane.org>
 <20110714215142.GI27451@valkosipuli.localdomain>
 <094eae8d-3a15-496f-aa0b-be6e8cefa20a@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <094eae8d-3a15-496f-aa0b-be6e8cefa20a@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 15, 2011 at 09:36:50PM +0300, Sylwester Nawrocki wrote:
> Hi Sakari,
> 
> thanks for your comments.

Hi Sylwester,

You're welcome. :-)

> Sakari Ailus <sakari.ailus@iki.fi> wrote:
> 
> T>On Thu, Jul 14, 2011 at 10:07:03PM +0300, Sylwester Nawrocki wrote:
> >> Hi Mauro,
> >
> >Hi Sylwester and Mauro,
> T>
> >> On Thu, 14 Jul 2011 13:27:17 -0300, Mauro Carvalho Chehab
> >> <mchehab@redhat.com> wrote:
> T>> >Em 08-07-2011 12:25, Sylwester Nawrocki escreveu:
> >...
> >> >>       s5p-fimc: Remove sclk_cam clock handling
> >> >>       s5p-fimc: Limit number of available inputs to one
> >> 
> >> 
> >> >Camera sensors at FIMC input are no longer selected with S_INPUT
> >> ioctl.
> >> >They will be attached to required FIMC entity through pipeline
> >> >re-configuration at the media device level.
> >> 
> >> 
> >> >Why? The proper way to select an input is via S_INPUT. The driver
> >> may also
> >> >optionally allow changing it via the media device, but it should
> >> not be
> >> >a mandatory requirement, as the media device API is optional.
> >> 
> >> The problem I'm trying to solve here is sharing the sensors and
> >> mipi-csi receivers between multiple FIMC H/W instances. Previously
> >> the driver supported attaching a sensor to only one selected FIMC at
> >> compile time. You could, for instance, specify all sensors as the
> >> selected FIMC's platform data and then use S_INPUT to choose between
> >> them. The sensor could not be used together with any other FIMC. But
> >> this is desired due to different capabilities of the FIMC IP
> >> instances. And now, instead of hardcoding a sensor assigment to
> >> particular video node, the sensors are bound to the media device.
> >> The media device driver takes the list of sensors and attaches them
> >> one by one to subsequent FIMC instances when it is initializing.
> >> Each sensor has a link to each FIMC but only one of them is active
> T>> by default. That said an user application can use selected camera by
> >> opening corresponding video node. Which camera is at which node can
> >> be queried with G_INPUT.
> >> 
> Tr>> I could try to implement the previous S_INPUT behaviour, but IMHO
> >> this would lead to considerable and unnecessary driver code
> >> complication due to supporting overlapping APIs.
> >
> >This sounds quite familiar and similar to OMAP 3 ISP. There's more to
> >configure than an S_INPUT ioctl can do. Selecting sensor using S_INPUT
> >involves a number of other decisions as well if I'm not mistaken.
> 
> Yes, in particular the number of subdevs in the data path may need to be
> changed which really belongs to the media device driver. And sensors
> arbitration between FIMC instances is best done at the media device layer.
> Same applies to the 2 external clocks for the sensors which are shared
> between all FIMC IP instances and the sensors. Thus switching between
> sensors with S_INPUT would possibly involve pipeline reconfiguration which
> doesn't sound like a good design.

AFAIR this was one of the major reasons the OMAP 3 ISP driver does not
support S_INPUT.

I guess the real question might not even be whether to support S_INPUT or
not, but how to provide a general purpose application an easy way to use the
device; right?

> >
> >Sylwester: could you provide an MC graph of the device with possibly a
> >few
> >sensors attached? AFAIR media-ctl -p and dotfile.
> 
> I would be happy to provide this information but I'm in the middle of
> vacations and cannot really do that at the moment;) I recall pasting some
> links to the graph images to v4l irc channel. Here is the working one that
> most closely depicts current state:
> http://wstaw.org/m/2011/05/26/fimc_graph__.png (yellow FIMC.n subdevs
> should not be there and s5p-mipi-csis.1 subdev should have links to all
> green FIMC.n subdevs).

This diagram is very informative. Thanks.

-- 
Sakari Ailus
sakari.ailus@iki.fi
