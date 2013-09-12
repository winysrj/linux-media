Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:51062 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab3ILTOh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Sep 2013 15:14:37 -0400
Date: Thu, 12 Sep 2013 21:13:49 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	=?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
Subject: [RFD] use-counting V4L2 clocks
Message-ID: <Pine.LNX.4.64.1309121947590.7038@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all

We've got a broken driver in 3.11 and in 3.12-rc and we don't have a clear 
way to properly fix it. The problem has been originally reported and 
discussed in [1], a patch-set to fix the problem has been proposed in [2], 
which actually lead to the topic of this mail - whether or not calls to 
v4l2_clk_enable() and v4l2_clk_disable(), or respectively to s_power(1) 
and s_power(0) subdevice core operations should be balanced. Currently 
they aren't in em28xx driver, and the V4L2 clock API throws warnings on 
attempts to disable already disabled clock. Patch [3] attempted to fix 
that. So, the question is - whether to enforce balanced power on / off 
calls, or to remove the warning.

Let's try to have a look at other examples in the kernel:

1. runtime PM: pm_runtime_get*() / pm_runtime_put*() only work, if 
balanced, but no warning is issued, if the balance is broken, AFAICS.

2. clock API: clk_enable() / clk_disable() in drivers/clk/clk.c have to be 
balanced and a warning is issued, if clk_disable() is called for an 
already disabled clock.

3. regulator API: regulator_enable() / regulator_disable() have to be 
balanced. A warning is issued if regulator_disable() is called for a 
disabled regulator.

So, I think, our V4L2 clock enable / disable calls should be balanced, and 
to enforce that a warning is helpful. Other opinions?

Thanks
Guennadi

[1] http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/68028
[2] http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/68510
[3] http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/68864

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
