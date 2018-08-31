Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:36407 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727114AbeHaJAJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Aug 2018 05:00:09 -0400
Message-ID: <5e65b9244ba28c89e56ec87a19808b19@smtp-cloud7.xs4all.net>
Date: Fri, 31 Aug 2018 06:54:29 +0200
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: cron job: media_tree daily build: ERRORS
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This message is generated daily by a cron job that builds media_tree for
the kernels and architectures in the list below.

Results of the daily build of media_tree:

date:			Fri Aug 31 05:00:13 CEST 2018
media-tree git hash:	3799eca51c5be3cd76047a582ac52087373b54b3
media_build git hash:	9623f0df237febbd2d3b36ee9541d8bebba19b2d
v4l-utils git hash:	fcccd99ebdc6ff01296f57948c52dacc9c1d2695
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
linux-3.1.10-i686: ERRORS
linux-3.1.10-x86_64: ERRORS
linux-3.2.102-i686: ERRORS
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
linux-3.12.74/arch/x86/include/asm/apic.h:234:13: error: storage class specified for parameter 'clear_local_APIC'
linux-3.12.74-x86_64: ERRORS
linux-3.13.11-i686: ERRORS
linux-3.13.11-x86_64: ERRORS
linux-3.14.79-i686: ERRORS
linux-3.14.79-x86_64: ERRORS
linux-3.14.79/arch/x86/include/asm/preempt.h:6,
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
specified for parameter 'printk_address'
specified for parameter 'printk_address'
specified for parameter 'printk_address'
specified for parameter 'dev_load'
specified for parameter 'irq_set_irq_wake'
specified for parameter 'ftrace_graph_init_task'
specified for parameter 'kernel_page_present'
specified for parameter 'numa_set_node'
specified for parameter 'llist_add_batch'
specified for parameter 'llist_add_batch'
specified for parameter 'llist_add_batch'
specified for parameter 'io_schedule_timeout'
specified for parameter 'io_schedule_timeout'
specified for parameter 'simple_empty'
specifiers or '...' before 'atomic_long_t'
specified for parameter 'next_online_pgdat'
specified for parameter 'klist_add_tail'
specified for parameter 'next_online_pgdat'
specified for parameter 'unlock_vector_lock'
specified for parameter 'device_rename'
specifiers or '...' before 'atomic64_t'
specifiers or '...' before 'atomic64_t'
spec-git: ERRORS
sparse: WARNINGS

Detailed results are available here:

http://www.xs4all.nl/~hverkuil/logs/Friday.log

Full logs are available here:

http://www.xs4all.nl/~hverkuil/logs/Friday.tar.bz2

The Media Infrastructure API from this daily build is here:

http://www.xs4all.nl/~hverkuil/spec/index.html
