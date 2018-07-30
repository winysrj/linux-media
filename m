Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:38705 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725858AbeG3F1K (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jul 2018 01:27:10 -0400
Message-ID: <f45c1f17c092ee6625a8e544a78e82b0@smtp-cloud8.xs4all.net>
Date: Mon, 30 Jul 2018 05:54:09 +0200
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: cron job: media_tree daily build: ERRORS
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This message is generated daily by a cron job that builds media_tree for
the kernels and architectures in the list below.

Results of the daily build of media_tree:

date:			Mon Jul 30 05:00:10 CEST 2018
media-tree git hash:	4faeaf9c0f4581667ce5826f9c90c4fd463ef086
media_build git hash:	5d2bedd1c9c770d03c3e95282f55fe9979d26248
v4l-utils git hash:	5e8d31abc6f531ef0bc0fc563d5311602a395685
edid-decode git hash:	ab18befbcacd6cd4dff63faa82e32700369d6f25
gcc version:		i686-linux-gcc (GCC) 8.1.0
sparse version:		0.5.2
smatch version:		0.5.1
host hardware:		x86_64
host os:		4.16.0-1-amd64

linux-git-arm-at91: OK
linux-git-arm-davinci: OK
linux-git-arm-multi: OK
linux-git-arm-pxa: OK
linux-git-arm-stm32: OK
linux-git-arm64: OK
linux-git-i686: WARNINGS
linux-git-mips: OK
linux-git-powerpc64: OK
linux-git-sh: OK
linux-git-x86_64: WARNINGS
Check COMPILE_TEST: OK
linux-2.6.36.4-i686: OK
linux-2.6.36.4-x86_64: OK
linux-2.6.37.6-i686: OK
linux-2.6.37.6-x86_64: OK
linux-2.6.38.8-i686: OK
linux-2.6.38.8-x86_64: OK
linux-2.6.39.4-i686: OK
linux-2.6.39.4-x86_64: OK
linux-3.0.101-i686: OK
linux-3.0.101-x86_64: OK
linux-3.1.10-i686: OK
linux-3.1.10-x86_64: OK
linux-3.2.102-i686: ERRORS
linux-3.2.102-x86_64: ERRORS
linux-3.3.8-i686: ERRORS
linux-3.3.8-x86_64: ERRORS
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
linux-3.10.108-i686: OK
linux-3.10.108-x86_64: OK
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
linux-3.16.57-i686: OK
linux-3.16.57-x86_64: OK
linux-3.17.8-i686: OK
linux-3.17.8-x86_64: OK
linux-3.18.115-i686: OK
linux-3.18.115-x86_64: OK
linux-3.19.8-i686: OK
linux-3.19.8-x86_64: OK
linux-4.0.9-i686: OK
linux-4.0.9-x86_64: OK
linux-4.1.52-i686: OK
linux-4.1.52-x86_64: OK
linux-4.2.8-i686: OK
linux-4.2.8-x86_64: OK
linux-4.3.6-i686: OK
linux-4.3.6-x86_64: OK
linux-4.4.140-i686: OK
linux-4.4.140-x86_64: OK
linux-4.5.7-i686: OK
linux-4.5.7-x86_64: OK
linux-4.6.7-i686: OK
linux-4.6.7-x86_64: OK
linux-4.7.10-i686: OK
linux-4.7.10-x86_64: OK
linux-4.8.17-i686: OK
linux-4.8.17-x86_64: OK
linux-4.9.112-i686: OK
linux-4.9.112-x86_64: OK
linux-4.10.17-i686: OK
linux-4.10.17-x86_64: OK
linux-4.11.12-i686: OK
linux-4.11.12-x86_64: OK
linux-4.12.14-i686: OK
linux-4.12.14-x86_64: OK
linux-4.13.16-i686: OK
linux-4.13.16-x86_64: OK
linux-4.14.55-i686: OK
linux-4.14.55-x86_64: OK
linux-4.15.18-i686: OK
linux-4.15.18-x86_64: OK
linux-4.16.18-i686: OK
linux-4.16.18-x86_64: OK
linux-4.17.6-i686: OK
linux-4.17.6-x86_64: OK
linux-4.18-rc4-i686: OK
linux-4.18-rc4-x86_64: OK
apps: OK
spec-git: OK
sparse: WARNINGS

Detailed results are available here:

http://www.xs4all.nl/~hverkuil/logs/Monday.log

Full logs are available here:

http://www.xs4all.nl/~hverkuil/logs/Monday.tar.bz2

The Media Infrastructure API from this daily build is here:

http://www.xs4all.nl/~hverkuil/spec/index.html
