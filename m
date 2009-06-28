Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr17.xs4all.nl ([194.109.24.37]:1206 "EHLO
	smtp-vbr17.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbZF1SQN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Jun 2009 14:16:13 -0400
Received: from localhost (marune.xs4all.nl [82.95.89.49])
	(authenticated bits=0)
	by smtp-vbr17.xs4all.nl (8.13.8/8.13.8) with ESMTP id n5SIGFBJ053121
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 28 Jun 2009 20:16:15 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Date: Sun, 28 Jun 2009 20:16:15 +0200 (CEST)
Message-Id: <200906281816.n5SIGFBJ053121@smtp-vbr17.xs4all.nl>
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [cron job] v4l-dvb daily build 2.6.22 and up: ERRORS, 2.6.16-2.6.21: ERRORS
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This message is generated daily by a cron job that builds v4l-dvb for
the kernels and architectures in the list below.

Results of the daily build of v4l-dvb:

date:        Sun Jun 28 19:00:02 CEST 2009
path:        http://www.linuxtv.org/hg/v4l-dvb
changeset:   12133:05e6c5c9bcb4
gcc version: gcc (GCC) 4.3.1
hardware:    x86_64
host os:     2.6.26

linux-2.6.22.19-armv5: OK
linux-2.6.23.12-armv5: OK
linux-2.6.24.7-armv5: OK
linux-2.6.25.11-armv5: OK
linux-2.6.26-armv5: OK
linux-2.6.27-armv5: OK
linux-2.6.28-armv5: OK
linux-2.6.29.1-armv5: OK
linux-2.6.30-armv5: OK
linux-2.6.31-rc1-armv5: ERRORS
linux-2.6.27-armv5-ixp: WARNINGS
linux-2.6.28-armv5-ixp: WARNINGS
linux-2.6.29.1-armv5-ixp: WARNINGS
linux-2.6.30-armv5-ixp: WARNINGS
linux-2.6.31-rc1-armv5-ixp: ERRORS
linux-2.6.28-armv5-omap2: WARNINGS
linux-2.6.29.1-armv5-omap2: WARNINGS
linux-2.6.30-armv5-omap2: WARNINGS
linux-2.6.31-rc1-armv5-omap2: ERRORS
linux-2.6.22.19-i686: WARNINGS
linux-2.6.23.12-i686: WARNINGS
linux-2.6.24.7-i686: WARNINGS
linux-2.6.25.11-i686: WARNINGS
linux-2.6.26-i686: WARNINGS
linux-2.6.27-i686: WARNINGS
linux-2.6.28-i686: WARNINGS
linux-2.6.29.1-i686: WARNINGS
linux-2.6.30-i686: WARNINGS
linux-2.6.31-rc1-i686: ERRORS
linux-2.6.23.12-m32r: OK
linux-2.6.24.7-m32r: OK
linux-2.6.25.11-m32r: OK
linux-2.6.26-m32r: OK
linux-2.6.27-m32r: OK
linux-2.6.28-m32r: OK
linux-2.6.29.1-m32r: OK
linux-2.6.30-m32r: OK
linux-2.6.31-rc1-m32r: ERRORS
linux-2.6.30-mips: WARNINGS
linux-2.6.31-rc1-mips: ERRORS
linux-2.6.27-powerpc64: WARNINGS
linux-2.6.28-powerpc64: WARNINGS
linux-2.6.29.1-powerpc64: WARNINGS
linux-2.6.30-powerpc64: WARNINGS
linux-2.6.31-rc1-powerpc64: ERRORS
linux-2.6.22.19-x86_64: WARNINGS
linux-2.6.23.12-x86_64: WARNINGS
linux-2.6.24.7-x86_64: WARNINGS
linux-2.6.25.11-x86_64: WARNINGS
linux-2.6.26-x86_64: OK
linux-2.6.27-x86_64: OK
linux-2.6.28-x86_64: OK
linux-2.6.29.1-x86_64: OK
linux-2.6.30-x86_64: WARNINGS
linux-2.6.31-rc1-x86_64: ERRORS
sparse (linux-2.6.30): OK
sparse (linux-2.6.31-rc1): OK
linux-2.6.16.61-i686: ERRORS
linux-2.6.17.14-i686: ERRORS
linux-2.6.18.8-i686: ERRORS
linux-2.6.19.5-i686: WARNINGS
linux-2.6.20.21-i686: WARNINGS
linux-2.6.21.7-i686: WARNINGS
linux-2.6.16.61-x86_64: ERRORS
linux-2.6.17.14-x86_64: ERRORS
linux-2.6.18.8-x86_64: ERRORS
linux-2.6.19.5-x86_64: WARNINGS
linux-2.6.20.21-x86_64: WARNINGS
linux-2.6.21.7-x86_64: WARNINGS

Detailed results are available here:

http://www.xs4all.nl/~hverkuil/logs/Sunday.log

Full logs are available here:

http://www.xs4all.nl/~hverkuil/logs/Sunday.tar.bz2

The V4L2 specification failed to build, but the last compiled spec is here:

http://www.xs4all.nl/~hverkuil/spec/v4l2.html

The DVB API specification from this daily build is here:

http://www.xs4all.nl/~hverkuil/spec/dvbapi.pdf

