Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:1572 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbZBJI7G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2009 03:59:06 -0500
Received: from localhost (marune.xs4all.nl [82.95.89.49])
	(authenticated bits=0)
	by smtp-vbr16.xs4all.nl (8.13.8/8.13.8) with ESMTP id n1A8wxNd096386
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 10 Feb 2009 09:59:04 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Date: Tue, 10 Feb 2009 09:58:59 +0100 (CET)
Message-Id: <200902100859.n1A8wxNd096386@smtp-vbr16.xs4all.nl>
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [cron job] WARNINGS: armv5 armv5-ixp armv5-omap2 i686 m32r mips powerpc64 x86_64 v4l-dvb build
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(This message is generated daily by a cron job that builds v4l-dvb for
the kernels and architectures in the list below.)

Results of the daily build of v4l-dvb:

date:        Tue Feb 10 08:37:17 CET 2009
path:        http://www.linuxtv.org/hg/v4l-dvb
changeset:   10503:9cb19f080660
gcc version: gcc (GCC) 4.3.1
hardware:    x86_64
host os:     2.6.26

linux-2.6.16.61-armv5: OK
linux-2.6.17.14-armv5: OK
linux-2.6.18.8-armv5: OK
linux-2.6.19.5-armv5: OK
linux-2.6.20.21-armv5: OK
linux-2.6.21.7-armv5: OK
linux-2.6.22.19-armv5: OK
linux-2.6.23.12-armv5: OK
linux-2.6.24.7-armv5: OK
linux-2.6.25.11-armv5: OK
linux-2.6.26-armv5: OK
linux-2.6.27-armv5: OK
linux-2.6.28-armv5: OK
linux-2.6.29-rc4-armv5: OK
linux-2.6.27-armv5-ixp: OK
linux-2.6.28-armv5-ixp: OK
linux-2.6.29-rc4-armv5-ixp: OK
linux-2.6.27-armv5-omap2: OK
linux-2.6.28-armv5-omap2: OK
linux-2.6.29-rc4-armv5-omap2: OK
linux-2.6.16.61-i686: OK
linux-2.6.17.14-i686: OK
linux-2.6.18.8-i686: OK
linux-2.6.19.5-i686: OK
linux-2.6.20.21-i686: OK
linux-2.6.21.7-i686: OK
linux-2.6.22.19-i686: OK
linux-2.6.23.12-i686: OK
linux-2.6.24.7-i686: OK
linux-2.6.25.11-i686: OK
linux-2.6.26-i686: OK
linux-2.6.27-i686: OK
linux-2.6.28-i686: OK
linux-2.6.29-rc4-i686: WARNINGS
linux-2.6.16.61-m32r: OK
linux-2.6.17.14-m32r: OK
linux-2.6.18.8-m32r: OK
linux-2.6.19.5-m32r: OK
linux-2.6.20.21-m32r: OK
linux-2.6.21.7-m32r: OK
linux-2.6.23.12-m32r: OK
linux-2.6.24.7-m32r: OK
linux-2.6.25.11-m32r: OK
linux-2.6.26-m32r: OK
linux-2.6.27-m32r: OK
linux-2.6.28-m32r: OK
linux-2.6.29-rc4-m32r: OK
linux-2.6.16.61-mips: OK
linux-2.6.26-mips: OK
linux-2.6.27-mips: OK
linux-2.6.28-mips: OK
linux-2.6.29-rc4-mips: WARNINGS
linux-2.6.27-powerpc64: OK
linux-2.6.28-powerpc64: OK
linux-2.6.29-rc4-powerpc64: WARNINGS
linux-2.6.16.61-x86_64: OK
linux-2.6.17.14-x86_64: OK
linux-2.6.18.8-x86_64: OK
linux-2.6.19.5-x86_64: OK
linux-2.6.20.21-x86_64: OK
linux-2.6.21.7-x86_64: OK
linux-2.6.22.19-x86_64: OK
linux-2.6.23.12-x86_64: OK
linux-2.6.24.7-x86_64: OK
linux-2.6.25.11-x86_64: OK
linux-2.6.26-x86_64: OK
linux-2.6.27-x86_64: OK
linux-2.6.28-x86_64: OK
linux-2.6.29-rc4-x86_64: WARNINGS
fw/apps: OK
spec: 
sparse (linux-2.6.28): ERRORS
sparse (linux-2.6.29-rc4): ERRORS

Detailed results are available here:

http://www.xs4all.nl/~hverkuil/logs/Tuesday.log

Full logs are available here:

http://www.xs4all.nl/~hverkuil/logs/Tuesday.tar.bz2

The V4L2 specification failed to build, but the last compiled spec is here:

http://www.xs4all.nl/~hverkuil/spec/v4l2.html
