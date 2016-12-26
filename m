Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:52672 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753995AbcLZEtn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Dec 2016 23:49:43 -0500
Message-ID: <8d5bddceea8050dae3c14acc03c4a223@smtp-cloud3.xs4all.net>
Date: Mon, 26 Dec 2016 05:49:40 +0100
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: cron job: media_tree daily build: ERRORS
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This message is generated daily by a cron job that builds media_tree for
the kernels and architectures in the list below.

Results of the daily build of media_tree:

date:			Mon Dec 26 05:00:17 CET 2016
media-tree git hash:	c739c0a7c3c2472d7562b8f802cdce44d2597c8b
media_build git hash:	1606032398b1d79149c1507be2029e1a00d8dff0
v4l-utils git hash:	c9aacef24d152007c7344b691da0cc90788395a7
gcc version:		i686-linux-gcc (GCC) 6.2.0
sparse version:		v0.5.0-3553-g78b2ea6
smatch version:		v0.5.0-3553-g78b2ea6
host hardware:		x86_64
host os:		4.8.0-164

linux-git-arm-at91: OK
linux-git-arm-davinci: OK
linux-git-arm-multi: OK
linux-git-arm-pxa: OK
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
linux-3.4.27-i686: WARNINGS
linux-3.5.7-i686: WARNINGS
linux-3.6.11-i686: WARNINGS
linux-3.7.4-i686: WARNINGS
linux-3.8-i686: WARNINGS
linux-3.9.2-i686: WARNINGS
linux-3.10.1-i686: WARNINGS
linux-3.11.1-i686: OK
linux-3.12.67-i686: OK
linux-3.13.11-i686: WARNINGS
linux-3.14.9-i686: WARNINGS
linux-3.15.2-i686: WARNINGS
linux-3.16.7-i686: WARNINGS
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
linux-4.8-i686: OK
linux-4.9-i686: OK
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
linux-3.8-x86_64: WARNINGS
linux-3.9.2-x86_64: WARNINGS
linux-3.10.1-x86_64: WARNINGS
linux-3.11.1-x86_64: OK
linux-3.12.67-x86_64: OK
linux-3.13.11-x86_64: WARNINGS
linux-3.14.9-x86_64: WARNINGS
linux-3.15.2-x86_64: WARNINGS
linux-3.16.7-x86_64: WARNINGS
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
linux-4.8-x86_64: OK
linux-4.9-x86_64: OK
apps: WARNINGS
spec-git: OK
sparse: WARNINGS

Detailed results are available here:

http://www.xs4all.nl/~hverkuil/logs/Monday.log

Full logs are available here:

http://www.xs4all.nl/~hverkuil/logs/Monday.tar.bz2

The Media Infrastructure API from this daily build is here:

http://www.xs4all.nl/~hverkuil/spec/index.html
