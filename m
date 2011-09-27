Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:54263 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821Ab1I0HBZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Sep 2011 03:01:25 -0400
Message-ID: <4E8174D8.6060001@ti.com>
Date: Tue, 27 Sep 2011 12:31:44 +0530
From: Archit Taneja <archit@ti.com>
MIME-Version: 1.0
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
CC: "Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
	"Semwal, Sumit" <sumit.semwal@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH 3/5] [media]: OMAP_VOUT: Fix VSYNC IRQ handling in omap_vout_isr
References: <1316167233-1437-1-git-send-email-archit@ti.com>	 <1316167233-1437-4-git-send-email-archit@ti.com>	 <19F8576C6E063C45BE387C64729E739404EC941F86@dbde02.ent.ti.com>	 <4E7AD29C.4070804@ti.com>	 <19F8576C6E063C45BE387C64729E739404ECA54614@dbde02.ent.ti.com>	 <CAB2ybb8ab9jSFB1J_CQfObB11QcdtQ=6Kf9zdbg0v5Jckf09sw@mail.gmail.com>	 <CAB2ybb-rZgDvS9Bo6AJF=KVd0irXHa0S0LrPJ=SWr0daJ6gX1w@mail.gmail.com>	 <CAB2ybb8UGC=HK7jpYaDym8Y8iy=omwWiXrV7cdRw3k20e0NiZw@mail.gmail.com>	 <19F8576C6E063C45BE387C64729E739404ECA548CF@dbde02.ent.ti.com> <1317106147.1991.10.camel@deskari> <19F8576C6E063C45BE387C64729E739404ECA548E1@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E739404ECA548E1@dbde02.ent.ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 27 September 2011 12:24 PM, Hiremath, Vaibhav wrote:
>> -----Original Message-----
>> From: Valkeinen, Tomi
>> Sent: Tuesday, September 27, 2011 12:19 PM
>> To: Hiremath, Vaibhav
>> Cc: Semwal, Sumit; Taneja, Archit; linux-omap@vger.kernel.org; linux-
>> media@vger.kernel.org
>> Subject: RE: [PATCH 3/5] [media]: OMAP_VOUT: Fix VSYNC IRQ handling in
>> omap_vout_isr
>>
>> On Tue, 2011-09-27 at 12:09 +0530, Hiremath, Vaibhav wrote:
>>> Please look at the patch carefully, it does exactly same thing. I
>>> understand the use-case what Archit explained in the last email but in
>>> this patch context, the use-case change anything here in this patch.
>>
>> With the current code, the ISR code will be ran for a panel connected to
>> LCD1 output when VSYNC for LCD2 happens.
>>
>> After Archit's patch, this no longer happens.
>>
>> I don't know what the ISR code does, so it may not cause any problems,
>> but it sure doesn't sound right running the code when a wrong interrupt
>> happens.
>>
>
> If you look at the patch, the patch barely checks for the condition and
> makes sure that the interrupt is either of VSYNC or VSYNC2, else return. Rest everything is same.

It doesn't only make sure that the interrupt it one of them, it uses it 
later too in the check:

if (!(irqstatus & irq))
	goto vout_isr_err;
...
...

>
> The right fix is in streamon api, where you mask the interrupt before
> registering it.

If this is the right fix, we should have a purely selective method of 
selecting the interrupts. Even for OMAP3, we register interrupts for LCD 
and TV, and then check the interrupt in the handler using panel type. 
Now, since have 2 different interrupts for the same panel type, we have 
to further distinguish using the manager id.

Archit

>
> Thanks,
> Vaibhav
>
>>   Tomi
>>
>
>

