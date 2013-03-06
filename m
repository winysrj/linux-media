Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:46102 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942Ab3CFKHb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Mar 2013 05:07:31 -0500
Message-ID: <51371553.5030103@ti.com>
Date: Wed, 6 Mar 2013 15:37:15 +0530
From: Sekhar Nori <nsekhar@ti.com>
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: Prabhakar Lad <prabhakar.lad@ti.com>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	<davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	<linux-media@vger.kernel.org>
Subject: Re: [PATCH] media: davinci: kconfig: fix incorrect selects
References: <1362492801-13202-1-git-send-email-nsekhar@ti.com> <CA+V-a8u0XLAN72ky05JO_4vvoMjnHXoXS7JAk6OPO3r8r46CLw@mail.gmail.com>
In-Reply-To: <CA+V-a8u0XLAN72ky05JO_4vvoMjnHXoXS7JAk6OPO3r8r46CLw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 3/6/2013 2:59 PM, Prabhakar Lad wrote:

>>  config VIDEO_DAVINCI_VPIF_DISPLAY
>>         tristate "DM646x/DA850/OMAPL138 EVM Video Display"
>> -       depends on VIDEO_DEV && (MACH_DAVINCI_DM6467_EVM || MACH_DAVINCI_DA850_EVM)
>> +       depends on VIDEO_DEV && (MACH_DAVINCI_DM6467_EVM || MACH_DAVINCI_DA850_EVM) && VIDEO_DAVINCI_VPIF
>>         select VIDEOBUF2_DMA_CONTIG
>> -       select VIDEO_DAVINCI_VPIF
>>         select VIDEO_ADV7343 if MEDIA_SUBDRV_AUTOSELECT
>>         select VIDEO_THS7303 if MEDIA_SUBDRV_AUTOSELECT
>>         help
>> @@ -15,9 +14,8 @@ config VIDEO_DAVINCI_VPIF_DISPLAY
>>
>>  config VIDEO_DAVINCI_VPIF_CAPTURE
>>         tristate "DM646x/DA850/OMAPL138 EVM Video Capture"
>> -       depends on VIDEO_DEV && (MACH_DAVINCI_DM6467_EVM || MACH_DAVINCI_DA850_EVM)
>> +       depends on VIDEO_DEV && (MACH_DAVINCI_DM6467_EVM || MACH_DAVINCI_DA850_EVM) && VIDEO_DAVINCI_VPIF
>>         select VIDEOBUF2_DMA_CONTIG
>> -       select VIDEO_DAVINCI_VPIF
>>         help
>>           Enables Davinci VPIF module used for captur devices.
>>           This module is common for following DM6467/DA850/OMAPL138
>> @@ -28,7 +26,7 @@ config VIDEO_DAVINCI_VPIF_CAPTURE
>>
>>  config VIDEO_DAVINCI_VPIF
>>         tristate "DaVinci VPIF Driver"
>> -       depends on VIDEO_DAVINCI_VPIF_DISPLAY || VIDEO_DAVINCI_VPIF_CAPTURE
>> +       depends on ARCH_DAVINCI
> 
> It would be better if this was  depends on MACH_DAVINCI_DM6467_EVM ||
> MACH_DAVINCI_DA850_EVM
> rather than 'ARCH_DAVINCI' then you can remove 'MACH_DAVINCI_DM6467_EVM' and
> 'MACH_DAVINCI_DA850_EVM' dependency from VIDEO_DAVINCI_VPIF_DISPLAY and
> VIDEO_DAVINCI_VPIF_CAPTURE. So it would be just 'depends on VIDEO_DEV
> && VIDEO_DAVINCI_VPIF'

I could, but vpif.c seems pretty board independent to me. Are you sure
no other board would like to build vpif.c? BTW, are vpif_display.c and
vpif_capture.c really that board specific? May be we can all make them
depend on ARCH_DAVINCI?

> 
> BTW this patch doesn’t apply on3.9.0-rc1.

Oops. I based this on a handy v3.8. I will fix.

Thanks,
sekhar
