Return-Path: <SRS0=J9mZ=O3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D01DC43387
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 10:13:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 350ED2184A
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 10:13:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbeLRKML (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 18 Dec 2018 05:12:11 -0500
Received: from foss.arm.com ([217.140.101.70]:42526 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726341AbeLRKML (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Dec 2018 05:12:11 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3D596A78;
        Tue, 18 Dec 2018 02:12:10 -0800 (PST)
Received: from p8cg001049571a15.blr.arm.com (p8cg001049571a15.blr.arm.com [10.162.41.146])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 30B2F3F5C0;
        Tue, 18 Dec 2018 02:12:01 -0800 (PST)
From:   Anshuman Khandual <anshuman.khandual@arm.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc:     ocfs2-devel@oss.oracle.com, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, linux-media@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-rdma@vger.kernel.org,
        dmaengine@vger.kernel.org, linux-block@vger.kernel.org,
        sparclinux@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-ia64@vger.kernel.org, linux-alpha@vger.kernel.org,
        akpm@linux-foundation.org, jiangqi903@gmail.com,
        hverkuil@xs4all.nl, vkoul@kernel.org, sfr@canb.auug.org.au,
        dledford@redhat.com, mpe@ellerman.id.au, axboe@kernel.dk,
        jeffrey.t.kirsher@intel.com, david@redhat.com
Subject: [PATCH V3 0/2] Replace all open encodings for NUMA_NO_NODE
Date:   Tue, 18 Dec 2018 15:42:11 +0530
Message-Id: <1545127933-10711-1-git-send-email-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Changes in V3:

- Dropped all references to NUMA_NO_NODE as per Lubomir Rinetl
- Split the patch into two creating a new one specifically for tools
- Folded Stephen's linux-next build fix into the second patch

Changes in V2: (https://patchwork.kernel.org/patch/10698089/)

- Added inclusion of 'numa.h' header at various places per Andrew
- Updated 'dev_to_node' to use NUMA_NO_NODE instead per Vinod

Changes in V1: (https://lkml.org/lkml/2018/11/23/485)

- Dropped OCFS2 changes per Joseph
- Dropped media/video drivers changes per Hans

RFC - https://patchwork.kernel.org/patch/10678035/

Build tested this with multiple cross compiler options like alpha, sparc,
arm64, x86, powerpc, powerpc64le etc with their default config which might
not have compiled tested all driver related changes. I will appreciate
folks giving this a test in their respective build environments.

All these places for replacement were found by running the following grep
patterns on the entire kernel code. Please let me know if this might have
missed some instances. This might also have replaced some false positives.
I will appreciate suggestions, inputs and review.

1. git grep "nid == -1"
2. git grep "node == -1"
3. git grep "nid = -1"
4. git grep "node = -1"

NOTE: I can still split the first patch into multiple ones - one for each
subsystem as suggested by Lubomir if that would be better.

Anshuman Khandual (1):
  mm: Replace all open encodings for NUMA_NO_NODE

Stephen Rothwell (1):
  Tools: Replace open encodings for NUMA_NO_NODE

 arch/alpha/include/asm/topology.h             |  3 ++-
 arch/ia64/kernel/numa.c                       |  2 +-
 arch/ia64/mm/discontig.c                      |  6 +++---
 arch/powerpc/include/asm/pci-bridge.h         |  3 ++-
 arch/powerpc/kernel/paca.c                    |  3 ++-
 arch/powerpc/kernel/pci-common.c              |  3 ++-
 arch/powerpc/mm/numa.c                        | 14 +++++++-------
 arch/powerpc/platforms/powernv/memtrace.c     |  5 +++--
 arch/sparc/kernel/pci_fire.c                  |  3 ++-
 arch/sparc/kernel/pci_schizo.c                |  3 ++-
 arch/sparc/kernel/psycho_common.c             |  3 ++-
 arch/sparc/kernel/sbus.c                      |  3 ++-
 arch/sparc/mm/init_64.c                       |  6 +++---
 arch/x86/include/asm/pci.h                    |  3 ++-
 arch/x86/kernel/apic/x2apic_uv_x.c            |  7 ++++---
 arch/x86/kernel/smpboot.c                     |  3 ++-
 drivers/block/mtip32xx/mtip32xx.c             |  5 +++--
 drivers/dma/dmaengine.c                       |  4 +++-
 drivers/infiniband/hw/hfi1/affinity.c         |  3 ++-
 drivers/infiniband/hw/hfi1/init.c             |  3 ++-
 drivers/iommu/dmar.c                          |  5 +++--
 drivers/iommu/intel-iommu.c                   |  3 ++-
 drivers/misc/sgi-xp/xpc_uv.c                  |  3 ++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  5 +++--
 include/linux/device.h                        |  2 +-
 init/init_task.c                              |  3 ++-
 kernel/kthread.c                              |  3 ++-
 kernel/sched/fair.c                           | 15 ++++++++-------
 lib/cpumask.c                                 |  3 ++-
 mm/huge_memory.c                              | 13 +++++++------
 mm/hugetlb.c                                  |  3 ++-
 mm/ksm.c                                      |  2 +-
 mm/memory.c                                   |  7 ++++---
 mm/memory_hotplug.c                           | 12 ++++++------
 mm/mempolicy.c                                |  2 +-
 mm/page_alloc.c                               |  4 ++--
 mm/page_ext.c                                 |  2 +-
 net/core/pktgen.c                             |  3 ++-
 net/qrtr/qrtr.c                               |  3 ++-
 tools/include/linux/numa.h                    | 16 ++++++++++++++++
 tools/perf/bench/numa.c                       |  6 +++---
 41 files changed, 123 insertions(+), 77 deletions(-)
 create mode 100644 tools/include/linux/numa.h

-- 
2.7.4

