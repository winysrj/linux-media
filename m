Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42154 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab1EaGjp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2011 02:39:45 -0400
Received: by bwz15 with SMTP id 15so3367229bwz.19
        for <linux-media@vger.kernel.org>; Mon, 30 May 2011 23:39:44 -0700 (PDT)
Date: Tue, 31 May 2011 17:43:23 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org, thunder.m@email.cz,
	"istvan_v@mailbox.hu" <istvan_v@mailbox.hu>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] XC4000 patches for kernel 2.6.37.2
Message-ID: <20110531174323.0f0c45c0@glory.local>
In-Reply-To: <BANLkTi=Lq+FF++yGhRmOa4NCigSt6ZurHg@mail.gmail.com>
References: <4D764337.6050109@email.cz>
	<20110531124843.377a2a80@glory.local>
	<BANLkTi=Lq+FF++yGhRmOa4NCigSt6ZurHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Devin

> On Mon, May 30, 2011 at 10:48 PM, Dmitri Belimov
> <d.belimov@gmail.com> wrote:
> > Hi
> >
> >> Hi Istvan
> >>
> >> š š š I am sending you modified patches for kernel 2.6.37.2, they
> >> works as expected.
> >>
> >> First apply kernel_xc4000.diff (your patch) then
> >> kernel_dtv3200h.diff for Leadtek DTV3200 XC4000 support.
> >
> > Can you resend your patches with right Signed-Off string for commit
> > into kernel?
> >
> > With my best regards, Dmitry.
> 
> He cannot offer a Signed-off-by for the entire patch - it's not his
> code.  The patches are based on the work that Davide Ferri and I did
> about 17 months ago:
> 
> http://kernellabs.com/hg/~dheitmueller/pctv-340e-2/shortlog
> 
> I'm not against seeing the xc4000 support going in, but the history
> needs to be preserved, which means it needs to be broken in to a patch
> series that properly credits my and Davide's work.

Is it possible make some patches and add support xc4000 into kernel?

With my best regards, Dmitry.
 
> Devin
> 
> -- 
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
