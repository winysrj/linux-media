Return-path: <mchehab@pedra>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3863 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080Ab0I1TLg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Sep 2010 15:11:36 -0400
Received: from localhost (marune.xs4all.nl [82.95.89.49])
	by smtp-vbr12.xs4all.nl (8.13.8/8.13.8) with ESMTP id o8SJBYB1003261
	for <linux-media@vger.kernel.org>; Tue, 28 Sep 2010 21:11:34 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Date: Tue, 28 Sep 2010 21:11:34 +0200 (CEST)
Message-Id: <201009281911.o8SJBYB1003261@smtp-vbr12.xs4all.nl>
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [cron job] v4l-dvb daily build 2.6.26 and up: ERRORS
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This message is generated daily by a cron job that builds v4l-dvb for
the kernels and architectures in the list below.

Results of the daily build of v4l-dvb:

date:        Tue Sep 28 19:00:17 CEST 2010
path:        http://www.linuxtv.org/hg/v4l-dvb
changeset:   15164:1da5fed5c8b2
git master:       3e6dce76d99b328716b43929b9195adfee1de00c
git media-master: dace3857de7a16b83ae7d4e13c94de8e4b267d2a
gcc version:      i686-linux-gcc (GCC) 4.4.3
host hardware:    x86_64
host os:          2.6.32.5

linux-2.6.32.6-armv5: WARNINGS
linux-2.6.33-armv5: OK
linux-2.6.34-armv5: WARNINGS
linux-2.6.35.3-armv5: WARNINGS
linux-2.6.36-rc2-armv5: ERRORS
linux-2.6.32.6-armv5-davinci: WARNINGS
linux-2.6.33-armv5-davinci: WARNINGS
linux-2.6.34-armv5-davinci: WARNINGS
linux-2.6.35.3-armv5-davinci: WARNINGS
linux-2.6.36-rc2-armv5-davinci: ERRORS
linux-2.6.32.6-armv5-ixp: WARNINGS
linux-2.6.33-armv5-ixp: WARNINGS
linux-2.6.34-armv5-ixp: WARNINGS
linux-2.6.35.3-armv5-ixp: WARNINGS
linux-2.6.36-rc2-armv5-ixp: ERRORS
linux-2.6.32.6-armv5-omap2: WARNINGS
linux-2.6.33-armv5-omap2: WARNINGS
linux-2.6.34-armv5-omap2: WARNINGS
linux-2.6.35.3-armv5-omap2: WARNINGS
linux-2.6.36-rc2-armv5-omap2: ERRORS
linux-2.6.26.8-i686: WARNINGS
linux-2.6.27.44-i686: WARNINGS
linux-2.6.28.10-i686: WARNINGS
linux-2.6.29.1-i686: WARNINGS
linux-2.6.30.10-i686: WARNINGS
linux-2.6.31.12-i686: WARNINGS
linux-2.6.32.6-i686: WARNINGS
linux-2.6.33-i686: WARNINGS
linux-2.6.34-i686: WARNINGS
linux-2.6.35.3-i686: WARNINGS
linux-2.6.36-rc2-i686: ERRORS
linux-2.6.32.6-m32r: WARNINGS
linux-2.6.33-m32r: OK
linux-2.6.34-m32r: WARNINGS
linux-2.6.35.3-m32r: WARNINGS
linux-2.6.36-rc2-m32r: ERRORS
linux-2.6.32.6-mips: WARNINGS
linux-2.6.33-mips: WARNINGS
linux-2.6.34-mips: WARNINGS
linux-2.6.35.3-mips: WARNINGS
linux-2.6.36-rc2-mips: ERRORS
linux-2.6.32.6-powerpc64: WARNINGS
linux-2.6.33-powerpc64: WARNINGS
linux-2.6.34-powerpc64: WARNINGS
linux-2.6.35.3-powerpc64: WARNINGS
linux-2.6.36-rc2-powerpc64: ERRORS
linux-2.6.26.8-x86_64: WARNINGS
linux-2.6.27.44-x86_64: WARNINGS
linux-2.6.28.10-x86_64: WARNINGS
linux-2.6.29.1-x86_64: WARNINGS
linux-2.6.30.10-x86_64: WARNINGS
linux-2.6.31.12-x86_64: WARNINGS
linux-2.6.32.6-x86_64: WARNINGS
linux-2.6.33-x86_64: WARNINGS
linux-2.6.34-x86_64: WARNINGS
linux-2.6.35.3-x86_64: WARNINGS
linux-2.6.36-rc2-x86_64: ERRORS
linux-git-Module.symvers: ERRORS
linux-git-armv5: ERRORS
linux-git-armv5-davinci: ERRORS
linux-git-armv5-ixp: ERRORS
linux-git-armv5-omap2: ERRORS
linux-git-i686: ERRORS
linux-git-m32r: ERRORS
linux-git-mips: ERRORS
linux-git-powerpc64: ERRORS
linux-git-x86_64: ERRORS
spec-git: OK
sparse: ERRORS

Detailed results are available here:

http://www.xs4all.nl/~hverkuil/logs/Tuesday.log

Full logs are available here:

http://www.xs4all.nl/~hverkuil/logs/Tuesday.tar.bz2

The V4L-DVB specification from this daily build is here:

http://www.xs4all.nl/~hverkuil/spec/media.html
