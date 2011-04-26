Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57867 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab1DZWGm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Apr 2011 18:06:42 -0400
Received: by ewy4 with SMTP id 4so341416ewy.19
        for <linux-media@vger.kernel.org>; Tue, 26 Apr 2011 15:06:41 -0700 (PDT)
Message-ID: <4DB741ED.30700@gmail.com>
Date: Wed, 27 Apr 2011 00:06:37 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	'Marek Szyprowski' <m.szyprowski@samsung.com>,
	linux Media Mailing List <linux-media@vger.kernel.org>,
	Kukjin Kim <kgene.kim@samsung.com>,
	Sungchun Kang <sungchun.kang@samsung.com>
Subject: Re: Dependency troubles with s5p-fimc driver
References: <4DB72C74.1070305@redhat.com>
In-Reply-To: <4DB72C74.1070305@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

On 04/26/2011 10:35 PM, Mauro Carvalho Chehab wrote:
> Hi Sylvester/Marek,
> 
> I've changed the kernel configuration in order to compile the media subsystem as a

Which kernel tree is this?
I assume it's kernel maintained by the System LSI team, so I cced Mr. Kukjin Kim.

> module (in order to allow me to use the media_build tree and compile just the
> modules I want). The end result is that the arch tree refused to compile with this
> error:
> 
>    CC      arch/arm/mach-s5pv310/mach-smdkc210.o
> arch/arm/mach-s5pv310/mach-smdkc210.c:1721:18: error: ‘writeback_info’ undeclared here (not in a function)
> arch/arm/mach-s5pv310/mach-smdkc210.c: In function ‘smdkc210_machine_init’:
> arch/arm/mach-s5pv310/mach-smdkc210.c:1947:7: warning: "CONFIG_VIDEO_SAMSUNG_S5P_FIMC" is not defined
> arch/arm/mach-s5pv310/mach-smdkc210.c: At top level:
> arch/arm/mach-s5pv310/mach-smdkc210.c:1673:33: warning: ‘isp_info’ defined but not used
> arch/arm/mach-s5pv310/mach-smdkc210.c:1729:20: warning: ‘smdkv310_subdev_config’ defined but not used
> arch/arm/mach-s5pv310/mach-smdkc210.c:1735:20: warning: ‘smdkv310_camera_config’ defined but not used
> make[1]: ** [arch/arm/mach-s5pv310/mach-smdkc210.o] Erro 1
> 
> By looking at arch/arm/mach-s5pv310/mach-smdkc210.c, it has lots of things like:
> 
> #if defined(CONFIG_SND_SOC_WM8994) || defined(CONFIG_SND_SOC_WM8994_MODULE)
> #include<linux/mfd/wm8994/pdata.h>
> #endif
> 
> Using #if/#endif blocks to include header data is not a good practice. Unfortunately,
> it seems that all platform data is full of this. The error seems to be here:

Yes, I agree this is not right. However our team maintains only the
following boards:

arch/arm/mach-s5pv210/mach-goni.c
arch/arm/mach-s5pv210/mach-aquila.c
arch/arm/mach-exynos4/mach-universal_c210.c

> 
> /* for mainline fimc interface */
> #ifdef CONFIG_VIDEO_SAMSUNG_S5P_FIMC
> #ifdef WRITEBACK_ENABLED
> struct writeback_mbus_platform_data {
> 	int id;
> 	struct v4l2_mbus_framefmt fmt;
> };
> 
> static struct i2c_board_info writeback_info = {
> 	I2C_BOARD_INFO("writeback", 0x0),
> };
> #endif

Hmm...first time I see this stuff..

Kgene, could you please have a look?
Or please forward this to someone who can take care of these issues.

Thank you,
Sylwester

> 
> You should be doing, instead, a check like this one for all symbols that are allowed
> to be module at the Kconfig:
> 
> #if defined(CONFIG_SND_SOC_WM8994) || defined(CONFIG_SND_SOC_WM8994_MODULE)
> 
> Cheers,
> Mauro.
> 
> -
> As reference, I'm enclosing my .config.
> 
[snip]

