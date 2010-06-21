Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:56019 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756808Ab0FUArx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Jun 2010 20:47:53 -0400
Subject: Re: [PATCH 3/4] ir-core: move decoding state to ir_raw_event_ctrl
From: Andy Walls <awalls@md.metrocast.net>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	Jarod Wilson <jarod@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, linux-input@vger.kernel.org
In-Reply-To: <AANLkTinJPFBBDEiOpbFhkAccF5E7caKNmAuvEnq-uV4W@mail.gmail.com>
References: <20100424211411.11570.2189.stgit@localhost.localdomain>
	 <4BDF2B45.9060806@redhat.com> <20100607190003.GC19390@hardeman.nu>
	 <20100607201530.GG16638@redhat.com> <20100608175017.GC5181@hardeman.nu>
	 <AANLkTimuYkKzDPvtnrWKoT8sh1H9paPBQQNmYWOT7-R2@mail.gmail.com>
	 <20100609132908.GM16638@redhat.com> <20100609175621.GA19620@hardeman.nu>
	 <20100609181506.GO16638@redhat.com>
	 <AANLkTims0dmYCOoI_K4S6Q8hwLV_MqUdGQjVwFu43sCL@mail.gmail.com>
	 <20100613202945.GA5883@hardeman.nu>
	 <AANLkTim6f6jM4TGzyQsuHDNPUSsjINXFHck0NevrtqHr@mail.gmail.com>
	 <AANLkTil6P0rnmViLwpkiBOYoC6qF217V90g7Nslk3DHN@mail.gmail.com>
	 <1276776859.2461.16.camel@localhost>
	 <AANLkTinJPFBBDEiOpbFhkAccF5E7caKNmAuvEnq-uV4W@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 20 Jun 2010 20:47:56 -0400
Message-ID: <1277081276.2252.12.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2010-06-17 at 11:11 -0400, Jarod Wilson wrote:
> On Thu, Jun 17, 2010 at 8:14 AM, Andy Walls <awalls@md.metrocast.net> wrote:

> >> A fully functional tree carrying both of David's patches and the
> >> entire stack of other patches I've submitted today, based on top of
> >> the linuxtv staging/rc branch, can be found here:
> >>
> >> http://git.wilsonet.com/linux-2.6-ir-wip.git/?a=shortlog;h=refs/heads/patches
> >>
> >> Also includes the lirc patches that I believe are ready to be
> >> submitted for actual consideration (note that they're dependent on
> >> David's two patches).
> >
> >
> > I'll try and play with this this weekend along with some cx23885
> > cleanup.
> 
> Excellent. A few things to note... 

Jarrod,

I was unable to get this task completed in the time I had available this
weekend.  A power supply failure, unexpected hard drive replacement, and
my inability to build/install a kernel from a git tree that would
actually boot my Fedora 12 installation didn't help.  (My productivity
has tanked since v4l-dvb went to GIT for CM, and the last time I built a
real kernel without rpmbuild was for RedHat 9. I'm still working out
processes for doing basic things, sorry.)

I'll have time on Thursday night to try again.




> Many of the lirc_dev ioctls are
> currently commented out, and haven't in any way been wired up to tx
> callbacks,

Yes, I saw, that's OK.  It should be easy enough to hack something in
for testing and prototyping.


>  I've only enabled the minimum necessary for mceusb. The
> ioctls are all using __u32 params, which, if you're on x86_64, will
> require a patched lirc userspace build to make the ioctl types match.
> I'm using this patch atm:
> 
> http://wilsonet.com/jarod/lirc_misc/lirc-0.8.6-make-ioctls-u32.patch
> 
> (In the future, lirc userspace should obviously just build against
> <media/lirc.h>).


I've got all x86_64 bit machines here, so thank you for the tips.

Regards,
Andy

