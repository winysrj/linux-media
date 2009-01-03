Return-path: <video4linux-list-bounces@redhat.com>
Date: Sat, 3 Jan 2009 14:18:02 -0200 (BRST)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0901031611350.3955@axis700.grange>
Message-ID: <alpine.LRH.2.00.0901031411110.3513@caramujo.chehab.org>
References: <f17812d70901020716n2e6bb9cas2958ea4df2a19af8@mail.gmail.com>
	<Pine.LNX.4.64.0901021625420.4694@axis700.grange>
	<20090103104338.6822c576@pedra.chehab.org>
	<Pine.LNX.4.64.0901031415060.3955@axis700.grange>
	<1230993179.4302.11.camel@palomino.walls.org>
	<Pine.LNX.4.64.0901031611350.3955@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: video4linux-list@redhat.com, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] pxa-camera: fix redefinition warnings and missing DMA
 definitions
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <linux-media.vger.kernel.org>

On Sat, 3 Jan 2009, Guennadi Liakhovetski wrote:

> On Sat, 3 Jan 2009, Andy Walls wrote:
>
>> On Sat, 2009-01-03 at 15:04 +0100, Guennadi Liakhovetski wrote:
>>
>>> Can we pleeeeease somehow consider possibilities to move to a complete
>>> kernel-tree development, or at least allow both. Whereas I personally see
>>> no good way to have both. I really don't understand why you think, that
>>> v4l users are not intelligent enough to compile complete kernel trees.
>>> IMHO it is simpler, than compiling external drivers, but that's subjective
>>> of course.
>>
>> I'd just like to interject that my 53.333 kbps download speed on
>> dial-up, on a good day, makes an initial git clone (or whatever) of 150
>> MB a painful experience.
>
> I think, I can understand you quite well, I only moved to DSL about 3
> years ago, and the first DSL that I had was WLAN to some hot-spot with
> varying quality and availability... But - you don't have to clone kernels
> _often_. As you say, you only have to do this once. And I would make a
> "shallow" clone - you don't need the whole kernel history since the
> introduction of git. And yes, I think, it will make up those 150MB you're
> referring above. And then, after the initial clone you just pull updates,
> which is much less, as you certainly know. So, yes, the initial clone
> would be painful for you, sorry... Is it at least a flat-rate?

Andy, I understand your concerns, but, on the other hand, sometimes I 
loose an entire day going back and forward between -git and -hg, when we 
have more serious conflicts. So, we really need to use a more standard 
approach. This envolves migrating to -git.

This can't happen soon, due to the reasons I've pointed on my previous 
email, but we need to address this during this year.

When we started with -hg, we had about 50-60 patches per kernel window. 
We're now having about 700! Since the changes for problems are 
exponential, as we have more patches, we're now 100x worse than before.

>> Compiling whole kernels: no big deal on a modern machine.
>
> I'm sure also here not everyone will agree. I also only upgraded from my
> Duron 900MHz less than a year ago.

make drivers/media/ allows you to compile just the V4L stuff. With this, 
you can check if your patches are ok against upstream. This is something 
that everyone should do, anyway.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
