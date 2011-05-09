Return-path: <mchehab@gaivota>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59288 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab1EIUAR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 May 2011 16:00:17 -0400
Received: by wya21 with SMTP id 21so4166813wya.19
        for <linux-media@vger.kernel.org>; Mon, 09 May 2011 13:00:16 -0700 (PDT)
Subject: Re: [PATCH] [media] ite-cir: make IR receive work after resume
From: Juan =?ISO-8859-1?Q?Jes=FAs_Garc=EDa?= de Soria Lucena
	<skandalfo@gmail.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4DC84470.7060603@redhat.com>
References: <dwy71fckod7ba37187igo82l.1304967460349@email.android.com>
	 <4DC84470.7060603@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 22:00:13 +0200
Message-ID: <1304971213.1892.4.camel@rimmer>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi again,

El lun, 09-05-2011 a las 15:45 -0400, Jarod Wilson escribió:
> Well, looking at the resume function, I wasn't sure if I wanted to
> mess with things while it was possibly trying to finish up tx, but
> upon closer inspection, I don't think we can ever get into the
> state where we're actually doing anything in the tx handler where
> it would matter. If dev->transmitting is true and we're actually
> able to grab the spinlock, it means we're just in the middle of
> the mdelay for remaining_us, and everything done after that is
> partially redundant with init_hardware anyway. So yeah, it looks
> safe to me to just put in the init_hardware unconditionally above
> the check for dev->transmitting.
> 
> On a related note though... what are the actual chances that we are
> suspending in the middle of tx, and what are the chances it would
> actually be of any use to resume that tx after waking up?
> 
> So what I'm now thinking is this: add a wait_event_interruptible on
> tx_ended in the suspend path if dev->transmitting to let tx finish
> before we suspend. Then in resume, we're never resuming in the
> middle of tx and the whole conditional goes away.

That looks like an approach way nicer than the current one. That way
sent codes wouldn't be interrupted during transmission by a concurrent
suspend request and, yes, the resume function is more elegant too.

Please go ahead with this idea if you wish :-)


Best regards,

    Juan Jesús.

