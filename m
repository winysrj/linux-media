Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:36834 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112Ab3DLL07 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Apr 2013 07:26:59 -0400
MIME-Version: 1.0
In-Reply-To: <5167EDF9.5070009@ti.com>
References: <1365764734-16515-1-git-send-email-prabhakar.csengg@gmail.com> <5167EDF9.5070009@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 12 Apr 2013 16:56:37 +0530
Message-ID: <CA+V-a8vKaHOX2FL5nP-0Tq2RBrRRHg0fhY3kT+tgVTOKdcyE5A@mail.gmail.com>
Subject: Re: [PATCH] ARM: daVinci: dm644x/dm355/dm365: replace
 V4L2_STD_525_60/625_50 with V4L2_STD_NTSC/PAL
To: Sekhar Nori <nsekhar@ti.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	LAK <linux-arm-kernel@lists.infradead.org>,
	LKML <inux-kernel@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sekhar,

On Fri, Apr 12, 2013 at 4:50 PM, Sekhar Nori <nsekhar@ti.com> wrote:
>
>
> On 4/12/2013 4:35 PM, Prabhakar lad wrote:
>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>
>> This patch replaces V4L2_STD_525_60/625_50 with V4L2_STD_NTSC/PAL
>> respectively as this are the proper video standards.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> Reported-by: Hans Verkuil <hans.verkuil@cisco.com>
>> Cc: Sekhar Nori <nsekhar@ti.com>
>
> I assume you have tested it, some testing information would have been
> good. The patch as such is OK with me. I assume this will go through
> media tree for sake of dependencies.
>
> Acked-by: Sekhar Nori <nsekhar@ti.com>
>
Thanks for the ACK, Yes I have tested the patch. missed to add the tested info.
And yes this patch will go via media tree.

Regards,
--Prabhakar

> Thanks,
> Sekhar
>
>> ---
>>  Note:- This patch is on top of following pull
>>   https://patchwork.linuxtv.org/patch/17888/
>>
>>  arch/arm/mach-davinci/board-dm355-evm.c  |    4 ++--
>>  arch/arm/mach-davinci/board-dm365-evm.c  |    4 ++--
>>  arch/arm/mach-davinci/board-dm644x-evm.c |    4 ++--
>>  3 files changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/arm/mach-davinci/board-dm355-evm.c b/arch/arm/mach-davinci/board-dm355-evm.c
>> index 1043506..886481c 100644
>> --- a/arch/arm/mach-davinci/board-dm355-evm.c
>> +++ b/arch/arm/mach-davinci/board-dm355-evm.c
>> @@ -247,7 +247,7 @@ static struct vpbe_enc_mode_info dm355evm_enc_preset_timing[] = {
>>       {
>>               .name           = "ntsc",
>>               .timings_type   = VPBE_ENC_STD,
>> -             .std_id         = V4L2_STD_525_60,
>> +             .std_id         = V4L2_STD_NTSC,
>>               .interlaced     = 1,
>>               .xres           = 720,
>>               .yres           = 480,
>> @@ -259,7 +259,7 @@ static struct vpbe_enc_mode_info dm355evm_enc_preset_timing[] = {
>>       {
>>               .name           = "pal",
>>               .timings_type   = VPBE_ENC_STD,
>> -             .std_id         = V4L2_STD_625_50,
>> +             .std_id         = V4L2_STD_PAL,
>>               .interlaced     = 1,
>>               .xres           = 720,
>>               .yres           = 576,
>> diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
>> index 0518ce5..2a66743 100644
>> --- a/arch/arm/mach-davinci/board-dm365-evm.c
>> +++ b/arch/arm/mach-davinci/board-dm365-evm.c
>> @@ -381,7 +381,7 @@ static struct vpbe_enc_mode_info dm365evm_enc_std_timing[] = {
>>       {
>>               .name           = "ntsc",
>>               .timings_type   = VPBE_ENC_STD,
>> -             .std_id         = V4L2_STD_525_60,
>> +             .std_id         = V4L2_STD_NTSC,
>>               .interlaced     = 1,
>>               .xres           = 720,
>>               .yres           = 480,
>> @@ -393,7 +393,7 @@ static struct vpbe_enc_mode_info dm365evm_enc_std_timing[] = {
>>       {
>>               .name           = "pal",
>>               .timings_type   = VPBE_ENC_STD,
>> -             .std_id         = V4L2_STD_625_50,
>> +             .std_id         = V4L2_STD_PAL,
>>               .interlaced     = 1,
>>               .xres           = 720,
>>               .yres           = 576,
>> diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
>> index a021800..745280d 100644
>> --- a/arch/arm/mach-davinci/board-dm644x-evm.c
>> +++ b/arch/arm/mach-davinci/board-dm644x-evm.c
>> @@ -622,7 +622,7 @@ static struct vpbe_enc_mode_info dm644xevm_enc_std_timing[] = {
>>       {
>>               .name           = "ntsc",
>>               .timings_type   = VPBE_ENC_STD,
>> -             .std_id         = V4L2_STD_525_60,
>> +             .std_id         = V4L2_STD_NTSC,
>>               .interlaced     = 1,
>>               .xres           = 720,
>>               .yres           = 480,
>> @@ -634,7 +634,7 @@ static struct vpbe_enc_mode_info dm644xevm_enc_std_timing[] = {
>>       {
>>               .name           = "pal",
>>               .timings_type   = VPBE_ENC_STD,
>> -             .std_id         = V4L2_STD_625_50,
>> +             .std_id         = V4L2_STD_PAL,
>>               .interlaced     = 1,
>>               .xres           = 720,
>>               .yres           = 576,
>>
