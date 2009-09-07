Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:47160 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbZIGQzE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Sep 2009 12:55:04 -0400
Received: by ewy2 with SMTP id 2so2182004ewy.17
        for <linux-media@vger.kernel.org>; Mon, 07 Sep 2009 09:55:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <37219a840909040828i4b4c6781g2f2955a0fdba649b@mail.gmail.com>
References: <37219a840909012132l6c04af65hddecd2d52e196bcb@mail.gmail.com>
	 <4AA12E17.4080006@iki.fi>
	 <37219a840909040828i4b4c6781g2f2955a0fdba649b@mail.gmail.com>
Date: Mon, 7 Sep 2009 12:55:03 -0400
Message-ID: <37219a840909070955k6e3f61dek5bad39a72863e8d5@mail.gmail.com>
Subject: Re: [RFC] Allow bridge drivers to have better control over DVB
	frontend operations
From: Michael Krufky <mkrufky@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 4, 2009 at 11:28 AM, Michael Krufky<mkrufky@kernellabs.com> wrote:
> On Fri, Sep 4, 2009 at 11:11 AM, Antti Palosaari<crope@iki.fi> wrote:
>> On 09/02/2009 07:32 AM, Michael Krufky wrote:
>>>
>>> Over the course of the past year, a number of developers have
>>> expressed a need for giving the bridge drivers better control over
>>> dvb_frontend operations.  Specifically, there is a need for the bridge
>>> driver to receive a DVB frontend IOCTL and have the opportunity to
>>> allow or deny the IOCTL to proceed, as resources permit.
>>>
>>> For instance, in the case of a hybrid device, only the bridge driver
>>> knows whether the analog functionality is presently being used.  If
>>> the driver is currently in analog mode, serving video frames, the
>>> driver will have a chance to deny the DVB frontend ioctl request
>>> before dvb-core passes the request on to the frontend driver,
>>> potentially damaging the analog video stream already in progress.
>>>
>>> In some cases, the bridge driver might have to perform a setup
>>> operation to use a feature specific to the device.  For instance, the
>>> bridge device may be in a low powered state - this new capability
>>> allows the driver to wake up before passing the command on to the
>>> frontend driver.  This new feature will allow LinuxTV developers to
>>> finally get working on actual power management support within the
>>> v4l/dvb subsystem, without the fear of breaking devices with hybrid
>>> analog / digital functionality.
>>>
>>> In other cases, there may be situations in which multiple RF
>>> connectors are available to the tuner, but only the bridge driver will
>>> be aware of this, as this type of thing is specific to the device's
>>> hardware implementation.  As there are many tuners capable of multiple
>>> RF spigots, not all devices actually employ this feature - only the
>>> bridge driver knows what implementations support such features, and
>>> how to enable / disable them.
>>>
>>> The possibilities are endless.  I actually did all the heavy lifting
>>> involved in this a few months ago, but haven't had a moment to write
>>> up this RFC until now.
>>>
>>> The change to dvb-core that allows this new functionality is posted to
>>> my development repository on kernellabs.com.  I have also included an
>>> example of how this can be used on a digital tuner board with multiple
>>> RF inputs.  The multiple RF input switching is already supported in
>>> today's code, but I promised Mauro that I would present a better
>>> method of doing this before the upcoming merge window.  For your
>>> review and comments, please take a look at the topmost changesets,
>>> starting with "create a standard method for dvb adapter drivers to
>>> override frontend ioctls":
>>>
>>> http://kernellabs.com/hg/~mkrufky/fe_ioctl_override
>>
>> Idea looks very good! I tested one DVB USB device need blocking IOCTLs when
>> demod and tuner are power save and didn't saw functionality problems.
>>
>> However, it was a little bit hard to add callback to DVB USB driver. Could
>> that callback be added to the struct dvb_usb_adapter_properties for simplify
>> things? I have feeling that this callback will be useful most DVb USB
>> devices - setting GPIOs and clock settings for power save.
>>
>> Name fe_ioctl_override sounds like whole IOCTL will be replaced with new one
>> which is not true. Still, I don't know which could be better name.
>
> Thank you for the feedback, Antti.
>
> Yes, I can add a generic mechanism into the DVB USB device framework
> to enable this functionality there.  I'll take care of that after we
> merge the initial core changes, or maybe I will have time to do that
> over the next week.  You're right, this feature will certainly be
> useful in the dvb-usb framework, as well as many others.
>
> As far as the name fe_ioctl_override, this does apply to the entire
> IOCTL, but currently only being used for SET_FRONTEND.  As more needs
> arise, the possibilities of this feature will become more prominent.
>
> This is not a "replacement" for the IOCTL per se.  As the comments in
> dvbdev.h explain, depending on the return value of the bridge
> callback, this will determine whether or not the previous default
> IOCTL handling should be allowed to continue, or whether the bridge's
> override returns back to userspace itself.  So, if configured a
> certain way, this feature CAN be used to replace dvb-core's IOCTL
> handling, but in most cases it will simply allow the bridge to do
> pre-processing and post-processing of a given IOCTL.
>
> As fe_ioctl_override is actually most descriptive of the process going
> on, I'd like to keep that name as-is.

Antti,

I pushed the change to let dvb-usb drivers specify an
fe_ioctl_override callback within the dvb_usb_adapter_properties
structure.  Please check the repository for the latest changesets.

I plan to ask Mauro to merge this tree at some point over this next
week -- If anybody else has comments, please chime in :-)

Regards,

Mike
