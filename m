Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:46049 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbZBYHoM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2009 02:44:12 -0500
Message-ID: <49A4F5F8.3070005@redhat.com>
Date: Wed, 25 Feb 2009 08:40:40 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: kilgota@banach.math.auburn.edu,
	Adam Baker <linux@baker-net.org.uk>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Jean-Francois Moine <moinejf@free.fr>,
	Olivier Lorin <o.lorin@laposte.net>,
	Trent Piepho <xyzzy@speakeasy.org>, linux-omap@vger.kernel.org
Subject: Re: [RFC] How to pass camera Orientation to userspace
References: <200902180030.52729.linux@baker-net.org.uk> <200902211253.58061.hverkuil@xs4all.nl> <20090223080715.0c97774e@pedra.chehab.org> <200902232237.32362.linux@baker-net.org.uk> <alpine.LNX.2.00.0902231730410.13397@banach.math.auburn.edu> <alpine.LRH.2.00.0902241723090.6831@pedra.chehab.org> <alpine.LNX.2.00.0902241449020.15189@banach.math.auburn.edu> <alpine.LRH.2.00.0902242153490.6831@pedra.chehab.org>
In-Reply-To: <alpine.LRH.2.00.0902242153490.6831@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

<really big snip>

>> So, what do these two deep questions, which confound the assembled 
>> wisdom of an entire list of Linux video developers, have to do with 
>> tables in userspace? None that I can see, unless someone wants to 
>> provide a mechanism for the information, having been collected in the 
>> module, to be available to the table in userspace.
> 
> I'm not saying that userspace tables would solve all problems. I'm just 
> saying that this should be part of the solution.
> 
> For sure we need to have a way for retrieving this information for 
> devices like the sq905 cameras, where the information can't be currently 
> be determined by userspace.
> 
> In the case of sq905, this information is static, right? If so, IMO, the 
> better approach is to use a flag at the v4l2_input, as already discussed 
> in this thread.
> 

Yes we all seem to agree on this. Adam, since you started this thread can you 
write a small RFC with that solution worked out with proposed videodev2.h changes?

Note that I'm only talking about input flags for the orientation problem and 
not the pivotting problem. I think the pivotting problem may need some more 
discussion. But since we all seem to be in agreement wrt to orientation problem 
and specifically the sq905 problem, lets do one more RFC, then everyone does a 
+1 to that and we move forward with this as a solution for the orientation problem.

Regards,

Hans


p.s.

For the pivotting problem I'm tending towards a special control class which 
contains read-only controls which are really camera properties. This will allow 
us to cope with any granularity of pivoting sensors. This could then also be 
used for in example aperture. But lets start a new thread for that.
