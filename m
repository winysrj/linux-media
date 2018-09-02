Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:60982 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725950AbeIBJJG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 2 Sep 2018 05:09:06 -0400
Message-ID: <bb182b8243b13128469db5931cfb1276@smtp-cloud8.xs4all.net>
Date: Sun, 02 Sep 2018 06:54:38 +0200
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: cron job: media_tree daily build: ERRORS
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This message is generated daily by a cron job that builds media_tree for
the kernels and architectures in the list below.

Results of the daily build of media_tree:

date:			Sun Sep  2 05:00:10 CEST 2018
media-tree git hash:	d842a7cf938b6e0f8a1aa9f1aec0476c9a599310
media_build git hash:	27f99df152c7e5ae155c6e7888e12234eaa0fc25
v4l-utils git hash:	f44f00e8b4ac6e9aa05bac8953e3fcc89e1fe198
edid-decode git hash:	b2da1516df3cc2756bfe8d1fa06d7bf2562ba1f4
gcc version:		i686-linux-gcc (GCC) 8.1.0
sparse version:		0.5.2
smatch version:		0.5.1
host hardware:		x86_64
host os:		4.18.5-marune

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
linux-3.0.101/arch/x86/include/asm/fixmap.h:217:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
linux-3.1.10-i686: ERRORS
linux-3.1.10-x86_64: ERRORS
linux-3.2.102-i686: ERRORS
linux-3.2.102-x86_64: ERRORS
linux-3.3.8-i686: ERRORS
linux-3.3.8-x86_64: ERRORS
linux-3.3.8/arch/x86/include/asm/compat.h:172:2: error: expected specifier-qualifier-list before 'compat_size_t'
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
linux-3.11.10-x86_64: ERRORS
linux-3.12.74-i686: ERRORS
linux-3.12.74/arch/x86/include/asm/paravirt.h:127:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
linux-3.12.74-x86_64: ERRORS
linux-3.13.11-i686: ERRORS
linux-3.13.11-x86_64: ERRORS
linux-3.14.79-i686: ERRORS
linux-3.14.79-x86_64: ERRORS
linux-3.14.79/arch/x86/include/asm/preempt.h:6,
linux-3.15.10-i686: ERRORS
linux-3.15.10-x86_64: ERRORS
linux-3.15.10/arch/x86/include/asm/processor.h:432:1: note: in expansion of macro 'DECLARE_PER_CPU_FIRST'
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
linux-4.19-rc1-i686: OK
linux-4.19-rc1-x86_64: OK
apps: OK
specified for parameter 'make_bad_inode'
specified for parameter '__bad_size_call_parameter'
specified for parameter 'hrtimer_try_to_cancel'
specified for parameter 'hrtimer_try_to_cancel'
specifier-qualifier-list before 'atomic_long_t'
specified for parameter 'io_schedule_timeout'
specified for parameter 'init_bsp_APIC'
specified for parameter 'capable_wrt_inode_uidgid'
specified for parameter 'do_getitimer'
specified for parameter 'do_getitimer'
specifiers or '...' before 'atomic_long_t'
specifiers or '...' before 'atomic_long_t'
specifiers or '...' before 'atomic64_t'
specifiers or '...' before 'atomic64_t'
specifiers or '...' before 'atomic64_t'
specifiers or '...' before 'atomic64_t'
specified for parameter 'Elf64_Half'
specified for parameter '__page_ref_mod'
spec-git: ERRORS
sparse: WARNINGS

Detailed results are available here:

http://www.xs4all.nl/~hverkuil/logs/Sunday.log

Full logs are available here:

http://www.xs4all.nl/~hverkuil/logs/Sunday.tar.bz2

The Media Infrastructure API from this daily build is here:

http://www.xs4all.nl/~hverkuil/spec/index.html
