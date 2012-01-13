Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw-out2.cc.tut.fi ([130.230.160.33]:56179 "EHLO
	mail-gw-out2.cc.tut.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab2AMNtx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jan 2012 08:49:53 -0500
Message-ID: <4F1032F9.8020505@iki.fi>
Date: Fri, 13 Jan 2012 15:34:49 +0200
From: Anssi Hannula <anssi.hannula@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-input@vger.kernel.org,
	linux-media <linux-media@vger.kernel.org>,
	Jiri Kosina <jkosina@suse.cz>
Subject: Re: Two devices, same USB ID: one needs HID, the other doesn't. How
 to solve this?
References: <201201131142.33779.hverkuil@xs4all.nl>
In-Reply-To: <201201131142.33779.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13.01.2012 12:42, Hans Verkuil wrote:
> Hi!

Hi!

Adding Jiri Kosina, the HID maintainer.

> I've made a video4linux driver for the USB Keene FM Transmitter. See:
> 
> http://www.amazon.co.uk/Keene-Electronics-USB-FM-Transmitter/dp/B003GCHPDY/ref=sr_1_1?ie=UTF8&qid=1326450476&sr=8-1
> 
> The driver code is here:
> 
> http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/keene
> 
> Unfortunately this device has exactly the same USB ID as the Logitech AudioHub
> USB speaker (http://www.logitech.com/en-us/439/3503).
> 
> The AudioHub has HID support for volume keys, but the FM transmitter needs
> a custom V4L2 driver instead.
> 
> I've attached the full lsusb -v output of both devices, but this is the diff of
> the two:
> 
> $ diff keene.txt audiohub.txt -u
[...]
> @@ -152,7 +151,7 @@
>            bCountryCode            0 Not supported
>            bNumDescriptors         1
>            bDescriptorType        34 Report
> -          wDescriptorLength      22
> +          wDescriptorLength      31
>           Report Descriptors: 
>             ** UNAVAILABLE **
>        Endpoint Descriptor:
> 
> As you can see, the differences are very small.

The HID Report descriptors could be interesting as they differ. You can
look at them in:
/sys/kernel/debug/hid/*/rdesc

I guess one option would be to make this a "regular" HID driver like
those in drivers/hid/hid-*.c (and just set the v4l things up if the
descriptor is as expected, otherwise let standard HID-input handle
them), but there is the issue of where to place the driver, then, as it
can't be both in drivers/hid and drivers/media...

Probably the easy way out is to simply add the device into
drivers/hid/hid-core.c:hid_ignore(), by checking e.g.
vendor+product+name, and hope all "B-LINK USB Audio" devices are FM
transmitters (the name suggests that may not necessarily be the case,
though). Report descriptor contents are not available at hid_ignore()
point yet.

> In my git tree I worked around it by adding the USB ID to the ignore list
> if the Keene driver is enabled, and ensuring that the Keene driver is
> disabled by default.
> 
> But is there a better method to do this? At least the iProduct strings are
> different, is that something that can be tested in hid-core.c?
> 
> Regards,
> 
> 	Hans


-- 
Anssi Hannula
