Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60966 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbZBYAyo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2009 19:54:44 -0500
Date: Tue, 24 Feb 2009 21:53:55 -0300 (BRT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: kilgota@banach.math.auburn.edu
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Adam Baker <linux@baker-net.org.uk>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	Olivier Lorin <o.lorin@laposte.net>,
	Trent Piepho <xyzzy@speakeasy.org>, linux-omap@vger.kernel.org
Subject: Re: [RFC] How to pass camera Orientation to userspace
In-Reply-To: <alpine.LNX.2.00.0902241449020.15189@banach.math.auburn.edu>
Message-ID: <alpine.LRH.2.00.0902242153490.6831@pedra.chehab.org>
References: <200902180030.52729.linux@baker-net.org.uk> <200902211253.58061.hverkuil@xs4all.nl> <20090223080715.0c97774e@pedra.chehab.org> <200902232237.32362.linux@baker-net.org.uk> <alpine.LNX.2.00.0902231730410.13397@banach.math.auburn.edu>
 <alpine.LRH.2.00.0902241723090.6831@pedra.chehab.org> <alpine.LNX.2.00.0902241449020.15189@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 24 Feb 2009, kilgota@banach.math.auburn.edu wrote:

>
>
> On Tue, 24 Feb 2009, Mauro Carvalho Chehab wrote:
>
>>  On Mon, 23 Feb 2009, kilgota@banach.math.auburn.edu wrote:
>
>
> <big snip>
>
>
>>  Theodore,
>>
>>  You're considering just one subset of the V4L usages: notebook webcams.
>
> Actually, the sq905 cameras are not "notebook webcams." They are cheap, 
> consumer entry level dual-mode cameras. They can be used as hand-held still 
> cameras, to shoot still photos, and they can also be used as webcams. When 
> sold, they usually came with some kind of mounting device that could hold 
> them rigidly for webcam use. There are lots of similar cameras. Mercifully, 
> not all of those others have the problems of the sq905, which have led to 
> the present impasse.
>
>
> If
>>  you think about non-notebook webcams [1] or about security cams, you'll
>>  see that the only way for you to have the flipping information is inside
>>  some userspace file.
>
> However, there are obvious differences. For those cameras the question might 
> well come up about how to control the movement of the camera, or, at least, 
> to be aware of which way the camera is pointing. For these, the topic is an 
> inherent property of the particular model of the camera -- or a defect, if 
> someone wants to say so. Since the property is not determined by USB number, 
> it is inherently impossible outside of the module to create a table which 
> contains the needed information.
>
> My intention here was to re-focus attention on the original problem which 
> brought up the current discussion, and to that end the problem must be 
> clearly understood. To have the flipping information inside some userspace 
> file might solve some other problem and may be a generally very good idea. 
> But it will not, can not, and never will be able to solve this problem.
>
>>
>>  For example, I have here one video input bttv board with 16 cameras,
>>  connected on 4 bttv chips. I have also a Pelco camera, that has just one
>>  support socket. Depending on the place you mount it, the camera has to be
>>  rotated by 180 degrees. It can also be useful to mount it rotated by 90
>>  degrees.
>
> Good. So one needs external controls and userspace tools. Did I ever say 
> that such things should never be done? No. All I said was that there is a 
> problem, presently on the table, and those kinds of things are not, can not 
> be, never were, and never will be solutions for _this_ problem.
>
>>
>>  After mounting the cameras, no matter what apps you are using (a
>>  streaming video app to broadcast it via internet, a security app, etc),
>>  the rotation
>>  information for that input, on that particular PCI, bus won't change.
>>
>>  As we've standardized the VIDIOC_QUERYCAP bus_info, now, the information
>>  for the camera at input 3 of bttv hardware at PCI addres 03:00.3 is
>>  unique. It is also unique the same information for a notebook mounted
>>  webcam (since the USB bus ID won't change for that devices).
>
> Errrm... Again, the cameras in question here are not notebook mounted 
> webcams.
>
>>
>>  So, if we standardize where this information is stored, for example, at
>>  /etc/libv4l and/or at ~/.libv4lrc, and let libv4l handle such info, this
>>  will be something consistent for all applications using libv4l. Other
>>  apps that might not want to trust on libv4l can also read the info at the
>>  same file.
>
> Sorry, this will not work here. It may solve some other problem, but not 
> this problem. Or, if one wants to "store" the information there, I don't 
> care, really, but then there needs to be a way to get the information from 
> the module, where it is, and get written into said table, which is where you 
> want it, and this needs to happen every time an sq905 camera gets plugged in 
> -- without pestering the user about the matter every time that such a camera 
> gets hooked up.
>
> Comparison: I have tossed a coin. Is it going to come up heads? Or tails? It 
> is possible to know which, because the coin has been tossed. It would not 
> even be cheating to look at it, or allow someone who did look at it, to pass 
> to us the information. But we are not going to look, and if someone tells us 
> we will not listen because we have not agreed on what language to use for 
> communication. Instead, we will put a guess about the outcome into a table. 
> We will make it a nice table, which can be revised using nice GUI tools, so 
> it is easy for the user. So if our guess is wrong let the user fix it. Then 
> next time we toss the coin the table entry will be right because either it 
> was right before, or now someone fixed it???
>
>>
>>  So, I really think that this should be part of the approach.
>
> I was not even addressing what should or should not be part of the approach 
> to some other problems. My point was that such discussion is not germane to 
> the problem of how to pass on the correct orientation of the sensor, for the 
> sq905 cameras. There are lots of other problems out there to solve. No 
> denying that.
>
> Also an overview is often very helpful. Also trying to visualize what might 
> be needed in the future is helpful. All of this can be extremely helpful. 
> But not everyone can see or imagine every possible thing. For example, it 
> seems that some of the best minds in the business are stunned when 
> confronted with the fact that some manufacturer of cheap electronics in 
> Taiwan has produced a lot of mass-market cameras with the sensors turned 
> upside down, along with some other cameras having the same USB ID with 
> different sensors, which act a bit differently. Clearly, if such a thing 
> happened once it can happen again. So how to deal with such a
> problem? Something similar or worse will surely come up again.
>
>>
>>  I agree that we should have a way to get a hint about a camera rotation,
>>  if this is somehow provided by reading at the hardware.
>>
>>  [1] Normal webcams can be mounted on some hardware and have some
>>  orientations that would be different than expected. I've seen this before
>>  on some PC-based harware where the camera is enclosed inside the clause,
>>  like on Automatic Transfer Machines. Also, the user may want to use the
>>  camera on an inverted position, to make easy to fix it somewhere.
>
> Again, these are in fact separate issues. The fundamental issue required for 
> supporting the sq905 cameras is that an agreed-upon method must exist by 
> which precisely two pieces of information can be passed along by the module. 
> Which of the two pieces of information is relevant and needs to be sent 
> along is, alas, only known from within the module. That is the backdrop for 
> the entire discussion. As far as I know, this thread would not exist if that 
> need had not come up. These two pieces of information are, precisely, "frame 
> data requires flipping across a horizontal axis unless camera is upside 
> down" and "frame data requires flipping across a vertical axis unless camera 
> is held up to a mirror"
>
> So, what do these two deep questions, which confound the assembled wisdom of 
> an entire list of Linux video developers, have to do with tables in 
> userspace? None that I can see, unless someone wants to provide a mechanism 
> for the information, having been collected in the module, to be available to 
> the table in userspace.

I'm not saying that userspace tables would solve all problems. I'm just 
saying that this should be part of the solution.

For sure we need to have a way for retrieving this information for devices 
like the sq905 cameras, where the information can't be currently be 
determined by userspace.

In the case of sq905, this information is static, right? If so, IMO, the 
better approach is to use a flag at the v4l2_input, as already discussed 
in this thread.

-- 
Cheers,
Mauro Carvalho Chehab
http://linuxtv.org
mchehab@infradead.org
