Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:62884 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934411Ab3DHLiq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 07:38:46 -0400
MIME-Version: 1.0
In-Reply-To: <51629B3D.4080905@ti.com>
References: <1364903044-13752-1-git-send-email-prabhakar.csengg@gmail.com>
 <1364903044-13752-2-git-send-email-prabhakar.csengg@gmail.com> <51629B3D.4080905@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 8 Apr 2013 17:08:24 +0530
Message-ID: <CA+V-a8swx0LB0eK0bZwcuFhVCW2UB8Bvm3ebwMQifo=-TB6ASA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] media: davinci: vpss: enable vpss clocks
To: Sekhar Nori <nsekhar@ti.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	LAK <linux-arm-kernel@lists.infradead.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sekhar,

On Mon, Apr 8, 2013 at 3:56 PM, Sekhar Nori <nsekhar@ti.com> wrote:
> On 4/2/2013 5:14 PM, Prabhakar lad wrote:
>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>
>> By default the VPSS clocks were enabled in capture driver
>> for davinci family which creates duplicates for dm355/dm365/dm644x.
>> This patch adds support to enable the VPSS clocks in VPSS driver,
>> which avoids duplication of code and also adding clock aliases.
>>
>> This patch uses PM runtime API to enable/disable instead common clock
>> framework. con_ids for master and slave clocks of vpss is added in pm_domain
>
> Common clock framework in not (yet) used on DaVinci, so this is misleading.
>
OK, I'll make it 'This patch uses PM runtime API to enable/disable
clock, instead
of Davinci specific clock framework. con_ids for master and slave
clocks of vpss is added in pm_domain'

>> diff --git a/arch/arm/mach-davinci/pm_domain.c b/arch/arm/mach-davinci/pm_domain.c
>> index c90250e..445b10b 100644
>> --- a/arch/arm/mach-davinci/pm_domain.c
>> +++ b/arch/arm/mach-davinci/pm_domain.c
>> @@ -53,7 +53,7 @@ static struct dev_pm_domain davinci_pm_domain = {
>>
>>  static struct pm_clk_notifier_block platform_bus_notifier = {
>>       .pm_domain = &davinci_pm_domain,
>> -     .con_ids = { "fck", NULL, },
>> +     .con_ids = { "fck", "master", "slave", NULL, },
>
> NULL is sentinel so you can drop the ',' after that. Apart from that,
> for the mach-davinci parts:
>
OK

Regards,
--Prabhakar

> Acked-by: Sekhar Nori <nsekhar@ti.com>
>
> Thanks,
> Sekhar
