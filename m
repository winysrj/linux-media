Return-path: <mchehab@localhost>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48757 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab1GFSRY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2011 14:17:24 -0400
Received: by eyx24 with SMTP id 24so58891eyx.19
        for <linux-media@vger.kernel.org>; Wed, 06 Jul 2011 11:17:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E14A127.8040805@kolumbus.fi>
References: <1307804731-16430-1-git-send-email-hverkuil@xs4all.nl>
	<201106152237.02427.hverkuil@xs4all.nl>
	<BANLkTimVQDoHo+5-2ZkU0sE0LWiUjHeBXg@mail.gmail.com>
	<201106160821.15352.hverkuil@xs4all.nl>
	<4DF9E5AB.1050707@redhat.com>
	<BANLkTi=Wq=swMMBfK+X9gVQ0XhL4OSxXFA@mail.gmail.com>
	<4E14A127.8040805@kolumbus.fi>
Date: Wed, 6 Jul 2011 14:17:21 -0400
Message-ID: <CAGoCfiwjXYBR8FBYMS8BsBM20mCQLvWQbyhLh-psA_HX73SGjw@mail.gmail.com>
Subject: Re: [RFCv2 PATCH 0/5] tuner-core: fix s_std and s_tuner
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Marko Ristola <marko.ristola@kolumbus.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Andy Walls <awalls@md.metrocast.net>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

On Wed, Jul 6, 2011 at 1:53 PM, Marko Ristola <marko.ristola@kolumbus.fi> wrote:
>
> Hi.
>
> I think that you could reuse lots of code with smart suspend / resume.
>
> What do you think about this DVB power saving case (about the concept, don't look at details, please):
>
> - One device has responsibility to do the power off when it can be done (mantis_core.ko)
> - In my case there is only one frontend tda10021.ko to take care of.
>
> - dvb_frontend.c would call fe->sleep(fe). The callback goes into mantis_core.ko.
> - mantis_core.ko will traverse all devices on it's responsibility, all (tda10021.ko) are idle.
> => suspend tda10021.ko by calling tda10021->sleep() and do additional power off things.
>
> - When dvb_frontend.c wants tuner to be woken up,
>  mantis_core.ko does hardware resets and power on first and then resumes tda10021->init(fe).
>
> I implemented something that worked a few years ago with suspend / resume.
> In mantis_dvb.c's driver probe function I modified tuner_ops to enable these runtime powersaving features:
> +                       mantis->fe->ops.tuner_ops.sleep = mantis_dvb_tuner_sleep;
> +                       mantis->fe->ops.tuner_ops.init = mantis_dvb_tuner_init;
>
> That way mantis_core.ko had all needed details to do any advanced power savings I wanted.
>
> Suspend / resume worked well: During resume there was only a glitch at the picture and sound
> and the TV channel watching continued. tda10021 (was cu1216 at that time)
> restored the original TV channel. It took DVB FE_LOCK during resume.
> Suspended DMA transfer was recovered before returning into userspace.
>
> So I think that you need a single device (mantis_core.ko) that can see the whole picture,
> in what states the subdevices are: can you touch the power button?.
> With DVB this is easy because dvb_frontend.c tells when a frontend is idle and when it is not.
>
> The similar idea of some kind of watchdog that is able to track when a single
> device (frontend) is used and when it is not used, would be sufficient.
>
> The topmost driver (mantis_core.ko in my case) would then be responsible to track multiple frontends
> (subdevices), if they all are idle or not, with suitable mutex protection.
> Then this driver could easilly suspend/resume these subdevices and press power switch when necessary.
>
>
> So the clash between DVB and V4L devices would be solved:
> Both DVB and V4L calls a (different) sleep() function on mantis_core.ko
> mantis_core.ko will turn power off when both "frontends" are sleeping.
> If only one sleeps, the one can be put to sleep or suspended, but power
> button can't be touched.
>
> What do you think?
>
> I did this easy case mantis_core.ko solution in about Summer 2007.
> It needs a rewrite and testing, if I take it from the dust.
>
> Regards,
> Marko Ristola

Hi Marko,

This is one of those ideas that sounds good in theory but in practice
getting it to work with all the different types of boards is really a
challenge.  It would need to take into account devices with multiple
frontends, shared tuners between V4L and DVB, shared tuners between
different DVB frontends, etc.

For example, the DVB frontend call to sleep the demod is actually
deferred.  This exposes all sorts of fun races with applications such
as MythTV which switch between DVB and V4L modes in fast succession.
For example, on the HVR-950Q I debugged an issue last year where
switching from DVB to V4L would close the DVB frontend device,
immediately open the V4L device, start tuning the V4L device, and then
a couple hundred milliseconds later the sleep call would arrive from
the DVB frontend thread which would screw up the tuner state.

In other words, the locking is not trivial and you need to take into
account the various threads that can be running.  Taking the above
example, if you had deferred freeing up the device until the sleep
call arrived, then the DVB close would have returned immediately, and
the V4L open would have failed because the device was "still in use".

Also, you need to take into consideration that bringing some devices
out of sleep can be a *very* time consuming operation.  This is mostly
due to loading of firmware, which on some devices can take upwards of
ten seconds due to large blobs and slow i2c busses.  Hence if you have
too granular a power management strategy you end up with a situation
where you are continuously calling a resume routine which takes ten
seconds.  This adds up quickly if for example you call v4l2-ctl half a
dozen times before starting streaming.

All that said, I believe that you are correct in that the business
logic needs to ultimately be decided by the bridge driver, rather than
having the dvb/tuner core blindly calling the sleep routines against
the tuner and demod drivers without a full understanding of what
impact it has on the board as a whole.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
