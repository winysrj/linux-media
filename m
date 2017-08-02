Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:33307 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751727AbdHBDw0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 1 Aug 2017 23:52:26 -0400
Message-ID: <44fc3d5609df465316508a1fdb541517@smtp-cloud9.xs4all.net>
Date: Wed, 02 Aug 2017 05:52:24 +0200
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: cron job: media_tree daily build: ERRORS
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This message is generated daily by a cron job that builds media_tree for
the kernels and architectures in the list below.

Results of the daily build of media_tree:

date:			Wed Aug  2 05:00:16 CEST 2017
media-tree git hash:	da48c948c263c9d87dfc64566b3373a858cc8aa2
media_build git hash:	f01a9176bb03f22e3cd3b70282bd7fd272e504ae
v4l-utils git hash:	98c162029eb1a21b39028180ac5d36b544a9493c
gcc version:		i686-linux-gcc (GCC) 7.1.0
sparse version:		v0.5.0
smatch version:		v0.5.0-3553-g78b2ea6
host hardware:		x86_64
host os:		4.11.0-164

linux-git-arm-at91: OK
linux-git-arm-davinci: OK
linux-git-arm-multi: WARNINGS
linux-git-arm-pxa: OK
linux-git-arm-stm32: OK
linux-git-blackfin-bf561: OK
linux-git-i686: OK
linux-git-m32r: OK
linux-git-mips: OK
linux-git-powerpc64: OK
linux-git-sh: OK
linux-git-x86_64: OK
linux-2.6.36.4-i686: WARNINGS
linux-2.6.37.6-i686: WARNINGS
linux-2.6.38.8-i686: WARNINGS
linux-2.6.39.4-i686: WARNINGS
linux-3.0.60-i686: WARNINGS
linux-3.1.10-i686: WARNINGS
linux-3.2.37-i686: WARNINGS
linux-3.3.8-i686: WARNINGS
linux-3.4.27-i686: ERRORS
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
linux-3.15.2-i686: WARNINGS
linux-3.16.7-i686: WARNINGS
linux-3.17.8-i686: ERRORS
linux-3.18.7-i686: ERRORS
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
linux-2.6.36.4-x86_64: WARNINGS
linux-2.6.37.6-x86_64: WARNINGS
linux-2.6.38.8-x86_64: WARNINGS
linux-2.6.39.4-x86_64: WARNINGS
linux-3.0.60-x86_64: WARNINGS
linux-3.1.10-x86_64: WARNINGS
linux-3.2.37-x86_64: WARNINGS
linux-3.3.8-x86_64: WARNINGS
linux-3.4.27-x86_64: ERRORS
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
apps: WARNINGS
spec-git: OK
sparse: ERRORS

Detailed results are available here:

http://www.xs4all.nl/~hverkuil/logs/Wednesday.log

Full logs are available here:

http://www.xs4all.nl/~hverkuil/logs/Wednesday.tar.bz2

The Media Infrastructure API from this daily build is here:

http://www.xs4all.nl/~hverkuil/spec/index.html
