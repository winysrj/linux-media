Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpauth12.prod.mesa1.secureserver.net ([64.202.165.35]:59075
	"HELO smtpauth12.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752730Ab1HXAVl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Aug 2011 20:21:41 -0400
Subject: New SOC Camera hardware
Mime-Version: 1.0 (Apple Message framework v1244.3)
Content-Type: text/plain; charset=us-ascii
From: Gilles <gilles@gigadevices.com>
In-Reply-To: <fe2a004a676834efbb488b985de0370b@www.tabletspain.net>
Date: Tue, 23 Aug 2011 17:15:00 -0700
Content-Transfer-Encoding: 8BIT
Message-Id: <A731A584-CEE7-4F51-9483-9989E7495562@gigadevices.com>
References: <fe2a004a676834efbb488b985de0370b@www.tabletspain.net>
To: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Folks,

I am currently trying to add V4L2 SOC Camera support for an embedded board (Blackfin 527 EZKIT-V2).
Trying to learn from the few existing examples and was wondering if anyone could shed some light on this:

More specifically, I'm looking at:

arch/sh/boards/mach-ap325rxa/setup.c

arch/arm/mach-mx3/mach-pcm037.c
drivers/media/video/mx3_camera.c

I have the feeling that mx3 appears to be incomplete (or untested?) because of this statement in

static int __devinit mx3_camera_probe(struct platform_device *pdev)
{
  [...]
  soc_host		= &mx3_cam->soc_host;

Where mx3->soc_host appears to never be initialized since it's allocation (followed by a memzero).

Anyway, my question is: the ap325 board setup appears to do the job without a dedicated SOC driver.
Am I reading this correctly or is there a SOC driver for the ap325 I'm not seeing?

This is all so very hard with the total lack of comments in the code as well as the convoluted Kconfig/makefiles.

I'd appreciate any help anyone is willing to offer. Even after reading soc-camera.txt and a few others I still don't know what is *really* necessary.


I've pretty much come to the conclusion that in order to add SOC support for camera on a board I need to:

1) add a I2C_BOARD_INFO entry with the camera I2C address (in the board specific setup based on the appropriate CONFIG_...)

2) add a soc_camera_link for the camera sensor with that I2C info.

[...]

)) Add the device in the board __init. In my case in arch/blackfin/mach-bf527/boards/ezkit.c in __init ezkit_init()

add a call to platform_add_device

I know I'm missiong a lot of pieces to this puzzle. 
I'm seeing other boards allocate DMA regions first and then only add the camera if it succeeded.
Then I'm seeing the ap325 which creates TWO soc_camera_link (I'm assuming one is for the SOC driver which does not exist elsewhere?...)

Can anyone please shed some light on all this or point me to a SOC drivers for dummy document I may have missed???

I'd appreciate any input anyone is willing to lend.

Thanks,
Gilles
.

