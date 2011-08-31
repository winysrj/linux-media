Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:40362 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab1HaMGl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 08:06:41 -0400
Message-ID: <4E5E23CA.4030208@infradead.org>
Date: Wed, 31 Aug 2011 09:06:34 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] media: none of the drivers should be enabled by default
References: <Pine.LNX.4.64.1108301921040.19151@axis700.grange> <201108311021.05793.hverkuil@xs4all.nl> <Pine.LNX.4.64.1108311023260.8429@axis700.grange> <201108311053.00687.hverkuil@xs4all.nl> <Pine.LNX.4.64.1108311103130.8429@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1108311103130.8429@axis700.grange>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 31-08-2011 06:06, Guennadi Liakhovetski escreveu:
>>>> I would propose to start by reorganizing the menu. E.g. make a submenu for
>>>> old legacy bus drivers (parallel port, ISA), for platform drivers, and for
>>>> 'rare' drivers (need a better name for that :-) ). For example the Hexium
>>>> PCI drivers are very rare, and few people have them.
>>>
>>> Sure, this can be done, not sure whether I'm a suitable person for this 
>>> task - I don't have a very good overview of the present market 
>>> situation;-)

It is hard to say what's "rare". While we know a few examples, nobody has a
worldwide situation about what's rare.

Of course, parallel port and ISA are things that makes sense to put into a separate
sub-menu, as those devices are not common at all.

>>>> Once that is done we can look at disabling those legacy/platform/rare 
>> drivers.
>>>
>>> I'm not sure any of those are actually enabled. What concerns me most are 
>>> tuner and remote controller drivers. Do they also belong to your "rare" 
>>> category? Do you agree, that they have to be disabled by default?
>>
>> I can't comment on the remote controller drivers as I haven't been involved
>> with that.
> 
> Mauro?

If RC is disabled, most PC cards don't work (bttv, cx88, ivtv, dvb-usb, ...).
Ok, this is due to a lack of proper module support on those drivers, but changing
it requires some work on each driver that depends on RC.

Also, if RC is selected, the RC decoder protocols need to be enabled by default, 
as otherwise several devices will stop working, as, on modern devices, there's
no hardware anymore to decode the IR pulses. The RC protocol Kconfig options are 
there, in fact, to allow disabling some RC decoding protocol when people are 100% 
sure that such software decoder won't be needed on some particular environment.

>> With regards to the tuners: perhaps it is sufficient to default MEDIA_ATTACH
>> to 'y'? That should prevent building those tuners that are not needed.
> 
> Sorry, I don't see how this should work. I mean tuners under 
> drivers/media/common/tuners/.
> 
>> I wouldn't change anything else here.

Tuners are required for all TV and DVB cards. Maybe we can put an explicit Kconfig
item for TV devices, and change the config stuff to something like:

config MEDIA_NEED_TUNER
	tristate

menuconfig MEDIA_TV
	tristate "TV and grabber cards"
	select MEDIA_NEED_TUNER
...
menuconfig MEDIA_WEBCAMS
	tristate "Webcameras"
...

config DVB_CORE
	tristate "DVB for Linux"
	depends on NET && INET
	select CRC32
	select MEDIA_NEED_TUNER


config MEDIA_TUNER_TDA827X
	tristate "Philips TDA827X silicon tuner"
	depends on VIDEO_MEDIA && I2C
	default MEDIA_NEED_TUNER if MEDIA_TUNER_CUSTOMIZE
	help
	  A DVB-T silicon tuner module. Say Y when you want to support this tuner.

There's one problem with the above strategy: on a few drivers, the same
driver is used for both webcams and TV. I know that em28xx has this problem,
as the same driver also supports the non-UVC em27xx-based webcams.
I think that the same is true also for usbvision.

If we put those devices under the "TV and grabber cards", people that have just a
em28xx-based webcam won't find them inside the MEDIA_WEBCAMS menus.

Of course, we can workaround it, by creating a "fake" item inside the webcams
menu, like:

menuconfig MEDIA_WEBCAMS
	tristate "Webcameras"

config MEDIA_EM27xx
	tristate "em27xx-based webcams"


and put some glue magic between MEDIA_EM27xx and em28xx:

config VIDEO_EM28XX
	depends on MEDIA_EM27xx if MEDIA_EM27xx


> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/

