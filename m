Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3825 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452AbZCJNfB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2009 09:35:01 -0400
Message-ID: <7153.62.70.2.252.1236692097.squirrel@webmail.xs4all.nl>
Date: Tue, 10 Mar 2009 14:34:57 +0100 (CET)
Subject: Re: [REVIEW PATCH 11/14] OMAP34XXCAM: Add driver
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Sakari Ailus" <sakari.ailus@maxwell.research.nokia.com>
Cc: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	"DongSoo Kim" <dongsoo.kim@gmail.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Toivonen Tuukka.O" <tuukka.o.toivonen@nokia.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hans Verkuil wrote:
>>> Sergio has posted earlier a patchset containing a driver for using the
>>> ISP to process images from memory to memory. The ISP driver is used
>>> roughly the same way as with the omap34xxcam and real sensors. The
>>> interface towards the userspace offered by the driver, however, is
>>> different, you probably saw it (preview and resizer wrappers).
>>>
>>> My opinion has been that the memory-to-memory operation of the ISP
>>> should also offer V4L2 interface. V4L2, however, doesn't support such
>>> devices at the moment. The only differences that I can see is that
>>>
>>> 1. the input is a video buffer instead of sensor and
>>>
>>> 2. the source format needs to be specified somehow since the ISP can
>>> also do format conversion. So it's output and input at the same time.
>>>
>>> But if we had one video device per ISP, then memory-to-memory operation
>>> would be just one... input or output or what? :)
>>>
>>> Earlier we were thinking of creating one device node for it.
>>
>> This sounds like a codec interface as 'described' here:
>>
>> http://www.xs4all.nl/~hverkuil/spec/v4l2.html#CODEC
>>
>> It would be a first for V4L2 to have a driver that can do this, but I
>> agree
>> that that would be a single device that has both 'output' and 'capture'.
>
> Ok. Although this work most probably will be left for future at this
> point.
>
>>> Currently you can have just one device node using the ISP open.
>>> omap34xxcam_open() calls isp_get() which fails if the ISP use count was
>>> non-zero (means one).
>>>
>>> Or did I misunderstood something?
>>
>> Oh dear. Please don't use 'use counts'. It is perfectly acceptable and
>> desirable to have multiple opens on the same video node. Only one file
>
>> Use counts are really bad and totally unnecessary. Only if another file
>> handle is in streaming mode (and when using VIDIOC_S_PRIORITY) does it
>> make
>> sense to return -EBUSY for certain ioctls or read/write operations.
>> Otherwise you shouldn't limit the user from opening the same device node
>> as
>> many times as he wants and use that to query the video device.
>
> ?
>
> Having a use count doesn't prevent multiple file handles nor otherwise
> artificially limit functionality. We need to be able to shut down the
> slaves when they are no longer needed. IMO having an use count to do
> this is fine (unless otherwise proven).

Yes, it is fine for such purposes. As long as it isn't abused to restrict
functionality on subsequent opens. Several drivers use it for that, and
that is NOT right. But it's OK for powersaving implementations. I should
have mentioned that.

> Also the camera driver does try_module_get() to the slaves when it's
> opened by the first user. module_put() is called on those when the last
> user goes away.

This is to allow those modules to be unloaded?

> We'd also like to get rid of the current way of directly telling the
> slaves what their power state should be. Rather we'd like to tell the
> slaves what's expected from them. This could translate to
> open/release/streamon/streamoff commands. To be able to do this, the use
> count is required --- unless this task is given to the slaves
> (v4l2_subdevs).

Sounds interesting. I would have to see a proposal or proof-of-concept
code to determine how useful it is. It's however better to do this after
the v4l2-subdev conversion.

>> BTW, I looked at omap24xxcam_open(): data like fh->pix does *not* belong
>> to
>> the filehandle struct, it should be part of the top-level data
>> structure.
>
> That's fixed in the omap34xxcam.c. :)

Yay!

>> You want to be able to do simple things like querying a video node for
>> the
>> currently selected format. You can't do that if the format is stored in
>> the
>> filehandle! E.g.: you are streaming and you want to run
>> v4l2-ctl --get-fmt-video to check what video format is being used.
>> Things
>> like this must be supported by a well-written v4l2 driver. Again, sadly
>> quite a few v4l2 drivers do this wrong as well :-(
>>
>> I also see that cam->users is not decreased by one if
>> omap24xxcam_sensor_enable() fails.
>>
>> Note that I'm looking at the code in the v4l-dvb repository, the
>> linux-omap
>> git tree might have fixed that already.
>
> I'm afraid it's still there. Will fix that.

OK.

Thanks,

       Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

