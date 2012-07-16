Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm9.bullet.mail.ird.yahoo.com ([77.238.189.35]:46011 "HELO
	nm9.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753292Ab2GPWVO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jul 2012 18:21:14 -0400
Message-ID: <1342477272.58502.YahooMailClassic@web29403.mail.ird.yahoo.com>
Date: Mon, 16 Jul 2012 23:21:12 +0100 (BST)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: patches to media_build, and a few other things
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have a couple of patches to my local media_build repo, which do these:

- a new option "--as-is" to the build script. It basically suppresses any git pull/rebase to both media_build and the ./media subdirectory (if used in combination with --main-git). In combination to --main-git, you are left on your own and be wholy responsible about what is inside ./media - I use that to check Antti's work (which is on a branch), and also since I have some interrim patches to media_build itself, I would prefer I can tell it not to  pull/merge .

- a small change to v4l/Makefile , to install under /lib/modules/$(KERNELRELEASE)/updates/... - recent fedora seems to have a modprobe preference to load from "../updates/..." (or at least, that's the case of having installed compat-wireless at some stage - one might want to steal some code from that?), when more than one kernel module of the same name exists. This is so as not to trash distro-shipped modules (and also if one cleans out ".../updates/..." and runs "depmod -a", one is back to distro as shipped behavior). Also trashing distro-shipped modules have the side-effect of making drpm not to work and whole kernel packages are downloaded in the next "yum upgrade".

I also have a suggestion to make:

- How http://linux/linuxtv.org/downloads/drivers/linux-media-LATEST.tar.bz2
is generated, probably should be documented. Over the weekend I was playing with one with timestamp Jul 7, and it is quite broken with firstly header files not in the right place (linux/v4l2-common.h instead of media/v4l2-common.h), and also the following:

media_build/v4l/../linux/include/media/v4l2-dev.h:127:2: error: unknown type name 'v4l2_std_id'
media_build/v4l/../linux/include/media/v4l2-dev.h:128:2: error: unknown type name 'v4l2_std_id'
media_build/v4l/../linux/include/media/v4l2-dev.h:135:32: error: 'BASE_VIDIOC_PRIVATE' undeclared here (not in a function)

I see that the Jul 16 version has both of these issues fixed... but I am not against having a look myself if it is urgent enough for me (considered that it was broken for 9 days).

- a few of the firmware files are newer/different than distro-shipped... I am less bothered by it trashing distro-shipped packaged files as the linux-firmware package is rarely upgraded. But maybe one can try pushing some of that upstream?

The last one, something for Antti to figure out:

- I found that that part of backports/api_version.patch, which changes LINUX_VERSION_CODE to V4L2_VERSION in drivers/media/video/v4l2-ioctl.c, is relocated from line 930-ish in http://linux/linuxtv.org/downloads/drivers/linux-media-LATEST.tar.bz2 to 
line 590-ish in Antti's dvb_core branch. So there are commits which are in 
linux-media-LATEST.tar.bz2 and not in Antti's branch or vice versa. (so that's any reason who one wants to know how linux-media-LATEST.tar.bz2 is made).
