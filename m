Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60825 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab1KHCDr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2011 21:03:47 -0500
Received: by faan17 with SMTP id n17so35870faa.19
        for <linux-media@vger.kernel.org>; Mon, 07 Nov 2011 18:03:46 -0800 (PST)
MIME-Version: 1.0
Reply-To: whittenburg@gmail.com
In-Reply-To: <201111071214.36935.laurent.pinchart@ideasonboard.com>
References: <CABcw_OkE=ANKDCVRRxgj33Mt=b3KAtGpe3RMnL3h0UMgOQ0ZdQ@mail.gmail.com>
	<CABcw_Omf-xChfK8qu5u95KUqvnrKu99WQiPRWvZTmpy4rW6xiw@mail.gmail.com>
	<4EB7BC1F.50902@mlbassoc.com>
	<201111071214.36935.laurent.pinchart@ideasonboard.com>
Date: Mon, 7 Nov 2011 20:03:43 -0600
Message-ID: <CABcw_Omoj2VkiksKEs1tV_9vB6ZVtTvUJ2GK0beY5JjFSBgd_g@mail.gmail.com>
Subject: Re: media0 not showing up on beagleboard-xm
From: Chris Whittenburg <whittenburg@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Gary Thomas <gary@mlbassoc.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 7, 2011 at 5:14 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Monday 07 November 2011 12:08:15 Gary Thomas wrote:
>> On 2011-11-06 15:26, Chris Whittenburg wrote:
>> > On Fri, Nov 4, 2011 at 6:49 AM, Laurent Pinchart wrote:
>> >> On Tuesday 25 October 2011 04:48:13 Chris Whittenburg wrote:
>> >>> I'm using oe-core to build the 3.0.7+ kernel, which runs fine on my
>> >>> beagleboard-xm.
>> >>
>> >> You will need board code to register the OMAP3 ISP platform device that
>> >> will then be picked by the OMAP3 ISP driver. Example of such board code
>> >> can be found at
>> >>
>> >> http://git.linuxtv.org/pinchartl/media.git/commit/37f505296ccd3fb055e03b
>> >> 2ab15ccf6ad4befb8d
>> >
>> > I followed your example to add the MT9P031 support, and now I get
>> > /dev/media0 and /dev/video0 to 7.
>> >
>> > I don't have the actual sensor hooked up yet.
>> >
>> > If I try "media-ctl -p", I see lots of "Failed to open subdev device
>> > node" msgs.
>> > http://pastebin.com/F1TC9A1n
>> >
>> > This is with the media-ctl utility from:
>> > http://feeds.angstrom-distribution.org/feeds/core/ipk/eglibc/armv7a/base/
>> > media-ctl_0.0.1-r0_armv7a.ipk
>> >
>> > I also tried with the latest from your media-ctl repository, but got
>> > the same msgs.
>> >
>> > Is this an issue with my 3.0.8 kernel not being compatible with
>> > current media-ctl utility?  Is there some older commit that I should
>> > build from?  Or maybe it is just a side effect of the sensor not being
>> > connected yet.
>>
>> Does your kernel config enable CONFIG_VIDEO_V4L2_SUBDEV_API?

Yes, it is enabled...  Here is a snippet of my config:

#
# Multimedia core support
#
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2_COMMON=y
CONFIG_VIDEO_V4L2_SUBDEV_API=y
CONFIG_DVB_CORE=m
CONFIG_VIDEO_MEDIA=m


> And does your system run udev, or have you created the device nodes manually ?

It runs udev-173... I didn't create the nodes manually.

I also have the /dev/v4l-subdev0 to 7 entries, as expected.

Anything else I should check?

Thanks.
