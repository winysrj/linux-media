Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1Jnj2S-0003Rw-SC
	for linux-dvb@linuxtv.org; Mon, 21 Apr 2008 01:33:42 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Mon, 21 Apr 2008 01:25:13 +0200
References: <47F9E95D.6070705@yahoo.de>
	<200804180321.07891@orion.escape-edv.de> <480B9CDE.20800@yahoo.de>
In-Reply-To: <480B9CDE.20800@yahoo.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804210125.13638@orion.escape-edv.de>
Subject: Re: [linux-dvb] High CPU load in "top" due to budget_av slot polling
Reply-To: linux-dvb@linuxtv.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Robert Schedel wrote:
> Oliver Endriss wrote:
> > Robert Schedel wrote:
> >> Oliver Endriss wrote:
> >>> Robert Schedel wrote:
> >>>>
> >>>> Enabling debug traces shows that polling for the PSR in function 
> >>>> 'saa7146_wait_for_debi_done_sleep' constantly times out after 250x1ms 
> >>>> sleeps:
> >>>>
> >>>>  > saa7146: saa7146_wait_for_debi_done_sleep(): saa7146 (0): 
> >>>> saa7146_wait_for_debi_done_sleep timed out while waiting for transfer 
> >>>> completion
> >>>>
> >>>> Increasing the 250ms did not avoid the timeout. And as I understood from 
> >>>> previous list mails, this timeout is normal when no CI/CAM is connected 
> >>>> to the DEBI. However, for me the high frequency polling does not make 
> >>>> sense if someone does not plan to plug in a CI/CAM.
> >>>>
> >>>> When commenting out two lines in 'dvb_ca_en50221_thread_update_delay' to 
> >>>> increase the polling timer for slotstate NONE from 100ms (!) to 60s, the 
> >>>> CPU load went down to 0. So this is some kind of workaround for me.
> >>> Afaics the polling interval could be increased to something like 5s or
> >>> 10s if (and only if) the slot is empty. Could you provide a patch?
> >> Attached a patch for 2.6.24.4. Opinions?
> > 
> > Basically it should work but it has to be tested with CI/CAM, too.
> 
> Correct, unfortunately I cannot test it against a CI.

@all:
Could someone who runs budget-av with a CAM please test Robert's patch?
Thanks!

> > Furthermore it is not sufficient to test with budget-av because many
> > other drivers will be affected.
> > 
> > So I would prefer a patch which does not touch behaviour for other card
> > drivers (if possible).
> 
> To my understanding of the DVB code dvb_ca_en50221 is only referenced by 
> budget_av and budget_ci, at least in the vanilla kernel 2.6.25.

You are right (and I am a bit surprised).

> The  patch only changes the timer for slot state EMPTY if 
> DVB_CA_EN50221_FLAG_IRQ_CAMCHANGE is not set, which is for
> 1) budget_av
> 2) budget_ci if the CI firmware version is 0xa2 (because IRQs for CAM 
> change are not supported in this version)
> 
> And those two cases are probably affected by the load issue and should 
> be fixed.
> 
> Of course, we could add another DVB_CA_EN50221 flag solely for budget_av 
> to exclude case 2), but does this make sense? Who is available to test 
> against a budget_ci with FW=0xa2 whether it is affected by the load issue?

After looking closer at your patch I saw that most changes are comments
or coding-style related. Afaics the patch should be safe.

So I will commit your patch next weekend, unless someone spots a
problem.

> >> Regarding DEBI_E: Just found a av7110 code comment which also reflects
> >> what my recent tests showed:
> >>           /* Note: Don't try to handle the DEBI error irq (MASK_18), in
> >>            * intel mode the timeout is asserted all the time...
> >>            */
> >>
> >> So really only DEBI_S would be left, see below.
> > 
> > Did you check whether DEBI_S and/or DEBI_E are ever asserted with your
> > setup? If not, an interrupt would never occur anyway...
> 
> DEBI_E was always asserted (as described in the av7110 code comment), so 
> it was worthless. DEBI_S was never asserted without CI (therefore the 
> 250ms timeout), so it would probably only be received when a CI is used. 
> But as described in my other email with measurements, it seems that 
> there is no need to optimize the debi_done function further.

Ok, thanks for checking.

> >>>> 4. Are the high timeout periods in debi_done (50ms/250ms) in relation to 
> >>>> the 100ms poll timer intended? (I found the recent patch to this code in 
> >>>> the mailing list end of last year)
> >>> That patch was applied to reduce the load on the pci bus in busy-wait
> >>> mode. Basically it did not change anything for cam polling. (In fact I
> >>> was not aware that the CAM was polled every 100ms. Imho this should be
> >>> fixed.)
> >> Only wondered whether the 250ms might have been smaller in former driver
> >> versions.
> > 
> > Iirc it should be even worse with older drivers.
> > 
> > Basically the 250ms timeout is just a last resort to escape from the
> > loop, if the debi transfer hangs for some reason. We might try to reduce
> > the timeout but I don't know how far we can go. (Touching 'magic' values
> > might be dangeous.)
> 
> As above, according to my measurements we would not need to change the 
> 250ms timeout.

Agreed.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
