Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:57556 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184AbZJNOmv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Oct 2009 10:42:51 -0400
Received: by fxm27 with SMTP id 27so11673862fxm.17
        for <linux-media@vger.kernel.org>; Wed, 14 Oct 2009 07:42:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20091014113035.5f8a2681@pedra.chehab.org>
References: <829197380910132052w155116ecrcea808abe87a57a6@mail.gmail.com>
	 <20091014122550.7c84bba5@ieee.org>
	 <829197380910140612t726251d6y7cff3873587101b4@mail.gmail.com>
	 <20091014160626.70db928b@ieee.org>
	 <829197380910140711l7624c0c8va474156f712580a4@mail.gmail.com>
	 <20091014113035.5f8a2681@pedra.chehab.org>
Date: Wed, 14 Oct 2009 10:42:13 -0400
Message-ID: <829197380910140742n4e91b97fg33c37407bd68870b@mail.gmail.com>
Subject: Re: em28xx DVB modeswitching change: call for testers
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Giuseppe Borzi <gborzi@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 14, 2009 at 10:30 AM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> Devin,
>
> You can't simply remove the DVB gpio setup there. It is used when you change
> from analog/digital, when you restore from hibernation and to turn on the demod
> on hybrid devices, and to turn it off after stopping DVB. If you're having troubles
> there, then probably the DVB demod poweron/reset gpio sequence is wrong or
> incomplete.

The em28xx_dvb_bus_ctrl() callback should already be putting it into
digital mode when the frontend gets opened.  The point behind the
change is that we should not be switching in and out of dvb mode
whenever somebody starts/stops streaming.  It should be controlled
based on opening closing the frontend (which is what the ts_bus_ctrl
callback should accomplish).

We ran into the issue because the dvb gpio for the board in question
actually strobes the reset rather than just taking it out of reset.
While I could change the dvb_gpio to match some of the other boards,
we really *should* be strobing the reset after powering up the chip.

If we're really relying on the calls in the start_feed() callback when
coming out of hibernation, then the code is broken in that case as
well, since there is no guarantee the demod is properly
re-initialized.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
