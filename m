Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:55786 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbZBNWd5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Feb 2009 17:33:57 -0500
Date: Sat, 14 Feb 2009 16:44:52 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Hans de Goede <hdegoede@redhat.com>,
	Adam Baker <linux@baker-net.org.uk>,
	linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	Olivier Lorin <o.lorin@laposte.net>
Subject: Re: Adding a control for Sensor Orientation
In-Reply-To: <200902142259.44431.hverkuil@xs4all.nl>
Message-ID: <alpine.LNX.2.00.0902141624410.315@banach.math.auburn.edu>
References: <200902142048.51863.linux@baker-net.org.uk> <49973DDB.7000109@redhat.com> <200902142259.44431.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Sat, 14 Feb 2009, Hans Verkuil wrote:

> On Saturday 14 February 2009 22:55:39 Hans de Goede wrote:
>> Adam Baker wrote:
>>> Hi all,
>>>
>>> Hans Verkuil put forward a convincing argument that sensor orientation
>>> shouldn't be part of the buffer flags as then it would be unavailable
>>> to clients that use read()
>>
>> Yes and this is a bogus argument, clients using read also do not get
>> things like timestamps, and vital information like which field is in the
>> read buffer when dealing with interleaved sources. read() is a simple
>> interface for simple applications. Given that the only user of these
>> flags will likely be libv4l I *strongly* object to having this info in
>> some control, it is not a control, it is a per frame (on some cams)
>> information about how to interpret that frame, the buffer flags is a very
>> logical place, *the* logical place even for this!
>>
>> The fact that there is no way to transport metadata about a frame like
>> flags, but also timestamp and field! Is a problem with the read interface
>> in general, iow read() is broken wrt to this. If people care add some
>> ioctl or something which users of read() can use to get the buffer
>> metadata from the last read() buffer, stuffing buffer metadata in a
>> control (barf), because of read() brokenness is a very *bad* idea, and
>> won't work in general due to synchronization problems.
>>
>> Doing this as a control will be a pain to implement both at the driver
>> level, see the discussion this is causing, and in libv4l. For libv4l this
>> will basicly mean polling the control. And hello polling is lame and
>> something from the 1980-ies.
>>
>> Please just make this a buffer flag.
>
> OK, make it a buffer flag. I've got to agree that it makes more sense to do
> it that way.
>
> Regards,
>
> 	Hans
>
> -- 
> Hans Verkuil - video4linux developer - sponsored by TANDBERG
>

Let me take a moment to remind everyone what the problem is that brought 
this discussion up. Adam Baker and I are working on a driver for a certain 
camera. Or, better stated, for a set of various cameras, which all have 
the same USB Vendor:Product number. Various cameras which all have this ID 
have different capabilities and need different treatment of the frame 
data.

The most particular problem is that some of the cameras require byte 
reversal of the frame data string, which would rotate the image 180 
degrees around its center. Others of these cameras require reversal of the 
horizontal lines in the image (vertical 180 degree rotation of the image 
across a horizontal axis).

The point is, one can not tell from the Vendor:Product number which of 
these actions is required. However, one *is* able to tell immediately 
after the camera is initialized, which of these actions is required. 
Namely, one reads and parses the response to the first USB command sent to 
the camera.

So, for us (Adam and me) the question is simply to know how everyone will 
agree that the information about the image orientation can be sent from 
the module to V4L. When this issue is resolved, we can finish writing the 
sq905 camera driver. From this rather narrow point of view, the issue is 
not which method ought to be adopted. Rather, the issue is that no method 
has been adopted. It is rather difficult to write module code which will 
obey a non-existent standard.

Theodore Kilgore

