Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:60473 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab1I0GjJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Sep 2011 02:39:09 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Semwal, Sumit" <sumit.semwal@ti.com>
CC: "Taneja, Archit" <archit@ti.com>,
	"Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 27 Sep 2011 12:09:01 +0530
Subject: RE: [PATCH 3/5] [media]: OMAP_VOUT: Fix VSYNC IRQ handling in
 omap_vout_isr
Message-ID: <19F8576C6E063C45BE387C64729E739404ECA548CF@dbde02.ent.ti.com>
References: <1316167233-1437-1-git-send-email-archit@ti.com>
 <1316167233-1437-4-git-send-email-archit@ti.com>
 <19F8576C6E063C45BE387C64729E739404EC941F86@dbde02.ent.ti.com>
 <4E7AD29C.4070804@ti.com>
 <19F8576C6E063C45BE387C64729E739404ECA54614@dbde02.ent.ti.com>
 <CAB2ybb8ab9jSFB1J_CQfObB11QcdtQ=6Kf9zdbg0v5Jckf09sw@mail.gmail.com>
 <CAB2ybb-rZgDvS9Bo6AJF=KVd0irXHa0S0LrPJ=SWr0daJ6gX1w@mail.gmail.com>
 <CAB2ybb8UGC=HK7jpYaDym8Y8iy=omwWiXrV7cdRw3k20e0NiZw@mail.gmail.com>
In-Reply-To: <CAB2ybb8UGC=HK7jpYaDym8Y8iy=omwWiXrV7cdRw3k20e0NiZw@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -----Original Message-----
> From: Semwal, Sumit
> Sent: Tuesday, September 27, 2011 11:12 AM
> To: Hiremath, Vaibhav
> Cc: Taneja, Archit; Valkeinen, Tomi; linux-omap@vger.kernel.org; linux-
> media@vger.kernel.org
> Subject: Re: [PATCH 3/5] [media]: OMAP_VOUT: Fix VSYNC IRQ handling in
> omap_vout_isr
> 
> Hi Vaibhav,
> >>
> >> On Mon, Sep 26, 2011 at 3:49 PM, Hiremath, Vaibhav <hvaibhav@ti.com>
> wrote:
> >>>
> >>> > -----Original Message-----
> >>> > From: Taneja, Archit
> >>> > Sent: Thursday, September 22, 2011 11:46 AM
> >>> > To: Hiremath, Vaibhav
> >>> > Cc: Valkeinen, Tomi; linux-omap@vger.kernel.org; Semwal, Sumit;
> linux-
> >>> > media@vger.kernel.org
> >>> > Subject: Re: [PATCH 3/5] [media]: OMAP_VOUT: Fix VSYNC IRQ handling
> in
> >>> > omap_vout_isr
> >>> >
> >>> > Hi,
> >
> >   <snip>
> >>>
> >>> > >> -          if (!(irqstatus&  (DISPC_IRQ_VSYNC |
> DISPC_IRQ_VSYNC2)))
> >>> > >> +          if (mgr_id == OMAP_DSS_CHANNEL_LCD)
> >>> > >> +                  irq = DISPC_IRQ_VSYNC;
> >>> > >> +          else if (mgr_id == OMAP_DSS_CHANNEL_LCD2)
> >>> > >> +                  irq = DISPC_IRQ_VSYNC2;
> >>> > >> +          else
> >>> > >> +                  goto vout_isr_err;
> >>> > >> +
> >>> > >> +          if (!(irqstatus&  irq))
> >>> > >>                    goto vout_isr_err;
> >>> > >>            break;
> >>> > > I understand what this patch meant for, but I am more curious to
> know
> >>> > > What is value addition of this patch?
> >>> > >
> >>> > > if (!(irqstatus&  (DISPC_IRQ_VSYNC | DISPC_IRQ_VSYNC2)))
> >>> > >
> >>> > > Vs
> >>> > >
> >>> > > if (mgr_id == OMAP_DSS_CHANNEL_LCD)
> >>> > >     irq = DISPC_IRQ_VSYNC;
> >>> > > else if (mgr_id == OMAP_DSS_CHANNEL_LCD2)
> >>> > >     irq = DISPC_IRQ_VSYNC2;
> >>> > >
> >>> > > Isn't this same, because we are not doing anything separate and
> special
> >>> > > for VSYNC and VSYNC2?
> >>> >
> >>> > Consider a use case where the primary LCD panel(connected to LCD
> >>> > manager) is configured at a 60 Hz refresh rate, and the secondary
> >>> > panel(connected to LCD2) refreshes at 30 Hz. Let the overlay
> >>> > configuration be something like this:
> >>> >
> >>> > /dev/video1----->overlay1----->LCD manager----->Primary panel(60 Hz)
> >>> >
> >>> >
> >>> > /dev/video2----->overlay2----->LCD2 manager----->Secondary Panel(30
> Hz)
> >>> >
> >>> >
> >>> > Now if we are doing streaming on both video1 and video2, since we
> deque
> >>> > on either VSYNC or VSYNC2, video2 buffers will deque faster than the
> >>> > panels refresh, which is incorrect. So for video2, we should only
> deque
> >>> > when we get a VSYNC2 interrupt. Thats why there is a need to
> correlate
> >>> > the interrupt and the overlay manager.
> >>> >
> >>>
> >>> Archit,
> >>>
> >>> I think I am still not understood or convinced with your description
> above,
> >>>
> >>> The code snippet which we are referring here, does check whether the
> >>> interrupt is either VSYNC or VSYNC2, else fall back to "vout_isr_err".
> >
> >
> I am not quite sure I understand what is the confusing part here -
> below is my understanding; please correct me if you think otherwise.
> As I understand, this patch creates a (missing) correlation between a
> manager and the corresponding ISR. The earlier code would accept a
> VSYNC2 for LCD1 manager, which is not the correct thing to do.
> That is why the check of 'if ((mgr==LCD) && (IRQ==VSYNC))' kind of
> thing is needed; Which part of this do you think the above patch
> doesn't do? Or, do you think it is not needed / done correctly?
Sumit,

Please look at the patch carefully, it does exactly same thing. I understand the use-case what Archit explained in the last email but in this patch context, the use-case change anything here in this patch. 

Can you review it carefully again?

Thanks,
Vaibhav
> >>>
> >>> For me both are doing same thing, the original code is optimized way
> of implementation. Can you please review it again?
> >>>
> >>> Thanks,
> >>> Vaibhav
> >
> >
> Thanks and best regards,
> ~Sumit.
> >>>
> >>> <snip>
