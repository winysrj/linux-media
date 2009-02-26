Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51030 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541AbZBZLkA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2009 06:40:00 -0500
Date: Thu, 26 Feb 2009 08:39:28 -0300 (BRT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"mchehab@infradead.org" <mchehab@infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: [PATCH v4] v4l/tvp514x: make the module aware of rich people
In-Reply-To: <19F8576C6E063C45BE387C64729E739404279B65AC@dbde02.ent.ti.com>
Message-ID: <alpine.LRH.2.00.0902260839190.19426@caramujo.chehab.org>
References: <19F8576C6E063C45BE387C64729E739404279B65AC@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 26 Feb 2009, Hiremath, Vaibhav wrote:

> Hi Sebastian,
>
> I have validated the changes and it looks ok to me. As I mentioned the only issue I observed is, patch doesn't get applied cleanly (may be due to mail-server).
>
> Hans/Mauro,
>
> You can pull this patch.

Applied, thanks.
>
> Thanks,
> Vaibhav Hiremath
> Platform Support Products
> Texas Instruments Inc
> Ph: +91-80-25099927
>
>> -----Original Message-----
>> From: Sebastian Andrzej Siewior [mailto:bigeasy@linutronix.de]
>> Sent: Saturday, February 21, 2009 2:14 PM
>> To: Hiremath, Vaibhav
>> Cc: video4linux-list@redhat.com; mchehab@infradead.org; linux-
>> media@vger.kernel.org
>> Subject: Re: [PATCH v4] v4l/tvp514x: make the module aware of rich
>> people
>>
>> * Sebastian Andrzej Siewior | 2009-02-10 20:30:39 [+0100]:
>>
>>> because they might design two of those chips on a single board.
>>> You never know.
>>>
>>> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>>> ---
>>> v4: fix checkpatch issues
>>
>> I don't want to rush anything but is there any update on this?
>>
>> Sebastian
>
>

-- 
Cheers,
Mauro Carvalho Chehab
http://linuxtv.org
mchehab@infradead.org
