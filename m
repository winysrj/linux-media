Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39372 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289Ab0CMG0k (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Mar 2010 01:26:40 -0500
Message-ID: <4B9B31D5.5060603@redhat.com>
Date: Sat, 13 Mar 2010 07:33:57 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: Remaining drivers that aren't V4L2?
References: <829197381003121211l469c30bfjba077cea028bf680@mail.gmail.com> <201003122242.06508.hverkuil@xs4all.nl>
In-Reply-To: <201003122242.06508.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 03/12/2010 10:42 PM, Hans Verkuil wrote:
> On Friday 12 March 2010 21:11:49 Devin Heitmueller wrote:
>> Hello,
>>
>> I know some months ago, there was some discussion about a few drivers
>> which were stragglers and had not been converted from V4L to V4L2.
>>
>> Do we have a current list of driver which still haven't been converted?
>

As Hans Verkuil already said I've been working on steadily converting
v4l1 usb device drivers to gspca sub drivers, removing a lot of
redundant code and making them v4l2.

> These drivers are still v4l1:
>
> arv
> bw-qcam
> c-qcam
> cpia_pp

> cpia_usb

This one has a gspca subdriver now, and has been marked as
deprecated in 2.6.34, and scheduled for removal.

> ov511

This one has a gspca subdriver now, and has been marked as
deprecated in 2.6.34, and scheduled for removal.

> se401

Hans Verkuil gave me a camera with such a chip, I've been
meaning to work on this for a while. Note that the v4l1 driver
is completely broken (hanhs the machine) which complicates writing
a v4l2 driver, as I either need to first fix the v4l1 driver,
or just copy do a v4l2 driver based on the info in the v4l1 driver,
without having a driver to compare with.

> stradis

> stv680

This one has a gspca subdriver now, and has been marked as
deprecated in 2.6.34, and scheduled for removal.

> usbvideo

This actually is a framework for usb video devices a bit like
gspca one could say. It supports the following devices:

"USB 3com HomeConnect (aka vicam)"
"USB IBM (Xirlink) C-it Camera"
"USB Konica Webcam support"
"USB Logitech Quickcam Messenger"

Of which the Logitech Quickcam Messenger has a gspca subdriver
now, and is scheduled for removal.

> w9966
>
> Some of these have counterparts in gspca these days so possibly some drivers
> can be removed by now. Hans, can you point those out?
>

See above. Note in order to finish the conversion of drivers to
v4l1 besides time (which can be made every now and then) I really
really need hardware access, so if anyone has one of the usbvideo supported
devices lying around, and is willing to ship it to me, please drop
me a private mail!


> arv, bw-qcam, c-qcam, cpia_pp and stradis can probably be moved to staging
> and if no one steps up then they can be dropped altogether.
>

Ack!

> According to my notes I should be able to test cpia_usb. I would have to
> verify that, though. I think it is only used in a USB microscope. It is
> effectively a webcam. I can also test usbvideo (USB 1 TV capture device).
> The latter is probably the most important driver that needs converting,
> because I think these are not uncommon.
>

You gave your cpia1 camera to me, so now I have 2 to test with, 1 from
creative and the brandless one from you. Also note that this indeed is
used in microscopes, but also in regular webcams, Either way the cpia1
is supported in gspca now (for the usb version).

> However, I have no time to work on such a driver conversion. But if someone
> is seriously willing to put time and effort in that, then I am willing to
> mail the hardware.
>

You already did that, you gave me a cpia1, stv0680 and an se401 camera :)

>> I started doing some more tvtime work last night, and I would *love*
>> to drop V4L support (and *only* support V4L2 devices), since it would
>> make the code much cleaner, more reliable, and easier to test.
>>
>> If there are only a few obscure webcams remaining, then I'm willing to
>> tell those users that they have to stick with whatever old version of
>> tvtime they've been using since the last release four years ago.
>
> To my knowledge the usbvideo driver is probably the least obscure device
> that is still using V4L1.

I think you are confusing the usbvideo driver with the v4l2 usbvision
driver, which indeed gets used a lot in usb tv devices.

I think it is ok to drop v4l1 support from tvtime.

Regards,

Hans
