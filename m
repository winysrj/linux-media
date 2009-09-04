Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56991 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651AbZIDPLY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Sep 2009 11:11:24 -0400
Message-ID: <4AA12E17.4080006@iki.fi>
Date: Fri, 04 Sep 2009 18:11:19 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@kernellabs.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [RFC] Allow bridge drivers to have better control over DVB frontend
 	operations
References: <37219a840909012132l6c04af65hddecd2d52e196bcb@mail.gmail.com>
In-Reply-To: <37219a840909012132l6c04af65hddecd2d52e196bcb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/02/2009 07:32 AM, Michael Krufky wrote:
> Over the course of the past year, a number of developers have
> expressed a need for giving the bridge drivers better control over
> dvb_frontend operations.  Specifically, there is a need for the bridge
> driver to receive a DVB frontend IOCTL and have the opportunity to
> allow or deny the IOCTL to proceed, as resources permit.
>
> For instance, in the case of a hybrid device, only the bridge driver
> knows whether the analog functionality is presently being used.  If
> the driver is currently in analog mode, serving video frames, the
> driver will have a chance to deny the DVB frontend ioctl request
> before dvb-core passes the request on to the frontend driver,
> potentially damaging the analog video stream already in progress.
>
> In some cases, the bridge driver might have to perform a setup
> operation to use a feature specific to the device.  For instance, the
> bridge device may be in a low powered state - this new capability
> allows the driver to wake up before passing the command on to the
> frontend driver.  This new feature will allow LinuxTV developers to
> finally get working on actual power management support within the
> v4l/dvb subsystem, without the fear of breaking devices with hybrid
> analog / digital functionality.
>
> In other cases, there may be situations in which multiple RF
> connectors are available to the tuner, but only the bridge driver will
> be aware of this, as this type of thing is specific to the device's
> hardware implementation.  As there are many tuners capable of multiple
> RF spigots, not all devices actually employ this feature - only the
> bridge driver knows what implementations support such features, and
> how to enable / disable them.
>
> The possibilities are endless.  I actually did all the heavy lifting
> involved in this a few months ago, but haven't had a moment to write
> up this RFC until now.
>
> The change to dvb-core that allows this new functionality is posted to
> my development repository on kernellabs.com.  I have also included an
> example of how this can be used on a digital tuner board with multiple
> RF inputs.  The multiple RF input switching is already supported in
> today's code, but I promised Mauro that I would present a better
> method of doing this before the upcoming merge window.  For your
> review and comments, please take a look at the topmost changesets,
> starting with "create a standard method for dvb adapter drivers to
> override frontend ioctls":
>
> http://kernellabs.com/hg/~mkrufky/fe_ioctl_override

Idea looks very good! I tested one DVB USB device need blocking IOCTLs 
when demod and tuner are power save and didn't saw functionality problems.

However, it was a little bit hard to add callback to DVB USB driver. 
Could that callback be added to the struct dvb_usb_adapter_properties 
for simplify things? I have feeling that this callback will be useful 
most DVb USB devices - setting GPIOs and clock settings for power save.

Name fe_ioctl_override sounds like whole IOCTL will be replaced with new 
one which is not true. Still, I don't know which could be better name.

Antti
-- 
http://palosaari.fi/
