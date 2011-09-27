Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:50760 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751327Ab1I0HFu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Sep 2011 03:05:50 -0400
Subject: RE: [PATCH 3/5] [media]: OMAP_VOUT: Fix VSYNC IRQ handling in
 omap_vout_isr
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
Cc: "Semwal, Sumit" <sumit.semwal@ti.com>,
	"Taneja, Archit" <archit@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <19F8576C6E063C45BE387C64729E739404ECA548E1@dbde02.ent.ti.com>
References: <1316167233-1437-1-git-send-email-archit@ti.com>
	 <1316167233-1437-4-git-send-email-archit@ti.com>
	 <19F8576C6E063C45BE387C64729E739404EC941F86@dbde02.ent.ti.com>
	 <4E7AD29C.4070804@ti.com>
	 <19F8576C6E063C45BE387C64729E739404ECA54614@dbde02.ent.ti.com>
	 <CAB2ybb8ab9jSFB1J_CQfObB11QcdtQ=6Kf9zdbg0v5Jckf09sw@mail.gmail.com>
	 <CAB2ybb-rZgDvS9Bo6AJF=KVd0irXHa0S0LrPJ=SWr0daJ6gX1w@mail.gmail.com>
	 <CAB2ybb8UGC=HK7jpYaDym8Y8iy=omwWiXrV7cdRw3k20e0NiZw@mail.gmail.com>
	 <19F8576C6E063C45BE387C64729E739404ECA548CF@dbde02.ent.ti.com>
	 <1317106147.1991.10.camel@deskari>
	 <19F8576C6E063C45BE387C64729E739404ECA548E1@dbde02.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Sep 2011 10:05:45 +0300
Message-ID: <1317107145.1991.16.camel@deskari>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2011-09-27 at 12:24 +0530, Hiremath, Vaibhav wrote:
> If you look at the patch, the patch barely checks for the condition
> and
> makes sure that the interrupt is either of VSYNC or VSYNC2, else
> return. Rest everything is same.

This is what the current code does, in clearer form and slightly pseudo
code:

if (irq == VSYNC || irq == VSYNC2) {
	do isr stuff
}

This is what it does after Archit's patch:

if ((lcd == LCD1 && irq == VSYNC) || (lcd == LCD2 && irq == VSYNC2)) {
	do isr stuff;
}

I see a clear difference there. Or am I missing something?

> The right fix is in streamon api, where you mask the interrupt before
> registering it.

I'm not familiar with v4l so I don't know what that means, but yes, it
would be better if it's possible to only register for the needed
interrupts.

But the ISR code is still needed. If you are using both LCDs, you will
get both interrupts and you need to check if the interrupt is for the
right output.

 Tomi


