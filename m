Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4774 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756375Ab3BJVLF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Feb 2013 16:11:05 -0500
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166])
	(authenticated bits=0)
	by smtp-vbr14.xs4all.nl (8.13.8/8.13.8) with ESMTP id r1ALB1W0079374
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Sun, 10 Feb 2013 22:11:04 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from localhost (marune.xs4all.nl [80.101.105.217])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 127C311E00B9
	for <linux-media@vger.kernel.org>; Sun, 10 Feb 2013 22:11:00 +0100 (CET)
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: cron job: media_tree daily build: ERRORS
Message-Id: <20130210211101.127C311E00B9@alastor.dyndns.org>
Date: Sun, 10 Feb 2013 22:11:00 +0100 (CET)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This message is generated daily by a cron job that builds media_tree for
the kernels and architectures in the list below.

Results of the daily build of media_tree:

date:		Sun Feb 10 19:00:18 CET 2013
git branch:	for_v3.9
git hash:	4880f56438ef56457edd5548b257382761591998
gcc version:	i686-linux-gcc (GCC) 4.7.2
host hardware:	x86_64
host os:	3.8.03-marune

linux-git-arm-davinci: WARNINGS
linux-git-arm-exynos: ERRORS
linux-git-arm-omap: WARNINGS
linux-git-i686: OK
linux-git-m32r: OK
linux-git-mips: WARNINGS
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
linux-3.2.37-i686: WARNINGS
linux-3.3.8-i686: WARNINGS
linux-3.4.27-i686: WARNINGS
linux-3.5.7-i686: WARNINGS
linux-3.6.11-i686: WARNINGS
linux-3.7.4-i686: WARNINGS
linux-3.8-rc4-i686: OK
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
linux-3.2.37-x86_64: WARNINGS
linux-3.3.8-x86_64: WARNINGS
linux-3.4.27-x86_64: WARNINGS
linux-3.5.7-x86_64: WARNINGS
linux-3.6.11-x86_64: WARNINGS
linux-3.7.4-x86_64: WARNINGS
linux-3.8-rc4-x86_64: WARNINGS
apps: WARNINGS
spec-git: OK
sparse: ERRORS

Detailed results are available here:

http://www.xs4all.nl/~hverkuil/logs/Sunday.log

Full logs are available here:

http://www.xs4all.nl/~hverkuil/logs/Sunday.tar.bz2

The Media Infrastructure API from this daily build is here:

http://www.xs4all.nl/~hverkuil/spec/media.html
