Return-path: <mchehab@pedra>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2535 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848Ab1CHIOO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Mar 2011 03:14:14 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linaro-dev@lists.linaro.org
Subject: Yet another memory provider: can linaro organize a meeting?
Date: Tue, 8 Mar 2011 09:13:59 +0100
Cc: linux-media@vger.kernel.org, Jonghun Han <jonghun.han@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201103080913.59231.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all,

We had a discussion yesterday regarding ways in which linaro can assist
V4L2 development. One topic was that of sorting out memory providers like
GEM and HWMEM.

Today I learned of yet another one: UMP from ARM.

http://blogs.arm.com/multimedia/249-making-the-mali-gpu-device-driver-open-source/page__cid__133__show__newcomment/

This is getting out of hand. I think that organizing a meeting to solve this
mess should be on the top of the list. Companies keep on solving the same
problem time and again and since none of it enters the mainline kernel any
driver using it is also impossible to upstream.

All these memory-related modules have the same purpose: make it possible to
allocate/reserve large amounts of memory and share it between different
subsystems (primarily framebuffer, GPU and V4L).

It really shouldn't be that hard to get everyone involved together and settle
on a single solution (either based on an existing proposal or create a 'the
best of' vendor-neutral solution).

I am currently aware of the following solutions floating around the net
that all solve different parts of the problem:

In the kernel: GEM and TTM.
Out-of-tree: HWMEM, UMP, CMA, VCM, CMEM, PMEM.

I'm sure that last list is incomplete.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
