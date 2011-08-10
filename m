Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108Ab1HJMwu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Aug 2011 08:52:50 -0400
Message-ID: <4E427F0F.7000902@redhat.com>
Date: Wed, 10 Aug 2011 09:52:31 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	hverkuil@xs4all.nl
Subject: Re: [GIT PATCHES FOR 3.1] s5p-fimc and noon010pc30 driver updates
References: <4E303E5B.9050701@samsung.com> <4E31E960.1080008@gmail.com> <4E3230EE.7040602@redhat.com> <201107291036.44660.laurent.pinchart@ideasonboard.com> <4E41931B.5030901@redhat.com> <20110809231806.GA5926@valkosipuli.localdomain> <4E41CF28.9050406@redhat.com> <4E424426.6080303@samsung.com>
In-Reply-To: <4E424426.6080303@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 10-08-2011 05:41, Sylwester Nawrocki escreveu:
>>>> Why not? I never saw an embedded hardware that allows physically changing the
>>>> sensor.
> 
> I understood Laurent's statement that you can have same ISP driver deployed on
> multiple boards fitted with various sensors. Hence the multiple configurations
> that cannot be known in advance,

True, but such kind of dependence should solved either at config time or at
probe time. It doesn't make any sense to show that a hardware is present, when
it is not. This applies to both V4L or MC APIs (and also to sysfs).

>>>> If V4L2 API is not enough, implementing it on libv4l won't solve, as userspace
>>>> apps will use V4L2 API for requresting it.
>>>
>>> There are two kind of applications: specialised and generic. The generic
>>> ones may rely on restrictive policies put in place by a libv4l plugin
>>> whereas the specialised applications need to access the device's features
>>> directly to get the most out of it.
>>
>> A submitted upstream driver should be capable of working with the existing
>> tools/userspace.
>>
>> Currently, there isn't such libv4l plugins (or, at least, I failed to see a
>> merged plugin there for N9, S5P, etc). Let's not upstream new drivers or remove 
>> functionalities from already existing drivers based on something that has yet 
>> to be developed.
>>
>> After having it there properly working and tested independently, we may consider
>> patches removing V4L2 interfaces that were obsoleted in favor of using the libv4l
>> implementation, of course using the Kernel way of deprecating interfaces. But
>> doing it before having it, doesn't make any sense.
>>
>> Let's not put the the cart before the horse.
> 
> That's a good point. My long term plan was to deprecate and remove duplicated ioctls
> at the driver _once_ support for regular V4L2 interface on top of MC/subdev API
> is added at the v4l2 libraries. But this will happen after I create an initial.. 
> *cough* openmax IL for the driver. Which is not what the Tigers like best..

Ok.
> 
> --
> Regards,
> Sylwester

