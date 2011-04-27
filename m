Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:18953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754588Ab1D0APN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Apr 2011 20:15:13 -0400
Message-ID: <4DB76008.8040006@redhat.com>
Date: Tue, 26 Apr 2011 21:15:04 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <snjw23@gmail.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"'Marek Szyprowski'" <m.szyprowski@samsung.com>,
	linux Media Mailing List <linux-media@vger.kernel.org>,
	Kukjin Kim <kgene.kim@samsung.com>,
	Sungchun Kang <sungchun.kang@samsung.com>
Subject: Re: Dependency troubles with s5p-fimc driver
References: <4DB72C74.1070305@redhat.com> <4DB741ED.30700@gmail.com>
In-Reply-To: <4DB741ED.30700@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 26-04-2011 19:06, Sylwester Nawrocki escreveu:
> Hi Mauro,
> 
> On 04/26/2011 10:35 PM, Mauro Carvalho Chehab wrote:
>> Hi Sylvester/Marek,
>>
>> I've changed the kernel configuration in order to compile the media subsystem as a
> 
> Which kernel tree is this?

http://git.kernel.org/?p=linux/kernel/git/kki_ap/linux-2.6-samsung.git;a=shortlog;h=refs/heads/2.6.36-samsung

plus a series of patches that Sungchun sent me with the 5-MOLS driver.

> I assume it's kernel maintained by the System LSI team, so I cced Mr. Kukjin Kim.
> 
>> module (in order to allow me to use the media_build tree and compile just the
>> modules I want). The end result is that the arch tree refused to compile with this
>> error:
>>
>>    CC      arch/arm/mach-s5pv310/mach-smdkc210.o
>> arch/arm/mach-s5pv310/mach-smdkc210.c:1721:18: error: ‘writeback_info’ undeclared here (not in a function)
>> arch/arm/mach-s5pv310/mach-smdkc210.c: In function ‘smdkc210_machine_init’:
>> arch/arm/mach-s5pv310/mach-smdkc210.c:1947:7: warning: "CONFIG_VIDEO_SAMSUNG_S5P_FIMC" is not defined
>> arch/arm/mach-s5pv310/mach-smdkc210.c: At top level:
>> arch/arm/mach-s5pv310/mach-smdkc210.c:1673:33: warning: ‘isp_info’ defined but not used
>> arch/arm/mach-s5pv310/mach-smdkc210.c:1729:20: warning: ‘smdkv310_subdev_config’ defined but not used
>> arch/arm/mach-s5pv310/mach-smdkc210.c:1735:20: warning: ‘smdkv310_camera_config’ defined but not used
>> make[1]: ** [arch/arm/mach-s5pv310/mach-smdkc210.o] Erro 1
>>
>> By looking at arch/arm/mach-s5pv310/mach-smdkc210.c, it has lots of things like:
>>
>> #if defined(CONFIG_SND_SOC_WM8994) || defined(CONFIG_SND_SOC_WM8994_MODULE)
>> #include<linux/mfd/wm8994/pdata.h>
>> #endif
>>
>> Using #if/#endif blocks to include header data is not a good practice. Unfortunately,
>> it seems that all platform data is full of this. The error seems to be here:
> 
> Yes, I agree this is not right. However our team maintains only the
> following boards:
> 
> arch/arm/mach-s5pv210/mach-goni.c
> arch/arm/mach-s5pv210/mach-aquila.c
> arch/arm/mach-exynos4/mach-universal_c210.c

Ok.

>> /* for mainline fimc interface */
>> #ifdef CONFIG_VIDEO_SAMSUNG_S5P_FIMC
>> #ifdef WRITEBACK_ENABLED
>> struct writeback_mbus_platform_data {
>> 	int id;
>> 	struct v4l2_mbus_framefmt fmt;
>> };
>>
>> static struct i2c_board_info writeback_info = {
>> 	I2C_BOARD_INFO("writeback", 0x0),
>> };
>> #endif
> 
> Hmm...first time I see this stuff..
> 
> Kgene, could you please have a look?
> Or please forward this to someone who can take care of these issues.
> 
> Thank you,

Thanks!
Mauro
