Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:57640 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750996AbcGNC0r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 22:26:47 -0400
Received: from localhost (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 4864A1803C0
	for <linux-media@vger.kernel.org>; Thu, 14 Jul 2016 04:26:42 +0200 (CEST)
Date: Thu, 14 Jul 2016 04:26:42 +0200
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: cron job: media_tree daily build: ERRORS
Message-Id: <20160714022642.4864A1803C0@tschai.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This message is generated daily by a cron job that builds media_tree for
the kernels and architectures in the list below.

Results of the daily build of media_tree:

date:		Thu Jul 14 04:00:19 CEST 2016
git branch:	test
git hash:	5cac1f67ea0363d463a58ec2d9118268fe2ba5d6
gcc version:	i686-linux-gcc (GCC) 5.3.0
sparse version:	v0.5.0-56-g7647c77
smatch version:	v0.5.0-3428-gdfe27cf
host hardware:	x86_64
host os:	4.6.0-164

linux-git-arm-at91: OK
linux-git-arm-davinci: OK
linux-git-arm-multi: ERRORS
linux-git-blackfin-bf561: OK
linux-git-i686: OK
linux-git-m32r: OK
linux-git-mips: OK
linux-git-powerpc64: OK
linux-git-sh: OK
linux-git-x86_64: OK
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
linux-4.5-i686: ERRORS
linux-4.6-i686: ERRORS
linux-4.7-rc1-i686: ERRORS
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
linux-3.15.2-x86_64: ERRORS
linux-3.16.7-x86_64: ERRORS
linux-3.17.8-x86_64: ERRORS
linux-3.18.7-x86_64: ERRORS
linux-3.19-x86_64: ERRORS
linux-4.0-x86_64: ERRORS
linux-4.1.1-x86_64: ERRORS
linux-4.2-x86_64: ERRORS
linux-4.3-x86_64: ERRORS
linux-4.4-x86_64: ERRORS
linux-4.5-x86_64: ERRORS
linux-4.6-x86_64: ERRORS
linux-4.7-rc1-x86_64: ERRORS
apps: OK
spec-git: OK
sparse: WARNINGS
smatch: WARNINGS

Detailed results are available here:

http://www.xs4all.nl/~hverkuil/logs/Thursday.log

Full logs are available here:

http://www.xs4all.nl/~hverkuil/logs/Thursday.tar.bz2

The Media Infrastructure API from this daily build is here:

http://www.xs4all.nl/~hverkuil/spec/media.html
