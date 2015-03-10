Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:40972 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751391AbbCJONz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2015 10:13:55 -0400
Message-ID: <54FEFC19.9030500@xs4all.nl>
Date: Tue, 10 Mar 2015 15:13:45 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>,
	'Bastien Nocera' <hadess@hadess.net>
CC: 'Mauro Carvalho Chehab' <mchehab@osg.samsung.com>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	linux-input@vger.kernel.org
Subject: Re: [RFC v2 2/7] media: rc: Add cec protocol handling
References: <1421942679-23609-1-git-send-email-k.debski@samsung.com> <1421942679-23609-3-git-send-email-k.debski@samsung.com> <20150308112033.7d807164@recife.lan> <000801d05a85$2c83f4e0$858bdea0$%debski@samsung.com> <1425919423.1421.14.camel@hadess.net> <001a01d05b2a$26c71640$745542c0$%debski@samsung.com>
In-Reply-To: <001a01d05b2a$26c71640$745542c0$%debski@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/10/2015 01:02 PM, Kamil Debski wrote:
> Hi Bastien,
> 
> From: Bastien Nocera [mailto:hadess@hadess.net]
> Sent: Monday, March 09, 2015 5:44 PM
>>
>> On Mon, 2015-03-09 at 17:22 +0100, Kamil Debski wrote:
>>> Hi Mauro,
>>>
>>> From: Mauro Carvalho Chehab [mailto:mchehab@osg.samsung.com]
>>> Sent: Sunday, March 08, 2015 3:21 PM
>>>
>>>> Em Thu, 22 Jan 2015 17:04:34 +0100
>>>> Kamil Debski <k.debski@samsung.com> escreveu:
>>>>
>>>> (c/c linux-input ML)
>>>>
>>>>> Add cec protocol handling the RC framework.
>>>>
>>>> I added some comments, that reflects my understanding from what's
>>>> there at the keymap definitions found at:
>>>>         http://xtreamerdev.googlecode.com/files/CEC_Specs.pdf
>>>
>>> Thank you very much for the review, Mauro. Your comments are very
>> much
>>> appreciated.
>>
>> How does one use this new support? If I plug in my laptop to my TV,
>> will using the TV's remote automatically send those key events to the
>> laptop?
> 
> It depends on the hardware that is used in your laptop to handle HDMI.
> If there is hardware support for CEC then this framework can be used
> to create a driver for the laptop's HDMI hardware. Then the laptop will
> be able to communicate with the TV over CEC - this includes receiving
> key events from the TV.
> 
> Currently there are some CEC devices (and drivers) that enable Linux to
> use CEC, but there is no generic framework for CEC in the Linux kernel.
> My goal is to introduce such a framework, such that userspace
> application could work with different hardware using the same interface.
> 
> Getting back to your question - using this framework. There should be
> some initialization done by a user space application:
> - enabling CEC (if needed by the hardware/driver)
> - configuring the connection (e.g. what kind of device should the
>   laptop appear as, request the TV to pass remote control keys, etc.)
> - the TV will also send other CEC messages to the laptop, hence the
>   application should listen for such messages and act accordingly
> 
> How this should be done userspace? Definitely, it would be a good idea
> to use a library. Maybe a deamon that does the steps mentioned above
> would be a good idea? I am working on a simple library implementation
> that would wrap the kernel ioctls and provide a more user friendly API.

Let me add to this as the original designer of this framework: first of
all the CEC protocol is a protocol from hell, very ad-hoc designed.

The problem with that is that it very much depends on the product or device
driver what - if anything - of the CEC protocol should be exposed to the
end-user. You can decide to keep all the CEC handling in the driver, or
do almost everything in userspace or anything in between. The hardware
itself can be an HDMI receiver, transmitter or repeater, or it can be a
USB dongle that controls the CEC bus between two HDMI devices. So even
the subsystem involved in the device can be all over the place (usb,
drm, v4l).

So this CEC framework keeps the core protocol handling inside the kernel,
and allows drivers to expose the CEC protocol to varying degrees to
userspace. The pure CEC core commands should be handled in the kernel so
no userspace components should be needed to get a valid working setup. A
USB dongle might be an exception to that rule, I haven't looked at that
in detail.

On the userspace side of the CEC framework we might need a simple library.
I'm not so sure about a daemon: that should definitely be optional.

A standard cec-ctl utility to help test and control the CEC bus would be
useful. I am also thinking that a cec-compliance test utility would be
extremely useful to verify that drivers (and userspace) implement the
CEC commands correctly. Since CEC is a bit of a disaster, such a tool
would help a lot. Time permitting this is something I might work on
myself.

Regards,

	Hans
