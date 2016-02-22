Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:58729 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752823AbcBVD3Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Feb 2016 22:29:16 -0500
Received: from localhost (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 37A3918008B
	for <linux-media@vger.kernel.org>; Mon, 22 Feb 2016 04:29:11 +0100 (CET)
Date: Mon, 22 Feb 2016 04:29:11 +0100
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: cron job: media_tree daily build: ERRORS
Message-Id: <20160222032911.37A3918008B@tschai.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This message is generated daily by a cron job that builds media_tree for
the kernels and architectures in the list below.

Results of the daily build of media_tree:

date:		Mon Feb 22 04:00:13 CET 2016
git branch:	test
git hash:	f7b5dff0b59b20469b2a4889e6170c0069d37c8d
gcc version:	i686-linux-gcc (GCC) 5.1.0
sparse version:	v0.5.0-51-ga53cea2
smatch version:	v0.5.0-3228-g5cf65ab
host hardware:	x86_64
host os:	4.4.0-164

linux-git-arm-at91: OK
linux-git-arm-davinci: ERRORS
linux-git-arm-exynos: ERRORS
linux-git-arm-mx: ERRORS
linux-git-arm-omap: ERRORS
linux-git-arm-omap1: ERRORS
linux-git-arm-pxa: OK
linux-git-blackfin-bf561: ERRORS
linux-git-i686: ERRORS
linux-git-m32r: ERRORS
linux-git-mips: ERRORS
linux-git-powerpc64: OK
linux-git-sh: ERRORS
linux-git-x86_64: ERRORS
linux-2.6.36.4-i686: OK
linux-2.6.37.6-i686: OK
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
linux-3.8-i686: OK
linux-3.9.2-i686: ERRORS
linux-3.10.1-i686: ERRORS
linux-3.11.1-i686: OK
linux-3.12.23-i686: OK
linux-3.13.11-i686: ERRORS
linux-3.14.9-i686: ERRORS
linux-3.15.2-i686: ERRORS
linux-3.16.7-i686: ERRORS
linux-3.17.8-i686: ERRORS
linux-3.18.7-i686: ERRORS
linux-3.19-i686: ERRORS
linux-4.0-i686: ERRORS
linux-4.1.1-i686: ERRORS
linux-4.2-i686: ERRORS
linux-4.3-i686: ERRORS
linux-4.4-i686: ERRORS
linux-4.5-rc1-i686: ERRORS
linux-2.6.36.4-x86_64: OK
linux-2.6.37.6-x86_64: OK
linux-2.6.38.8-x86_64: OK
linux-2.6.39.4-x86_64: ERRORS
linux-3.0.60-x86_64: ERRORS
linux-3.1.10-x86_64: ERRORS
linux-3.2.37-x86_64: OK
linux-3.3.8-x86_64: OK
linux-3.4.27-x86_64: ERRORS
linux-3.5.7-x86_64: ERRORS
linux-3.6.11-x86_64: ERRORS
linux-3.7.4-x86_64: ERRORS
linux-3.8-x86_64: ERRORS
linux-3.9.2-x86_64: ERRORS
linux-3.10.1-x86_64: ERRORS
linux-3.11.1-x86_64: ERRORS
linux-3.12.23-x86_64: OK
linux-3.13.11-x86_64: OK
linux-3.14.9-x86_64: ERRORS
linux-3.15.2-x86_64: ERRORS
linux-3.16.7-x86_64: OK
linux-3.17.8-x86_64: OK
linux-3.18.7-x86_64: ERRORS
linux-3.19-x86_64: ERRORS
linux-4.0-x86_64: ERRORS
linux-4.1.1-x86_64: ERRORS
linux-4.2-x86_64: ERRORS
linux-4.3-x86_64: ERRORS
linux-4.4-x86_64: ERRORS
linux-4.5-rc1-x86_64: ERRORS
apps: OK
spec-git: OK
sparse: ERRORS
smatch: ERRORS

Detailed results are available here:

http://www.xs4all.nl/~hverkuil/logs/Monday.log

Full logs are available here:

http://www.xs4all.nl/~hverkuil/logs/Monday.tar.bz2

The Media Infrastructure API from this daily build is here:

http://www.xs4all.nl/~hverkuil/spec/media.html
