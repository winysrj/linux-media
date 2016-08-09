Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:51038 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752426AbcHIC7m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Aug 2016 22:59:42 -0400
Received: from localhost (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 122B11800D5
	for <linux-media@vger.kernel.org>; Tue,  9 Aug 2016 04:59:36 +0200 (CEST)
Date: Tue, 09 Aug 2016 04:59:36 +0200
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: cron job: media_tree daily build: ERRORS
Message-Id: <20160809025936.122B11800D5@tschai.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This message is generated daily by a cron job that builds media_tree for
the kernels and architectures in the list below.

Results of the daily build of media_tree:

date:		Tue Aug  9 04:00:27 CEST 2016
git branch:	test
git hash:	b6aa39228966e0d3f0bc3306be1892f87792903a
gcc version:	i686-linux-gcc (GCC) 5.4.0
sparse version:	v0.5.0-56-g7647c77
smatch version:	v0.5.0-3428-gdfe27cf
host hardware:	x86_64
host os:	4.6.0-164

linux-git-arm-at91: ERRORS
linux-git-arm-davinci: ERRORS
linux-git-arm-multi: ERRORS
linux-git-blackfin-bf561: ERRORS
linux-git-i686: OK
linux-git-m32r: OK
linux-git-mips: ERRORS
linux-git-powerpc64: OK
linux-git-sh: ERRORS
linux-git-x86_64: OK
linux-2.6.36.4-i686: ERRORS
linux-2.6.37.6-i686: ERRORS
linux-2.6.38.8-i686: ERRORS
linux-2.6.39.4-i686: ERRORS
linux-3.0.60-i686: ERRORS
linux-3.1.10-i686: ERRORS
linux-3.2.37-i686: OK
linux-3.3.8-i686: OK
linux-3.4.27-i686: OK
linux-3.5.7-i686: OK
linux-3.6.11-i686: WARNINGS
linux-3.7.4-i686: WARNINGS
linux-3.8-i686: WARNINGS
linux-3.9.2-i686: WARNINGS
linux-3.10.1-i686: WARNINGS
linux-3.11.1-i686: WARNINGS
linux-3.12.23-i686: WARNINGS
linux-3.13.11-i686: WARNINGS
linux-3.14.9-i686: WARNINGS
linux-3.15.2-i686: WARNINGS
linux-3.16.7-i686: WARNINGS
linux-3.17.8-i686: WARNINGS
linux-3.18.7-i686: WARNINGS
linux-3.19-i686: WARNINGS
linux-4.0-i686: WARNINGS
linux-4.1.1-i686: WARNINGS
linux-4.2-i686: WARNINGS
linux-4.3-i686: WARNINGS
linux-4.4-i686: WARNINGS
linux-4.5-i686: WARNINGS
linux-4.6-i686: WARNINGS
linux-4.7-i686: WARNINGS
linux-2.6.36.4-x86_64: ERRORS
linux-2.6.37.6-x86_64: ERRORS
linux-2.6.38.8-x86_64: ERRORS
linux-2.6.39.4-x86_64: ERRORS
linux-3.0.60-x86_64: ERRORS
linux-3.1.10-x86_64: ERRORS
linux-3.2.37-x86_64: OK
linux-3.3.8-x86_64: OK
linux-3.4.27-x86_64: OK
linux-3.5.7-x86_64: OK
linux-3.6.11-x86_64: WARNINGS
linux-3.7.4-x86_64: WARNINGS
linux-3.8-x86_64: WARNINGS
linux-3.9.2-x86_64: WARNINGS
linux-3.10.1-x86_64: WARNINGS
linux-3.11.1-x86_64: WARNINGS
linux-3.12.23-x86_64: WARNINGS
linux-3.13.11-x86_64: WARNINGS
linux-3.14.9-x86_64: WARNINGS
linux-3.15.2-x86_64: WARNINGS
linux-3.16.7-x86_64: WARNINGS
linux-3.17.8-x86_64: WARNINGS
linux-3.18.7-x86_64: WARNINGS
linux-3.19-x86_64: WARNINGS
linux-4.0-x86_64: WARNINGS
linux-4.1.1-x86_64: WARNINGS
linux-4.2-x86_64: WARNINGS
linux-4.3-x86_64: WARNINGS
linux-4.4-x86_64: WARNINGS
linux-4.5-x86_64: WARNINGS
linux-4.6-x86_64: WARNINGS
linux-4.7-x86_64: WARNINGS
apps: WARNINGS
spec-git: OK
sparse: WARNINGS
smatch: WARNINGS

Detailed results are available here:

http://www.xs4all.nl/~hverkuil/logs/Tuesday.log

Full logs are available here:

http://www.xs4all.nl/~hverkuil/logs/Tuesday.tar.bz2

The Media Infrastructure API from this daily build is here:

http://www.xs4all.nl/~hverkuil/spec/index.html
