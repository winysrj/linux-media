Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2989 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaAIDdw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 22:33:52 -0500
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr12.xs4all.nl (8.13.8/8.13.8) with ESMTP id s093XnI4001663
	for <linux-media@vger.kernel.org>; Thu, 9 Jan 2014 04:33:51 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from localhost (tschai [192.168.1.10])
	by tschai.lan (Postfix) with ESMTPSA id 845002A009C
	for <linux-media@vger.kernel.org>; Thu,  9 Jan 2014 04:33:41 +0100 (CET)
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: cron job: media_tree daily build: WARNINGS
Message-Id: <20140109033341.845002A009C@tschai.lan>
Date: Thu,  9 Jan 2014 04:33:41 +0100 (CET)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This message is generated daily by a cron job that builds media_tree for
the kernels and architectures in the list below.

Results of the daily build of media_tree:

date:		Thu Jan  9 04:00:24 CET 2014
git branch:	test
git hash:	dad4c41827c71a84c8455e19431278e8c1edf118
gcc version:	i686-linux-gcc (GCC) 4.8.2
sparse version:	0.4.5-rc1
host hardware:	x86_64
host os:	3.12-6.slh.2-amd64

linux-git-arm-at91: OK
linux-git-arm-davinci: OK
linux-git-arm-exynos: WARNINGS
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
linux-3.0.60-i686: WARNINGS
linux-3.1.10-i686: WARNINGS
linux-3.2.37-i686: OK
linux-3.3.8-i686: OK
linux-3.4.27-i686: WARNINGS
linux-3.5.7-i686: WARNINGS
linux-3.6.11-i686: WARNINGS
linux-3.7.4-i686: WARNINGS
linux-3.8-i686: WARNINGS
linux-3.9.2-i686: WARNINGS
linux-3.10.1-i686: OK
linux-3.11.1-i686: OK
linux-3.12-i686: OK
linux-3.13-rc1-i686: OK
linux-2.6.31.14-x86_64: WARNINGS
linux-2.6.32.27-x86_64: WARNINGS
linux-2.6.33.7-x86_64: WARNINGS
linux-2.6.34.7-x86_64: WARNINGS
linux-2.6.35.9-x86_64: WARNINGS
linux-2.6.36.4-x86_64: WARNINGS
linux-2.6.37.6-x86_64: WARNINGS
linux-2.6.38.8-x86_64: WARNINGS
linux-2.6.39.4-x86_64: WARNINGS
linux-3.0.60-x86_64: WARNINGS
linux-3.1.10-x86_64: WARNINGS
linux-3.2.37-x86_64: OK
linux-3.3.8-x86_64: OK
linux-3.4.27-x86_64: WARNINGS
linux-3.5.7-x86_64: WARNINGS
linux-3.6.11-x86_64: WARNINGS
linux-3.7.4-x86_64: WARNINGS
linux-3.8-x86_64: WARNINGS
linux-3.9.2-x86_64: WARNINGS
linux-3.10.1-x86_64: OK
linux-3.11.1-x86_64: OK
linux-3.12-x86_64: OK
linux-3.13-rc1-x86_64: OK
apps: OK
spec-git: OK
sparse version:	0.4.5-rc1
sparse: ERRORS

Detailed results are available here:

http://www.xs4all.nl/~hverkuil/logs/Thursday.log

Full logs are available here:

http://www.xs4all.nl/~hverkuil/logs/Thursday.tar.bz2

The Media Infrastructure API from this daily build is here:

http://www.xs4all.nl/~hverkuil/spec/media.html
