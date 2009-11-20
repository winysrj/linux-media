Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.work.de ([212.12.32.49]:47724 "EHLO smtp.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313AbZKTXkz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2009 18:40:55 -0500
Message-ID: <4B07290B.4060307@jusst.de>
Date: Sat, 21 Nov 2009 00:40:59 +0100
From: Julian Scheel <julian@jusst.de>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jean Delvare <khali@linux-fr.org>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: Details about DVB frontend API
References: <20091022211330.6e84c6e7@hyperion.delvare>	 <4B02FDA4.5030508@infradead.org>	 <1a297b360911200129pe5af064wf9cf239851ac5c46@mail.gmail.com>	 <200911201237.31537.julian@jusst.de> <1a297b360911200808k12676112lf7a11f3dfd44a187@mail.gmail.com>
In-Reply-To: <1a297b360911200808k12676112lf7a11f3dfd44a187@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Manu Abraham schrieb
> Not only is it time critical, but it should also be "atomic", ie it
> should be all in one go, ie one single snapshot of an event, not
> events bunched together serially. Things wont seem that "atomic" on a
> system with a large load. Latency will have a significant effect on
> the statistics (values) read back, since it is again disjoint events.
>   
Right, the values should be treatened as a unique unit...
> Time stamping would be helpful, prior to any processing by the library
> such that the time overhead for the calculations is offset, but that
> can be really useful within the same library alone. I can't imagine
> how time stamping can be helpful to result a low latency.
>   

No, timestamping would of course not be helpful for reducing the 
latency, it would just allow to correctly interpret values if they are 
delayed. So that you won't assume the values you receive can be taken as 
proven for the current moment.

> If you don't have a low latency, Consider this (even when you are able
> to ignore the statistics for any general processing, on the thought
> that "i can always live with those errors and i always had"):
>
> The error fedback into the loop for a sat positioner/rotor. The final
> calculated position will never be the actual position that you wanted
> the antenna to be at a certain location. The problem would be made
> worser by the different rotor speeds as well, to add to the nightmare.
>
> With the V5 operation, you bunch operations together in a serial
> manner, it is atomic to the sense that it happens or doesn't happen,
> but it is not atomic to the sense of any particular time frame. You
> just keep your fingers crossed that the CPU executes the event in the
> shortest frame. This won't hold good in all cases when there is a high
> latency on the system when there is a significant load.
>
> eg: You can imagine an IPTV headend streaming data, with a small CPU
> with multiple tuners and trying to compensate the offset that's
> introduced.
>
> Still worser situation: imagine a gyro stabilized setup, where the
> base itself is not that stationary.
>   

Ok, thanks for the details about how V5 API deals with this. Indeed this 
is a major issue one has to think of when talking about signal statistics.

> Some other points to be considered:
> * As of now, the get/set interface is not used for any signal statistics
>
> * Even if one prefers to normalize all parameters into one single
> standard, even then you wouldn't land with a get/set interface.
>
> * The generic get/set interface is good when you have an unknown set
> of parameters, such that one can keep adding in parameters.  Eg: most
> people favoured this approach when we had a larger set of modulations/
> error correction and other parameters.
>
> For the case what we have currently, we do not have such a varied set
> of parameters to consider.

Right, the situation about the parameters which will be requested in 
terms of signal statistics should not change for future frontend types, 
so it really should be a save approach to have a static API here. I have 
not yet done a very detailed look into your proposed patch, but I will 
do so tomorrow.
I really would like to see a reliable statistics API in v4l-dvb soon.

Regards,
Julian
