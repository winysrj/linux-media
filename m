Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:55230 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276Ab1IVGNU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Sep 2011 02:13:20 -0400
Message-ID: <4E7AD29C.4070804@ti.com>
Date: Thu, 22 Sep 2011 11:45:56 +0530
From: Archit Taneja <archit@ti.com>
MIME-Version: 1.0
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
CC: "Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Semwal, Sumit" <sumit.semwal@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH 3/5] [media]: OMAP_VOUT: Fix VSYNC IRQ handling in omap_vout_isr
References: <1316167233-1437-1-git-send-email-archit@ti.com> <1316167233-1437-4-git-send-email-archit@ti.com> <19F8576C6E063C45BE387C64729E739404EC941F86@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E739404EC941F86@dbde02.ent.ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Wednesday 21 September 2011 07:04 PM, Hiremath, Vaibhav wrote:
>> -----Original Message-----
>> From: Taneja, Archit
>> Sent: Friday, September 16, 2011 3:31 PM
>> To: Hiremath, Vaibhav
>> Cc: Valkeinen, Tomi; linux-omap@vger.kernel.org; Semwal, Sumit; linux-
>> media@vger.kernel.org; Taneja, Archit
>> Subject: [PATCH 3/5] [media]: OMAP_VOUT: Fix VSYNC IRQ handling in
>> omap_vout_isr
>>
>> Currently, in omap_vout_isr(), if the panel type is DPI, and if we
>> get either VSYNC or VSYNC2 interrupts, we proceed ahead to set the
>> current buffers state to VIDEOBUF_DONE and prepare to display the
>> next frame in the queue.
>>
>> On OMAP4, because we have 2 LCD managers, the panel type itself is not
>> sufficient to tell if we have received the correct irq, i.e, we shouldn't
>> proceed ahead if we get a VSYNC interrupt for LCD2 manager, or a VSYNC2
>> interrupt for LCD manager.
>>
>> Fix this by correlating LCD manager to VSYNC interrupt and LCD2 manager
>> to VSYNC2 interrupt.
>>
>> Signed-off-by: Archit Taneja<archit@ti.com>
>> ---
>>   drivers/media/video/omap/omap_vout.c |   14 +++++++++++---
>>   1 files changed, 11 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/media/video/omap/omap_vout.c
>> b/drivers/media/video/omap/omap_vout.c
>> index c5f2ea0..20638c3 100644
>> --- a/drivers/media/video/omap/omap_vout.c
>> +++ b/drivers/media/video/omap/omap_vout.c
>> @@ -566,8 +566,8 @@ err:
>>
>>   static void omap_vout_isr(void *arg, unsigned int irqstatus)
>>   {
>> -	int ret, fid;
>> -	u32 addr;
>> +	int ret, fid, mgr_id;
>> +	u32 addr, irq;
>>   	struct omap_overlay *ovl;
>>   	struct timeval timevalue;
>>   	struct omapvideo_info *ovid;
>> @@ -583,6 +583,7 @@ static void omap_vout_isr(void *arg, unsigned int
>> irqstatus)
>>   	if (!ovl->manager || !ovl->manager->device)
>>   		return;
>>
>> +	mgr_id = ovl->manager->id;
>>   	cur_display = ovl->manager->device;
>>
>>   	spin_lock(&vout->vbq_lock);
>> @@ -590,7 +591,14 @@ static void omap_vout_isr(void *arg, unsigned int
>> irqstatus)
>>
>>   	switch (cur_display->type) {
>>   	case OMAP_DISPLAY_TYPE_DPI:
>> -		if (!(irqstatus&  (DISPC_IRQ_VSYNC | DISPC_IRQ_VSYNC2)))
>> +		if (mgr_id == OMAP_DSS_CHANNEL_LCD)
>> +			irq = DISPC_IRQ_VSYNC;
>> +		else if (mgr_id == OMAP_DSS_CHANNEL_LCD2)
>> +			irq = DISPC_IRQ_VSYNC2;
>> +		else
>> +			goto vout_isr_err;
>> +
>> +		if (!(irqstatus&  irq))
>>   			goto vout_isr_err;
>>   		break;
> I understand what this patch meant for, but I am more curious to know
> What is value addition of this patch?
>
> if (!(irqstatus&  (DISPC_IRQ_VSYNC | DISPC_IRQ_VSYNC2)))
>
> Vs
>
> if (mgr_id == OMAP_DSS_CHANNEL_LCD)
> 	irq = DISPC_IRQ_VSYNC;
> else if (mgr_id == OMAP_DSS_CHANNEL_LCD2)
> 	irq = DISPC_IRQ_VSYNC2;
>
> Isn't this same, because we are not doing anything separate and special
> for VSYNC and VSYNC2?

Consider a use case where the primary LCD panel(connected to LCD 
manager) is configured at a 60 Hz refresh rate, and the secondary 
panel(connected to LCD2) refreshes at 30 Hz. Let the overlay 
configuration be something like this:

/dev/video1----->overlay1----->LCD manager----->Primary panel(60 Hz)


/dev/video2----->overlay2----->LCD2 manager----->Secondary Panel(30 Hz)


Now if we are doing streaming on both video1 and video2, since we deque 
on either VSYNC or VSYNC2, video2 buffers will deque faster than the 
panels refresh, which is incorrect. So for video2, we should only deque 
when we get a VSYNC2 interrupt. Thats why there is a need to correlate 
the interrupt and the overlay manager.

Regards,
Archit

>
> Thanks,
> Vaibhav
>
>
>>   	case OMAP_DISPLAY_TYPE_VENC:
>> --
>> 1.7.1
>
>

