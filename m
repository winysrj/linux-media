Return-path: <mchehab@gaivota>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:23602 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756436Ab0LSV7v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Dec 2010 16:59:51 -0500
Subject: Re: Power frequency detection.
From: Andy Walls <awalls@md.metrocast.net>
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Cc: Paulo Assis <pj.assis@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1012191423030.23950@banach.math.auburn.edu>
References: <73wo0g3yy30clob2isac30vm.1292782894810@email.android.com>
	 <alpine.LNX.2.00.1012191423030.23950@banach.math.auburn.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Dec 2010 17:00:33 -0500
Message-ID: <1292796033.2052.111.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Sun, 2010-12-19 at 14:51 -0600, Theodore Kilgore wrote:
> 
> On Sun, 19 Dec 2010, Andy Walls wrote:
> 
> > Theodore,
> > 
> > Aside from detect measurment of the power line, isn't a camera the best sort of sensor for this measurment anyway?
> > 
> > Just compute the average image luminosity over several frames and look for (10 Hz ?) periodic variation (beats), indicating a mismatch.
> > 
> > Sure you could just ask the user, but where's the challenge in that. ;)
> > 
> > Regards,
> > Andy
> 
> Well, if it is "established policy" to go with doing this as a control, I 
> guess we can just go ahead instead of doing something fancy.

My policy is let computers do what computers do well, and let people do
what people do well.  Looking at an image, recognizing flicker, and
twiddling knobs to make it go away (to one's own satisfaction) is much
better left to a person for one time adjustments.



> But it is nice to hear from you. Here is why.
> 
> The camera in question is another jeilinj camera. Its OEM software for 
> that other OS does present the option to choose line frequency. It also 
> asks for the user to specify an image quality index. I can not recall that 
> the software I got with my camera did any such thing. As I recall, it 
> merely let the camera to start streaming. Bur at the moment I have no idea 
> where I put that old CD.

The Software for our Sakar branded Jeilin camera was a little smarter.
I seem to recall image size adjustments.  I also recall the driver
binary contained multiple different MJPEG headers that I guess it could
have tack back on to the incoming stream.

However, the camera suffered such love/abuse at the hands of my 11 year
old daughter that it no longer functions, even with the electrical tape
that still holds the case together. ;)


> So, while I have you on the line, do you recall whether or not the OEM 
> software for the camera you bought for your daughter present any such 
> setup options?

I cannot.


> The new camera may be different in some particulars from the ones we have. 
> It does have a new Product number, so apparently Jeilin might not have 
> thought it is identical to the other ones. It does use a slightly 
> different initialization sequence. Therefore, the quick-and-dirty way to 
> support it would be just to introduce a patch which has switch statements 
> or conditionals all over the place, and just to support whatever the 
> camera was observed to do. However, that is obviously dirty as well as 
> quick.
> 
> While playing around with the code a bit, I have managed to make my 
> old camera work with essentially the same init sequence that the new 
> one is using. If this can be done right, it would clear a lot of crud out 
> of the driver code. Unfortunately, doing it right involves testing...

When researching Jeilin's offerings on their website long ago I recall a
few different chipsets, but only one that matched the MJPEG type camera
application.  It's probably just the difference between different
firmware versions in the camera with the same Jeilin camera chipset.


> Finally, one concern that I have in the back of my mind is the question of 
> control settings for a camera which streams in bulk mode and requires the 
> setup of a workqueue. The owner of the camera says that he has 
> "encountered no problems" with running the two controls mentioned above. 
> Clearly, that is not a complete answer which overcomes all possible 
> objections. Rather, things are OK if and only if we can ensure that these 
> controls can be run only while the workqueue that does the streaming is 
> inactive. Somehow, I suspect that the fact that a sensible user would only 
> run such commands at camera setup is an insufficient guarantee that no 
> problems will ever be encountered.
> 
> So, as I said, the question of interaction of a control and a workqueue is 
> another problem interesting little problem. Your thoughts on this 
> interesting little problem would be appreciated.

I am unfamiliar with:

1. Any USB interface mutual exclusions the kernel USB API and subsystem
provides as well as what the GSPCA framework provides.

2. Any USB transaction buffering and tracking the kernel USB subsystem
provides.

3. Whether the kernel and Jeilin chip allow USB sends and receives to be
interleaved to different bulk endpoints.




So I might not be able to provide too much help.  I have 2 ideas for you
coming from the perspective of me being a USB idiot:


1. Since the jlj_dostream() work handler function is essentially just a
synchronous poll loop on the device, you could just have it process the
ioctl() requests to change a control synchronously. 

a. The ioctl() call for the v4l2 control would submit a command to some
queue you set up for the purpose, and then sleep on a wait queue. 

b. The jlj_dostream() function would check the command queue at its
convenience, process any control command, and then wake up the wait
queue that the ioctl() is waiting on.

For this idea, don't forget to implement the command queue with proper
locking or other mutual exclusion.  You'll also need to think about how
to place ioctl() callers on the wait_queue and how to wake them up in
FIFO order, if you use this idea and allow multiple v4l2 control ioctl()
to be queued.



2. Restructure the workqueue function, jlj_dostream(), to handle a work
object in one pass (e.g. no loop to read more than one frame), handle
two different types of work objects (one for stream polling and one for
control ioctl() requests), and have it automatically reschedule the
stream polling work object.

a. When streaming, the current, single work object would still be used
and jlj_dostream() must be able to check that the work object is the one
indicating streaming work.  jlj_dostream() would only perform work
required to read one whole frame, unless you want to get fancy and deal
with partial frames.  The jlj_dostream() handler would then reschedule
the work object for streaming - maybe with a sensible delay.

b. For a V4L2 control ioctl() that needs to send a command to the
device, the ioctl() fills out the needed parameters in a scratch-pad
location and queues a different work object, associated with those
scratchpad parameters.  The ioctl() then sleeps on a wait queue
associated with that work object.  When the work handler function,
jlj_dostream(), gets called it must be able to determine the work object
is the one associated with an ioctl() control.  jlj_dostream() then
performs the actions required for the ioctl() and the wakes up the
wait_queue on which the ioctl() is waiting.  The work object is not
rescheduled by the work handler function.


For this idea, you'll be relying on the single-threaded workqueue to
provide mutual exclusion between processing of the two different types
of work objects (streaming and v4l2 control ioctl).  You can structure
things to have more than 1 work object for V4L2 control ioctl()
processing, if you like, since the workqueue can queue any number of
work objects.  But if you allow more than one ioctl() related work
object to be queued, you'll have to be careful about how things are
placed on the wait_queue and how they are awakened.



> As I said, Merry Christmas :-)


Merry Christmas.

Regards,
Andy

> Theodore Kilgore


