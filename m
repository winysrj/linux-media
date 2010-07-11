Return-path: <linux-media-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:52006 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab0GKPe3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Jul 2010 11:34:29 -0400
Message-ID: <4C39E481.1050903@kolumbus.fi>
Date: Sun, 11 Jul 2010 18:34:25 +0300
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Oliver Endriss <o.endriss@gmx.de>
Subject: Thoughts about suspending DVB C PCI device transparently
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi all.

Once in a time I wrote into Mantis driver Suspend / resume
code. The idea was, that bridge driver (mantis_dvb.c) will
handle the suspend / resume transparently to the application.

With a PCI device this was rather easy to achieve.
With xine, there was just a glitch with video and audio
after resume.

So after suspend, frontend was tuned into the original
frequency, and the DMA transfer state was restored.

Suspend:
1. Turn off possible DMA transfer if active (feeds > 0)
2. Remember tuner power on state.
3. Do tuner and fronted power off.

Resume:
1. Restore frontend and tuner power.
2. (feeds > 0)? Set frequency for the tuner.
3. (feeds > 0)? Restore DMA transfer into previous state.

What do you think about this?
I need some feedback: is it worth coding?
Other needed code is usual suspend / resume stuff.

Is it worth powering off the tuner, if it isn't
used?

For my current usage, powering off the unused tuner
gives more power savings than implementing suspend/resume.

Marko Ristola

------------------------------

// suspend to standby, ram or disk.
int mantis_dvb_suspend(struct mantis_pci *mantis, pm_message_t
     prevState, pm_message_t mesg)
{
         if (mantis->feeds > 0)
mantis_dma_stop(mantis);

         if (mantis->has_power)
                 mantis_fe_powerdown(mantis); // power off tuner.

         return 0;
}

void mantis_dvb_resume(struct mantis_pci *mantis, pm_message_t prevMesg)
{
        // power on frontend and tuner.
        mantis_frontend_tuner_init(mantis);

        if (mantis->feeds > 0 && mantis->fe->ops.tuner_ops.init)
                 (mantis->fe->ops.init)(mantis->fe);

         if (mantis->feeds > 0) {
                 (mantis->fe->ops.set_frontend)(mantis->fe, NULL);
mantis_dma_start(mantis);
         }
}

