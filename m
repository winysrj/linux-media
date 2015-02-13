Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:54570 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752374AbbBMJYW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2015 04:24:22 -0500
Message-ID: <54DDC2B7.2080503@xs4all.nl>
Date: Fri, 13 Feb 2015 10:24:07 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Jurgen Kramer <gtmkramer@xs4all.nl>
CC: Raimonds Cicans <ray@apollo.lv>, linux-media@vger.kernel.org
Subject: Re: [REGRESSION] media: cx23885 broken by commit 453afdd "[media]
 cx23885: convert to vb2"
References: <54B24370.6010004@apollo.lv> <54C9E238.9090101@xs4all.nl>		 <54CA1EB4.8000103@apollo.lv> <54CA23BE.7050609@xs4all.nl>		 <54CE24F2.7090400@apollo.lv> <54CF4508.9070305@xs4all.nl>	 <1423065972.2650.1.camel@xs4all.nl> <54D24685.1000708@xs4all.nl> <1423070484.2650.3.camel@xs4all.nl> <54DDC00D.209@xs4all.nl>
In-Reply-To: <54DDC00D.209@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jurgen, Raimond,

On 02/13/2015 10:12 AM, Hans Verkuil wrote:
> Hi Jurgen,
> 
> On 02/04/2015 06:21 PM, Jurgen Kramer wrote:
>> On Wed, 2015-02-04 at 17:19 +0100, Hans Verkuil wrote:
>>> On 02/04/2015 05:06 PM, Jurgen Kramer wrote:
>>>> Hi Hans,
>>>>
>>>> On Mon, 2015-02-02 at 10:36 +0100, Hans Verkuil wrote:
>>>>> Raimonds and Jurgen,
>>>>>
>>>>> Can you both test with the following patch applied to the driver:
>>>>
>>>> Unfortunately the mpeg error is not (completely) gone:
>>>
>>> OK, I suspected that might be the case. Is the UNBALANCED warning
>>> gone with my vb2 patch?
> 
>>> When you see this risc error, does anything
>>> break (broken up video) or crash, or does it just keep on streaming?
> 
> Can you comment on this question?
> 
>>
>> The UNBALANCED warnings have not reappeared (so far).
> 
> And they are still gone? If that's the case, then I'll merge the patch
> fixing this for 3.20.
> 
> With respect to the risc error: the only reason I can think of is that it
> is a race condition when the risc program is updated. I'll see if I can
> spend some time on this today or on Monday. Can you give me an indication
> how often you see this risc error message?

Can you both apply this patch and let me know what it says the next time you
get a risc error message? I just realized that important information was never
logged, so with luck this might help me pinpoint the problem.

Thanks,

	Hans

diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index 1ad4994..b66b8d4 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -1628,7 +1628,7 @@ static int cx23885_irq_ts(struct cx23885_tsport *port, u32 status)
 			dprintk(7, " (VID_BC_MSK_OF      0x%08x)\n",
 				VID_BC_MSK_OF);
 
-		printk(KERN_ERR "%s: mpeg risc op code error\n", dev->name);
+		printk(KERN_ERR "%s: mpeg risc op code error %x %d\n", dev->name, status, port == &dev->ts2);
 
 		cx_clear(port->reg_dma_ctl, port->dma_ctl_val);
 		cx23885_sram_channel_dump(dev,

