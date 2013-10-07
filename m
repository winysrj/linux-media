Return-path: <linux-media-owner@vger.kernel.org>
Received: from eddie.linux-mips.org ([78.24.191.182]:55150 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab3JGOYf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Oct 2013 10:24:35 -0400
Received: from localhost.localdomain ([127.0.0.1]:34722 "EHLO linux-mips.org"
        rhost-flags-OK-OK-OK-FAIL) by eddie.linux-mips.org with ESMTP
        id S6868732Ab3JGOYdtD1Sn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Oct 2013 16:24:33 +0200
Date: Mon, 7 Oct 2013 16:24:29 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>
Cc: linux-mips@linux-mips.org, linux-media@vger.kernel.org
Subject: Re: Suspected cache coherency problem on V4L2 and AR7100 CPU
Message-ID: <20131007142429.GG3098@linux-mips.org>
References: <m3eh82a1yo.fsf@t19.piap.pl>
 <m361t9a31i.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m361t9a31i.fsf@t19.piap.pl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 07, 2013 at 10:38:49AM +0200, Krzysztof Hałasa wrote:

> Please forgive me my MIPS TLB ignorance.

May the manual be with you :-)

> It seems there is a TLB entry pointing to the userspace buffer at the
> time the kernel pointer (kseg0) is used. Is is an allowed situation on
> MIPS 24K?
> 
> buffer: len 0x1000 (first page),
> 	userspace pointer 0x77327000,
> 	kernel pointer 0x867ac000 (physical address = 0x067ac000)
> 
> TLB Index: 15 pgmask=4kb va=77326000 asid=be
>        [pa=01149000 c=3 d=1 v=1 g=0] [pa=067ac000 c=3 d=1 v=1 g=0]
> 
> Should the TLB entry be deleted before using the kernel pointer (which
> points at the same page)?

That's fine.  You just need to ensure that there are no virtual aliases.
One way to do so is to increase the page size to 16kB.

Note that there is a variant of the 24K which has a VIPT cache but uses
hardware to resolve cache aliases.  That is, from a kernel cache management
perspective it behaves like a PIPT cache.

However as I understand what you're mapping to userspace is actually
device memory, right?  You probably want to map that uncached.  That's a
long standing issue in these two macros:

/*
 * Convert a physical pointer to a virtual kernel pointer for /dev/mem
 * access
 */
#define xlate_dev_mem_ptr(p)    __va(p)

/*
 * Convert a virtual cached pointer to an uncached pointer
 */
#define xlate_dev_kmem_ptr(p)   p

which are defined in arch/mips/include/asm/io.h.  These should return
a KSEG1 (uncached XKPHYS) address for anything but RAM.

Would that explain your observations?

  Ralf
