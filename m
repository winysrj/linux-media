Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:59837 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932729AbeDXD44 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 23:56:56 -0400
Message-ID: <80fd01857244855a69133ffb264a12da@smtp-cloud7.xs4all.net>
Date: Tue, 24 Apr 2018 05:56:53 +0200
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: cron job: media_tree daily build: ERRORS
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This message is generated daily by a cron job that builds media_tree for
the kernels and architectures in the list below.

Results of the daily build of media_tree:

date:			Tue Apr 24 05:00:12 CEST 2018
media-tree git hash:	a2b2eff6ac2716f499defa590a6ec4ba379d765e
media_build git hash:	4fb7a3cc8d0f56c7cddc3b5b29e35aa1159bc8d9
v4l-utils git hash:	9a4acdbe53884e5a433c1295eead61e45b0718e7
gcc version:		i686-linux-gcc (GCC) 7.3.0
sparse version:		0.5.2-RC1
smatch version:		0.5.1
host hardware:		x86_64
host os:		4.15.0-2-amd64

linux-git-arm-at91: OK
linux-git-arm-davinci: OK
linux-git-arm-multi: OK
linux-git-arm-pxa: OK
linux-git-arm-stm32: OK
linux-git-arm64: OK
linux-git-i686: OK
linux-git-mips: OK
linux-git-powerpc64: OK
linux-git-sh: OK
linux-git-x86_64: OK
Check COMPILE_TEST: OK
linux-2.6.36.4-i686: ERRORS
linux-2.6.36.4-x86_64: ERRORS
linux-2.6.37.6-i686: ERRORS
linux-2.6.37.6-x86_64: ERRORS
linux-2.6.38.8-i686: ERRORS
linux-2.6.38.8-x86_64: ERRORS
linux-2.6.39.4-i686: ERRORS
linux-2.6.39.4-x86_64: ERRORS
linux-3.0.101-i686: ERRORS
linux-3.0.101-x86_64: ERRORS
linux-3.1.10-i686: OK
linux-3.1.10-x86_64: OK
linux-3.2.101-i686: OK
linux-3.2.101-x86_64: OK
linux-3.3.8-i686: OK
linux-3.3.8-x86_64: OK
linux-3.4.113-i686: OK
linux-3.4.113-x86_64: OK
linux-3.5.7-i686: OK
linux-3.5.7-x86_64: OK
linux-3.6.11-i686: OK
linux-3.6.11-x86_64: OK
linux-3.7.10-i686: OK
linux-3.7.10-x86_64: OK
linux-3.8.13-i686: OK
linux-3.8.13-x86_64: OK
linux-3.9.11-i686: OK
linux-3.9.11-x86_64: OK
linux-3.10.108-i686: WARNINGS
linux-3.10.108-x86_64: WARNINGS
linux-3.11.10-i686: OK
linux-3.11.10-x86_64: OK
linux-3.12.74-i686: OK
linux-3.12.74-x86_64: OK
linux-3.13.11-i686: OK
linux-3.13.11-x86_64: OK
linux-3.14.79-i686: OK
linux-3.14.79-x86_64: OK
linux-3.15.10-i686: OK
linux-3.15.10-x86_64: OK
linux-3.16.56-i686: OK
linux-3.16.56-x86_64: OK
linux-3.17.8-i686: OK
linux-3.17.8-x86_64: OK
linux-3.18.102-i686: OK
linux-3.18.102-x86_64: OK
linux-3.19.8-i686: OK
linux-3.19.8-x86_64: OK
linux-4.0.9-i686: OK
linux-4.0.9-x86_64: OK
linux-4.1.51-i686: OK
linux-4.1.51-x86_64: OK
linux-4.2.8-i686: OK
linux-4.2.8-x86_64: OK
linux-4.3.6-i686: OK
linux-4.3.6-x86_64: OK
linux-4.4.109-i686: OK
linux-4.4.109-x86_64: OK
linux-4.5.7-i686: OK
linux-4.5.7-x86_64: OK
linux-4.6.7-i686: OK
linux-4.6.7-x86_64: OK
linux-4.7.10-i686: OK
linux-4.7.10-x86_64: OK
linux-4.8.17-i686: OK
linux-4.8.17-x86_64: OK
linux-4.9.91-i686: OK
linux-4.9.91-x86_64: OK
linux-4.14.31-i686: OK
linux-4.14.31-x86_64: OK
linux-4.15.14-i686: OK
linux-4.15.14-x86_64: OK
linux-4.16-i686: OK
linux-4.16-x86_64: OK
apps: OK
spec-git: OK
sparse: WARNINGS
smatch: OK

Detailed results are available here:

http://www.xs4all.nl/~hverkuil/logs/Tuesday.log

Full logs are available here:

http://www.xs4all.nl/~hverkuil/logs/Tuesday.tar.bz2

The Media Infrastructure API from this daily build is here:

http://www.xs4all.nl/~hverkuil/spec/index.html
