Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:59668 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751535AbcCMEA2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Mar 2016 23:00:28 -0500
Received: from localhost (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id E493D180096
	for <linux-media@vger.kernel.org>; Sun, 13 Mar 2016 05:00:21 +0100 (CET)
Date: Sun, 13 Mar 2016 05:00:21 +0100
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: cron job: media_tree daily build: WARNINGS
Message-Id: <20160313040021.E493D180096@tschai.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This message is generated daily by a cron job that builds media_tree for
the kernels and architectures in the list below.

Results of the daily build of media_tree:

date:		Sun Mar 13 04:00:21 CET 2016
git branch:	test
git hash:	840f5b0572ea9ddaca2bf5540a171013e92c97bd
gcc version:	i686-linux-gcc (GCC) 5.3.0
sparse version:	v0.5.0-51-ga53cea2
smatch version:	v0.5.0-3228-g5cf65ab
host hardware:	x86_64
host os:	4.4.0-164

linux-git-arm-at91: WARNINGS
linux-git-arm-davinci: WARNINGS
linux-git-arm-exynos: WARNINGS
linux-git-arm-mx: WARNINGS
linux-git-arm-omap: WARNINGS
linux-git-arm-omap1: WARNINGS
linux-git-arm-pxa: WARNINGS
linux-git-blackfin-bf561: WARNINGS
linux-git-i686: WARNINGS
linux-git-m32r: OK
linux-git-mips: WARNINGS
linux-git-powerpc64: WARNINGS
linux-git-sh: WARNINGS
linux-git-x86_64: WARNINGS
linux-2.6.36.4-i686: WARNINGS
linux-2.6.37.6-i686: WARNINGS
linux-2.6.38.8-i686: WARNINGS
linux-2.6.39.4-i686: WARNINGS
linux-3.0.60-i686: WARNINGS
linux-3.1.10-i686: WARNINGS
linux-3.2.37-i686: WARNINGS
linux-3.3.8-i686: WARNINGS
linux-3.4.27-i686: WARNINGS
linux-3.5.7-i686: WARNINGS
linux-3.6.11-i686: WARNINGS
linux-3.7.4-i686: WARNINGS
linux-3.8-i686: WARNINGS
linux-3.9.2-i686: WARNINGS
linux-3.10.1-i686: WARNINGS
linux-3.11.1-i686: WARNINGS
linux-3.12.23-i686: WARNINGS
linux-3.13.11-i686: WARNINGS
linux-3.14.9-i686: WARNINGS
linux-3.15.2-i686: WARNINGS
linux-3.16.7-i686: WARNINGS
linux-3.17.8-i686: WARNINGS
linux-3.18.7-i686: WARNINGS
linux-3.19-i686: WARNINGS
linux-4.0-i686: WARNINGS
linux-4.1.1-i686: WARNINGS
linux-4.2-i686: WARNINGS
linux-4.3-i686: WARNINGS
linux-4.4-i686: WARNINGS
linux-4.5-rc1-i686: WARNINGS
linux-2.6.36.4-x86_64: WARNINGS
linux-2.6.37.6-x86_64: WARNINGS
linux-2.6.38.8-x86_64: WARNINGS
linux-2.6.39.4-x86_64: WARNINGS
linux-3.0.60-x86_64: WARNINGS
linux-3.1.10-x86_64: WARNINGS
linux-3.2.37-x86_64: WARNINGS
linux-3.3.8-x86_64: WARNINGS
linux-3.4.27-x86_64: WARNINGS
linux-3.5.7-x86_64: WARNINGS
linux-3.6.11-x86_64: WARNINGS
linux-3.7.4-x86_64: WARNINGS
linux-3.8-x86_64: WARNINGS
linux-3.9.2-x86_64: WARNINGS
linux-3.10.1-x86_64: WARNINGS
linux-3.11.1-x86_64: WARNINGS
linux-3.12.23-x86_64: WARNINGS
linux-3.13.11-x86_64: WARNINGS
linux-3.14.9-x86_64: WARNINGS
linux-3.15.2-x86_64: WARNINGS
linux-3.16.7-x86_64: WARNINGS
linux-3.17.8-x86_64: WARNINGS
linux-3.18.7-x86_64: WARNINGS
linux-3.19-x86_64: WARNINGS
linux-4.0-x86_64: WARNINGS
linux-4.1.1-x86_64: WARNINGS
linux-4.2-x86_64: WARNINGS
linux-4.3-x86_64: WARNINGS
linux-4.4-x86_64: WARNINGS
linux-4.5-rc1-x86_64: WARNINGS
apps: OK
spec-git: OK
sparse: WARNINGS
smatch: ERRORS

Detailed results are available here:

http://www.xs4all.nl/~hverkuil/logs/Sunday.log

Full logs are available here:

http://www.xs4all.nl/~hverkuil/logs/Sunday.tar.bz2

The Media Infrastructure API from this daily build is here:

http://www.xs4all.nl/~hverkuil/spec/media.html
