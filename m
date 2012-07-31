Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63597 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832Ab2GaGOB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 02:14:01 -0400
Received: by wgbdr13 with SMTP id dr13so5531457wgb.1
        for <linux-media@vger.kernel.org>; Mon, 30 Jul 2012 23:14:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50170DE0.2030007@redhat.com>
References: <1343295404-8931-1-git-send-email-javier.martin@vista-silicon.com>
	<50170DE0.2030007@redhat.com>
Date: Tue, 31 Jul 2012 08:13:59 +0200
Message-ID: <CACKLOr2+y5emMuvKR0nLdQR=GtUOZ6Ms7j65bO5iXB8jJw0L4Q@mail.gmail.com>
Subject: Re: "[PULL] video_visstrim for 3.6"
From: javier Martin <javier.martin@vista-silicon.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
	Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 31 July 2012 00:42, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> Em 26-07-2012 06:36, Javier Martin escreveu:
>> Hi Mauro,
>> this pull request is composed of two series that provide support for two mem2mem devices:
>> - 'm2m-deinterlace' video deinterlacer
>> - 'coda video codec'
>> I've included platform support for them too.
>>
>>
>> The following changes since commit 6887a4131da3adaab011613776d865f4bcfb5678:
>>
>>    Linux 3.5-rc5 (2012-06-30 16:08:57 -0700)
>>
>> are available in the git repository at:
>>
>>    https://github.com/jmartinc/video_visstrim.git for_3.6
>>
>> for you to fetch changes up to 9bb10266da63ae7f8f198573e099580e9f98f4e8:
>>
>>    i.MX27: Visstrim_M10: Add support for deinterlacing driver. (2012-07-26 10:57:30 +0200)
>>
>> ----------------------------------------------------------------
>> Javier Martin (5):
>>        i.MX: coda: Add platform support for coda in i.MX27.
>>        media: coda: Add driver for Coda video codec.
>>        Visstrim M10: Add support for Coda.
>>        media: Add mem2mem deinterlacing driver.
>>        i.MX27: Visstrim_M10: Add support for deinterlacing driver.
>>
>>   arch/arm/mach-imx/clk-imx27.c                   |    4 +-
>>   arch/arm/mach-imx/devices-imx27.h               |    4 +
>>   arch/arm/mach-imx/mach-imx27_visstrim_m10.c     |   49 +-
>>   arch/arm/plat-mxc/devices/Kconfig               |    6 +-
>>   arch/arm/plat-mxc/devices/Makefile              |    1 +
>>   arch/arm/plat-mxc/devices/platform-imx27-coda.c |   37 +
>>   arch/arm/plat-mxc/include/mach/devices-common.h |    8 +
>
> I need ARM maintainer's ack for the patches that touch the above files.
>
> Regards,
> Mauro

Sascha or Russell,
could you please give me an ACK for the following patches?

i.MX27: Visstrim_M10: Add support for deinterlacing driver.
(http://www.spinics.net/lists/linux-media/msg50223.html)
Visstrim M10: Add support for Coda.. (http://patchwork.linuxtv.org/patch/13286/)

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
