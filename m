Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4013 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab3CWSyb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Mar 2013 14:54:31 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr2.xs4all.nl (8.13.8/8.13.8) with ESMTP id r2NIsSpc002703
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Sat, 23 Mar 2013 19:54:30 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from localhost (marune.xs4all.nl [80.101.105.217])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id D05B411E018E
	for <linux-media@vger.kernel.org>; Sat, 23 Mar 2013 19:54:27 +0100 (CET)
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: cron job: media_tree daily build: ERRORS
Message-Id: <20130323185427.D05B411E018E@alastor.dyndns.org>
Date: Sat, 23 Mar 2013 19:54:27 +0100 (CET)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This message is generated daily by a cron job that builds media_tree for
the kernels and architectures in the list below.

Results of the daily build of media_tree:

date:		Sat Mar 23 19:03:46 CET 2013
git branch:	test
git hash:	69aa6f4ec669b9121057cc9e32cb10b5f744f6d6
gcc version:	i686-linux-gcc (GCC) 4.7.2
host hardware:	x86_64
host os:	3.8-3.slh.2-amd64

linux-git-arm-davinci: OK
linux-git-arm-exynos: ERRORS
linux-git-arm-omap: WARNINGS
linux-git-blackfin: WARNINGS
linux-git-i686: OK
linux-git-m32r: OK
linux-git-mips: ERRORS
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
linux-3.1.10-i686: WARNINGS
linux-3.2.37-i686: WARNINGS
linux-3.3.8-i686: WARNINGS
linux-3.4.27-i686: WARNINGS
linux-3.5.7-i686: WARNINGS
linux-3.6.11-i686: ERRORS
linux-3.7.4-i686: ERRORS
linux-3.8-i686: ERRORS
linux-3.9-rc1-i686: WARNINGS
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
linux-3.1.10-x86_64: WARNINGS
linux-3.2.37-x86_64: WARNINGS
linux-3.3.8-x86_64: WARNINGS
linux-3.4.27-x86_64: WARNINGS
linux-3.5.7-x86_64: WARNINGS
linux-3.6.11-x86_64: ERRORS
linux-3.7.4-x86_64: ERRORS
linux-3.8-x86_64: ERRORS
linux-3.9-rc1-x86_64: WARNINGS
apps: WARNINGS
spec-git: OK
sparse: ERRORS

Detailed results are available here:

http://www.xs4all.nl/~hverkuil/logs/Saturday.log

Full logs are available here:

http://www.xs4all.nl/~hverkuil/logs/Saturday.tar.bz2

The Media Infrastructure API from this daily build is here:

http://www.xs4all.nl/~hverkuil/spec/media.html
