Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33828 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab1FPMvs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2011 08:51:48 -0400
Received: by ewy4 with SMTP id 4so123721ewy.19
        for <linux-media@vger.kernel.org>; Thu, 16 Jun 2011 05:51:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DF9E5AB.1050707@redhat.com>
References: <1307804731-16430-1-git-send-email-hverkuil@xs4all.nl>
	<201106152237.02427.hverkuil@xs4all.nl>
	<BANLkTimVQDoHo+5-2ZkU0sE0LWiUjHeBXg@mail.gmail.com>
	<201106160821.15352.hverkuil@xs4all.nl>
	<4DF9E5AB.1050707@redhat.com>
Date: Thu, 16 Jun 2011 08:51:45 -0400
Message-ID: <BANLkTi=Wq=swMMBfK+X9gVQ0XhL4OSxXFA@mail.gmail.com>
Subject: Re: [RFCv2 PATCH 0/5] tuner-core: fix s_std and s_tuner
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Andy Walls <awalls@md.metrocast.net>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Jun 16, 2011 at 7:14 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> One possible logic that would solve the scripting would be to use a watchdog
> to monitor ioctl activities. If not used for a while, it could send a s_power
> to put the device to sleep, but this may not solve all our problems.
>
> So, I agree with Devin: we need to add an option to explicitly control the
> power management logic of the device, having 3 modes of operation:
>        POWER_AUTO - use the watchdogs to poweroff
>        POWER_ON - explicitly powers on whatever subdevices are needed in
>                   order to make the V4L ready to stream;
>        POWER_OFF - Put all subdevices to power-off if they support it.
>
> After implementing such logic, and keeping the default as POWER_ON, we may
> announce that the default will change to POWER_AUTO, and give some time for
> userspace apps/scripts that need to use a different mode to change their
> behaviour. That means that, for example, "radio -qf" will need to change to
> POWER_ON mode, and "radio -m" should call POWER_OFF.

I've considered this idea before, and it's not bad in theory.  The one
thing you will definitely have to watch out for is causing a race
between DVB and V4L for hybrid tuners.  In other words, you can have a
user switching from analog to digital and you don't want the tuner to
get powered down a few seconds after they started streaming video from
DVB.

Any such solution would have to take the above into account.  We've
got a history of race conditions like this and I definitely don't want
to see a new one introduced.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
