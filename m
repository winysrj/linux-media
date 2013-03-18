Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:52054 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab3CRImy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 04:42:54 -0400
Message-ID: <5146D37D.7070506@ti.com>
Date: Mon, 18 Mar 2013 14:12:37 +0530
From: Sekhar Nori <nsekhar@ti.com>
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: Russell King <rmk+kernel@arm.linux.org.uk>,
	<davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	<linux-media@vger.kernel.org>
Subject: Re: [PATCH v3] media: davinci: kconfig: fix incorrect selects
References: <513EE45E.6050004@ti.com> <1363079692-16683-1-git-send-email-nsekhar@ti.com> <CA+V-a8v2-yGsfs_PXsq1OmcJmfYZzcjP2nO5DubdE_TLfghQ8g@mail.gmail.com>
In-Reply-To: <CA+V-a8v2-yGsfs_PXsq1OmcJmfYZzcjP2nO5DubdE_TLfghQ8g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 3/16/2013 2:06 PM, Prabhakar Lad wrote:
> Hi Sekhar,
> 
> Thanks for the patch!
> 
> On Tue, Mar 12, 2013 at 2:44 PM, Sekhar Nori <nsekhar@ti.com> wrote:
>> drivers/media/platform/davinci/Kconfig uses selects where
>> it should be using 'depends on'. This results in warnings of
>> the following sort when doing randconfig builds.
>>
>> warning: (VIDEO_DM6446_CCDC && VIDEO_DM355_CCDC && VIDEO_ISIF && VIDEO_DAVINCI_VPBE_DISPLAY) selects VIDEO_VPSS_SYSTEM which has unmet direct dependencies (MEDIA_SUPPORT && V4L_PLATFORM_DRIVERS && ARCH_DAVINCI)
>>
>> The VPIF kconfigs had a strange 'select' and 'depends on' cross
>> linkage which have been fixed as well by removing unneeded
>> VIDEO_DAVINCI_VPIF config symbol.
>>
>> Similarly, remove the unnecessary VIDEO_VPSS_SYSTEM and
>> VIDEO_VPFE_CAPTURE. They don't select any independent functionality
>> and were being used to manage code dependencies which can
>> be handled using makefile.
>>
>> Selecting video modules is now dependent on all ARCH_DAVINCI
>> instead of specific EVMs and SoCs earlier. This should help build
>> coverage. Remove unnecessary 'default y' for some config symbols.
>>
>> While at it, fix the Kconfig help text to make it more readable
>> and fix names of modules created during module build.
>>
>> Rename VIDEO_ISIF to VIDEO_DM365_ISIF as per suggestion from
>> Prabhakar.
>>
>> This patch has only been build tested; I have tried to not break
>> any existing assumptions. I do not have the setup to test video,
>> so any test reports welcome.
>>
> The series which I posted yesterday [1] for DM365 VPBE, uses a exported
> symbol 'vpss_enable_clock' so If I build vpbe as module it complains
> for following,
> 
> arch/arm/mach-davinci/built-in.o: In function `dm365_venc_setup_clock':
> pm_domain.c:(.text+0x302c): undefined reference to `vpss_enable_clock'
> pm_domain.c:(.text+0x3038): undefined reference to `vpss_enable_clock'
> pm_domain.c:(.text+0x3060): undefined reference to `vpss_enable_clock'
> pm_domain.c:(.text+0x306c): undefined reference to `vpss_enable_clock'
> 
> So how would you suggest to handle this VPSS config ?
> 
> [1] http://www.mail-archive.com/davinci-linux-open-source@linux.davincidsp.com/msg25443.html

I replied on the above thread. Lets continue the discussion there since
this error is not really related to this patch.

Thanks,
Sekhar
