Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:60908 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809Ab0AVQnP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jan 2010 11:43:15 -0500
Message-ID: <4B59D59B.3030504@maxwell.research.nokia.com>
Date: Fri, 22 Jan 2010 18:43:07 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	iivanov@mm-sol.com, gururaj.nagendra@intel.com
Subject: Re: [RFC v2 1/7] V4L: File handles
References: <4B30F713.8070004@maxwell.research.nokia.com> <1261500191-9441-1-git-send-email-sakari.ailus@maxwell.research.nokia.com> <alpine.LNX.2.01.1001181330300.31857@alastor>
In-Reply-To: <alpine.LNX.2.01.1001181330300.31857@alastor>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> Hi Sakari,

Hi Hans!

> I should have reviewed this weeks ago, but better late than never...

No problem, and thanks for the review!

> On Tue, 22 Dec 2009, Sakari Ailus wrote:
> 
>> This patch adds a list of v4l2_fh structures to every video_device.
>> It allows using file handle related information in V4L2. The event
>> interface
>> is one example of such use.
>>
>> Video device drivers should use the v4l2_fh pointer as their
>> file->private_data.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
>> ---
>> drivers/media/video/Makefile   |    2 +-
>> drivers/media/video/v4l2-dev.c |    2 +
>> drivers/media/video/v4l2-fh.c  |   57
>> ++++++++++++++++++++++++++++++++++++++++
>> include/media/v4l2-dev.h       |    4 +++
>> include/media/v4l2-fh.h        |   41 ++++++++++++++++++++++++++++
>> 5 files changed, 105 insertions(+), 1 deletions(-)
>> create mode 100644 drivers/media/video/v4l2-fh.c
>> create mode 100644 include/media/v4l2-fh.h
>>
>> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
>> index a61e3f3..1947146 100644
>> --- a/drivers/media/video/Makefile
>> +++ b/drivers/media/video/Makefile
>> @@ -10,7 +10,7 @@ stkwebcam-objs    :=    stk-webcam.o stk-sensor.o
>>
>> omap2cam-objs    :=    omap24xxcam.o omap24xxcam-dma.o
>>
>> -videodev-objs    :=    v4l2-dev.o v4l2-ioctl.o v4l2-device.o
>> +videodev-objs    :=    v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o
>>
>> # V4L2 core modules
>>
>> diff --git a/drivers/media/video/v4l2-dev.c
>> b/drivers/media/video/v4l2-dev.c
>> index 7090699..15b2ac8 100644
>> --- a/drivers/media/video/v4l2-dev.c
>> +++ b/drivers/media/video/v4l2-dev.c
>> @@ -421,6 +421,8 @@ static int __video_register_device(struct
>> video_device *vdev, int type, int nr,
>>     if (!vdev->release)
>>         return -EINVAL;
>>
>> +    v4l2_fh_init(vdev);
>> +
>>     /* Part 1: check device type */
>>     switch (type) {
>>     case VFL_TYPE_GRABBER:
>> diff --git a/drivers/media/video/v4l2-fh.c
>> b/drivers/media/video/v4l2-fh.c
>> new file mode 100644
>> index 0000000..406e4ac
>> --- /dev/null
>> +++ b/drivers/media/video/v4l2-fh.c
>> @@ -0,0 +1,57 @@
>> +/*
>> + * drivers/media/video/v4l2-fh.c
>> + *
>> + * V4L2 file handles.
>> + *
>> + * Copyright (C) 2009 Nokia Corporation.
>> + *
>> + * Contact: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License
>> + * version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, but
>> + * WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> + * General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
>> + * 02110-1301 USA
>> + */
>> +
>> +#include <media/v4l2-dev.h>
>> +#include <media/v4l2-fh.h>
>> +
>> +#include <linux/sched.h>
>> +#include <linux/vmalloc.h>
> 
> Weird includes. I would expect to see only spinlock.h and list.h to be
> included
> here.

Oops. They're clearly leftovers from somewhere else. Turns out even
those are not needed.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
