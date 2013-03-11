Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3069 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab3CKLqh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:46:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>
Subject: [REVIEW PATCH 00/42] go7007: complete overhaul
Date: Mon, 11 Mar 2013 12:45:38 +0100
Message-Id: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This patch series updates the staging go7007 driver to the latest
V4L2 frameworks and actually makes it work reliably.

Some highlights:

- moved the custom i2c drivers to media/i2c.
- replaced the s2250-loader by a common loader for all the supported
  devices.
- replaced all MPEG-related custom ioctls by standard ioctls and FMT
  support.
- added the saa7134-go7007 combination (similar to the saa7134-empress).

In addition I've made some V4L2 core and saa7115 changes (the first 6
patches):

- eliminate false lockdep warnings when dealing with nested control
  handlers. This patch is a slightly modified version from the one Andy
  posted a long time ago.
- add support to easily test if any subdevices support a particular operation.
- fix a few bugs in the code that tests if an ioctl is available: it didn't
  take 'disabling of ioctls' into account.
- added additional configuration flags to saa7115, needed by the go7007.
- improved querystd support in saa7115.

This driver now passes all v4l2-compliance tests.

Volokh, I've merged your tw2804 v4l2 framework cleanup patches into one
with my modifications on top. I hope you don't mind.

It has been tested with:

- Plextor PX-TV402U (PAL model)
- Sensoray S2250S (generously provided by Sensoray, all audio inputs
  now work!)
- Sensoray Model 614 (saa7134+go7007 PCI board, generously provided by
  Sensoray)
- WIS X-Men II sensor board (generously provided by Sensoray)
- Adlink PCI-MPG24 surveillance board

Everything seems to work OK, but for two things:

- the WIS X-Men and tthe S2250 do not honor requested frameperiod changes
  using S_PARM. The others work fine, and I have no idea why these work
  differently.
- the bttv part of the Adlink card doesn't work for me: I just get black
  with fuzzy lines. This doesn't work in 3.8 either, so I don't know
  what's going on here. It's not related to my patch series, that's for
  sure. Volokh, can you test it as well?

What needs to be done to get this driver out of staging? The main thing
is the motion detection support. Volokh has some addition code for that,
and I want to experiment with motion detection for this card and the
solo6x10 card and see if I can come up with a nice API for that.

It would also be nice to get the s2250-board.c code make use of the already
existing i2c devices, but it is hooked up somewhat strangely, so I need to
look at that some day.

I also need to look at the firmware licensing. I think it is all OK, but
I need to check. For now all the firmwares are available here:

http://hverkuil.home.xs4all.nl/go7007-fw.tar.bz2

Just unpack in /lib/firmware.

I've moved all firmwares into a single go7007 directory. And the old .hex
files have been converted into binary format that the cypress loader expects.

Pete, can you test this for your S2251 USB device?

This week I'll also receive a Plextor PX-M402U to test with and an ADS DVD
XPress DX2 is also on its way (I did some ebay shopping!).

I plan on posting the pull request this Friday, so let me know if there are
any issues.

BTW, my git tree is available here:

http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/go7007

Regards,

	Hans

