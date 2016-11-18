Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:34742 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751222AbcKREbc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Nov 2016 23:31:32 -0500
Message-ID: <c1b0c10a840e6f8bd6348607ed9e0428@smtp-cloud2.xs4all.net>
Date: Fri, 18 Nov 2016 05:31:29 +0100
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: cron job: media_tree daily build: ERRORS
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This message is generated daily by a cron job that builds media_tree for
the kernels and architectures in the list below.

Results of the daily build of media_tree:

date:			Fri Nov 18 05:00:15 CET 2016
media-tree git hash:	9e3d073009d271b694a1187414663fa89b968523
media_build git hash:	bd61d1f4217e104f91df1ba1b5a4594e379829de
v4l-utils git hash:	df1d86260fa3bf713194fb5f508ee74c8ae7385d
gcc version:		i686-linux-gcc (GCC) 6.2.0
sparse version:		v0.5.0-3553-g78b2ea6
smatch version:		v0.5.0-3553-g78b2ea6
host hardware:		x86_64
host os:		4.7.0-164

linux-git-arm-at91: OK
linux-git-arm-davinci: WARNINGS
linux-git-arm-multi: OK
linux-git-arm-pxa: OK
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
linux-3.12.67-i686: ERRORS
linux-3.13.11-i686: ERRORS
linux-3.14.9-i686: ERRORS
linux-3.15.2-i686: ERRORS
linux-3.16.7-i686: ERRORS
linux-3.17.8-i686: ERRORS
linux-3.18.7-i686: ERRORS
linux-3.19-i686: ERRORS
linux-4.0.9-i686: ERRORS
linux-4.1.33-i686: ERRORS
linux-4.2.8-i686: ERRORS
linux-4.3.6-i686: ERRORS
linux-4.4.22-i686: ERRORS
linux-4.5.7-i686: ERRORS
linux-4.6.7-i686: ERRORS
linux-4.7.5-i686: ERRORS
linux-4.8-i686: ERRORS
linux-4.9-rc5-i686: OK
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
linux-3.12.67-x86_64: ERRORS
linux-3.13.11-x86_64: ERRORS
linux-3.14.9-x86_64: ERRORS
linux-3.15.2-x86_64: ERRORS
linux-3.16.7-x86_64: ERRORS
linux-3.17.8-x86_64: ERRORS
linux-3.18.7-x86_64: ERRORS
linux-3.19-x86_64: ERRORS
linux-4.0.9-x86_64: ERRORS
linux-4.1.33-x86_64: ERRORS
linux-4.2.8-x86_64: ERRORS
linux-4.3.6-x86_64: ERRORS
linux-4.4.22-x86_64: ERRORS
linux-4.5.7-x86_64: ERRORS
linux-4.6.7-x86_64: ERRORS
linux-4.7.5-x86_64: ERRORS
linux-4.8-x86_64: ERRORS
linux-4.9-rc5-x86_64: OK
apps: WARNINGS
spec-git: OK
smatch: ERRORS
ABI WARNING: change for arm-at91
ABI WARNING: change for arm-davinci
ABI WARNING: change for arm-multi
ABI WARNING: change for arm-pxa
ABI WARNING: change for blackfin-bf561
ABI WARNING: change for mips
ABI WARNING: change for sh
sparse: WARNINGS

Detailed results are available here:

http://www.xs4all.nl/~hverkuil/logs/Friday.log

Full logs are available here:

http://www.xs4all.nl/~hverkuil/logs/Friday.tar.bz2

The Media Infrastructure API from this daily build is here:

http://www.xs4all.nl/~hverkuil/spec/index.html
