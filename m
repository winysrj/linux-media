Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:33647 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab1IMK3n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Sep 2011 06:29:43 -0400
Content-Class: urn:content-classes:message
Subject: Re: omap3isp as a wakeup source
From: Tero Kristo <t-kristo@ti.com>
Reply-To: <t-kristo@ti.com>
To: Enrico <ebutera@users.berlios.de>
CC: "Sakari Ailus" <sakari.ailus@iki.fi>,
	"anish singh" <anish198519851985@gmail.com>,
	<linux-media@vger.kernel.org>,
	"Laurent Pinchart" <laurent.pinchart@ideasonboard.com>
In-Reply-To: <CA+2YH7tEfmXnfgyFwbCEi4u5viRESM_Qckbc4MceSwsn151q6A@mail.gmail.com>
References: <CA+2YH7s-BH=4vN-DUZJXa9DKrwYsZORWq-YR9fK7JV9236ntMQ@mail.gmail.com> <20110912202822.GB1845@valkosipuli.localdomain> <CAK7N6vpr8uJSHMgTnrd=FrnvYf_Oqy8D3ua__S63T3nEvqaKGw@mail.gmail.com> <4E6EFCFC.5030803@iki.fi>	<1315907297.2355.9.camel@sokoban> <CA+2YH7tEfmXnfgyFwbCEi4u5viRESM_Qckbc4MceSwsn151q6A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Sep 2011 13:29:26 +0300
Message-ID: <1315909766.2355.13.camel@sokoban>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2011-09-13 at 12:08 +0200, Enrico wrote:
> On Tue, Sep 13, 2011 at 11:48 AM, Tero Kristo <t-kristo@ti.com> wrote:
> > On Tue, 2011-09-13 at 08:49 +0200, Sakari Ailus wrote:
> >> anish singh wrote:
> >> > On Tue, Sep 13, 2011 at 1:58 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> >> >> On Mon, Sep 12, 2011 at 04:50:42PM +0200, Enrico wrote:
> >> >>> Hi,
> >> >>
> >> >> Hi Enrico,
> >> >>
> >> >>> While testing omap3isp+tvp5150 with latest Deepthy bt656 patches
> >> >>> (kernel 3.1rc4) i noticed that yavta hangs very often when grabbing
> >> >>> or, if not hanged, it grabs at max ~10fps.
> >> >>>
> >> >>> Then i noticed that tapping on the (serial) console made it "unblock"
> >> >>> for some frames, so i thought it doesn't prevent the cpu to go
> >> >>> idle/sleep. Using the boot arg "nohlt" the problem disappear and it
> >> >>> grabs at a steady 25fps.
> >> >>>
> >> >>> In the code i found a comment that says the camera can't be a wakeup
> >> >>> source but the camera powerdomain is instead used to decide to not go
> >> >>> idle, so at this point i think the camera powerdomain is not enabled
> >> >>> but i don't know how/where to enable it. Any ideas?
> >> >>
> >> >> I can confirm this indeed is the case --- ISP can't wake up the system ---
> >> >> but don't know how to prevent the system from going to sleep when using the
> >> >> ISP.
> >> > Had it been on android i think wakelock would have been very useful.
> >>
> >> I believe there are proper means to do this using more standard methods
> >> as well. Not being a PM expert, I don't know how.
> >>
> >> Cc Tero.
> >>
> >
> > Hi,
> >
> > I don't think there are proper means yet to do this, as camera is
> > somewhat a special case in omap3, it is apparently the only module that
> > is causing this kind of problem. However, you can prevent idle when
> > camera is active with something like this:
> >
> > diff --git a/arch/arm/mach-omap2/pm34xx.c b/arch/arm/mach-omap2/pm34xx.c
> > index 2789e0a..7fdf6e2 100644
> > --- a/arch/arm/mach-omap2/pm34xx.c
> > +++ b/arch/arm/mach-omap2/pm34xx.c
> > @@ -358,6 +358,9 @@ void omap_sram_idle(void)
> >                                omap3_per_save_context();
> >        }
> >
> > +       if (pwrdm_read_pwrst(cam_pwrdm) == PWRDM_POWER_ON)
> > +               clkdm_deny_idle(mpu_pwrdm->pwrdm_clkdms[0]);
> > +
> >        /* CORE */
> >        if (core_next_state < PWRDM_POWER_ON) {
> >                omap_uart_prepare_idle(0);
> >
> >
> >
> > -Tero
> 
> i think something related is already in
> arch/arm/mach-omap2/cpuidle34xx.c omap3_enter_idle_bm(...):
> 
> /*
>  * Prevent idle completely if CAM is active.
>  * CAM does not have wakeup capability in OMAP3.
>  */
> cam_state = pwrdm_read_pwrst(cam_pd);
> if (cam_state == PWRDM_POWER_ON) {
>         new_state = dev->safe_state;
>         goto select_state;
> }
> 
> 

Yea, this should take care of it already.

> But probably the power domain is not set to ON, and i don't know where
> it should be set. Maybe, as Laurent suggested, adding runtime PM
> support will fix it?

Powerdomain is automatically on if there are any clocks enabled on it.
If you make sure that ISP has some activity ongoing, then it should be
on. You can check the state of the camera powerdomain
from /sys/kernel/debug/pm_debug/count file, if you have mounted debugfs.

But yea, there might be some conflict also ongoing with lack of runtime
PM here, I haven't been looking at ISP related issues for a long time.

-Tero



Texas Instruments Oy, Tekniikantie 12, 02150 Espoo. Y-tunnus: 0115040-6. Kotipaikka: Helsinki
 

