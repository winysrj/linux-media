Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:36401 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbZBDWTZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Feb 2009 17:19:25 -0500
Date: Wed, 4 Feb 2009 16:31:15 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Adam Baker <linux@baker-net.org.uk>
cc: Andy Walls <awalls@radix.net>,
	Jean-Francois Moine <moinejf@free.fr>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] Add support for sq905 based cameras to gspca
In-Reply-To: <200902042138.05028.linux@baker-net.org.uk>
Message-ID: <alpine.LNX.2.00.0902041610030.3988@banach.math.auburn.edu>
References: <200901192322.33362.linux@baker-net.org.uk> <200902032209.44133.linux@baker-net.org.uk> <1233714808.3086.57.camel@palomino.walls.org> <200902042138.05028.linux@baker-net.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Wed, 4 Feb 2009, Adam Baker wrote:

> On Wednesday 04 February 2009, Andy Walls wrote:
>> On Tue, 2009-02-03 at 22:09 +0000, Adam Baker wrote:
>>> On Tuesday 03 February 2009, Jean-Francois Moine wrote:
>>>> Indeed, the problem is there! You must have only one process reading
>>>> the webcam! I do not see how this can work with these 2 processes...
>>>
>>> Although 2 processes are created only one ever gets used.
>>> create_singlethread_workqueue would therefore be less wasteful but make
>>> no other difference.
>>
>> This is generally not the case.  There is a single workqueue as far as a
>> driver is concerned.  Work items submitted to the queue by the driver
>> are set to be processed by the same CPU submitting the work item (unless
>> you call queue_work_on() to specify the CPU).  However, there is no
>> guarantee that the same CPU will be submitting work requests to the
>> workqueue every time.
>>
>> For most drivers this is a moot point though, because they only ever
>> instantiate and submit one work object ever per device.  This means the
>> workqueue depth never exceeds 1 for most drivers.  So the correct
>> statement would be, I believe, "only one sq905 worker thread ever gets
>> used (per device per capture) at a time in sq905.c"
>
> Yes, I did mean only one gets used in the case of sq905.c (because the queue
> is created per capture and only one item gets submitted to it).
>
> <snip>
>>
>> I did look at the patch as submitted on Jan 19, and do have what I
>> intend to be constructive criticisms (sorry if they're overcome by
>> events by now):
>>
>> Creating and destroying the worker thread(s) at the start and stop of
>> each capture is a bit overkill.  It's akin to registering and
>> unregistering a device's interrupt handler before and after every
>> capture, but it's a bit worse overhead-wise.  It's probably better to
>> just instantiate the workqueue when the device "appears" (I'm not a USB
>> guy so insert appropraite term there) and destroy the workqueue and
>> worker threads(s) when the device is going to "disappear".  Or if it
>> will meet your performance requirements, create and destroy the
>> workqueue when you init and remove the module.  The workqueue and its
>> thread(s) are essentially the bottom half of your interrupt handler to
>> handle deferrable work - no point in killing them off until you really
>> don't need them anymore.
>>
>
> My thought was that the camera was likely to remain plugged in even if it
> wasn't being used so it was best to clean up as much as possible when it
> wasn't in use. I don't really know how the overheads of creating a workqueue
> when you do need it compares to leaving an unused one around sitting on the
> not ready queue in the process table but starting a capture is going to take
> many ms just for the USB traffic so a little extra overhead doesn't seem too
> worrying.
>
>> Also, you've created the workqueue threads with a non-unique name: the
>> expansion of MODULE_NAME.  You're basically saying that you only need
>> one workqueue, with it's per CPU thread(s), for all instantiations of an
>> sq905 device - which *can* be a valid design choice.  However, you're
>> bringing them up and tearing them down on a per capture basis.  That's a
>> problem that needs to be corrected if you intend to support multiple
>> sq905 devices on a single machine.  What happens when you attempt to
>> have two sq905 devices do simultaneous captures?  I don't know myself;
>> I've never tried to create 2 separate instantiations of a workqueue
>> object with the same name.
>>
>
> I see multiple instance of [pdflush] and [nfsd] which seem to work fine so I
> believe the name doesn't need to be unique, just a guide to the user of what
> is eating CPU time. I don't have 2 sq905 cameras to test it ...

Well, I do. Here is what happens:

1. Plugged in one of them, started the streaming.

2. Plugged in the second one. First one continues to stream, no problem. 
Attempt to start a stream from the second camera while the first one is 
streaming results in the error message,

VIDIOC_REQBUFS error 16, Device or resource busy

and the command line reappears. No obvious interference with the stream 
from the first camera is apparent.

3. After the stream from the first camera is closed, the streaming can be 
started again. However, the stream is again from the first camera which 
was plugged in.

4. After removing the first camera which was plugged in, I tried to start 
the stream from the second one. The stream will not start. A message says 
that

Cannot identify 'dev/video0': 2. No such file or directory.

5. Second camera left attached, first camera plugged in again. The first 
camera can stream again. The second one can not.

6. When the first camera is removed and the second one is then re-plugged, 
the second one will stream.

So, we can safely conclude that, as the module is presently constituted, 
there can be only one stream at a time. The second camera plugged in 
cannot stream. Neither can it conflict with the first one. The only thing 
which puzzles me a little bit is item 5. Apparently, the question is about 
which port the camera was connected to. So let's try three cameras. I will 
hook up camera number one, get a stream, close it, hook up number two 
through a different port, then remove number one and replace it with 
number three on the same port where number one was. What I suspected would 
happen is what happened. Number two would not stream. Number three would 
stream just as number one did. In other words, this was determined by 
which port was in use for number one, which is now also in use for number 
three.

So, now we know what happens.

Theodore Kilgore
