Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:38600 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753768AbdHWMCb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 08:02:31 -0400
Subject: Re: [RFC 00/19] Async sub-notifiers and how to use them
To: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        laurent.pinchart@ideasonboard.com
References: <20170718190401.14797-1-sakari.ailus@linux.intel.com>
 <eb0ff309-bdf5-30f9-06da-2fc6c35fbf6a@xs4all.nl>
 <20170720161400.ijud3kppizb44acw@valkosipuli.retiisi.org.uk>
 <20170721065754.GC20077@bigcity.dyn.berto.se>
 <4fa22637-c58e-79e3-be22-575b0a4ff3f9@iki.fi>
 <ea92d79c-bba0-ca22-c0a7-0535d635729c@xs4all.nl> <20170823113436.GA1767@amd>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ad9a6c0f-a798-78e9-f4d1-8ed0bb28ba60@xs4all.nl>
Date: Wed, 23 Aug 2017 14:02:24 +0200
MIME-Version: 1.0
In-Reply-To: <20170823113436.GA1767@amd>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/23/17 13:34, Pavel Machek wrote:
> Hi!
> 
>>>> Is this always the case? In the R-Car VIN driver I register the video 
>>>> devices using video_register_device() in the complete handler. Am I 
>>>> doing things wrong in that driver? I had a patch where I moved the 
>>>> video_register_device() call to probe time but it got shoot down in 
>>>> review and was dropped.
>>>
>>> I don't think the current implementation is wrong, it's just different
>>> from other drivers; there's really no requirement regarding this AFAIU.
>>> It's one of the things where no attention has been paid I presume.
>>
>> It actually is a requirement: when a device node appears applications can
>> reasonably expect to have a fully functioning device. True for any device
>> node. You don't want to have to wait until some unspecified time before
>> the full functionality is there.
> 
> Well... /dev/sdb appears, but you still get -ENOMEDIA before user
> presses "Turn on USB storage" button on android phone.
> 
> So I agree it is not desirable, but it sometimes happens.

But that is expected behavior. There is nothing wrong with the device.
Just as it is expected behavior that you can't stream from a video node
if there is no HDMI source connected.

That the HDMI receiver or sensor itself is completely missing is quite
another story, though.

Regards,

	Hans
