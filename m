Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57685 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757210Ab0FUDvW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Jun 2010 23:51:22 -0400
MIME-Version: 1.0
In-Reply-To: <1277081276.2252.12.camel@localhost>
References: <20100424211411.11570.2189.stgit@localhost.localdomain>
	<4BDF2B45.9060806@redhat.com>
	<20100607190003.GC19390@hardeman.nu>
	<20100607201530.GG16638@redhat.com>
	<20100608175017.GC5181@hardeman.nu>
	<AANLkTimuYkKzDPvtnrWKoT8sh1H9paPBQQNmYWOT7-R2@mail.gmail.com>
	<20100609132908.GM16638@redhat.com>
	<20100609175621.GA19620@hardeman.nu>
	<20100609181506.GO16638@redhat.com>
	<AANLkTims0dmYCOoI_K4S6Q8hwLV_MqUdGQjVwFu43sCL@mail.gmail.com>
	<20100613202945.GA5883@hardeman.nu>
	<AANLkTim6f6jM4TGzyQsuHDNPUSsjINXFHck0NevrtqHr@mail.gmail.com>
	<AANLkTil6P0rnmViLwpkiBOYoC6qF217V90g7Nslk3DHN@mail.gmail.com>
	<1276776859.2461.16.camel@localhost>
	<AANLkTinJPFBBDEiOpbFhkAccF5E7caKNmAuvEnq-uV4W@mail.gmail.com>
	<1277081276.2252.12.camel@localhost>
Date: Sun, 20 Jun 2010 23:51:21 -0400
Message-ID: <AANLkTikkSIk9XZiuF62YeCmGebrfy8SA9n3J5Agv8LjD@mail.gmail.com>
Subject: Re: [PATCH 3/4] ir-core: move decoding state to ir_raw_event_ctrl
From: Jarod Wilson <jarod@wilsonet.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	Jarod Wilson <jarod@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jun 20, 2010 at 8:47 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> On Thu, 2010-06-17 at 11:11 -0400, Jarod Wilson wrote:
>> On Thu, Jun 17, 2010 at 8:14 AM, Andy Walls <awalls@md.metrocast.net> wrote:
>
>> >> A fully functional tree carrying both of David's patches and the
>> >> entire stack of other patches I've submitted today, based on top of
>> >> the linuxtv staging/rc branch, can be found here:
>> >>
>> >> http://git.wilsonet.com/linux-2.6-ir-wip.git/?a=shortlog;h=refs/heads/patches
>> >>
>> >> Also includes the lirc patches that I believe are ready to be
>> >> submitted for actual consideration (note that they're dependent on
>> >> David's two patches).
>> >
>> >
>> > I'll try and play with this this weekend along with some cx23885
>> > cleanup.
>>
>> Excellent. A few things to note...
>
> Jarrod,
>
> I was unable to get this task completed in the time I had available this
> weekend.  A power supply failure, unexpected hard drive replacement, and
> my inability to build/install a kernel from a git tree that would
> actually boot my Fedora 12 installation didn't help.  (My productivity
> has tanked since v4l-dvb went to GIT for CM, and the last time I built a
> real kernel without rpmbuild was for RedHat 9. I'm still working out
> processes for doing basic things, sorry.)

Heh, yeah, hardware failure is always fun when you're trying really
hard to get something done. :)

As for the building your own kernel thing... I've been doing my work
mainly on a pair of x86_64 systems, one a ThinkPad T61 running Fedora
13, and the other an HP xw4400 workstation running RHEL6. In both
cases, I copied a distro kernel's, config file out of /boot/, and then
ran make oldconfig over it and build straight from what's in my tree,
which works well enough on both setups.

> I'll have time on Thursday night to try again.

No rush yet, we've got a while before the merge window still.
Christoph (Bartelmus) helped me out with a bunch of ioctl
documentation this weekend, so I've got that to add to the tree, then
I think I'll be prepared to resubmit the lirc bits. I'll shoot for
doing that next weekend, and hopefully, that'll give you a chance to
try 'em out before then and provide any necessary feedback/fixes/etc.
(Not that we can't also just fix things up as needed post-merge). I'm
still up in the air as to what I should work on next... So many lirc
drivers left to port still... Maybe zilog, maybe streamzap... Maybe
the MCE IR keyboard...

-- 
Jarod Wilson
jarod@wilsonet.com
