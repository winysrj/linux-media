Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2597 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab0DGT3b (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Apr 2010 15:29:31 -0400
Received: from localhost (marune.xs4all.nl [82.95.89.49])
	by smtp-vbr14.xs4all.nl (8.13.8/8.13.8) with ESMTP id o37JTQJL077906
	for <linux-media@vger.kernel.org>; Wed, 7 Apr 2010 21:29:30 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Date: Wed, 7 Apr 2010 21:29:26 +0200 (CEST)
Message-Id: <201004071929.o37JTQJL077906@smtp-vbr14.xs4all.nl>
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [cron job] v4l-dvb daily build 2.6.22 and up: ERRORS, 2.6.16-2.6.21: WARNINGS
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This message is generated daily by a cron job that builds v4l-dvb for
the kernels and architectures in the list below.

Results of the daily build of v4l-dvb:

date:        Wed Apr  7 19:00:18 CEST 2010
path:        http://www.linuxtv.org/hg/v4l-dvb
changeset:   14561:7c0b887911cf
git master:       f6760aa024199cfbce564311dc4bc4d47b6fb349
git media-master: a6eb7bc8e0eea78f96ad1b0f0195ec52b88c6a00
gcc version:      i686-linux-gcc (GCC) 4.4.3
host hardware:    x86_64
host os:          2.6.32.5

linux-2.6.32.6-armv5: OK
linux-2.6.33-armv5: OK
linux-2.6.34-rc1-armv5: OK
linux-2.6.32.6-armv5-davinci: WARNINGS
linux-2.6.33-armv5-davinci: WARNINGS
linux-2.6.34-rc1-armv5-davinci: WARNINGS
linux-2.6.32.6-armv5-ixp: WARNINGS
linux-2.6.33-armv5-ixp: WARNINGS
linux-2.6.34-rc1-armv5-ixp: WARNINGS
linux-2.6.32.6-armv5-omap2: WARNINGS
linux-2.6.33-armv5-omap2: WARNINGS
linux-2.6.34-rc1-armv5-omap2: WARNINGS
linux-2.6.22.19-i686: WARNINGS
linux-2.6.23.17-i686: WARNINGS
linux-2.6.24.7-i686: WARNINGS
linux-2.6.25.20-i686: WARNINGS
linux-2.6.26.8-i686: WARNINGS
linux-2.6.27.44-i686: WARNINGS
linux-2.6.28.10-i686: WARNINGS
linux-2.6.29.1-i686: WARNINGS
linux-2.6.30.10-i686: WARNINGS
linux-2.6.31.12-i686: WARNINGS
linux-2.6.32.6-i686: WARNINGS
linux-2.6.33-i686: WARNINGS
linux-2.6.34-rc1-i686: WARNINGS
linux-2.6.32.6-m32r: OK
linux-2.6.33-m32r: OK
linux-2.6.34-rc1-m32r: OK
linux-2.6.32.6-mips: WARNINGS
linux-2.6.33-mips: WARNINGS
linux-2.6.34-rc1-mips: WARNINGS
linux-2.6.32.6-powerpc64: WARNINGS
linux-2.6.33-powerpc64: WARNINGS
linux-2.6.34-rc1-powerpc64: WARNINGS
linux-2.6.22.19-x86_64: WARNINGS
linux-2.6.23.17-x86_64: WARNINGS
linux-2.6.24.7-x86_64: WARNINGS
linux-2.6.25.20-x86_64: WARNINGS
linux-2.6.26.8-x86_64: WARNINGS
linux-2.6.27.44-x86_64: WARNINGS
linux-2.6.28.10-x86_64: WARNINGS
linux-2.6.29.1-x86_64: WARNINGS
linux-2.6.30.10-x86_64: WARNINGS
linux-2.6.31.12-x86_64: WARNINGS
linux-2.6.32.6-x86_64: WARNINGS
linux-2.6.33-x86_64: WARNINGS
linux-2.6.34-rc1-x86_64: WARNINGS
linux-git-armv5: WARNINGS
linux-git-armv5-davinci: WARNINGS
linux-git-armv5-ixp: WARNINGS
linux-git-armv5-omap2: WARNINGS
linux-git-i686: WARNINGS
linux-git-m32r: OK
linux-git-mips: WARNINGS
linux-git-powerpc64: WARNINGS
linux-git-x86_64: WARNINGS
spec: ERRORS
spec-git: ERRORS
sparse: ERRORS
linux-2.6.16.62-i686: WARNINGS
linux-2.6.17.14-i686: WARNINGS
linux-2.6.18.8-i686: WARNINGS
linux-2.6.19.7-i686: WARNINGS
linux-2.6.20.21-i686: WARNINGS
linux-2.6.21.7-i686: WARNINGS
linux-2.6.16.62-x86_64: WARNINGS
linux-2.6.17.14-x86_64: WARNINGS
linux-2.6.18.8-x86_64: WARNINGS
linux-2.6.19.7-x86_64: WARNINGS
linux-2.6.20.21-x86_64: WARNINGS
linux-2.6.21.7-x86_64: WARNINGS

Detailed results are available here:

http://www.xs4all.nl/~hverkuil/logs/Wednesday.log

Full logs are available here:

http://www.xs4all.nl/~hverkuil/logs/Wednesday.tar.bz2

The V4L-DVB specification failed to build, but the last compiled spec is here:

http://www.xs4all.nl/~hverkuil/spec/media.html
