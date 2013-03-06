Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:48215 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166Ab3CFKfk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2013 05:35:40 -0500
Received: by mail-wg0-f46.google.com with SMTP id fg15so7088448wgb.1
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2013 02:35:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5137191F.6050707@ti.com>
References: <1362492801-13202-1-git-send-email-nsekhar@ti.com>
 <CA+V-a8u0XLAN72ky05JO_4vvoMjnHXoXS7JAk6OPO3r8r46CLw@mail.gmail.com>
 <51371553.5030103@ti.com> <CA+V-a8uRWQxcBSoTkuDAqzzCyR2e20JHEWzVuS39389QEoPazg@mail.gmail.com>
 <5137191F.6050707@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 6 Mar 2013 16:05:18 +0530
Message-ID: <CA+V-a8s_x_X_GdQ0aa36e-B3DhxpXJ5vzsce0yqPcn78g81m+w@mail.gmail.com>
Subject: Re: [PATCH] media: davinci: kconfig: fix incorrect selects
To: Sekhar Nori <nsekhar@ti.com>
Cc: Prabhakar Lad <prabhakar.lad@ti.com>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	davinci-linux-open-source@linux.davincidsp.com,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 6, 2013 at 3:53 PM, Sekhar Nori <nsekhar@ti.com> wrote:
> On 3/6/2013 3:46 PM, Prabhakar Lad wrote:
>> Sekhar,
>>
>> On Wed, Mar 6, 2013 at 3:37 PM, Sekhar Nori <nsekhar@ti.com> wrote:
>>> On 3/6/2013 2:59 PM, Prabhakar Lad wrote:
>>>
>>>>>  config VIDEO_DAVINCI_VPIF_DISPLAY
>>>>>         tristate "DM646x/DA850/OMAPL138 EVM Video Display"
>>>>> -       depends on VIDEO_DEV && (MACH_DAVINCI_DM6467_EVM || MACH_DAVINCI_DA850_EVM)
>>>>> +       depends on VIDEO_DEV && (MACH_DAVINCI_DM6467_EVM || MACH_DAVINCI_DA850_EVM) && VIDEO_DAVINCI_VPIF
>>>>>         select VIDEOBUF2_DMA_CONTIG
>>>>> -       select VIDEO_DAVINCI_VPIF
>>>>>         select VIDEO_ADV7343 if MEDIA_SUBDRV_AUTOSELECT
>>>>>         select VIDEO_THS7303 if MEDIA_SUBDRV_AUTOSELECT
>>>>>         help
>>>>> @@ -15,9 +14,8 @@ config VIDEO_DAVINCI_VPIF_DISPLAY
>>>>>
>>>>>  config VIDEO_DAVINCI_VPIF_CAPTURE
>>>>>         tristate "DM646x/DA850/OMAPL138 EVM Video Capture"
>>>>> -       depends on VIDEO_DEV && (MACH_DAVINCI_DM6467_EVM || MACH_DAVINCI_DA850_EVM)
>>>>> +       depends on VIDEO_DEV && (MACH_DAVINCI_DM6467_EVM || MACH_DAVINCI_DA850_EVM) && VIDEO_DAVINCI_VPIF
>>>>>         select VIDEOBUF2_DMA_CONTIG
>>>>> -       select VIDEO_DAVINCI_VPIF
>>>>>         help
>>>>>           Enables Davinci VPIF module used for captur devices.
>>>>>           This module is common for following DM6467/DA850/OMAPL138
>>>>> @@ -28,7 +26,7 @@ config VIDEO_DAVINCI_VPIF_CAPTURE
>>>>>
>>>>>  config VIDEO_DAVINCI_VPIF
>>>>>         tristate "DaVinci VPIF Driver"
>>>>> -       depends on VIDEO_DAVINCI_VPIF_DISPLAY || VIDEO_DAVINCI_VPIF_CAPTURE
>>>>> +       depends on ARCH_DAVINCI
>>>>
>>>> It would be better if this was  depends on MACH_DAVINCI_DM6467_EVM ||
>>>> MACH_DAVINCI_DA850_EVM
>>>> rather than 'ARCH_DAVINCI' then you can remove 'MACH_DAVINCI_DM6467_EVM' and
>>>> 'MACH_DAVINCI_DA850_EVM' dependency from VIDEO_DAVINCI_VPIF_DISPLAY and
>>>> VIDEO_DAVINCI_VPIF_CAPTURE. So it would be just 'depends on VIDEO_DEV
>>>> && VIDEO_DAVINCI_VPIF'
>>>
>>> I could, but vpif.c seems pretty board independent to me. Are you sure
>>> no other board would like to build vpif.c? BTW, are vpif_display.c and
>>> vpif_capture.c really that board specific? May be we can all make them
>>> depend on ARCH_DAVINCI?
>>>
>> VPIF is present only in DM646x and DA850/OMAP-L1138.
>> vpif.c is common file which is used by vpif_capture and vpif_display.
>
> So vpif.c per se doesn't do anything useful. Why the dependency on EVMs?
> There are other boards for these platform which could use VPIF.
>
yep agreed!

Regards,
--Prabhakar

> Thanks,
> Sekhar
