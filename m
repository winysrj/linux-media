Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:39035 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751159Ab1FLPeF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2011 11:34:05 -0400
References: <1307799283-15518-1-git-send-email-hverkuil@xs4all.nl> <201106121430.03114.hverkuil@xs4all.nl> <1307883186.2592.10.camel@localhost> <201106121523.15127.hverkuil@xs4all.nl> <1307886285.2592.31.camel@localhost> <BANLkTiktMGy_7e0VDs=VDy0rb1rZwk9rXw@mail.gmail.com>
In-Reply-To: <BANLkTiktMGy_7e0VDs=VDy0rb1rZwk9rXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [RFCv1 PATCH 7/7] tuner-core: s_tuner should not change tuner mode.
From: Andy Walls <awalls@md.metrocast.net>
Date: Sun, 12 Jun 2011 11:34:09 -0400
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <cf933f52-a61d-40d4-bcb4-c69988e41708@email.android.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Devin Heitmueller <dheitmueller@kernellabs.com> wrote:

>On Sun, Jun 12, 2011 at 9:44 AM, Andy Walls <awalls@md.metrocast.net>
>wrote:
>> BTW, the cx18-alsa module annoys me as a developer.  PulseAudio holds
>> the device nodes open, pinning the cx18-alsa and cx18 modules in
>kernel.
>> When killed, PulseAudio respawns rapidly and reopens the nodes.
>> Unloading cx18 for development purposes is a real pain when the
>> cx18-alsa module exists.
>
>We've talked about this before, but something just feels wrong about
>this.  I don't have this problem with other drivers that provide an
>"-alsa" module.  For example, my ngene tree has four ALSA PCM devices
>and 16 mixer controls, yet PulseAudio doesn't keep the module in use.
>
>The more I think about this, the more I suspect this is just some sort
>of subtle bug in the cx18 ALSA driver where some resource is not being
>freed.
>
>Devin
>
>-- 
>Devin J. Heitmueller - Kernel Labs
>http://www.kernellabs.com

I'll recheck with my shiny new Fedora 15 install maybe later tonight.

The only thing that springs to mind that PA may not like is no mixer controls.  Some basic code is there in cx18-alsa-mixer.c, but never registered.

Pactl does have some magic cmd to let go of the nodes, but I can never remember it.

Regards,
Andy 
