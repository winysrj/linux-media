Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:43391 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515Ab1GNTKH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2011 15:10:07 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1QhRIT-0004nW-An
	for linux-media@vger.kernel.org; Thu, 14 Jul 2011 21:10:05 +0200
Received: from athedsl-4491808.home.otenet.gr ([94.71.86.40])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 14 Jul 2011 21:10:05 +0200
Received: from snjw23 by athedsl-4491808.home.otenet.gr with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 14 Jul 2011 21:10:05 +0200
To: linux-media@vger.kernel.org
From: Sylwester Nawrocki <snjw23@gmail.com>
Subject: =?ISO-8859-15?Q?Re:_[GIT_PATCHES_FOR_3.1]_s5p-fimc_and_noon010p?= =?ISO-8859-15?Q?c30_drivers_conversion=0A_to_media_controller_API?=
Date: Thu, 14 Jul 2011 22:07:03 +0300
Message-ID: <almarsoft.8585519850362298955@news.gmane.org>
References: <4E17216F.7030200@samsung.com> <4E1F18E5.9050703@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
In-Reply-To: <4E1F18E5.9050703@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Thu, 14 Jul 2011 13:27:17 -0300, Mauro Carvalho Chehab 
<mchehab@redhat.com> wrote:
> Em 08-07-2011 12:25, Sylwester Nawrocki escreveu:
> > Hi Mauro,
> > 
> > The following changes since commit 
6068c012c3741537c9f965be5b4249f989aa5efc:
> > 
> >   [media] v4l: Document V4L2 control endianness as machine 
endianness (2011-07-07 19:26:11 -0300)
> > 
> > are available in the git repository at:
> >   git://git.infradead.org/users/kmpark/linux-2.6-samsung 
s5p-fimc-next
> > 
> > These patches convert FIMC and the sensor driver to media 
controller API,
> > i.e. a top level media device is added to be able to manage at 
runtime
> > attached sensors and all video processing entities present in the 
SoC.
> > An additional subdev at FIMC capture driver exposes the scaler and
> > composing functionality of the video capture IP.
> > The previously existing functionality is entirely retained.
> > 
> > I have introduced a few changes comparing to the last version 
(v3) sent
> > to the ML, as commented below.
> > 
> > Sylwester Nawrocki (28):
> >       s5p-fimc: Add support for runtime PM in the mem-to-mem 
driver
> >       s5p-fimc: Add media entity initialization
> >       s5p-fimc: Remove registration of video nodes from probe()


> That patch seems weird for me. If they aren't registered at probe,
> when they're registered?

They are registered in the media device probe callback, please see 
fimc-mdevice.c, fimc_md_probe(). After all the modules they depend on 
were initialized and registered. 
This is needed to assure proper initialization sequence. 
I also needed media device instance at hand when registering a video 
node.

> >       s5p-fimc: Remove sclk_cam clock handling
> >       s5p-fimc: Limit number of available inputs to one


> Camera sensors at FIMC input are no longer selected with S_INPUT 
ioctl.
> They will be attached to required FIMC entity through pipeline
> re-configuration at the media device level.


> Why? The proper way to select an input is via S_INPUT. The driver 
may also
> optionally allow changing it via the media device, but it should 
not be
> a mandatory requirement, as the media device API is optional.

The problem I'm trying to solve here is sharing the sensors and 
mipi-csi receivers between multiple FIMC H/W instances. Previously 
the driver supported attaching a sensor to only one selected FIMC at 
compile time. You could, for instance, specify all sensors as the 
selected FIMC's platform data and then use S_INPUT to choose between 
them. The sensor could not be used together with any other FIMC. But 
this is desired due to different capabilities of the FIMC IP 
instances. And now, instead of hardcoding a sensor assigment to 
particular video node, the sensors are bound to the media device. The 
media device driver takes the list of sensors and attaches them one 
by one to subsequent FIMC instances when it is initializing. Each 
sensor has a link to each FIMC but only one of them is active by 
default. That said an user application can use selected camera by 
opening corresponding video node. Which camera is at which node can 
be queried with G_INPUT.

I could try to implement the previous S_INPUT behaviour, but IMHO 
this would lead to considerable and unnecessary driver code 
complication due to supporting overlapping APIs.

--
Regards,
Sylwester

