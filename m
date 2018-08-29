Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:53370 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727067AbeH2IWc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Aug 2018 04:22:32 -0400
Message-ID: <c36f4e24a7de0e7abfbb82bfe7acd378@smtp-cloud7.xs4all.net>
Date: Wed, 29 Aug 2018 06:27:32 +0200
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: cron job: media_tree daily build: ERRORS
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This message is generated daily by a cron job that builds media_tree for
the kernels and architectures in the list below.

Results of the daily build of media_tree:

date:			Wed Aug 29 05:00:14 CEST 2018
media-tree git hash:	5b394b2ddf0347bef56e50c69a58773c94343ff3
media_build git hash:	baf45935ffad914f33faf751ad9f4d0dd276c021
v4l-utils git hash:	e37fbf50a28c1a1cfe9e00a60542bc14192a87ba
edid-decode git hash:	b2da1516df3cc2756bfe8d1fa06d7bf2562ba1f4
gcc version:		i686-linux-gcc (GCC) 8.1.0
sparse version:		0.5.2
smatch version:		0.5.1
host hardware:		x86_64
host os:		4.18.0-marune

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
linux-3.1.10-i686: ERRORS
linux-3.1.10-x86_64: ERRORS
linux-3.2.102-i686: ERRORS
linux-3.2.102/arch/x86/include/asm/smp.h:183:17: error: storage class specified for parameter 'disabled_cpus'
linux-3.2.102-x86_64: ERRORS
linux-3.3.8-i686: ERRORS
linux-3.3.8-x86_64: ERRORS
linux-3.4.113-i686: ERRORS
linux-3.4.113-x86_64: ERRORS
linux-3.5.7-i686: ERRORS
linux-3.5.7-x86_64: ERRORS
linux-3.6.11-i686: ERRORS
linux-3.6.11-x86_64: ERRORS
linux-3.7.10-i686: ERRORS
linux-3.7.10-x86_64: ERRORS
linux-3.8.13-i686: ERRORS
linux-3.8.13-x86_64: ERRORS
linux-3.9.11-i686: ERRORS
linux-3.9.11-x86_64: ERRORS
linux-3.10.108-i686: ERRORS
linux-3.10.108-x86_64: ERRORS
linux-3.11.10-i686: ERRORS
linux-3.11.10/arch/x86/include/asm/msr.h:131,
linux-3.11.10-x86_64: ERRORS
linux-3.12.74-i686: ERRORS
linux-3.12.74-x86_64: ERRORS
linux-3.13.11-i686: ERRORS
linux-3.13.11/arch/x86/include/asm/hw_irq.h:49:24: error: storage class specified for parameter 'invalidate_interrupt9'
linux-3.13.11-x86_64: ERRORS
linux-3.14.79-i686: ERRORS
linux-3.14.79-x86_64: ERRORS
linux-3.15.10-i686: ERRORS
linux-3.15.10-x86_64: ERRORS
linux-3.16.57-i686: ERRORS
linux-3.16.57-x86_64: ERRORS
linux-3.17.8-i686: ERRORS
linux-3.17.8-x86_64: ERRORS
linux-3.18.119-i686: ERRORS
linux-3.18.119-x86_64: ERRORS
linux-3.19.8-i686: ERRORS
linux-3.19.8-x86_64: ERRORS
linux-4.0.9-i686: ERRORS
linux-4.0.9-x86_64: ERRORS
linux-4.1.52-i686: ERRORS
linux-4.1.52-x86_64: ERRORS
linux-4.2.8-i686: ERRORS
linux-4.2.8-x86_64: ERRORS
linux-4.3.6-i686: ERRORS
linux-4.3.6-x86_64: ERRORS
linux-4.4.152-i686: ERRORS
linux-4.4.152-x86_64: ERRORS
linux-4.5.7-i686: ERRORS
linux-4.5.7-x86_64: ERRORS
linux-4.6.7-i686: ERRORS
linux-4.6.7-x86_64: ERRORS
linux-4.7.10-i686: ERRORS
linux-4.7.10-x86_64: ERRORS
linux-4.8.17-i686: ERRORS
linux-4.8.17-x86_64: ERRORS
linux-4.9.124-i686: ERRORS
linux-4.9.124-x86_64: ERRORS
linux-4.10.17-i686: ERRORS
linux-4.10.17-x86_64: ERRORS
linux-4.11.12-i686: ERRORS
linux-4.11.12-x86_64: ERRORS
linux-4.12.14-i686: ERRORS
linux-4.12.14-x86_64: ERRORS
linux-4.13.16-i686: ERRORS
linux-4.13.16-x86_64: ERRORS
linux-4.14.67-i686: ERRORS
linux-4.14.67-x86_64: ERRORS
linux-4.15.18-i686: ERRORS
linux-4.15.18-x86_64: ERRORS
linux-4.16.18-i686: ERRORS
linux-4.16.18-x86_64: ERRORS
linux-4.17.19-i686: ERRORS
linux-4.17.19-x86_64: ERRORS
linux-4.18.5-i686: ERRORS
linux-4.18.5-x86_64: ERRORS
linux-4.19-rc1-i686: ERRORS
linux-4.19-rc1-x86_64: ERRORS
apps: OK
specified for parameter 'kernel_sock_ioctl'
specifiers or '...' before 'read_descriptor_t'
specified for parameter 'ftrace_graph_init_task'
specified for parameter 'ioctl_by_bdev'
specifiers or '...' before 'atomic_long_t'
specifiers or '...' before 'atomic_long_t'
specifiers or '...' before 'atomic64_t'
specifiers or '...' before 'atomic64_t'
spec-git: OK
sparse: WARNINGS

Detailed results are available here:

http://www.xs4all.nl/~hverkuil/logs/Wednesday.log

Full logs are available here:

http://www.xs4all.nl/~hverkuil/logs/Wednesday.tar.bz2

The Media Infrastructure API from this daily build is here:

http://www.xs4all.nl/~hverkuil/spec/index.html
