Return-path: <linux-media-owner@vger.kernel.org>
Received: from p3plsmtpa07-10.prod.phx3.secureserver.net ([173.201.192.239]:44884
	"HELO p3plsmtpa07-10.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751434Ab1IZVfh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Sep 2011 17:35:37 -0400
Subject: Re: New SOC Camera hardware
Mime-Version: 1.0 (Apple Message framework v1244.3)
Content-Type: text/plain; charset=US-ASCII
From: Gilles <gilles@gigadevices.com>
In-Reply-To: <CAHG8p1CK5-BbDSdX5qGsGxfsvCZPc6S76ehE-2O1YORF4wM31A@mail.gmail.com>
Date: Mon, 26 Sep 2011 14:28:56 -0700
Cc: linux-media@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org
Content-Transfer-Encoding: 7BIT
Message-Id: <F63697F7-FEE5-439D-A014-3CC33A89C7CA@gigadevices.com>
References: <fe2a004a676834efbb488b985de0370b@www.tabletspain.net> <A731A584-CEE7-4F51-9483-9989E7495562@gigadevices.com> <CAHG8p1CK5-BbDSdX5qGsGxfsvCZPc6S76ehE-2O1YORF4wM31A@mail.gmail.com>
To: Scott Jiang <scott.jiang.linux@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Scott,

A late echo. I am just now getting into the heart of this project and realize I missed your answer here from back in August. Just grabbed the trunk from the repo and trying to compile it.

I'm not sure I understand why it would work with one sensor driver and not another. I thought the whole point of an adapter driver was to separate the camera sensor functions from the hardware. I guess the reason why I ask is because I currently need to get it to work with the Micron MT9V022 (which has a sensor driver).

Thanks,
Gilles
.



On Aug 24, 2011, at 19:41 , Scott Jiang wrote:

> Hi Gilles,
> 
> If you want to write a driver for blackfin, you can visit
> http://blackfin.uclinux.org/ and find linux kernel repo url.
> I have written a blackfin bridge driver, vs6624 sensor driver and
> adv7183 decoder driver. You can reference vs6624 driver.
> I didn't use soc camera framework because it can't support decoder well.
> These patch hasn't uploaded to mainline, I hope it is helpful for you.
> 
> Regards,
> Scott
> 
> 2011/8/24 Gilles <gilles@gigadevices.com>:
>> Folks,
>> 
>> I am currently trying to add V4L2 SOC Camera support for an embedded board (Blackfin 527 EZKIT-V2).
>> Trying to learn from the few existing examples and was wondering if anyone could shed some light on this:
>> 
>> More specifically, I'm looking at:
>> 
>> arch/sh/boards/mach-ap325rxa/setup.c
>> 
>> arch/arm/mach-mx3/mach-pcm037.c
>> drivers/media/video/mx3_camera.c
>> 
>> I have the feeling that mx3 appears to be incomplete (or untested?) because of this statement in
>> 
>> static int __devinit mx3_camera_probe(struct platform_device *pdev)
>> {
>>  [...]
>>  soc_host              = &mx3_cam->soc_host;
>> 
>> Where mx3->soc_host appears to never be initialized since it's allocation (followed by a memzero).
>> 
>> Anyway, my question is: the ap325 board setup appears to do the job without a dedicated SOC driver.
>> Am I reading this correctly or is there a SOC driver for the ap325 I'm not seeing?
>> 
>> This is all so very hard with the total lack of comments in the code as well as the convoluted Kconfig/makefiles.
>> 
>> I'd appreciate any help anyone is willing to offer. Even after reading soc-camera.txt and a few others I still don't know what is *really* necessary.
>> 
>> 
>> I've pretty much come to the conclusion that in order to add SOC support for camera on a board I need to:
>> 
>> 1) add a I2C_BOARD_INFO entry with the camera I2C address (in the board specific setup based on the appropriate CONFIG_...)
>> 
>> 2) add a soc_camera_link for the camera sensor with that I2C info.
>> 
>> [...]
>> 
>> )) Add the device in the board __init. In my case in arch/blackfin/mach-bf527/boards/ezkit.c in __init ezkit_init()
>> 
>> add a call to platform_add_device
>> 
>> I know I'm missiong a lot of pieces to this puzzle.
>> I'm seeing other boards allocate DMA regions first and then only add the camera if it succeeded.
>> Then I'm seeing the ap325 which creates TWO soc_camera_link (I'm assuming one is for the SOC driver which does not exist elsewhere?...)
>> 
>> Can anyone please shed some light on all this or point me to a SOC drivers for dummy document I may have missed???
>> 
>> I'd appreciate any input anyone is willing to lend.
>> 
>> Thanks,
>> Gilles
>> .
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

