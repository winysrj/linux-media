Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1265 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab2BENRd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Feb 2012 08:17:33 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>,
	alsa-devel@alsa-project.org
Subject: tea575x-tuner improvements & use in maxiradio
Date: Sun,  5 Feb 2012 14:17:05 +0100
Message-Id: <1328447827-9842-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These patches improve the tea575x-tuner module to make it up to date with
the latest V4L2 frameworks.

The maxiradio driver has also been converted to use the tea575x-tuner and
I've used that card to test it.

Unfortunately, this card can't read the data pin, so the new hardware seek
functionality has been tested only partially (yes, it seeks, but when it finds
a channel I can't read back the frequency).

Ondrej, are you able to test these patches for the sound cards that use this
tea575x tuner?

Note that these two patches rely on other work that I did and that hasn't been
merged yet. So it is best to pull from my git tree:

http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/radio-pci2

You can use the v4l-utils repository (http://git.linuxtv.org/v4l-utils.git) to
test the drivers: the v4l2-compliance test should succeed and with v4l2-ctl you
can test the hardware seek:

To seek down:

v4l2-ctl -d /dev/radio0 --freq-seek=dir=0

To seek up:

v4l2-ctl -d /dev/radio0 --freq-seek=dir=1

To do the compliance test:

v4l2-compliance -r /dev/radio0

Regards,

	Hans

