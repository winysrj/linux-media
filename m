Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:37990 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750954AbbBPDkz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Feb 2015 22:40:55 -0500
Received: from localhost (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 8EB2E2A0083
	for <linux-media@vger.kernel.org>; Mon, 16 Feb 2015 04:40:35 +0100 (CET)
Date: Mon, 16 Feb 2015 04:40:35 +0100
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: cron job: media_tree daily build: ERRORS
Message-Id: <20150216034035.8EB2E2A0083@tschai.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This message is generated daily by a cron job that builds media_tree for
the kernels and architectures in the list below.

Results of the daily build of media_tree:

date:		Mon Feb 16 04:00:22 CET 2015
git branch:	test
git hash:	135f9be9194cf7778eb73594aa55791b229cf27c
gcc version:	i686-linux-gcc (GCC) 4.9.1
sparse version:	v0.5.0-41-g6c2d743
smatch version:	0.4.1-3153-g7d56ab3
host hardware:	x86_64
host os:	3.18.0-5.slh.1-amd64

linux-git-arm-at91: ERRORS
linux-git-arm-davinci: ERRORS
linux-git-arm-exynos: ERRORS
linux-git-arm-mx: ERRORS
linux-git-arm-omap: ERRORS
linux-git-arm-omap1: ERRORS
linux-git-arm-pxa: ERRORS
linux-git-blackfin: OK
linux-git-i686: OK
linux-git-m32r: OK
linux-git-mips: ERRORS
linux-git-powerpc64: OK
linux-git-sh: ERRORS
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
linux-3.10.1-i686: ERRORS
linux-3.11.1-i686: ERRORS
linux-3.12.23-i686: ERRORS
linux-3.13.11-i686: ERRORS
linux-3.14.9-i686: ERRORS
linux-3.15.2-i686: ERRORS
linux-3.16-i686: ERRORS
linux-3.17.8-i686: ERRORS
linux-3.18-i686: ERRORS
linux-3.19-rc4-i686: OK
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
linux-3.10.1-x86_64: ERRORS
linux-3.11.1-x86_64: ERRORS
linux-3.12.23-x86_64: ERRORS
linux-3.13.11-x86_64: ERRORS
linux-3.14.9-x86_64: ERRORS
linux-3.15.2-x86_64: ERRORS
linux-3.16-x86_64: ERRORS
linux-3.17.8-x86_64: ERRORS
linux-3.18-x86_64: ERRORS
linux-3.19-rc4-x86_64: OK
apps: OK
spec-git: OK
sparse: ERRORS
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
smatch: ERRORS

Detailed results are available here:

http://www.xs4all.nl/~hverkuil/logs/Monday.log

Full logs are available here:

http://www.xs4all.nl/~hverkuil/logs/Monday.tar.bz2

The Media Infrastructure API from this daily build is here:

http://www.xs4all.nl/~hverkuil/spec/media.html
