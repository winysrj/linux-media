Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:60136 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751978AbeBVEn5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 23:43:57 -0500
Message-ID: <5688a918bd3e57d8b14b94c5d98c98c1@smtp-cloud7.xs4all.net>
Date: Thu, 22 Feb 2018 05:43:50 +0100
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: cron job: media_tree daily build: ABI WARNING
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This message is generated daily by a cron job that builds media_tree for
the kernels and architectures in the list below.

Results of the daily build of media_tree:

date:			Thu Feb 22 05:00:16 CET 2018
media-tree git hash:	29422737017b866d4a51014cc7522fa3a99e8852
media_build git hash:	d144cfe4b3c37ece55ae27778c99765d4943c4fa
v4l-utils git hash:	df81877f81b130d0c2bdc952367e29f55f1352f1
gcc version:		i686-linux-gcc (GCC) 7.3.0
sparse version:		v0.5.0-3994-g45eb2282
smatch version:		v0.5.0-3994-g45eb2282
host hardware:		x86_64
host os:		4.14.0-3-amd64

linux-git-arm-at91: OK
linux-git-arm-davinci: OK
linux-git-arm-multi: OK
linux-git-arm-pxa: OK
linux-git-arm-stm32: OK
linux-git-arm64: OK
linux-git-blackfin-bf561: OK
linux-git-i686: OK
linux-git-m32r: OK
linux-git-mips: OK
linux-git-powerpc64: OK
linux-git-sh: OK
linux-git-x86_64: OK
linux-2.6.36.4-i686: WARNINGS
linux-2.6.36.4-x86_64: WARNINGS
linux-2.6.37.6-i686: WARNINGS
linux-2.6.37.6-x86_64: WARNINGS
linux-2.6.38.8-i686: WARNINGS
linux-2.6.38.8-x86_64: WARNINGS
linux-2.6.39.4-i686: WARNINGS
linux-2.6.39.4-x86_64: WARNINGS
linux-3.0.60-i686: WARNINGS
linux-3.0.60-x86_64: WARNINGS
linux-3.1.10-i686: WARNINGS
linux-3.1.10-x86_64: WARNINGS
linux-3.2.98-i686: WARNINGS
linux-3.2.98-x86_64: WARNINGS
linux-3.3.8-i686: WARNINGS
linux-3.3.8-x86_64: WARNINGS
linux-3.4.27-i686: WARNINGS
linux-3.4.27-x86_64: WARNINGS
linux-3.5.7-i686: WARNINGS
linux-3.5.7-x86_64: WARNINGS
linux-3.6.11-i686: WARNINGS
linux-3.6.11-x86_64: WARNINGS
linux-3.7.4-i686: WARNINGS
linux-3.7.4-x86_64: WARNINGS
linux-3.8-i686: WARNINGS
linux-3.8-x86_64: WARNINGS
linux-3.9.2-i686: WARNINGS
linux-3.9.2-x86_64: WARNINGS
linux-3.10.1-i686: WARNINGS
linux-3.10.1-x86_64: WARNINGS
linux-3.11.1-i686: WARNINGS
linux-3.11.1-x86_64: WARNINGS
linux-3.12.67-i686: WARNINGS
linux-3.12.67-x86_64: WARNINGS
linux-3.13.11-i686: WARNINGS
linux-3.13.11-x86_64: WARNINGS
linux-3.14.9-i686: WARNINGS
linux-3.14.9-x86_64: WARNINGS
linux-3.15.2-i686: WARNINGS
linux-3.15.2-x86_64: WARNINGS
linux-3.16.53-i686: WARNINGS
linux-3.16.53-x86_64: WARNINGS
linux-3.17.8-i686: WARNINGS
linux-3.17.8-x86_64: WARNINGS
linux-3.18.93-i686: WARNINGS
linux-3.18.93-x86_64: WARNINGS
linux-3.19-i686: WARNINGS
linux-3.19-x86_64: WARNINGS
linux-4.0.9-i686: WARNINGS
linux-4.0.9-x86_64: WARNINGS
linux-4.1.49-i686: WARNINGS
linux-4.1.49-x86_64: WARNINGS
linux-4.2.8-i686: WARNINGS
linux-4.2.8-x86_64: WARNINGS
linux-4.3.6-i686: WARNINGS
linux-4.3.6-x86_64: WARNINGS
linux-4.4.115-i686: OK
linux-4.4.115-x86_64: OK
linux-4.5.7-i686: WARNINGS
linux-4.5.7-x86_64: WARNINGS
linux-4.6.7-i686: OK
linux-4.6.7-x86_64: WARNINGS
linux-4.7.5-i686: OK
linux-4.7.5-x86_64: WARNINGS
linux-4.8-i686: OK
linux-4.8-x86_64: WARNINGS
linux-4.9.80-i686: OK
linux-4.9.80-x86_64: OK
linux-4.10.14-i686: OK
linux-4.10.14-x86_64: WARNINGS
linux-4.11-i686: OK
linux-4.11-x86_64: WARNINGS
linux-4.12.1-i686: OK
linux-4.12.1-x86_64: WARNINGS
linux-4.13-i686: OK
linux-4.13-x86_64: OK
linux-4.14.17-i686: OK
linux-4.14.17-x86_64: OK
linux-4.15.2-i686: OK
linux-4.15.2-x86_64: OK
linux-4.16-rc1-i686: OK
linux-4.16-rc1-x86_64: OK
apps: WARNINGS
spec-git: OK
ABI WARNING: change for blackfin-bf561
sparse: WARNINGS
smatch: OK

Detailed results are available here:

http://www.xs4all.nl/~hverkuil/logs/Thursday.log

Full logs are available here:

http://www.xs4all.nl/~hverkuil/logs/Thursday.tar.bz2

The Media Infrastructure API from this daily build is here:

http://www.xs4all.nl/~hverkuil/spec/index.html
