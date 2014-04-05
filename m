Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2306 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933AbaDECfo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Apr 2014 22:35:44 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr9.xs4all.nl (8.13.8/8.13.8) with ESMTP id s352ZfdI076514
	for <linux-media@vger.kernel.org>; Sat, 5 Apr 2014 04:35:43 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from localhost (tschai [192.168.1.10])
	by tschai.lan (Postfix) with ESMTPSA id A2F142A03F4
	for <linux-media@vger.kernel.org>; Sat,  5 Apr 2014 04:35:29 +0200 (CEST)
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: cron job: media_tree daily build: OK
Message-Id: <20140405023529.A2F142A03F4@tschai.lan>
Date: Sat,  5 Apr 2014 04:35:29 +0200 (CEST)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This message is generated daily by a cron job that builds media_tree for
the kernels and architectures in the list below.

Results of the daily build of media_tree:

date:		Sat Apr  5 04:00:42 CEST 2014
git branch:	test
git hash:	a83b93a7480441a47856dc9104bea970e84cda87
gcc version:	i686-linux-gcc (GCC) 4.8.2
sparse version:	v0.5.0-11-g38d1124
host hardware:	x86_64
host os:	3.13-7.slh.1-amd64

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
linux-2.6.31.14-i686: OK
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
linux-3.8-i686: OK
linux-3.9.2-i686: OK
linux-3.10.1-i686: OK
linux-3.11.1-i686: OK
linux-3.12-i686: OK
linux-3.13-i686: OK
linux-3.14-i686: OK
linux-2.6.31.14-x86_64: OK
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
linux-3.8-x86_64: OK
linux-3.9.2-x86_64: OK
linux-3.10.1-x86_64: OK
linux-3.11.1-x86_64: OK
linux-3.12-x86_64: OK
linux-3.13-x86_64: OK
linux-3.14-x86_64: OK
apps: OK
spec-git: OK
sparse version:	v0.5.0-11-g38d1124
sparse: ERRORS

Detailed results are available here:

http://www.xs4all.nl/~hverkuil/logs/Saturday.log

Full logs are available here:

http://www.xs4all.nl/~hverkuil/logs/Saturday.tar.bz2

The Media Infrastructure API from this daily build is here:

http://www.xs4all.nl/~hverkuil/spec/media.html
