Return-path: <mchehab@pedra>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1340 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab1ECQOF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 May 2011 12:14:05 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [git:v4l-dvb/for_v2.6.40] [media] cx18: mmap() support for raw YUV video capture
Date: Tue, 3 May 2011 18:13:53 +0200
Cc: Hans Verkuil <hansverk@cisco.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org,
	Simon Farnsworth <simon.farnsworth@onelan.co.uk>,
	Steven Toth <stoth@kernellabs.com>,
	Andy Walls <awalls@md.metrocast.net>
References: <E1QGwlS-0006ys-15@www.linuxtv.org> <201105031559.52492.hansverk@cisco.com> <4DC01931.70404@redhat.com>
In-Reply-To: <4DC01931.70404@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105031813.53460.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, May 03, 2011 17:03:13 Mauro Carvalho Chehab wrote:
> Em 03-05-2011 10:59, Hans Verkuil escreveu:
> > On Tuesday, May 03, 2011 14:49:43 Devin Heitmueller wrote:
> 
> > What better non-embedded driver to implement vb2 in than one that doesn't yet 
> > do stream I/O? The risks of breaking anything are much smaller and it would be 
> > a good 'gentle introduction' to vb2. 
> 
> The risk is there even on this case: existing applications should work with vb2.
> Also, you're discussing about something that we don't have: there's no vb2 patches
> for cx18 yet.
> 
> > Also, it prevents the unnecessary 
> > overhead of having to replace videobuf in the future in cx18.
> 
> This overhead already exists, as a vb1 solution is there and there's no vb2 solution
> yet.
> 
> > The problem is no doubt different agendas. You want to have your code 
> > upstreamed. I want to have code upstreamed that uses the latest frameworks.
> 
> From my side, I'm more concerned if vb2 will really support all memory modes that
> vb1 already supports, on both kernelspace and userspace API's. I'm not confident
> about that yet, and before starting spreading a solution that we don't know for sure
> that it will work on non-embedded devices, with similar or better performance than vb1, 
> we need to fully test it with one complete driver, before testing on vb subsets, 
> in order to fix architectural design problems (if is there any). Before that, 
> porting any non-embedded driver to vb2 is premature.
> 
> > And the only way to prove that vb2 works is to use it. Saying "it's unproven, 
> > so let's not use it" is silly. 
> 
> Yes, and nobody said otherwise.
> 
> > The right approach IMHO is to implement it in 
> > new drivers, and ensure that the author(s) of the framework give high priority 
> > to fixing any issues that may surface.
> 
> This is where we diverge: while a "pure api/application compliance" might work
> with a new driver, you can't compare performance if you don't have the very same 
> driver using vb1 against the same driver using vb2. Even for de-facto API compliance
> tests, if you find something not working with some application and a new driver, it
> is harder to point the fingers if the issue is at VB2 or at the new driver, as a
> new driver is, per definition: NEW. So, it is untested.
> 
> On the other hand, if you take an existing drivers, convert it to VB2, test it with
> some compliant tool and it works, and test with application X and it breaks, you
> know for sure that the error is at VB2.

It sounds great, but the problem is that there is little incentive to convert existing
drivers to vb2. Take cx18: someone obviously wants to get this code in. So if you
require vb2 then there is an incentive to do that work. If the current version is
accepted, then the incentive to move to vb2 is gone. If you are lucky you can find
developers like Andy who might look at it. Look at how long it took to get rid of
V4L1. Or how long it takes to convert drivers to video_ioctl2? Or the control
framework?

It is much easier to put such requirements on incoming code. Once it is in it can
take a very long time to convert code to a newer framework.

Regards,

	Hans
