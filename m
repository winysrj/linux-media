Return-path: <linux-media-owner@vger.kernel.org>
Received: from dell.nexicom.net ([216.168.96.13]:43585 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab2HGNEt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Aug 2012 09:04:49 -0400
Received: from mail.lockie.ca (dyn-dsl-mb-216-168-121-226.nexicom.net [216.168.121.226])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id q77D4ln3008119
	for <linux-media@vger.kernel.org>; Tue, 7 Aug 2012 09:04:48 -0400
Message-ID: <6ef5338940a90b4c8000594d546bf479.squirrel@lockie.ca>
In-Reply-To: <20120807112742.GB29636@valkosipuli.retiisi.org.uk>
References: <501D4535.8080404@lockie.ca>
    <f1bd5aea-00cd-4b3f-9562-d25153f8cef3@email.android.com>
    <501DA203.7070800@lockie.ca>
    <20120805212054.GA29636@valkosipuli.retiisi.org.uk>
    <501F4A5B.1000608@lockie.ca>
    <20120807112742.GB29636@valkosipuli.retiisi.org.uk>
Date: Tue, 7 Aug 2012 09:04:44 -0400
Subject: Re: boot slow down
From: bjlockie@lockie.ca
To: "Sakari Ailus" <sakari.ailus@iki.fi>
Cc: "Andy Walls" <awalls@md.metrocast.net>,
	"linux-media Mailing List" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Hi James,
>
> On Mon, Aug 06, 2012 at 12:38:51AM -0400, James wrote:
>> On 08/05/12 17:20, Sakari Ailus wrote:
>> > Hi Andy and James,
>> >
>> > On Sat, Aug 04, 2012 at 06:28:19PM -0400, James wrote:
>> >> On 08/04/12 13:42, Andy Walls wrote:
>> >>> James <bjlockie@lockie.ca> wrote:
>> >>>
>> >>>> There's a big pause before the 'unable'
>> >>>>
>> >>>> [    2.243856] usb 4-1: Manufacturer: Logitech
>> >>>> [   62.739097] cx25840 6-0044: unable to open firmware
>> >>>> v4l-cx23885-avcore-01.fw
>> >>>>
>> >>>>
>> >>>> I have a cx23885
>> >>>> cx23885[0]: registered device video0 [v4l2]
>> >>>>
>> >>>> Is there any way to stop it from trying to load the firmware?
>> >>>> What is the firmware for, analog tv? Digital works fine and analog
>> is
>> >>>> useless to me.
>> >>>> I assume it is timing out there.
>> >>>> --
>> >>>> To unsubscribe from this list: send the line "unsubscribe
>> linux-media"
>> >>>> in
>> >>>> the body of a message to majordomo@vger.kernel.org
>> >>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >>>
>> >>> The firmware is for the analog broadcast audio standard (e.g. BTSC)
>> detection microcontroller.
>> >>>
>> >>> The A/V core of the CX23885/7/8 chips is for analog vidoe and audio
>> processing (broadcast, CVBS, SVideo, audio L/R in).
>> >>>
>> >>> The A/V core of the CX23885 provides the IR unit and the Video PLL
>> provides the timing for the IR unit.
>> >>>
>> >>> The A/V core of the CX23888 provides the Video PLL which is the
>> timing for the IR unit in the CX23888.
>> >>>
>> >>> Just grab the firmware and be done with it.  Don't waste time with
>> trying to make the cx23885 working properly but halfway.
>> >>>
>> >>> Regards,
>> >>> Andy
>> >>
>> >> I already have the firmware.
>> >> # ls -l /lib/firmware/v4l-cx23885-avcore-01.fw
>> >> -rw-r--r-- 1 root root 16382 Oct 15  2011
>> /lib/firmware/v4l-cx23885-avcore-01.fw
>> >
>> > The timeout if for allowing the user space helper enough time to
>> provide the
>> > driver with the firmware, but it seems the helper isn't around as the
>> > timeout expires. Is udev running around the time of the first line? Is
>> the
>> > driver linked directly into the kernel or is it a module?
>> >
>> > Kind regards,
>> >
>> I have this set so the firmware is in the kernel.
>>
>> Symbol: FIRMWARE_IN_KERNEL [=y]
>
> I don't know about that driver, but if the udev would have to provide the
> firmware, and it's not running, the delay is expected. Two seconds after
> kernel startup is so early that the user space, including udev, might not
> yet be running.
>
> Kind regards,
>
> --
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk

Doesn't that kernel option mean the firmware is put into the kernel at
kernel build time?

If I build the module, is there a module option to skip the delay?

