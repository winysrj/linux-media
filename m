Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3549 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab3LLM0q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Dec 2013 07:26:46 -0500
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr12.xs4all.nl (8.13.8/8.13.8) with ESMTP id rBCCQhQH042065
	for <linux-media@vger.kernel.org>; Thu, 12 Dec 2013 13:26:45 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.192.168.1.1 (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 8229D2A2224
	for <linux-media@vger.kernel.org>; Thu, 12 Dec 2013 13:26:34 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv2 PATCH 0/2] Move sn9c102 and omap24xx/tcm825x to staging.
Date: Thu, 12 Dec 2013 13:26:31 +0100
Message-Id: <1386851193-3845-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[Repost, this time with rename-detection turned on...]

This RFC patch series moves sn9c102 and omap24xx/tcm825x to staging.
The sn9c102 driver has been deprecated for quite some time and most of the
supported webcams are now part of gspca. Nobody has the hardware for the
remaining webcams and nobody is actively maintaining this driver.

Converting this driver to the v4l2 frameworks would be a major undertaking.
This driver is no longer part of Fedora for some time now without ever
receiving any complaints, so instead of updating it it is a better idea to
phase it out. Step one of that process is to move it to staging.

This decision was taken during the last media summit in Edinburgh.

The second patch moves the omap24xx and tcm825x to staging, together with
the v4l2-int-device source. These drivers are the only ones that use that
old int-device API, nobody is actively maintaining these any more, and
attempts to convert them to the subdev API have failed (it compiles, but
it crashes and nobody has the time to chase the problem).

I really want to get rid of v4l2-int-device, especially since there are
some platforms out there (MXC) that still use it. None of the drivers based
on int-device can ever be upstreamed, so I am hoping that just removing this
deprecated API altogether will finally convince the maintainers of those
out-of-tree platforms to switch to a modern API.

Moving these drivers to staging is the first step and my plan is to
remove it completely second half of 2014. A nice side-effect of moving
the v4l2-int-device source and header to staging is also that nobody
can use v4l2-int-device.h anymore in another driver since it is no longer
part of the include directory.

Regards,

	Hans

