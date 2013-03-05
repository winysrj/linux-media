Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3895 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab3CETsi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2013 14:48:38 -0500
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr10.xs4all.nl (8.13.8/8.13.8) with ESMTP id r25JmYqf050381
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Tue, 5 Mar 2013 20:48:37 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from localhost (marune.xs4all.nl [80.101.105.217])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 8A75511E00AE
	for <linux-media@vger.kernel.org>; Tue,  5 Mar 2013 20:48:28 +0100 (CET)
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: cron job: media_tree daily build: ERRORS
Message-Id: <20130305194828.8A75511E00AE@alastor.dyndns.org>
Date: Tue,  5 Mar 2013 20:48:28 +0100 (CET)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This message is generated daily by a cron job that builds media_tree for
the kernels and architectures in the list below.

Results of the daily build of media_tree:

date:		Tue Mar  5 19:00:23 CET 2013
git branch:	test
git hash:	5ce60d790a246c4c32043ac9b142615466479728
gcc version:	i686-linux-gcc (GCC) 4.7.2
host hardware:	x86_64
host os:	3.8.03-marune

linux-git-arm-davinci: WARNINGS
linux-git-arm-exynos: WARNINGS
linux-git-arm-omap: WARNINGS
linux-git-blackfin: WARNINGS
linux-git-i686: OK
linux-git-m32r: OK
linux-git-mips: WARNINGS
linux-git-Module.symvers: ERRORS
linux-git-powerpc64: OK
linux-git-sh: OK
linux-git-x86_64: OK
linux-2.6.31.14-i686: ERRORS
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
linux-3.9-rc1-i686: OK
linux-2.6.31.14-x86_64: ERRORS
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
linux-3.9-rc1-x86_64: WARNINGS
apps: WARNINGS
spec-git: OK
sparse: ERRORS

Detailed results are available here:

http://www.xs4all.nl/~hverkuil/logs/Tuesday.log

Full logs are available here:

http://www.xs4all.nl/~hverkuil/logs/Tuesday.tar.bz2

The Media Infrastructure API from this daily build is here:

http://www.xs4all.nl/~hverkuil/spec/media.html
