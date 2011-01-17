Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54674 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab1AQPXq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jan 2011 10:23:46 -0500
Received: by ewy5 with SMTP id 5so2666848ewy.19
        for <linux-media@vger.kernel.org>; Mon, 17 Jan 2011 07:23:45 -0800 (PST)
Message-ID: <4D345EAE.3040303@mvista.com>
Date: Mon, 17 Jan 2011 18:22:22 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
MIME-Version: 1.0
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>
CC: LMML <linux-media@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH v14 1/2] davinci vpbe: platform specific additions
References: <B85A65D85D7EB246BE421B3FB0FBB5930247F9A823@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB5930247F9A823@dbde02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello.

Hadli, Manjunath wrote:

>>> This patch implements the overall device creation for the Video 
>>> display driver.

>>     It does not only that...

>>> Signed-off-by: Manjunath Hadli<manjunath.hadli@ti.com>
>>> Acked-by: Muralidharan Karicheri<m-karicheri2@ti.com>
>>> Acked-by: Hans Verkuil<hverkuil@xs4all.nl>
>> [...]

>>> diff --git a/arch/arm/mach-davinci/devices.c 
>>> b/arch/arm/mach-davinci/devices.c index 22ebc64..f435c7d 100644
>>> --- a/arch/arm/mach-davinci/devices.c
>>> +++ b/arch/arm/mach-davinci/devices.c
>>> @@ -33,6 +33,8 @@
>>>   #define DM365_MMCSD0_BASE	     0x01D11000
>>>   #define DM365_MMCSD1_BASE	     0x01D00000
>>>
>>> +void __iomem  *davinci_sysmodbase;
>>> +

>>     I think this should be added in a sperate patch.

    I meant to type "separate". :-)

>>> diff --git a/arch/arm/mach-davinci/include/mach/dm644x.h 
>>> b/arch/arm/mach-davinci/include/mach/dm644x.h
>>> index 5a1b26d..790925f 100644
>>> --- a/arch/arm/mach-davinci/include/mach/dm644x.h
>>> +++ b/arch/arm/mach-davinci/include/mach/dm644x.h
>>> @@ -40,8 +44,14 @@
>>>   #define DM644X_ASYNC_EMIF_DATA_CE2_BASE 0x06000000
>>>   #define DM644X_ASYNC_EMIF_DATA_CE3_BASE 0x08000000
>>>
>>> +/* VPBE register base addresses */
>>> +#define DM644X_VPSS_REG_BASE		0x01c73400
>>> +#define DM644X_VENC_REG_BASE		0x01C72400
>>> +#define DM644X_OSD_REG_BASE		0x01C72600

>>     Note that for other devices we don't have '_REG' in such macros. Would make sense to delete it here for consistency.

> You mean other devices like Dm355/Dm365?

    No, I mean macros defining the base addresses of the other SoC devices (like 
EMAC and AEMIF you have just above your macros).

WBR, Sergei

