Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:50224 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751609AbbBRDp3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2015 22:45:29 -0500
Received: from localhost (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 2BA1E2A008D
	for <linux-media@vger.kernel.org>; Wed, 18 Feb 2015 04:45:08 +0100 (CET)
Date: Wed, 18 Feb 2015 04:45:08 +0100
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: cron job: media_tree daily build: ABI WARNING
Message-Id: <20150218034508.2BA1E2A008D@tschai.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This message is generated daily by a cron job that builds media_tree for
the kernels and architectures in the list below.

Results of the daily build of media_tree:

date:		Wed Feb 18 04:00:23 CET 2015
git branch:	test
git hash:	135f9be9194cf7778eb73594aa55791b229cf27c
gcc version:	i686-linux-gcc (GCC) 4.9.1
sparse version:	v0.5.0-41-g6c2d743
smatch version:	0.4.1-3153-g7d56ab3
host hardware:	x86_64
host os:	3.18.0-5.slh.1-amd64

linux-git-arm-at91: OK
linux-git-arm-davinci: WARNINGS
linux-git-arm-exynos: OK
linux-git-arm-mx: OK
linux-git-arm-omap: OK
linux-git-arm-omap1: OK
linux-git-arm-pxa: OK
linux-git-blackfin: OK
linux-git-i686: OK
linux-git-m32r: OK
linux-git-mips: WARNINGS
linux-git-powerpc64: OK
linux-git-sh: OK
linux-git-x86_64: OK
linux-2.6.32.27-i686: OK
linux-2.6.33.7-i686: OK
linux-2.6.34.7-i686: OK
linux-2.6.35.9-i686: OK
linux-2.6.36.4-i686: OK
linux-2.6.37.6-i686: OK
linux-2.6.38.8-i686: OK
linux-2.6.39.4-i686: OK
linux-3.0.60-i686: OK
linux-3.1.10-i686: OK
linux-3.2.37-i686: OK
linux-3.3.8-i686: OK
linux-3.4.27-i686: OK
linux-3.5.7-i686: OK
linux-3.6.11-i686: OK
linux-3.7.4-i686: OK
linux-3.8-i686: WARNINGS
linux-3.9.2-i686: WARNINGS
linux-3.10.1-i686: OK
linux-3.11.1-i686: OK
linux-3.12.23-i686: OK
linux-3.13.11-i686: OK
linux-3.14.9-i686: OK
linux-3.15.2-i686: OK
linux-3.16.7-i686: OK
linux-3.17.8-i686: OK
linux-3.18.7-i686: OK
linux-3.19-i686: OK
linux-2.6.32.27-x86_64: OK
linux-2.6.33.7-x86_64: OK
linux-2.6.34.7-x86_64: OK
linux-2.6.35.9-x86_64: OK
linux-2.6.36.4-x86_64: OK
linux-2.6.37.6-x86_64: OK
linux-2.6.38.8-x86_64: OK
linux-2.6.39.4-x86_64: OK
linux-3.0.60-x86_64: OK
linux-3.1.10-x86_64: OK
linux-3.2.37-x86_64: OK
linux-3.3.8-x86_64: OK
linux-3.4.27-x86_64: OK
linux-3.5.7-x86_64: OK
linux-3.6.11-x86_64: OK
linux-3.7.4-x86_64: OK
linux-3.8-x86_64: WARNINGS
linux-3.9.2-x86_64: WARNINGS
linux-3.10.1-x86_64: OK
linux-3.11.1-x86_64: OK
linux-3.12.23-x86_64: OK
linux-3.13.11-x86_64: OK
linux-3.14.9-x86_64: OK
linux-3.15.2-x86_64: OK
linux-3.16.7-x86_64: OK
linux-3.17.8-x86_64: OK
linux-3.18.7-x86_64: OK
linux-3.19-x86_64: OK
apps: OK
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
sparse: WARNINGS
smatch: ERRORS

Detailed results are available here:

http://www.xs4all.nl/~hverkuil/logs/Wednesday.log

Full logs are available here:

http://www.xs4all.nl/~hverkuil/logs/Wednesday.tar.bz2

The Media Infrastructure API from this daily build is here:

http://www.xs4all.nl/~hverkuil/spec/media.html
