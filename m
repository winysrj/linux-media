Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48990 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab1FLN5F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2011 09:57:05 -0400
Received: by ewy4 with SMTP id 4so1359754ewy.19
        for <linux-media@vger.kernel.org>; Sun, 12 Jun 2011 06:57:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1307886285.2592.31.camel@localhost>
References: <1307799283-15518-1-git-send-email-hverkuil@xs4all.nl>
	<201106121430.03114.hverkuil@xs4all.nl>
	<1307883186.2592.10.camel@localhost>
	<201106121523.15127.hverkuil@xs4all.nl>
	<1307886285.2592.31.camel@localhost>
Date: Sun, 12 Jun 2011 09:57:03 -0400
Message-ID: <BANLkTiktMGy_7e0VDs=VDy0rb1rZwk9rXw@mail.gmail.com>
Subject: Re: [RFCv1 PATCH 7/7] tuner-core: s_tuner should not change tuner mode.
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, Jun 12, 2011 at 9:44 AM, Andy Walls <awalls@md.metrocast.net> wrote:
> BTW, the cx18-alsa module annoys me as a developer.  PulseAudio holds
> the device nodes open, pinning the cx18-alsa and cx18 modules in kernel.
> When killed, PulseAudio respawns rapidly and reopens the nodes.
> Unloading cx18 for development purposes is a real pain when the
> cx18-alsa module exists.

We've talked about this before, but something just feels wrong about
this.  I don't have this problem with other drivers that provide an
"-alsa" module.  For example, my ngene tree has four ALSA PCM devices
and 16 mixer controls, yet PulseAudio doesn't keep the module in use.

The more I think about this, the more I suspect this is just some sort
of subtle bug in the cx18 ALSA driver where some resource is not being
freed.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
