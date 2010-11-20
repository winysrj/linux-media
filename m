Return-path: <mchehab@gaivota>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49133 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab0KTM6m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Nov 2010 07:58:42 -0500
Received: by ewy5 with SMTP id 5so1022313ewy.19
        for <linux-media@vger.kernel.org>; Sat, 20 Nov 2010 04:58:41 -0800 (PST)
Date: Sat, 20 Nov 2010 13:57:15 +0100
From: Richard Zidlicky <rz@linux-m68k.org>
To: Marko Ristola <marko.ristola@kolumbus.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Oliver Endriss <o.endriss@gmx.de>
Subject: Re: Thoughts about suspending DVB C PCI device transparently
Message-ID: <20101120125715.GA15076@linux-m68k.org>
References: <4C39E481.1050903@kolumbus.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C39E481.1050903@kolumbus.fi>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi,

found this old email when searching for suspend issues, seems like a good idea. 
Just wondering - how many eg dvb drivers are there with working suspend/hibernate 
(all buses, not just PCI)? Me thinks only a small fraction, the rest will crash
unless blacklisted by pm-utils?

Would it be worth to code a generic approach working around drivers that need to be
blacklisted? It seems that because of eg firmware loading this might be the only way 
to get dvb drivers behave?

Richard

> Once in a time I wrote into Mantis driver Suspend / resume
> code. The idea was, that bridge driver (mantis_dvb.c) will
> handle the suspend / resume transparently to the application.
>
> With a PCI device this was rather easy to achieve.
> With xine, there was just a glitch with video and audio
> after resume.
>
> So after suspend, frontend was tuned into the original
> frequency, and the DMA transfer state was restored.
>
> Suspend:
> 1. Turn off possible DMA transfer if active (feeds > 0)
> 2. Remember tuner power on state.
> 3. Do tuner and fronted power off.
>
> Resume:
> 1. Restore frontend and tuner power.
> 2. (feeds > 0)? Set frequency for the tuner.
> 3. (feeds > 0)? Restore DMA transfer into previous state.
>
> What do you think about this?
> I need some feedback: is it worth coding?
> Other needed code is usual suspend / resume stuff.
>
> Is it worth powering off the tuner, if it isn't
> used?
>
> For my current usage, powering off the unused tuner
> gives more power savings than implementing suspend/resume.
>
> Marko Ristola
>
> ------------------------------
>
> // suspend to standby, ram or disk.
> int mantis_dvb_suspend(struct mantis_pci *mantis, pm_message_t
>     prevState, pm_message_t mesg)
> {
>         if (mantis->feeds > 0)
> mantis_dma_stop(mantis);
>
>         if (mantis->has_power)
>                 mantis_fe_powerdown(mantis); // power off tuner.
>
>         return 0;
> }
>
> void mantis_dvb_resume(struct mantis_pci *mantis, pm_message_t prevMesg)
> {
>        // power on frontend and tuner.
>        mantis_frontend_tuner_init(mantis);
>
>        if (mantis->feeds > 0 && mantis->fe->ops.tuner_ops.init)
>                 (mantis->fe->ops.init)(mantis->fe);
>
>         if (mantis->feeds > 0) {
>                 (mantis->fe->ops.set_frontend)(mantis->fe, NULL);
> mantis_dma_start(mantis);
>         }
> }
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
