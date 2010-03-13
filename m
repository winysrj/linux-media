Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935788Ab0CMU7j (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Mar 2010 15:59:39 -0500
Message-ID: <4B9BFCB6.4080805@redhat.com>
Date: Sat, 13 Mar 2010 17:59:34 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-input@vger.kernel.org
Subject: Re: [PATCH] V4L/DVB: ir: Add a link to associate /sys/class/ir/irrcv
 with the input device
References: <4B99104B.3090307@redhat.com> <20100311175214.GB7467@core.coreip.homeip.net> <4B99C3D7.7000301@redhat.com> <20100313084157.GD22494@core.coreip.homeip.net>
In-Reply-To: <20100313084157.GD22494@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dmitry Torokhov wrote:
> On Fri, Mar 12, 2010 at 01:32:23AM -0300, Mauro Carvalho Chehab wrote:
>> Dmitry Torokhov wrote:
>>> Hi Mauro,
>>>
>>> On Thu, Mar 11, 2010 at 12:46:19PM -0300, Mauro Carvalho Chehab wrote:
>>>> In order to allow userspace programs to autoload an IR table, a link is
>>>> needed to point to the corresponding input device.
>>>>
>>>> $ tree /sys/class/irrcv/irrcv0
>>>> /sys/class/irrcv/irrcv0
>>>> |-- current_protocol
>>>> |-- input -> ../../../pci0000:00/0000:00:0b.1/usb1/1-3/input/input22
>>>> |-- power
>>>> |   `-- wakeup
>>>> |-- subsystem -> ../../../../class/irrcv
>>>> `-- uevent
>>>>
>>>> It is now easy to associate an irrcv device with the corresponding
>>>> device node, at the input interface.
>>>>
>>> I guess the question is why don't you make input device a child of your
>>> irrcvX device? Then I believe driver core will link them properly. It
>>> will also ensure proper power management hierarchy.
>>>
>>> That probably will require you changing from class_dev into device but
>>> that's the direction kernel is going to anyway.
>> Done, see enclosed. It is now using class_register/device_register. The
>> newly created device for irrcv is used as the parent for input_dev->dev.
>>
>> The resulting code looked cleaner after the change ;)
>>
> 
> It is indeed better, however I wonder if current hierarchy expresses the
> hardware in best way. You currently have irrcv devices grow in parallel
> with input devices whereas I would expect input devices be children of
> irrcv devices:
> 
> 
> 	parent (PCI board, USB) -> irrcvX -> input1
>                                           -> input2
> 					 ...
> 

It is representing it right:

usb1/1-3 -> irrcv -> irrcv0 -> input7 -> event7

The only extra attribute there is the class name "irrcv", but this seems
coherent with the other classes on this device (dvb, sound, power, video4linux).

The created tree is:

$ tree /sys/class/irrcv/
/sys/class/irrcv/
`-- irrcv0 -> ../../devices/pci0000:00/0000:00:0b.1/usb1/1-3/irrcv/irrcv0

$ tree /sys/devices/pci0000:00/0000:00:0b.1/usb1/1-3/
/sys/devices/pci0000:00/0000:00:0b.1/usb1/1-3/
|-- 1-3:1.0
|   |-- bAlternateSetting
|   |-- bInterfaceClass
|   |-- bInterfaceNumber
|   |-- bInterfaceProtocol
|   |-- bInterfaceSubClass
|   |-- bNumEndpoints
|   |-- driver -> ../../../../../../bus/usb/drivers/em28xx
|   |-- ep_81
|   |   |-- bEndpointAddress
|   |   |-- bInterval
|   |   |-- bLength
|   |   |-- bmAttributes
|   |   |-- direction
|   |   |-- interval
|   |   |-- power
|   |   |   `-- wakeup
|   |   |-- type
|   |   |-- uevent
|   |   `-- wMaxPacketSize
|   |-- ep_82
|   |   |-- bEndpointAddress
|   |   |-- bInterval
|   |   |-- bLength
|   |   |-- bmAttributes
|   |   |-- direction
|   |   |-- interval
|   |   |-- power
|   |   |   `-- wakeup
|   |   |-- type
|   |   |-- uevent
|   |   `-- wMaxPacketSize
|   |-- ep_83
|   |   |-- bEndpointAddress
|   |   |-- bInterval
|   |   |-- bLength
|   |   |-- bmAttributes
|   |   |-- direction
|   |   |-- interval
|   |   |-- power
|   |   |   `-- wakeup
|   |   |-- type
|   |   |-- uevent
|   |   `-- wMaxPacketSize
|   |-- ep_84
|   |   |-- bEndpointAddress
|   |   |-- bInterval
|   |   |-- bLength
|   |   |-- bmAttributes
|   |   |-- direction
|   |   |-- interval
|   |   |-- power
|   |   |   `-- wakeup
|   |   |-- type
|   |   |-- uevent
|   |   `-- wMaxPacketSize
|   |-- modalias
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../../../../bus/usb
|   |-- supports_autosuspend
|   |-- uevent
|   `-- video4linux
|       |-- vbi2
|       |   |-- dev
|       |   |-- device -> ../../../1-3:1.0
|       |   |-- index
|       |   |-- name
|       |   |-- power
|       |   |   `-- wakeup
|       |   |-- subsystem -> ../../../../../../../../class/video4linux
|       |   `-- uevent
|       `-- video2
|           |-- dev
|           |-- device -> ../../../1-3:1.0
|           |-- index
|           |-- name
|           |-- power
|           |   `-- wakeup
|           |-- subsystem -> ../../../../../../../../class/video4linux
|           `-- uevent
|-- authorized
|-- bcdDevice
|-- bConfigurationValue
|-- bDeviceClass
|-- bDeviceProtocol
|-- bDeviceSubClass
|-- bmAttributes
|-- bMaxPacketSize0
|-- bMaxPower
|-- bNumConfigurations
|-- bNumInterfaces
|-- busnum
|-- configuration
|-- descriptors
|-- dev
|-- devnum
|-- devpath
|-- driver -> ../../../../../bus/usb/drivers/usb
|-- dvb
|   |-- dvb0.demux0
|   |   |-- dev
|   |   |-- device -> ../../../1-3
|   |   |-- power
|   |   |   `-- wakeup
|   |   |-- subsystem -> ../../../../../../../class/dvb
|   |   `-- uevent
|   |-- dvb0.dvr0
|   |   |-- dev
|   |   |-- device -> ../../../1-3
|   |   |-- power
|   |   |   `-- wakeup
|   |   |-- subsystem -> ../../../../../../../class/dvb
|   |   `-- uevent
|   |-- dvb0.frontend0
|   |   |-- dev
|   |   |-- device -> ../../../1-3
|   |   |-- power
|   |   |   `-- wakeup
|   |   |-- subsystem -> ../../../../../../../class/dvb
|   |   `-- uevent
|   `-- dvb0.net0
|       |-- dev
|       |-- device -> ../../../1-3
|       |-- power
|       |   `-- wakeup
|       |-- subsystem -> ../../../../../../../class/dvb
|       `-- uevent
|-- ep_00
|   |-- bEndpointAddress
|   |-- bInterval
|   |-- bLength
|   |-- bmAttributes
|   |-- direction
|   |-- interval
|   |-- power
|   |   `-- wakeup
|   |-- type
|   |-- uevent
|   `-- wMaxPacketSize
|-- i2c-3
|   |-- 3-005c
|   |   |-- driver -> ../../../../../../../bus/i2c/drivers/tvp5150
|   |   |-- modalias
|   |   |-- name
|   |   |-- power
|   |   |   `-- wakeup
|   |   |-- subsystem -> ../../../../../../../bus/i2c
|   |   `-- uevent
|   |-- 3-0061
|   |   |-- driver -> ../../../../../../../bus/i2c/drivers/tuner
|   |   |-- modalias
|   |   |-- name
|   |   |-- power
|   |   |   `-- wakeup
|   |   |-- subsystem -> ../../../../../../../bus/i2c
|   |   `-- uevent
|   |-- delete_device
|   |-- device -> ../../1-3
|   |-- name
|   |-- new_device
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../../../../bus/i2c
|   `-- uevent
|-- idProduct
|-- idVendor
|-- irrcv
|   `-- irrcv0
|       |-- current_protocol
|       |-- device -> ../../../1-3
|       |-- input7
|       |   |-- capabilities
|       |   |   |-- abs
|       |   |   |-- ev
|       |   |   |-- ff
|       |   |   |-- key
|       |   |   |-- led
|       |   |   |-- msc
|       |   |   |-- rel
|       |   |   |-- snd
|       |   |   `-- sw
|       |   |-- device -> ../../irrcv0
|       |   |-- event7
|       |   |   |-- dev
|       |   |   |-- device -> ../../input7
|       |   |   |-- power
|       |   |   |   `-- wakeup
|       |   |   |-- subsystem -> ../../../../../../../../../class/input
|       |   |   `-- uevent
|       |   |-- id
|       |   |   |-- bustype
|       |   |   |-- product
|       |   |   |-- vendor
|       |   |   `-- version
|       |   |-- modalias
|       |   |-- name
|       |   |-- phys
|       |   |-- power
|       |   |   `-- wakeup
|       |   |-- subsystem -> ../../../../../../../../class/input
|       |   |-- uevent
|       |   `-- uniq
|       |-- power
|       |   `-- wakeup
|       |-- subsystem -> ../../../../../../../class/irrcv
|       `-- uevent
|-- maxchild
|-- power
|   |-- active_duration
|   |-- autosuspend
|   |-- connected_duration
|   |-- level
|   |-- persist
|   `-- wakeup
|-- product
|-- quirks
|-- remove
|-- serial
|-- sound
|   `-- card1
|       |-- controlC1
|       |   |-- dev
|       |   |-- device -> ../../card1
|       |   |-- power
|       |   |   `-- wakeup
|       |   |-- subsystem -> ../../../../../../../../class/sound
|       |   `-- uevent
|       |-- device -> ../../../1-3
|       |-- id
|       |-- number
|       |-- pcmC1D0c
|       |   |-- dev
|       |   |-- device -> ../../card1
|       |   |-- pcm_class
|       |   |-- power
|       |   |   `-- wakeup
|       |   |-- subsystem -> ../../../../../../../../class/sound
|       |   `-- uevent
|       |-- power
|       |   `-- wakeup
|       |-- subsystem -> ../../../../../../../class/sound
|       `-- uevent
|-- speed
|-- subsystem -> ../../../../../bus/usb
|-- uevent
|-- urbnum
`-- version


$ tree /sys/class/irrcv/irrcv0/
/sys/class/irrcv/irrcv0/
|-- current_protocol
|-- device -> ../../../1-3
|-- input7
|   |-- capabilities
|   |   |-- abs
|   |   |-- ev
|   |   |-- ff
|   |   |-- key
|   |   |-- led
|   |   |-- msc
|   |   |-- rel
|   |   |-- snd
|   |   `-- sw
|   |-- device -> ../../irrcv0
|   |-- event7
|   |   |-- dev
|   |   |-- device -> ../../input7
|   |   |-- power
|   |   |   `-- wakeup
|   |   |-- subsystem -> ../../../../../../../../../class/input
|   |   `-- uevent
|   |-- id
|   |   |-- bustype
|   |   |-- product
|   |   |-- vendor
|   |   `-- version
|   |-- modalias
|   |-- name
|   |-- phys
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../../../../../../class/input
|   |-- uevent
|   `-- uniq
|-- power
|   `-- wakeup
|-- subsystem -> ../../../../../../../class/irrcv
`-- uevent

13 directories, 25 files

> This way your PM sequence as follows - input core does its thing and
> releases all pressed keys, etc, then you can shut off the receiver and
> then board driver can shut doen the main piece. Otherwise irrcv0 suspend
> may be racing with input suspend and so forth.
> 
> Thanks.
> 


-- 

Cheers,
Mauro
