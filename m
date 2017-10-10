Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:34619 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751596AbdJJEHp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 00:07:45 -0400
Message-ID: <b4f9405eacb768e6fe2605cc1a693491@smtp-cloud9.xs4all.net>
Date: Tue, 10 Oct 2017 06:07:42 +0200
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: cron job: media_tree daily build: ERRORS
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This message is generated daily by a cron job that builds media_tree for
the kernels and architectures in the list below.

Results of the daily build of media_tree:

date:			Tue Oct 10 05:00:14 CEST 2017
media-tree git hash:	c1301077213d4dca34f01fc372b64d3c4a49a437
media_build git hash:	4f1031979bd1ff205f19f88c85f387d6e5408f5e
v4l-utils git hash:	01c04f7c8ad1a91af33e20621eba9200f447737e
gcc version:		i686-linux-gcc (GCC) 7.1.0
sparse version:		v0.5.0
smatch version:		v0.5.0-3553-g78b2ea6
host hardware:		x86_64
host os:		4.12.0-164

linux-git-arm-at91: OK
linux-git-arm-davinci: OK
linux-git-arm-multi: OK
linux-git-arm-pxa: OK
linux-git-arm-stm32: OK
linux-git-blackfin-bf561: OK
linux-git-i686: OK
linux-git-m32r: WARNINGS
linux-git-mips: OK
linux-git-powerpc64: OK
linux-git-sh: OK
linux-git-x86_64: OK
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
linux-3.6.11-i686: WARNINGS
linux-3.7.4-i686: WARNINGS
linux-3.8-i686: WARNINGS
linux-3.9.2-i686: WARNINGS
linux-3.10.1-i686: WARNINGS
linux-3.11.1-i686: WARNINGS
linux-3.12.67-i686: WARNINGS
linux-3.13.11-i686: WARNINGS
linux-3.14.9-i686: WARNINGS
linux-3.15.2-i686: ERRORS
linux-3.16.7-i686: ERRORS
linux-3.17.8-i686: WARNINGS
linux-3.18.7-i686: WARNINGS
linux-3.19-i686: WARNINGS
linux-4.0.9-i686: WARNINGS
linux-4.1.33-i686: WARNINGS
linux-4.2.8-i686: WARNINGS
linux-4.3.6-i686: WARNINGS
linux-4.4.22-i686: WARNINGS
linux-4.5.7-i686: WARNINGS
linux-4.6.7-i686: WARNINGS
linux-4.7.5-i686: WARNINGS
linux-4.8-i686: OK
linux-4.9.26-i686: OK
linux-4.10.14-i686: OK
linux-4.11-i686: OK
linux-4.12.1-i686: OK
linux-4.13-i686: OK
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
linux-3.6.11-x86_64: WARNINGS
linux-3.7.4-x86_64: WARNINGS
linux-3.8-x86_64: WARNINGS
linux-3.9.2-x86_64: WARNINGS
linux-3.10.1-x86_64: WARNINGS
linux-3.11.1-x86_64: WARNINGS
linux-3.12.67-x86_64: WARNINGS
linux-3.13.11-x86_64: WARNINGS
linux-3.14.9-x86_64: WARNINGS
linux-3.15.2-x86_64: WARNINGS
linux-3.16.7-x86_64: WARNINGS
linux-3.17.8-x86_64: WARNINGS
linux-3.18.7-x86_64: WARNINGS
linux-3.19-x86_64: WARNINGS
linux-4.0.9-x86_64: WARNINGS
linux-4.1.33-x86_64: WARNINGS
linux-4.2.8-x86_64: WARNINGS
linux-4.3.6-x86_64: WARNINGS
linux-4.4.22-x86_64: WARNINGS
linux-4.5.7-x86_64: WARNINGS
linux-4.6.7-x86_64: WARNINGS
linux-4.7.5-x86_64: WARNINGS
linux-4.8-x86_64: WARNINGS
linux-4.9.26-x86_64: WARNINGS
linux-4.10.14-x86_64: WARNINGS
linux-4.11-x86_64: WARNINGS
linux-4.12.1-x86_64: WARNINGS
linux-4.13-x86_64: OK
apps: OK
spec-git: OK

Detailed results are available here:

http://www.xs4all.nl/~hverkuil/logs/Tuesday.log

Full logs are available here:

http://www.xs4all.nl/~hverkuil/logs/Tuesday.tar.bz2

The Media Infrastructure API from this daily build is here:

http://www.xs4all.nl/~hverkuil/spec/index.html
