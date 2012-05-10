Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932130Ab2EJOOs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 10:14:48 -0400
Message-ID: <4FABCD4B.1050803@redhat.com>
Date: Thu, 10 May 2012 11:14:35 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media <linux-media@vger.kernel.org>,
	Patrick Boettcher <pboettcher@kernellabs.com>
Subject: Re: [RFCv1] DVB-USB improvements
References: <4FA91BBF.5060405@iki.fi>
In-Reply-To: <4FA91BBF.5060405@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 08-05-2012 10:12, Antti Palosaari escreveu:
> Factors behind the changes are mostly coming from the fact current struct dvb_usb_device_properties contains so many static configuration options.
> You cannot change single dvb_usb_device_properties easily (safely) at runtime since it is usually driver global struct and thus shared between all 
> the DVB USB driver instances. That fits just fine for the traditional devices where all configuration is same for the devices having single USB ID.
> Nowadays we have more and more devices that are based of chipset vendor reference designs - even using just single USB ID chipset vendor have given 
> for that chipset. These reference designs still varies much about used chips and configurations. Configuring different base chips, USB-bridge, demod, 
> tuner, and also peripheral properties like dual tuners, remotes and CI is needed to do runtime because of single USB ID is used for that all.

Drivers waste lots of space with dvb_usb_device_properties, as this struct is HUGE.
Also, the structure index number need to match the USB ID table index, which causes
merge troubles from time to time, breaking existing cards when new ones are added.

Also, if the remote controller is different, a series of data needs to be duplicated
into a separate entry.

IMHO, it would be better to re-design it to avoid wasting space without need.

> 
> My personal innovator behind all these is problems I met when developing AF9015 and AF9035 drivers. Also RTL2831U and RTL2832U are kinda similar and have given some more motivation.
> 
> Here is small list what I am planning to do. It is surely so much work that everything is not possible, but lets try to select most important and easiest as a higher priority.
> 
> 
> resume / suspend support
> -------------------
> * very important feature
> * crashes currently when DVB USB tries to download firmware when resuming from suspend
> 
> read_config1
> -------------------
> * new callback to do initial tweaks
> * very first callback
> * is that really needed?

Calling it as "read_config1" is not nice, as "1" has no strong meaning.

It would be better to name it as "read_config_early", if this is needed.

> 
> read_mac_address => read_config2
> -------------------
> * rename it read_config2 or read_config if read_config1 is not implemented at all

"read_config" seems a good name for it.

> * rename old callback and extend it usage as a more general
> * only 8 devices use currently

> * when returned mac != 0 => print mac address as earlier, otherwise work as a general callback

Please, don't do that. Different behaviors if mac is filled (or not) is a very bad idea.

> 
> new callback init()
> -------------------
> * called after tuner attach to initialize rest of device
> * good place to do some general settings
>   - configure endpoints
>   - configure remote controller
>   - configure + attach CI
> 
> change DVB-USB to dynamic debug
> -------------------
> * use Kernel new dynamic debugs instead of own proprietary system
> 
> download_firmware
> -------------------
> * struct usb_device => struct dvb_usb_device
> * we need access for the DVB USB driver state in every callback
> 
> identify_state
> -------------------
> * struct usb_device => struct dvb_usb_device
> * we need access for the DVB USB driver state in every callback

IMO, all callbacks should use the same argument (either usb_device or dvb_usb_device).

> 
> attach all given adapter frontends as once
> -------------------
> * for the MFE devices attach all frontends as once

We should first clean-up the bad/legacy MFE drivers, as most use MFE to
implement a single FE chipset that supports more than one delivery system.

> * deregister all frontends if error returned
> * small effect only for MFE
> 
> attach all given adapter tuners as once
> -------------------
> * deregister all frontends if error returned
> * small effect only for MFE
> 
> make remote dynamically configurable
> -------------------

The first step here is to remove rc.legacy stuff.

> * default keytable mapped same level with USB-ID & device name etc.
> * there is generally 3 things that could be mapped to USB ID
>   - USB IDs (cold + warm)
>   - device name
>   - remote controller keytable
>   - all the others could be resolved & configured dynamically
> * it is not only keytable but whole remote should be changed dynamically configurable

The issue with IR is because of the issue with struct dvb_usb_device_properties.

If you take a look at em28xx implementation, for example, there's just one
parameter for the IR keytables that determine if a device will be loaded with
or without IR: the RC keytable.

re-designing dvb_usb_device_properties should fix it.

> 
> make stream dynamically configurable
> -------------------
> * we need change stream parameters in certain situations
>   - there is multiple endpoints but shared MFE
>   - need to set params according to stream bandwidth (USB1.1, DVB-T, DVB-C2 in same device)
>   - leave old static configrations as those are but add callbacks to get new values at runtime
> 
> dynamically growing device list in dvb_usb_device_properties
> -------------------
> * currently number of devices are limited statically
> * there is devices having ~50 or more IDs which means multiple dvb_usb_device_properties are needed
> 
> dynamic USB ID support
> -------------------
> * currently not supported by DVB USB
> 
> analog support for the DVB USB
> -------------------
> * currently not supported by DVB USB

In order to add analog support, it is likely simpler to take em28xx (mainly em28xx-video) as an 
example on how things are implemented on analog side. The gspca implementation may also help a 
lot, but it doesn't contain the tuner bits.

It would be great to have an "usb_media" core implementation that would merge gspca_core,
dvb_usb and USB TV bits (found on em28xx/tm6000) into a single core, but if we're taking
this road, then I think you should start with this new design. 

The conceptual architecture used by gspca, em28xx and dvb_core are different. Merging them
into a single architectural design will be a really nice project, but that would probably
mean to write a new design from scratch, and then importing bits from each of the above.

This is likely a big project.

> * I have no experience

The easiest way to start working with analog is to take a look at vivi.c driver. It is just a
test driver that requires no hardware, and implements the basic stuff for analog. It doesn't
implement the tuner logic, though.

> * em28xx can be converted?

If you implement the analog code, it shouldn't be hard to convert em28xx. The hardest part
will likely to integrate DVB USB with videobuf2 and with tuner-core.

Regards,
Mauro
