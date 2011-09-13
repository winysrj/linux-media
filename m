Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:50826 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab1IML2z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Sep 2011 07:28:55 -0400
Date: Tue, 13 Sep 2011 14:28:51 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Enrico <ebutera@users.berlios.de>
Cc: t-kristo@ti.com, anish singh <anish198519851985@gmail.com>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Deepthy Ravi <deepthy.ravi@ti.com>
Subject: Re: omap3isp as a wakeup source
Message-ID: <20110913112851.GC1845@valkosipuli.localdomain>
References: <CA+2YH7s-BH=4vN-DUZJXa9DKrwYsZORWq-YR9fK7JV9236ntMQ@mail.gmail.com>
 <20110912202822.GB1845@valkosipuli.localdomain>
 <CAK7N6vpr8uJSHMgTnrd=FrnvYf_Oqy8D3ua__S63T3nEvqaKGw@mail.gmail.com>
 <4E6EFCFC.5030803@iki.fi>
 <1315907297.2355.9.camel@sokoban>
 <CA+2YH7vCLaCUhANZvWcEgcGxvjaauWxR=oE93t=wWELkHXtfcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+2YH7vCLaCUhANZvWcEgcGxvjaauWxR=oE93t=wWELkHXtfcw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 13, 2011 at 12:28:12PM +0200, Enrico wrote:
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
> >                                omap3_per_save_context();
> >        }
> >
> > +       if (pwrdm_read_pwrst(cam_pwrdm) == PWRDM_POWER_ON)
> > +               clkdm_deny_idle(mpu_pwrdm->pwrdm_clkdms[0]);
> > +
> >        /* CORE */
> >        if (core_next_state < PWRDM_POWER_ON) {
> >                omap_uart_prepare_idle(0);
> >
> >
> >
> > -Tero
> 
> 
> One more thing: i just noticed that in Deepthy bt656 patches there is
> one patch [1] to add cam regulators (1v8 and 2v8) to the omap3evm
> board file, i'm not using an omap3evm but maybe i should add them to
> my board file too?

In general, if your board doesn't require them (e.g. for sensors' use) you
should't add them.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
