Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1848 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbZCRTTd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2009 15:19:33 -0400
Received: from localhost (marune.xs4all.nl [82.95.89.49])
	(authenticated bits=0)
	by smtp-vbr9.xs4all.nl (8.13.8/8.13.8) with ESMTP id n2IJJUZ1058243
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 18 Mar 2009 20:19:30 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Date: Wed, 18 Mar 2009 20:19:30 +0100 (CET)
Message-Id: <200903181919.n2IJJUZ1058243@smtp-vbr9.xs4all.nl>
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [cron job] v4l-dvb daily build 2.6.22 and up: WARNINGS, 2.6.16-2.6.21: ERRORS
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This message is generated daily by a cron job that builds v4l-dvb for
the kernels and architectures in the list below.

Results of the daily build of v4l-dvb:

date:        Wed Mar 18 19:00:07 CET 2009
path:        http://www.linuxtv.org/hg/v4l-dvb
changeset:   11094:f5af3128fde9
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
linux-2.6.29-rc8-armv5: OK
linux-2.6.27-armv5-ixp: OK
linux-2.6.28-armv5-ixp: OK
linux-2.6.29-rc8-armv5-ixp: OK
linux-2.6.28-armv5-omap2: OK
linux-2.6.29-rc8-armv5-omap2: OK
linux-2.6.22.19-i686: WARNINGS
linux-2.6.23.12-i686: WARNINGS
linux-2.6.24.7-i686: WARNINGS
linux-2.6.25.11-i686: WARNINGS
linux-2.6.26-i686: OK
linux-2.6.27-i686: OK
linux-2.6.28-i686: OK
linux-2.6.29-rc8-i686: OK
linux-2.6.23.12-m32r: OK
linux-2.6.24.7-m32r: OK
linux-2.6.25.11-m32r: OK
linux-2.6.26-m32r: OK
linux-2.6.27-m32r: OK
linux-2.6.28-m32r: OK
linux-2.6.29-rc8-m32r: OK
linux-2.6.22.19-mips: WARNINGS
linux-2.6.26-mips: OK
linux-2.6.27-mips: OK
linux-2.6.28-mips: OK
linux-2.6.29-rc8-mips: OK
linux-2.6.27-powerpc64: OK
linux-2.6.28-powerpc64: OK
linux-2.6.29-rc8-powerpc64: OK
linux-2.6.22.19-x86_64: WARNINGS
linux-2.6.23.12-x86_64: WARNINGS
linux-2.6.24.7-x86_64: WARNINGS
linux-2.6.25.11-x86_64: WARNINGS
linux-2.6.26-x86_64: OK
linux-2.6.27-x86_64: OK
linux-2.6.28-x86_64: OK
linux-2.6.29-rc8-x86_64: OK
fw/apps: OK
sparse (linux-2.6.28): ERRORS
sparse (linux-2.6.29-rc8): ERRORS

Detailed results are available here:

http://www.xs4all.nl/~hverkuil/logs/Wednesday.log

Full logs are available here:

http://www.xs4all.nl/~hverkuil/logs/Wednesday.tar.bz2

The V4L2 specification from this daily build is here:

http://www.xs4all.nl/~hverkuil/spec/v4l2.html

The DVB API specification from this daily build is here:

http://www.xs4all.nl/~hverkuil/spec/dvbapi.pdf

