Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43F33C04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 11:47:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09703206B7
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 11:47:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 09703206B7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=v3.sk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727616AbeLELrO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 06:47:14 -0500
Received: from shell.v3.sk ([90.176.6.54]:48530 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727094AbeLELrO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Dec 2018 06:47:14 -0500
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id F0EB1C4E2C;
        Wed,  5 Dec 2018 12:47:07 +0100 (CET)
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id x1-ASTHKGzzB; Wed,  5 Dec 2018 12:47:03 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 13AC2C4EDB;
        Wed,  5 Dec 2018 12:47:03 +0100 (CET)
X-Virus-Scanned: amavisd-new at zimbra.v3.sk
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 1xoonmHxIDJf; Wed,  5 Dec 2018 12:47:02 +0100 (CET)
Received: from belphegor (nat-pool-brq-t.redhat.com [213.175.37.10])
        by zimbra.v3.sk (Postfix) with ESMTPSA id 96733C4E2C;
        Wed,  5 Dec 2018 12:47:01 +0100 (CET)
Message-ID: <f2ca9a41e8c9da66f828a0e40449d01d8e2e6f39.camel@v3.sk>
Subject: Re: [PATCH V2] mm: Replace all open encodings for NUMA_NO_NODE
From:   Lubomir Rintel <lkundrak@v3.sk>
To:     Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     ocfs2-devel@oss.oracle.com, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, linux-media@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-rdma@vger.kernel.org,
        dmaengine@vger.kernel.org, linux-block@vger.kernel.org,
        sparclinux@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-ia64@vger.kernel.org, linux-alpha@vger.kernel.org,
        akpm@linux-foundation.org, jiangqi903@gmail.com,
        hverkuil@xs4all.nl, vkoul@kernel.org
Date:   Wed, 05 Dec 2018 12:47:00 +0100
In-Reply-To: <d58f8b38-660c-7673-4466-6651ad32eada@arm.com>
References: <1543235202-9075-1-git-send-email-anshuman.khandual@arm.com>
         <a9082610ae6d99d988f7cc22a29d8474726a12e7.camel@v3.sk>
         <d58f8b38-660c-7673-4466-6651ad32eada@arm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.2 (3.30.2-2.fc29) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, 2018-12-05 at 17:01 +0530, Anshuman Khandual wrote:
> 
> On 12/05/2018 02:56 AM, Lubomir Rintel wrote:
> > On Mon, 2018-11-26 at 17:56 +0530, Anshuman Khandual wrote:
> > > At present there are multiple places where invalid node number is encoded
> > > as -1. Even though implicitly understood it is always better to have macros
> > > in there. Replace these open encodings for an invalid node number with the
> > > global macro NUMA_NO_NODE. This helps remove NUMA related assumptions like
> > > 'invalid node' from various places redirecting them to a common definition.
> > > 
> > > Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> > > ---
> > > Changes in V2:
> > > 
> > > - Added inclusion of 'numa.h' header at various places per Andrew
> > > - Updated 'dev_to_node' to use NUMA_NO_NODE instead per Vinod
> > > 
> > > Changes in V1: (https://lkml.org/lkml/2018/11/23/485)
> > > 
> > > - Dropped OCFS2 changes per Joseph
> > > - Dropped media/video drivers changes per Hans
> > > 
> > > RFC - https://patchwork.kernel.org/patch/10678035/
> > > 
> > > Build tested this with multiple cross compiler options like alpha, sparc,
> > > arm64, x86, powerpc, powerpc64le etc with their default config which might
> > > not have compiled tested all driver related changes. I will appreciate
> > > folks giving this a test in their respective build environment.
> > > 
> > > All these places for replacement were found by running the following grep
> > > patterns on the entire kernel code. Please let me know if this might have
> > > missed some instances. This might also have replaced some false positives.
> > > I will appreciate suggestions, inputs and review.
> > > 
> > > 1. git grep "nid == -1"
> > > 2. git grep "node == -1"
> > > 3. git grep "nid = -1"
> > > 4. git grep "node = -1"
> > > 
> > >  arch/alpha/include/asm/topology.h             |  3 ++-
> > >  arch/ia64/kernel/numa.c                       |  2 +-
> > >  arch/ia64/mm/discontig.c                      |  6 +++---
> > >  arch/ia64/sn/kernel/io_common.c               |  3 ++-
> > >  arch/powerpc/include/asm/pci-bridge.h         |  3 ++-
> > >  arch/powerpc/kernel/paca.c                    |  3 ++-
> > >  arch/powerpc/kernel/pci-common.c              |  3 ++-
> > >  arch/powerpc/mm/numa.c                        | 14 +++++++-------
> > >  arch/powerpc/platforms/powernv/memtrace.c     |  5 +++--
> > >  arch/sparc/kernel/auxio_32.c                  |  3 ++-
> > >  arch/sparc/kernel/pci_fire.c                  |  3 ++-
> > >  arch/sparc/kernel/pci_schizo.c                |  3 ++-
> > >  arch/sparc/kernel/pcic.c                      |  7 ++++---
> > >  arch/sparc/kernel/psycho_common.c             |  3 ++-
> > >  arch/sparc/kernel/sbus.c                      |  3 ++-
> > >  arch/sparc/mm/init_64.c                       |  6 +++---
> > >  arch/sparc/prom/init_32.c                     |  3 ++-
> > >  arch/sparc/prom/init_64.c                     |  5 +++--
> > >  arch/sparc/prom/tree_32.c                     | 13 +++++++------
> > >  arch/sparc/prom/tree_64.c                     | 19 ++++++++++---------
> > >  arch/x86/include/asm/pci.h                    |  3 ++-
> > >  arch/x86/kernel/apic/x2apic_uv_x.c            |  7 ++++---
> > >  arch/x86/kernel/smpboot.c                     |  3 ++-
> > >  arch/x86/platform/olpc/olpc_dt.c              | 17 +++++++++--------
> > >  drivers/block/mtip32xx/mtip32xx.c             |  5 +++--
> > >  drivers/dma/dmaengine.c                       |  4 +++-
> > >  drivers/infiniband/hw/hfi1/affinity.c         |  3 ++-
> > >  drivers/infiniband/hw/hfi1/init.c             |  3 ++-
> > >  drivers/iommu/dmar.c                          |  5 +++--
> > >  drivers/iommu/intel-iommu.c                   |  3 ++-
> > >  drivers/misc/sgi-xp/xpc_uv.c                  |  3 ++-
> > >  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  5 +++--
> > >  include/linux/device.h                        |  2 +-
> > >  init/init_task.c                              |  3 ++-
> > >  kernel/kthread.c                              |  3 ++-
> > >  kernel/sched/fair.c                           | 15 ++++++++-------
> > >  lib/cpumask.c                                 |  3 ++-
> > >  mm/huge_memory.c                              | 13 +++++++------
> > >  mm/hugetlb.c                                  |  3 ++-
> > >  mm/ksm.c                                      |  2 +-
> > >  mm/memory.c                                   |  7 ++++---
> > >  mm/memory_hotplug.c                           | 12 ++++++------
> > >  mm/mempolicy.c                                |  2 +-
> > >  mm/page_alloc.c                               |  4 ++--
> > >  mm/page_ext.c                                 |  2 +-
> > >  net/core/pktgen.c                             |  3 ++-
> > >  net/qrtr/qrtr.c                               |  3 ++-
> > >  tools/perf/bench/numa.c                       |  6 +++---
> > >  48 files changed, 146 insertions(+), 108 deletions(-)
> > Thanks for the patch. It seems to me that you've got a fairly large
> > amount of it wrong though -- perhaps relying just on "git grep" alone
> > is not the best idea.
> 
> Hmm, okay.
> 
> > The diffstat is not all that big, it is entirely plausible to just
> > review each hunk manually: just do a "git show -U20" to get some
> > context.
> > 
> > You get a NAK from me for the OLPC DT part, but I think at least the
> > sparc/prom part also deals with device tree nodes and not NUMA nodes.
> 
> Will take a closer look at all the instances you have pointed out and
> then re-spin the patch. Just wondering how should I take care of
> Stephen's patch which is a fix for this one and available in Andrew's
> staging tree. Should I just go ahead and fold both them with Stephen's
> signed-off-by while re-spinning this patch ? Please suggest.

I think it would be better if this had been split into multiple
patches, one per subsystem, instead of a single large patch. It would
be easier to review it that way.

With Stephen's patch (am I looking at the correct one?) the tools/perf
part gets its own copy of numa.h and thus is not dependent on the rest
of the patch, correct?

To me it seems that the best course of action now would be to split off
a "tools: replace open encodings for NUMA_NO_NODE" patch with Stephen's
changes folded in. Keep his sign-off and add a "Co-Developed-by" tag. 

Cheers,
Lubo

