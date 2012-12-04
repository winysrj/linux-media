Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3604 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab2LDUw3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Dec 2012 15:52:29 -0500
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr10.xs4all.nl (8.13.8/8.13.8) with ESMTP id qB4KqQ81011117
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Tue, 4 Dec 2012 21:52:28 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from localhost (marune.xs4all.nl [80.101.105.217])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id CC2B665A028E
	for <linux-media@vger.kernel.org>; Tue,  4 Dec 2012 21:52:25 +0100 (CET)
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: cron job: media_tree daily build: ERRORS
Message-Id: <20121204205225.CC2B665A028E@alastor.dyndns.org>
Date: Tue,  4 Dec 2012 21:52:25 +0100 (CET)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This message is generated daily by a cron job that builds media_tree for
the kernels and architectures in the list below.

Results of the daily build of media_tree:

date:        Tue Dec  4 19:00:23 CET 2012
git hash:    16427faf28674451a7a0485ab0a929402f355ffd
gcc version:      i686-linux-gcc (GCC) 4.7.1
host hardware:    x86_64
host os:          3.4.07-marune

linux-git-arm-eabi-davinci: WARNINGS
linux-git-arm-eabi-exynos: OK
linux-git-arm-eabi-omap: WARNINGS
linux-git-i686: WARNINGS
linux-git-m32r: OK
linux-git-mips: WARNINGS
linux-git-powerpc64: OK
linux-git-sh: WARNINGS
linux-git-x86_64: WARNINGS
linux-2.6.31.12-i686: WARNINGS
linux-2.6.32.6-i686: WARNINGS
linux-2.6.33-i686: WARNINGS
linux-2.6.34-i686: WARNINGS
linux-2.6.35.3-i686: WARNINGS
linux-2.6.36-i686: WARNINGS
linux-2.6.37-i686: WARNINGS
linux-2.6.38.2-i686: WARNINGS
linux-2.6.39.1-i686: WARNINGS
linux-3.0-i686: WARNINGS
linux-3.1-i686: WARNINGS
linux-3.2.1-i686: WARNINGS
linux-3.3-i686: WARNINGS
linux-3.4-i686: ERRORS
linux-3.5-i686: ERRORS
linux-3.6-i686: WARNINGS
linux-3.7-rc1-i686: WARNINGS
linux-2.6.31.12-x86_64: WARNINGS
linux-2.6.32.6-x86_64: WARNINGS
linux-2.6.33-x86_64: WARNINGS
linux-2.6.34-x86_64: WARNINGS
linux-2.6.35.3-x86_64: WARNINGS
linux-2.6.36-x86_64: WARNINGS
linux-2.6.37-x86_64: WARNINGS
linux-2.6.38.2-x86_64: WARNINGS
linux-2.6.39.1-x86_64: WARNINGS
linux-3.0-x86_64: WARNINGS
linux-3.1-x86_64: WARNINGS
linux-3.2.1-x86_64: WARNINGS
linux-3.3-x86_64: WARNINGS
linux-3.4-x86_64: ERRORS
linux-3.5-x86_64: ERRORS
linux-3.6-x86_64: WARNINGS
linux-3.7-rc1-x86_64: WARNINGS
apps: WARNINGS
spec-git: WARNINGS
sparse: ERRORS

Detailed results are available here:

http://www.xs4all.nl/~hverkuil/logs/Tuesday.log

Full logs are available here:

http://www.xs4all.nl/~hverkuil/logs/Tuesday.tar.bz2

The V4L-DVB specification from this daily build is here:

http://www.xs4all.nl/~hverkuil/spec/media.html
