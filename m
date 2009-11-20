Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.work.de ([212.12.32.49]:55924 "EHLO smtp.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbZKTLh2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2009 06:37:28 -0500
From: Julian Scheel <julian@jusst.de>
To: Manu Abraham <abraham.manu@gmail.com>
Subject: Re: Details about DVB frontend API
Date: Fri, 20 Nov 2009 12:37:31 +0100
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jean Delvare <khali@linux-fr.org>,
	LMML <linux-media@vger.kernel.org>
References: <20091022211330.6e84c6e7@hyperion.delvare> <4B02FDA4.5030508@infradead.org> <1a297b360911200129pe5af064wf9cf239851ac5c46@mail.gmail.com>
In-Reply-To: <1a297b360911200129pe5af064wf9cf239851ac5c46@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911201237.31537.julian@jusst.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Freitag, 20. November 2009 10:29:34 schrieb Manu Abraham:
> Let me explain a bit. The current issue that persists as Devin explained in
> another email explains things to a certain extend, but still i think it
> might be better to detail further.
> 
> Generally a request can be classified to 3 basic types.
> 
> 1. Request to acquire, retrieve acquisition details
> 2. Get information (device state, device info)
> 3. Get information (channel statistics)
> 
> 
> The first one for example is a request to say tune to a channel, get tuned
> channel details, or even other frontend specific commands such as SEC
> operations. These operations are not very critical with regards on a time
> scale, just that things could be shifted all along on the time scale, the
> worser the implementation, the larger the time "taken to carry around a
> larger set of information to handle the operation". Currently, the V3.x and
> the V5 implementation handles this. The V3 implementation is small and
>  fast, while the V5 implementation is "sluggish".
> 
> 
> The second one gets basic device information. The V3 implementation handled
> this to a certain extend, but the V5 implementation hardly handles this and
> the implementation is rather crude rather than being "sophisticated".
> 
> 
> The third aspect which is basically needed in most cases for debugging the
> channel properties. If all things were ideal, one wouldn't need to know the
> details on what's going on inside. So being in the far from ideal thing,
>  the requisite to know what happens internally is very much a need in all
>  cases. Another point to be noted is that this category of information is
>  very much critical on a timescale as these parameters are valid for a very
>  certain instances of time only. The more this information gets out of
>  sync, the more these values are meaningless. Also another point to be
>  noted is that all these values when read back together at the very same
>  instance only does make sense. It is indeed very hard to achieve this very
>  short timespan between each of the values being monitored. The larger the
>  bandwidth associated, the larger the error introduced in the readback of
>  the values within the same timeframe in between the reads. So the
>  timeframe has to be the very least possible in between this operation to
>  the device driver internals too..
> 
> 
> Although, i have pointed out with this patch what happens at the driver
> level and at the userspace level, There needs additions to the libdvb parts
> to handle whatever conversions from format x to y. This needs to be handled
> since it might not be very easy to be handled consistsently by all
> applications. So in this concept, the application can choose the format
> conversion from the library as well, such that the application can provide
> the statistics in either the the driver native format, or a unified format
> (conversion done by the library) if the user prefers it.
> 
> > We are already redefining some existing ioctls there, so it would be
> > clearer for the userspace developers what would be the new way to
> > retrieve frontend stats, as we can simply say that DVBS2API features
> > superseeds the equivalent DVB v3 ioctls.
> 
> As i have noted above, the statistics related calls have a meaning, if and
> only if it is hanled very fast and properly with no caching. Having a
> genarlized datastructure to handle this event, breaks up the whole meaning
> of having this call itself in this position.
> 
> What an API generally does is to make things generalized. When one makes
> things "the most generalized way" an overhead is also associated with it in
> terms of performance. If things were possible, i would directly read from
> memory from an application from the hardware itself for processing data in
> such a scenario, rather than to make things very generalized. This is an
> area where concepts like data caching can be ruled out completely. We are
> already at a disadvantage with the kernel driver doing a copy_to_user
> itself. Ideally, a memory mapped to userspace would have been the ideal
> thing over here.
> 
> It is just the question of having yet another set of statistics calls that
> handles the information properly or not.

Hi Manu,

thanks for the detailed explanation of your point. Actually I am not 
completely familiar with how the S2API calls are handled internally. Still are 
there any proven measurements about the timeframe the calls are being executed 
within? - I absolutely see that reading signal statistics is a time critical 
process, at least it is important to be able to assign the data to a specific 
moment so it can be interpreted in conjunction with the data which is being 
received in that moment.
If this would be the only point where the delay is important one might be able 
to overcome this by adding timestamps into the retrieved data, although I am 
not sure if this would be feasible at all. Anyway having a very good and low-
delay statistics approach would allow realtime applications like sat-finders 
to be implemented (provided, the hardware delivers good enough data).
This would let me vote for a direct IOCTL approach to gain the best possible 
performance.
Treating signal statistics as a seperate approach from configuring the 
frontend would be tolerable for me, so that it could use a different API-
approach than the tuning, which goes with S2API.

I hope you can follow my thoughts and it might be a bit of help for getting 
this forward.

Best regards,
Julian

