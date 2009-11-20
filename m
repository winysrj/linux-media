Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:58256 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887AbZKTQIr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2009 11:08:47 -0500
Received: by fxm21 with SMTP id 21so3836940fxm.21
        for <linux-media@vger.kernel.org>; Fri, 20 Nov 2009 08:08:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200911201237.31537.julian@jusst.de>
References: <20091022211330.6e84c6e7@hyperion.delvare>
	 <4B02FDA4.5030508@infradead.org>
	 <1a297b360911200129pe5af064wf9cf239851ac5c46@mail.gmail.com>
	 <200911201237.31537.julian@jusst.de>
Date: Fri, 20 Nov 2009 20:08:52 +0400
Message-ID: <1a297b360911200808k12676112lf7a11f3dfd44a187@mail.gmail.com>
Subject: Re: Details about DVB frontend API
From: Manu Abraham <abraham.manu@gmail.com>
To: Julian Scheel <julian@jusst.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jean Delvare <khali@linux-fr.org>,
	LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 20, 2009 at 3:37 PM, Julian Scheel <julian@jusst.de> wrote:
> Am Freitag, 20. November 2009 10:29:34 schrieb Manu Abraham:
>> Let me explain a bit. The current issue that persists as Devin explained in
>> another email explains things to a certain extend, but still i think it
>> might be better to detail further.
>>
>> Generally a request can be classified to 3 basic types.
>>
>> 1. Request to acquire, retrieve acquisition details
>> 2. Get information (device state, device info)
>> 3. Get information (channel statistics)
>>
>>
>> The first one for example is a request to say tune to a channel, get tuned
>> channel details, or even other frontend specific commands such as SEC
>> operations. These operations are not very critical with regards on a time
>> scale, just that things could be shifted all along on the time scale, the
>> worser the implementation, the larger the time "taken to carry around a
>> larger set of information to handle the operation". Currently, the V3.x and
>> the V5 implementation handles this. The V3 implementation is small and
>>  fast, while the V5 implementation is "sluggish".
>>
>>
>> The second one gets basic device information. The V3 implementation handled
>> this to a certain extend, but the V5 implementation hardly handles this and
>> the implementation is rather crude rather than being "sophisticated".
>>
>>
>> The third aspect which is basically needed in most cases for debugging the
>> channel properties. If all things were ideal, one wouldn't need to know the
>> details on what's going on inside. So being in the far from ideal thing,
>>  the requisite to know what happens internally is very much a need in all
>>  cases. Another point to be noted is that this category of information is
>>  very much critical on a timescale as these parameters are valid for a very
>>  certain instances of time only. The more this information gets out of
>>  sync, the more these values are meaningless. Also another point to be
>>  noted is that all these values when read back together at the very same
>>  instance only does make sense. It is indeed very hard to achieve this very
>>  short timespan between each of the values being monitored. The larger the
>>  bandwidth associated, the larger the error introduced in the readback of
>>  the values within the same timeframe in between the reads. So the
>>  timeframe has to be the very least possible in between this operation to
>>  the device driver internals too..
>>
>>
>> Although, i have pointed out with this patch what happens at the driver
>> level and at the userspace level, There needs additions to the libdvb parts
>> to handle whatever conversions from format x to y. This needs to be handled
>> since it might not be very easy to be handled consistsently by all
>> applications. So in this concept, the application can choose the format
>> conversion from the library as well, such that the application can provide
>> the statistics in either the the driver native format, or a unified format
>> (conversion done by the library) if the user prefers it.
>>
>> > We are already redefining some existing ioctls there, so it would be
>> > clearer for the userspace developers what would be the new way to
>> > retrieve frontend stats, as we can simply say that DVBS2API features
>> > superseeds the equivalent DVB v3 ioctls.
>>
>> As i have noted above, the statistics related calls have a meaning, if and
>> only if it is hanled very fast and properly with no caching. Having a
>> genarlized datastructure to handle this event, breaks up the whole meaning
>> of having this call itself in this position.
>>
>> What an API generally does is to make things generalized. When one makes
>> things "the most generalized way" an overhead is also associated with it in
>> terms of performance. If things were possible, i would directly read from
>> memory from an application from the hardware itself for processing data in
>> such a scenario, rather than to make things very generalized. This is an
>> area where concepts like data caching can be ruled out completely. We are
>> already at a disadvantage with the kernel driver doing a copy_to_user
>> itself. Ideally, a memory mapped to userspace would have been the ideal
>> thing over here.
>>
>> It is just the question of having yet another set of statistics calls that
>> handles the information properly or not.
>
> Hi Manu,
>
> thanks for the detailed explanation of your point. Actually I am not
> completely familiar with how the S2API calls are handled internally. Still are
> there any proven measurements about the timeframe the calls are being executed
> within? - I absolutely see that reading signal statistics is a time critical
> process, at least it is important to be able to assign the data to a specific
> moment so it can be interpreted in conjunction with the data which is being
> received in that moment.


Not only is it time critical, but it should also be "atomic", ie it
should be all in one go, ie one single snapshot of an event, not
events bunched together serially. Things wont seem that "atomic" on a
system with a large load. Latency will have a significant effect on
the statistics (values) read back, since it is again disjoint events.


> If this would be the only point where the delay is important one might be able
> to overcome this by adding timestamps into the retrieved data, although I am
> not sure if this would be feasible at all. Anyway having a very good and low-
> delay statistics approach would allow realtime applications like sat-finders
> to be implemented (provided, the hardware delivers good enough data).
> This would let me vote for a direct IOCTL approach to gain the best possible
> performance.

Time stamping would be helpful, prior to any processing by the library
such that the time overhead for the calculations is offset, but that
can be really useful within the same library alone. I can't imagine
how time stamping can be helpful to result a low latency.

If you don't have a low latency, Consider this (even when you are able
to ignore the statistics for any general processing, on the thought
that "i can always live with those errors and i always had"):

The error fedback into the loop for a sat positioner/rotor. The final
calculated position will never be the actual position that you wanted
the antenna to be at a certain location. The problem would be made
worser by the different rotor speeds as well, to add to the nightmare.

With the V5 operation, you bunch operations together in a serial
manner, it is atomic to the sense that it happens or doesn't happen,
but it is not atomic to the sense of any particular time frame. You
just keep your fingers crossed that the CPU executes the event in the
shortest frame. This won't hold good in all cases when there is a high
latency on the system when there is a significant load.

eg: You can imagine an IPTV headend streaming data, with a small CPU
with multiple tuners and trying to compensate the offset that's
introduced.

Still worser situation: imagine a gyro stabilized setup, where the
base itself is not that stationary.


> Treating signal statistics as a seperate approach from configuring the
> frontend would be tolerable for me, so that it could use a different API-
> approach than the tuning, which goes with S2API.

Some other points to be considered:

* As of now, the get/set interface is not used for any signal statistics

* Even if one prefers to normalize all parameters into one single
standard, even then you wouldn't land with a get/set interface.

* The generic get/set interface is good when you have an unknown set
of parameters, such that one can keep adding in parameters.  Eg: most
people favoured this approach when we had a larger set of modulations/
error correction and other parameters.

For the case what we have currently, we do not have such a varied set
of parameters to consider.


Regards,
Manu
