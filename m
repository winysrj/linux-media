Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nexicom.net ([216.168.96.13]:37372 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756058Ab2HGUdw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Aug 2012 16:33:52 -0400
Received: from mail.lockie.ca (dyn-dsl-mb-216-168-121-226.nexicom.net [216.168.121.226])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id q77KXoVd013189
	for <linux-media@vger.kernel.org>; Tue, 7 Aug 2012 16:33:51 -0400
Message-ID: <48430fdf908e6481ae55103bd11b7cfe.squirrel@lockie.ca>
In-Reply-To: <32d7859a-ceda-442d-be67-f4f682a6e3b9@email.android.com>
References: <501D4535.8080404@lockie.ca>
    <f1bd5aea-00cd-4b3f-9562-d25153f8cef3@email.android.com>
    <501DA203.7070800@lockie.ca>
    <20120805212054.GA29636@valkosipuli.retiisi.org.uk>
    <501F4A5B.1000608@lockie.ca>
    <20120807112742.GB29636@valkosipuli.retiisi.org.uk>
    <6ef5338940a90b4c8000594d546bf479.squirrel@lockie.ca>
    <32d7859a-ceda-442d-be67-f4f682a6e3b9@email.android.com>
Date: Tue, 7 Aug 2012 16:33:46 -0400
Subject: Re: boot slow down
From: bjlockie@lockie.ca
To: "Andy Walls" <awalls@md.metrocast.net>
Cc: "Sakari Ailus" <sakari.ailus@iki.fi>,
	"linux-media Mailing List" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> bjlockie@lockie.ca wrote:
>
>>> Hi James,
>>>
>>> On Mon, Aug 06, 2012 at 12:38:51AM -0400, James wrote:
>>>> On 08/05/12 17:20, Sakari Ailus wrote:
>>>> > Hi Andy and James,
>>>> >
>>>> > On Sat, Aug 04, 2012 at 06:28:19PM -0400, James wrote:
>>>> >> On 08/04/12 13:42, Andy Walls wrote:
>>>> >>> James <bjlockie@lockie.ca> wrote:
>>>> >>>
>>>> >>>> There's a big pause before the 'unable'
>>>> >>>>
>>>> >>>> [    2.243856] usb 4-1: Manufacturer: Logitech
>>>> >>>> [   62.739097] cx25840 6-0044: unable to open firmware
>>>> >>>> v4l-cx23885-avcore-01.fw
>>>> >>>>
>>>> >>>>
>>>> >>>> I have a cx23885
>>>> >>>> cx23885[0]: registered device video0 [v4l2]
>>>> >>>>
>>>> >>>> Is there any way to stop it from trying to load the firmware?
>>>> >>>> What is the firmware for, analog tv? Digital works fine and
>>analog
>>>> is
>>>> >>>> useless to me.
>>>> >>>> I assume it is timing out there.
>>>> >>>> --
>>>> >>>> To unsubscribe from this list: send the line "unsubscribe
>>>> linux-media"
>>>> >>>> in
>>>> >>>> the body of a message to majordomo@vger.kernel.org
>>>> >>>> More majordomo info at
>>http://vger.kernel.org/majordomo-info.html
>>>> >>>
>>>> >>> The firmware is for the analog broadcast audio standard (e.g.
>>BTSC)
>>>> detection microcontroller.
>>>> >>>
>>>> >>> The A/V core of the CX23885/7/8 chips is for analog vidoe and
>>audio
>>>> processing (broadcast, CVBS, SVideo, audio L/R in).
>>>> >>>
>>>> >>> The A/V core of the CX23885 provides the IR unit and the Video
>>PLL
>>>> provides the timing for the IR unit.
>>>> >>>
>>>> >>> The A/V core of the CX23888 provides the Video PLL which is the
>>>> timing for the IR unit in the CX23888.
>>>> >>>
>>>> >>> Just grab the firmware and be done with it.  Don't waste time
>>with
>>>> trying to make the cx23885 working properly but halfway.
>>>> >>>
>>>> >>> Regards,
>>>> >>> Andy
>>>> >>
>>>> >> I already have the firmware.
>>>> >> # ls -l /lib/firmware/v4l-cx23885-avcore-01.fw
>>>> >> -rw-r--r-- 1 root root 16382 Oct 15  2011
>>>> /lib/firmware/v4l-cx23885-avcore-01.fw
>>>> >
>>>> > The timeout if for allowing the user space helper enough time to
>>>> provide the
>>>> > driver with the firmware, but it seems the helper isn't around as
>>the
>>>> > timeout expires. Is udev running around the time of the first
>>line? Is
>>>> the
>>>> > driver linked directly into the kernel or is it a module?
>>>> >
>>>> > Kind regards,
>>>> >
>>>> I have this set so the firmware is in the kernel.
>>>>
>>>> Symbol: FIRMWARE_IN_KERNEL [=y]
>>>
>>> I don't know about that driver, but if the udev would have to provide
>>the
>>> firmware, and it's not running, the delay is expected. Two seconds
>>after
>>> kernel startup is so early that the user space, including udev, might
>>not
>>> yet be running.
>>>
>>> Kind regards,
>>>
>>> --
>>> Sakari Ailus
>>> e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
>>
>>Doesn't that kernel option mean the firmware is put into the kernel at
>>kernel build time?
>>
>>If I build the module, is there a module option to skip the delay?
>
>
> Hi,
>
> The CX2388x firmware is _never_ built into the kernel.  I'm not sure what
> that particular kernel config option is for.
>
> The kernel delay waiting for userspace to load firmware is settable using
> a node under /sys somewhere. The default is 60 seconds.  You will have to
> change it in very early boot, or fix the hardcoded constant in the kernel
> and recompile your kernel.
>
> Shortening the delay may not get you entirely acceptable results.  If udev
> is not, or is refusing to load firmware for the cx25840 module, then that
> module will not properly initialize the CX23885/7/8 A/V core hardware and
> will likely return with failure.  I'm not sure if the cx23885 driver will
> happily continue on, if that happens.

It works fine even though it times out.

>
> If you still have a modular kernel build around, you may wish to test with
> it.  Blacklist the cx23885 module in /etc/modprobe.conf and the use
> udevadm to investigate what is going on with udev when you later modprobe
> the cx23885 driver.
>
> If building the video card driver into the kernel is causing you all the
> problems, then I simply recommend not doing that.

I'll try it as a module.

>
> Regards,
> Andy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


