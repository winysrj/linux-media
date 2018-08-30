Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:34208 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727129AbeH3IxH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Aug 2018 04:53:07 -0400
Message-ID: <0e83fccbecf56bfa930120d00dbbc5db@smtp-cloud7.xs4all.net>
Date: Thu, 30 Aug 2018 06:52:47 +0200
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: cron job: media_tree daily build: ERRORS
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This message is generated daily by a cron job that builds media_tree for
the kernels and architectures in the list below.

Results of the daily build of media_tree:

date:			Thu Aug 30 05:00:10 CEST 2018
media-tree git hash:	3799eca51c5be3cd76047a582ac52087373b54b3
media_build git hash:	baf45935ffad914f33faf751ad9f4d0dd276c021
v4l-utils git hash:	e37fbf50a28c1a1cfe9e00a60542bc14192a87ba
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
linux-git-sh: WARNINGS
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
linux-3.12.74-x86_64: ERRORS
linux-3.13.11-i686: ERRORS
linux-3.13.11-x86_64: ERRORS
linux-3.14.79-i686: ERRORS
linux-3.14.79-x86_64: ERRORS
linux-3.14.79/arch/x86/include/asm/preempt.h:6,
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
linux-4.19-rc1-i686: ERRORS
linux-4.19-rc1-x86_64: ERRORS
apps: OK
specified for parameter 'kernel_sock_ioctl'
specified for parameter 'sk_buff_data_t'
specified for parameter 'pci_hotplug_mem_size'
specified for parameter 'socket_seq_show'
specified for parameter 'socket_seq_show'
specified for parameter 'socket_seq_show'
specified for parameter 'pci_hotplug_mem_size'
specified for parameter 'make_bad_inode'
specified for parameter 'probe_kernel_write'
specified for parameter 'zonelists_mutex'
specifier-qualifier-list before 'kgid_t'
specified for parameter '__invalidate_device'
specified for parameter 'mmap_min_addr'
specified for parameter 'numa_set_node'
specified for parameter 'io_schedule_timeout'
specified for parameter 'io_schedule_timeout'
specified for parameter 'io_schedule_timeout'
specified for parameter 'init_bsp_APIC'
specified for parameter 'init_bsp_APIC'
specified for parameter 'early_pfn_to_nid'
specifiers or '...' before 'dr_match_t'
specified for parameter 'shrink_dcache_parent'
specifiers or '...' before 'atomic_long_t'
specifiers or '...' before 'atomic_long_t'
specifiers or '...' before 'atomic_long_t'
specifiers or '...' before 'atomic_long_t'
specifiers or '...' before 'atomic_long_t'
specifiers or '...' before 'atomic_long_t'
specified for parameter 'klist_add_tail'
specifiers or '...' before 'wait_bit_action_f'
specifiers or '...' before 'atomic64_t'
specifiers or '...' before 'atomic64_t'
specifiers or '...' before 'atomic64_t'
specifiers or '...' before 'atomic64_t'
spec-git: ERRORS
sparse: WARNINGS

Detailed results are available here:

http://www.xs4all.nl/~hverkuil/logs/Thursday.log

Full logs are available here:

http://www.xs4all.nl/~hverkuil/logs/Thursday.tar.bz2

The Media Infrastructure API from this daily build is here:

http://www.xs4all.nl/~hverkuil/spec/index.html
