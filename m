Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2857 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab3HQS3M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Aug 2013 14:29:12 -0400
Received: from tschai.lan (166.80-203-20.nextgentel.com [80.203.20.166])
	(authenticated bits=0)
	by smtp-vbr11.xs4all.nl (8.13.8/8.13.8) with ESMTP id r7HIT9uU068154
	for <linux-media@vger.kernel.org>; Sat, 17 Aug 2013 20:29:11 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Date: Sat, 17 Aug 2013 20:29:09 +0200 (CEST)
Message-Id: <201308171829.r7HIT9uU068154@smtp-vbr11.xs4all.nl>
Received: from localhost (marune.xs4all.nl [80.101.105.217])
	by tschai.lan (Postfix) with ESMTPSA id 320D82A075F
	for <linux-media@vger.kernel.org>; Sat, 17 Aug 2013 20:29:03 +0200 (CEST)
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: cron job: media_tree daily build: WARNINGS
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This message is generated daily by a cron job that builds media_tree for
the kernels and architectures in the list below.

Results of the daily build of media_tree:

date:		Sat Aug 17 19:00:21 CEST 2013
git branch:	test
git hash:	dfb9f94e8e5e7f73c8e2bcb7d4fb1de57e7c333d
gcc version:	i686-linux-gcc (GCC) 4.8.1
sparse version:	v0.4.5-rc1
host hardware:	x86_64
host os:	3.9-7.slh.1-amd64

linux-git-arm-at91: OK
linux-git-arm-davinci: OK
linux-git-arm-exynos: OK
linux-git-arm-mx: OK
linux-git-arm-omap: OK
linux-git-arm-omap1: OK
linux-git-arm-pxa: OK
linux-git-blackfin: OK
linux-git-i686: OK
linux-git-m32r: OK
linux-git-mips: OK
linux-git-powerpc64: OK
linux-git-sh: OK
linux-git-x86_64: OK
linux-2.6.31.14-i686: WARNINGS
linux-2.6.32.27-i686: WARNINGS
linux-2.6.33.7-i686: WARNINGS
linux-2.6.34.7-i686: WARNINGS
linux-2.6.35.9-i686: WARNINGS
linux-2.6.36.4-i686: WARNINGS
linux-2.6.37.6-i686: WARNINGS
linux-2.6.38.8-i686: WARNINGS
linux-2.6.39.4-i686: WARNINGS
linux-3.0.60-i686: OK
linux-3.10-i686: OK
linux-3.1.10-i686: OK
linux-3.2.37-i686: OK
linux-3.3.8-i686: OK
linux-3.4.27-i686: WARNINGS
linux-3.5.7-i686: WARNINGS
linux-3.6.11-i686: WARNINGS
linux-3.7.4-i686: WARNINGS
linux-3.8-i686: WARNINGS
linux-3.9.2-i686: WARNINGS
linux-2.6.31.14-x86_64: WARNINGS
linux-2.6.32.27-x86_64: WARNINGS
linux-2.6.33.7-x86_64: WARNINGS
linux-2.6.34.7-x86_64: WARNINGS
linux-2.6.35.9-x86_64: WARNINGS
linux-2.6.36.4-x86_64: WARNINGS
linux-2.6.37.6-x86_64: WARNINGS
linux-2.6.38.8-x86_64: WARNINGS
linux-2.6.39.4-x86_64: WARNINGS
linux-3.0.60-x86_64: OK
linux-3.10-x86_64: OK
linux-3.1.10-x86_64: OK
linux-3.2.37-x86_64: OK
linux-3.3.8-x86_64: OK
linux-3.4.27-x86_64: WARNINGS
linux-3.5.7-x86_64: WARNINGS
linux-3.6.11-x86_64: WARNINGS
linux-3.7.4-x86_64: WARNINGS
linux-3.8-x86_64: WARNINGS
linux-3.9.2-x86_64: WARNINGS
apps: WARNINGS
spec-git: OK
sparse version:	v0.4.5-rc1
sparse: ERRORS

Detailed results are available here:

http://www.xs4all.nl/~hverkuil/logs/Saturday.log

Full logs are available here:

http://www.xs4all.nl/~hverkuil/logs/Saturday.tar.bz2

The Media Infrastructure API from this daily build is here:

http://www.xs4all.nl/~hverkuil/spec/media.html
