Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1177 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757990Ab3IBCyw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Sep 2013 22:54:52 -0400
Received: from tschai.lan (166.80-203-20.nextgentel.com [80.203.20.166])
	(authenticated bits=0)
	by smtp-vbr10.xs4all.nl (8.13.8/8.13.8) with ESMTP id r822sn5O004062
	for <linux-media@vger.kernel.org>; Mon, 2 Sep 2013 04:54:51 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from localhost (tschai [192.168.1.10])
	by tschai.lan (Postfix) with ESMTPSA id 1A5BD2A0761
	for <linux-media@vger.kernel.org>; Mon,  2 Sep 2013 04:54:40 +0200 (CEST)
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: cron job: media_tree daily build: WARNINGS
Message-Id: <20130902025440.1A5BD2A0761@tschai.lan>
Date: Mon,  2 Sep 2013 04:54:40 +0200 (CEST)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This message is generated daily by a cron job that builds media_tree for
the kernels and architectures in the list below.

Results of the daily build of media_tree:

date:		Mon Sep  2 04:00:21 CEST 2013
git branch:	test
git hash:	26a20eb09d44dc064c4f5d1f024bd501c09edb4b
gcc version:	i686-linux-gcc (GCC) 4.8.1
sparse version:	0.4.5-rc1
host hardware:	x86_64
host os:	3.10.1

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
linux-3.10.1-i686: OK
linux-3.1.10-i686: OK
linux-3.11-rc1-i686: OK
linux-3.2.37-i686: OK
linux-3.3.8-i686: OK
linux-3.4.27-i686: OK
linux-3.5.7-i686: OK
linux-3.6.11-i686: OK
linux-3.7.4-i686: OK
linux-3.8-i686: OK
linux-3.9.2-i686: OK
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
linux-3.10.1-x86_64: OK
linux-3.1.10-x86_64: OK
linux-3.11-rc1-x86_64: OK
linux-3.2.37-x86_64: OK
linux-3.3.8-x86_64: OK
linux-3.4.27-x86_64: OK
linux-3.5.7-x86_64: OK
linux-3.6.11-x86_64: OK
linux-3.7.4-x86_64: OK
linux-3.8-x86_64: OK
linux-3.9.2-x86_64: OK
apps: WARNINGS
spec-git: OK
ABI WARNING: change for arm-at91
ABI WARNING: change for arm-davinci
ABI WARNING: change for arm-exynos
ABI WARNING: change for arm-mx
ABI WARNING: change for arm-omap
ABI WARNING: change for arm-omap1
ABI WARNING: change for arm-pxa
ABI WARNING: change for blackfin
ABI WARNING: change for i686
ABI WARNING: change for m32r
ABI WARNING: change for mips
ABI WARNING: change for powerpc64
ABI WARNING: change for sh
ABI WARNING: change for x86_64
sparse version:	0.4.5-rc1
sparse: ERRORS

Detailed results are available here:

http://www.xs4all.nl/~hverkuil/logs/Monday.log

Full logs are available here:

http://www.xs4all.nl/~hverkuil/logs/Monday.tar.bz2

The Media Infrastructure API from this daily build is here:

http://www.xs4all.nl/~hverkuil/spec/media.html
