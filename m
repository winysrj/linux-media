Return-path: <linux-media-owner@vger.kernel.org>
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:42095 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752807AbaLTMpA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Dec 2014 07:45:00 -0500
Date: Sat, 20 Dec 2014 12:44:48 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 0/8] Fix issues in em28xx
Message-ID: <20141220124448.GG11285@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While testing a PCTV tripleSTICK 292e, a couple of issues were
discovered.  Firstly, disconnecting the device causes a lockdep
splat, which is addressed in the first patch.

Secondly, a number of kernel messages are missing their terminating
newline characters, and these are spread over a range of commits and
a range of kernel versions.  Therefore, I've split the fixes up by
offending commit, which should make backporting to stable trees
easier.  (Some need to be applied to 3.14 and on, some to 3.15 and on,
etc.)

It isn't clear who is the maintainer for this driver; there is no
MAINTAINERS entry.  If there is a maintainer, please ensure that they
add themselves to this critical file.  Thanks.

 drivers/media/usb/em28xx/em28xx-audio.c |  8 ++++----
 drivers/media/usb/em28xx/em28xx-core.c  |  4 ++--
 drivers/media/usb/em28xx/em28xx-dvb.c   | 14 +++++++-------
 drivers/media/usb/em28xx/em28xx-input.c |  9 ++++-----
 drivers/media/usb/em28xx/em28xx-video.c |  6 +++---
 5 files changed, 20 insertions(+), 21 deletions(-)

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
