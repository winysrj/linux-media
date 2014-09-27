Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4259 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaI0C0J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Sep 2014 22:26:09 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209])
	(authenticated bits=0)
	by smtp-vbr11.xs4all.nl (8.13.8/8.13.8) with ESMTP id s8R2Q5Q7047972
	for <linux-media@vger.kernel.org>; Sat, 27 Sep 2014 04:26:07 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from localhost (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id CB1592A1CED
	for <linux-media@vger.kernel.org>; Sat, 27 Sep 2014 04:25:51 +0200 (CEST)
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: cron job: media_tree daily build: ERRORS
Message-Id: <20140927022551.CB1592A1CED@tschai.lan>
Date: Sat, 27 Sep 2014 04:25:51 +0200 (CEST)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This message is generated daily by a cron job that builds media_tree for
the kernels and architectures in the list below.

Results of the daily build of media_tree:

date:		Sat Sep 27 04:00:18 CEST 2014
git branch:	test
git hash:	214635f94dc3e4069b05817e5d55b58784ba8971
gcc version:	i686-linux-gcc (GCC) 4.9.1
sparse version:	v0.5.0-20-g7abd8a7
host hardware:	x86_64
host os:	3.16-2.slh.3-amd64

linux-git-arm-at91: OK
linux-git-arm-davinci: ERRORS
linux-git-arm-exynos: OK
linux-git-arm-mx: OK
linux-git-arm-omap: OK
linux-git-arm-omap1: OK
linux-git-arm-pxa: OK
linux-git-blackfin: OK
linux-git-i686: OK
linux-git-m32r: OK
linux-git-mips: ERRORS
linux-git-powerpc64: OK
linux-git-sh: OK
linux-git-x86_64: OK
linux-2.6.32.27-i686: ERRORS
linux-2.6.33.7-i686: ERRORS
linux-2.6.34.7-i686: ERRORS
linux-2.6.35.9-i686: ERRORS
linux-2.6.36.4-i686: ERRORS
linux-2.6.37.6-i686: ERRORS
linux-2.6.38.8-i686: ERRORS
linux-2.6.39.4-i686: ERRORS
linux-3.0.60-i686: ERRORS
linux-3.1.10-i686: ERRORS
linux-3.2.37-i686: ERRORS
linux-3.3.8-i686: ERRORS
linux-3.4.27-i686: ERRORS
linux-3.5.7-i686: ERRORS
linux-3.6.11-i686: ERRORS
linux-3.7.4-i686: ERRORS
linux-3.8-i686: ERRORS
linux-3.9.2-i686: ERRORS
linux-3.10.1-i686: ERRORS
linux-3.11.1-i686: ERRORS
linux-3.12.23-i686: ERRORS
linux-3.13.11-i686: ERRORS
linux-3.14.9-i686: ERRORS
linux-3.15.2-i686: WARNINGS
linux-3.16-i686: WARNINGS
linux-3.17-rc1-i686: WARNINGS
linux-2.6.32.27-x86_64: ERRORS
linux-2.6.33.7-x86_64: ERRORS
linux-2.6.34.7-x86_64: ERRORS
linux-2.6.35.9-x86_64: ERRORS
linux-2.6.36.4-x86_64: ERRORS
linux-2.6.37.6-x86_64: ERRORS
linux-2.6.38.8-x86_64: ERRORS
linux-2.6.39.4-x86_64: ERRORS
linux-3.0.60-x86_64: ERRORS
linux-3.1.10-x86_64: ERRORS
linux-3.2.37-x86_64: ERRORS
linux-3.3.8-x86_64: ERRORS
linux-3.4.27-x86_64: ERRORS
linux-3.5.7-x86_64: ERRORS
linux-3.6.11-x86_64: ERRORS
linux-3.7.4-x86_64: ERRORS
linux-3.8-x86_64: ERRORS
linux-3.9.2-x86_64: ERRORS
linux-3.10.1-x86_64: ERRORS
linux-3.11.1-x86_64: ERRORS
linux-3.12.23-x86_64: ERRORS
linux-3.13.11-x86_64: ERRORS
linux-3.14.9-x86_64: ERRORS
linux-3.15.2-x86_64: WARNINGS
linux-3.16-x86_64: WARNINGS
linux-3.17-rc1-x86_64: WARNINGS
apps: OK
spec-git: OK
sparse: WARNINGS

Detailed results are available here:

http://www.xs4all.nl/~hverkuil/logs/Saturday.log

Full logs are available here:

http://www.xs4all.nl/~hverkuil/logs/Saturday.tar.bz2

The Media Infrastructure API from this daily build is here:

http://www.xs4all.nl/~hverkuil/spec/media.html
