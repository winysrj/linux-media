Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:32078 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbZCJMPG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2009 08:15:06 -0400
Message-ID: <49B659BC.7090409@maxwell.research.nokia.com>
Date: Tue, 10 Mar 2009 14:14:52 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	"DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Toivonen Tuukka.O (Nokia-D/Oulu)" <tuukka.o.toivonen@nokia.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [REVIEW PATCH 11/14] OMAP34XXCAM: Add driver
References: <A24693684029E5489D1D202277BE89442E296E09@dlee02.ent.ti.com> <200903042344.32820.hverkuil@xs4all.nl> <49B031D6.1070203@maxwell.research.nokia.com> <200903052224.03015.hverkuil@xs4all.nl>
In-Reply-To: <200903052224.03015.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
>> Sergio has posted earlier a patchset containing a driver for using the
>> ISP to process images from memory to memory. The ISP driver is used
>> roughly the same way as with the omap34xxcam and real sensors. The
>> interface towards the userspace offered by the driver, however, is
>> different, you probably saw it (preview and resizer wrappers).
>>
>> My opinion has been that the memory-to-memory operation of the ISP
>> should also offer V4L2 interface. V4L2, however, doesn't support such
>> devices at the moment. The only differences that I can see is that
>>
>> 1. the input is a video buffer instead of sensor and
>>
>> 2. the source format needs to be specified somehow since the ISP can
>> also do format conversion. So it's output and input at the same time.
>>
>> But if we had one video device per ISP, then memory-to-memory operation
>> would be just one... input or output or what? :)
>>
>> Earlier we were thinking of creating one device node for it.
> 
> This sounds like a codec interface as 'described' here:
> 
> http://www.xs4all.nl/~hverkuil/spec/v4l2.html#CODEC
> 
> It would be a first for V4L2 to have a driver that can do this, but I agree 
> that that would be a single device that has both 'output' and 'capture'.

Ok. Although this work most probably will be left for future at this point.

>> Currently you can have just one device node using the ISP open.
>> omap34xxcam_open() calls isp_get() which fails if the ISP use count was
>> non-zero (means one).
>>
>> Or did I misunderstood something?
> 
> Oh dear. Please don't use 'use counts'. It is perfectly acceptable and 
> desirable to have multiple opens on the same video node. Only one file 

> Use counts are really bad and totally unnecessary. Only if another file 
> handle is in streaming mode (and when using VIDIOC_S_PRIORITY) does it make 
> sense to return -EBUSY for certain ioctls or read/write operations. 
> Otherwise you shouldn't limit the user from opening the same device node as 
> many times as he wants and use that to query the video device.

?

Having a use count doesn't prevent multiple file handles nor otherwise 
artificially limit functionality. We need to be able to shut down the 
slaves when they are no longer needed. IMO having an use count to do 
this is fine (unless otherwise proven).

Also the camera driver does try_module_get() to the slaves when it's 
opened by the first user. module_put() is called on those when the last 
user goes away.

We'd also like to get rid of the current way of directly telling the 
slaves what their power state should be. Rather we'd like to tell the 
slaves what's expected from them. This could translate to 
open/release/streamon/streamoff commands. To be able to do this, the use 
count is required --- unless this task is given to the slaves 
(v4l2_subdevs).

> BTW, I looked at omap24xxcam_open(): data like fh->pix does *not* belong to 
> the filehandle struct, it should be part of the top-level data structure. 

That's fixed in the omap34xxcam.c. :)

> You want to be able to do simple things like querying a video node for the 
> currently selected format. You can't do that if the format is stored in the 
> filehandle! E.g.: you are streaming and you want to run 
> v4l2-ctl --get-fmt-video to check what video format is being used. Things 
> like this must be supported by a well-written v4l2 driver. Again, sadly 
> quite a few v4l2 drivers do this wrong as well :-(
> 
> I also see that cam->users is not decreased by one if 
> omap24xxcam_sensor_enable() fails.
> 
> Note that I'm looking at the code in the v4l-dvb repository, the linux-omap 
> git tree might have fixed that already.

I'm afraid it's still there. Will fix that.

Thanks.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com

