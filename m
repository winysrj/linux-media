Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:8752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019Ab1ECL3j (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 May 2011 07:29:39 -0400
Message-ID: <4DBFE71A.7000207@redhat.com>
Date: Tue, 03 May 2011 08:29:30 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Andy Walls <awalls@md.metrocast.net>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org,
	Simon Farnsworth <simon.farnsworth@onelan.co.uk>,
	Steven Toth <stoth@kernellabs.com>
Subject: Re: [git:v4l-dvb/for_v2.6.40] [media] cx18: mmap() support for raw
 YUV video capture
References: <E1QGwlS-0006ys-15@www.linuxtv.org> <1304390415.2461.126.camel@localhost> <4DBF7642.8000101@redhat.com> <201105030715.59423.hverkuil@xs4all.nl>
In-Reply-To: <201105030715.59423.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 03-05-2011 02:15, Hans Verkuil escreveu:
> On Tuesday, May 03, 2011 05:28:02 Mauro Carvalho Chehab wrote:
>>> 2. I'd at least like Simon's revised patch to be merged instead, to fix
>>> the known deficincies in this one.
>>
>> IMO, the proper workflow would be that Simon should send his changes, as
>> a diff patch against the current one. We can all review it, based on the
>> comments you sent in priv and fix it.
> 
> I disagree. The proper workflow in this particular instance is to revert the
> patch, have Simon post the revised patch to the list and have it reviewed on
> the list.
> 
> As Andy noticed, in this particular case the whole procedure was a mess due
> to completely understandable reasons. Nobody is to blame, it's just one of
> those things that happens.
> 
> Reading through the comments Andy made regarding this patch it is clear to
> me that there are too many issues with this patch.
> 
> Anyway, I stand by my NACK.

I won't do anything before seeing the new version. Reverting a patch is painful,
as it means that I need to take extra care when sending upstream, and I'm having
enough headaches with all patchwork issues. I won't do it, except if we can't
have this fixed before the end of the next merge window.

>> As it seems that that the patch offers a subset of the desired features
>> that you're planning with your approach, maybe the better would be to add
>> a CONFIG var to enable YUV support, stating that such feature is experimental.
>>
>>> 3. If merging this patch, means a change to videobuf2 in the future is
>>> not allowed, than I'd prefer to NACK the patch that introduces
>>> videobuf(1) into cx18.
>>
>> The addition of VB1 first doesn't imply that VB2 would be acked or nacked.
>>
>> In any case, the first non-embedded VB2 driver will need a very careful
>> review, to be sure that they won't break any userspace applications. 
>> On embedded hardware, only a limited set of applications are supported, and they
>> are patched and bundled together with the hardware, so there's not much concern
>> about userspace apps breakage.
>>
>> However, on non-embedded hardware, we should be sure that no regressions to
>> existing applications will happen. So, the better would be if the first VB2 
>> non-embedded driver to be a full-featured V4L2 board (e. g. saa7134 or bttv, 
>> as they support all types of video buffer userspace API's, including overlay
>> mode), allowing us to test if VB2 is really following the specs (both the
>> "de facto" and "de jure" specs).
> 
> I fail to see why we can't implement vb2 in cx18.

Where did I said that?  Please, don't understand me wrong, nor put words into my mouth.
All I said is that vb2 is not enough tested.

> And vb2 has been tested
> extensively already with respect to the spec. vivi is using it, and I'm doing
> a lot of testing with that driver.

There are two specs envolved here: the V4L2 API spec and the by practice spec,
used by userspace apps developers when they write their stuff. It is a Linux
requirement that Kernel changes should not break existing applications (no
regressions). This basically means that the "by practice" spec should not be
broken.

I'm not saying that vb2 broke it. All I'm saying is that we don't have enough tests.
vivi is nice to test new features, but only developers use it, and on a restricted
environment. Embedded drivers also use it also on a restricted environment, were
just one application is used, and such application is developed (or patched) to
work for an specific piece of hardware.

I really doubt that, except by people that work with embedded devices, people tried
to use vb2 into a real environment. For example, on the early days of videobuf
split into vb sub-drivers, kernel OOPSes/Panic's were noticed when channels were 
changed, because hardware DMA engine restarts on some hardware, and this caused
some race conditions.

So, before applying vb2 to a driver that will be used by the existing applications,
a wide range of tests with the applications are needed.

> Note that the current set of drivers behaves different already depending on
> whether videobuf is used or not. Drivers like UVC follow the spec, drivers
> based on videobuf don't. It's a big freakin' mess.

The long term solution is to merge all vb stuff into one solution, and I have
good hope that vb2 will be such solution. But before doing that, we need to be
sure that vb2 will work with all kinds of situations covered by vb1, uvc-vb,
gspca-vb, etc. We'll get there one day, but we should not put the cart before 
the horse.

The proper way of doing it is to do convert a ful-featured v4l2 driver that works
fine with vb1 and test it, after its conversion to vb2, if all situations are
covered by vb2, and it it works properly with the existing applications, fixing
it until it works properly. After having one of such drivers properly working,
we can migrate the others to vb2.

Doing the opposite way by adding new drivers to vb2 without even knowing if it
is compliant with the "status quo" is risky and will just add more entropy, as
vb2 is currently just one more vb implementation, that it is still not known to
work for all cases, just like the other existing ones.

Mauro.

