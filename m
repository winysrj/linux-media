Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:1032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124Ab1ECPDV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 May 2011 11:03:21 -0400
Message-ID: <4DC01931.70404@redhat.com>
Date: Tue, 03 May 2011 12:03:13 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hansverk@cisco.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Simon Farnsworth <simon.farnsworth@onelan.co.uk>,
	Steven Toth <stoth@kernellabs.com>,
	Andy Walls <awalls@md.metrocast.net>
Subject: Re: [git:v4l-dvb/for_v2.6.40] [media] cx18: mmap() support for raw
 YUV video capture
References: <E1QGwlS-0006ys-15@www.linuxtv.org> <201105022331.29142.hverkuil@xs4all.nl> <BANLkTinjYo0zW56+vEMDciXkdk9gePOZnQ@mail.gmail.com> <201105031559.52492.hansverk@cisco.com>
In-Reply-To: <201105031559.52492.hansverk@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 03-05-2011 10:59, Hans Verkuil escreveu:
> On Tuesday, May 03, 2011 14:49:43 Devin Heitmueller wrote:

> What better non-embedded driver to implement vb2 in than one that doesn't yet 
> do stream I/O? The risks of breaking anything are much smaller and it would be 
> a good 'gentle introduction' to vb2. 

The risk is there even on this case: existing applications should work with vb2.
Also, you're discussing about something that we don't have: there's no vb2 patches
for cx18 yet.

> Also, it prevents the unnecessary 
> overhead of having to replace videobuf in the future in cx18.

This overhead already exists, as a vb1 solution is there and there's no vb2 solution
yet.

> The problem is no doubt different agendas. You want to have your code 
> upstreamed. I want to have code upstreamed that uses the latest frameworks.

>From my side, I'm more concerned if vb2 will really support all memory modes that
vb1 already supports, on both kernelspace and userspace API's. I'm not confident
about that yet, and before starting spreading a solution that we don't know for sure
that it will work on non-embedded devices, with similar or better performance than vb1, 
we need to fully test it with one complete driver, before testing on vb subsets, 
in order to fix architectural design problems (if is there any). Before that, 
porting any non-embedded driver to vb2 is premature.

> And the only way to prove that vb2 works is to use it. Saying "it's unproven, 
> so let's not use it" is silly. 

Yes, and nobody said otherwise.

> The right approach IMHO is to implement it in 
> new drivers, and ensure that the author(s) of the framework give high priority 
> to fixing any issues that may surface.

This is where we diverge: while a "pure api/application compliance" might work
with a new driver, you can't compare performance if you don't have the very same 
driver using vb1 against the same driver using vb2. Even for de-facto API compliance
tests, if you find something not working with some application and a new driver, it
is harder to point the fingers if the issue is at VB2 or at the new driver, as a
new driver is, per definition: NEW. So, it is untested.

On the other hand, if you take an existing drivers, convert it to VB2, test it with
some compliant tool and it works, and test with application X and it breaks, you
know for sure that the error is at VB2.

> Anyway, converting bttv to vb2 is steadily getting higher on my TODO list. 
> Unfortunately there is still a large number of other items that are also on 
> that list. I'd love to have more time for this, and things actually may 
> improve in the future, but not any time soon :-(
> 
> Regards,
> 
> 	Hans

