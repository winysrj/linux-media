Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:38012 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726080AbeIMItw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 04:49:52 -0400
Message-ID: <3c413327b0f7bf0f4062f940c3efe6b3@smtp-cloud9.xs4all.net>
Date: Thu, 13 Sep 2018 05:42:12 +0200
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: cron job: media_tree daily build: ERRORS
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This message is generated daily by a cron job that builds media_tree for
the kernels and architectures in the list below.

Results of the daily build of media_tree:

date:			Thu Sep 13 04:00:17 CEST 2018
media-tree git hash:	78cf8c842c111df656c63b5d04997ea4e40ef26a
media_build git hash:	73a39eb63460f29cbe9bc056ae0b05ce9e813b11
v4l-utils git hash:	d26e4941419b05fcb2b6708ee32aef367c2ec4af
edid-decode git hash:	b2da1516df3cc2756bfe8d1fa06d7bf2562ba1f4
gcc version:		i686-linux-gcc (GCC) 8.2.0
sparse version:		0.5.2
smatch version:		0.5.1
host hardware:		x86_64
host os:		4.17.0-3-amd64

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
linux-2.6.36.4-i686: WARNINGS
linux-2.6.36.4-x86_64: ERRORS
linux-2.6.37.6-i686: WARNINGS
linux-2.6.37.6-x86_64: WARNINGS
linux-2.6.38.8-i686: WARNINGS
linux-2.6.38.8-x86_64: WARNINGS
linux-2.6.39.4-i686: WARNINGS
linux-2.6.39.4-x86_64: WARNINGS
linux-3.0.101-i686: WARNINGS
linux-3.0.101-x86_64: WARNINGS
linux-3.1.10-i686: WARNINGS
linux-3.1.10-x86_64: WARNINGS
linux-3.2.102-i686: WARNINGS
linux-3.2.102-x86_64: WARNINGS
linux-3.3.8-i686: WARNINGS
linux-3.3.8-x86_64: WARNINGS
linux-3.4.113-i686: WARNINGS
linux-3.4.113-x86_64: WARNINGS
linux-3.5.7-i686: WARNINGS
linux-3.5.7-x86_64: WARNINGS
linux-3.6.11-i686: WARNINGS
linux-3.6.11-x86_64: WARNINGS
linux-3.7.10-i686: WARNINGS
linux-3.7.10-x86_64: WARNINGS
linux-3.8.13-i686: WARNINGS
linux-3.8.13-x86_64: WARNINGS
linux-3.9.11-i686: WARNINGS
linux-3.9.11-x86_64: WARNINGS
linux-3.10.108-i686: WARNINGS
linux-3.10.108-x86_64: WARNINGS
linux-3.11.10-i686: WARNINGS
linux-3.11.10-x86_64: WARNINGS
linux-3.12.74-i686: WARNINGS
linux-3.12.74-x86_64: WARNINGS
linux-3.13.11-i686: WARNINGS
linux-3.13.11-x86_64: WARNINGS
linux-3.14.79-i686: WARNINGS
linux-3.14.79-x86_64: WARNINGS
linux-3.15.10-i686: WARNINGS
linux-3.15.10-x86_64: WARNINGS
linux-3.16.57-i686: WARNINGS
linux-3.16.57-x86_64: WARNINGS
linux-3.17.8-i686: WARNINGS
linux-3.17.8-x86_64: WARNINGS
linux-3.18.119-i686: OK
linux-3.18.119-x86_64: OK
linux-3.19.8-i686: WARNINGS
linux-3.19.8-x86_64: WARNINGS
linux-4.0.9-i686: WARNINGS
linux-4.0.9-x86_64: WARNINGS
linux-4.1.52-i686: WARNINGS
linux-4.1.52-x86_64: WARNINGS
linux-4.2.8-i686: WARNINGS
linux-4.2.8-x86_64: WARNINGS
linux-4.3.6-i686: OK
linux-4.3.6-x86_64: OK
linux-4.4.152-i686: OK
linux-4.4.152-x86_64: OK
linux-4.5.7-i686: OK
linux-4.5.7-x86_64: OK
linux-4.6.7-i686: OK
linux-4.6.7-x86_64: OK
linux-4.7.10-i686: OK
linux-4.7.10-x86_64: OK
linux-4.8.17-i686: OK
linux-4.8.17-x86_64: OK
linux-4.9.124-i686: OK
linux-4.9.124-x86_64: OK
linux-4.10.17-i686: OK
linux-4.10.17-x86_64: OK
linux-4.11.12-i686: OK
linux-4.11.12-x86_64: OK
linux-4.12.14-i686: OK
linux-4.12.14-x86_64: OK
linux-4.13.16-i686: OK
linux-4.13.16-x86_64: OK
linux-4.14.67-i686: OK
linux-4.14.67-x86_64: OK
linux-4.15.18-i686: OK
linux-4.15.18-x86_64: OK
linux-4.16.18-i686: OK
linux-4.16.18-x86_64: OK
linux-4.17.19-i686: OK
linux-4.17.19-x86_64: OK
linux-4.18.5-i686: OK
linux-4.18.5-x86_64: OK
linux-4.19-rc1-i686: OK
linux-4.19-rc1-x86_64: OK
apps: OK
spec-git: OK
sparse: WARNINGS

Logs weren't copied as they are too large (2368 kB)

The Media Infrastructure API from this daily build is here:

http://www.xs4all.nl/~hverkuil/spec/index.html
