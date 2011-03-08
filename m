Return-path: <mchehab@pedra>
Received: from ganesha.gnumonks.org ([213.95.27.120]:54822 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088Ab1CHHJ2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Mar 2011 02:09:28 -0500
From: Jonghun Han <jonghun.han@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com
Subject: [RFC 0/1] v4l: videobuf2: Add Exynos devices based allocator, named SDVMM
Date: Tue,  8 Mar 2011 15:47:44 +0900
Message-Id: <1299566865-5499-1-git-send-email-jonghun.han@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

==================
Introduction
==================
The purpose of this RFC is to discuss the vb2-allocator
for multimedia devices available in upcoming Samsung SoC Exynos.
Not all of them are merged or submitted by now,
but I decided to post this for starting discussion about buffer management.

vb2-sdvmm is an allocator using SDVMM.
The SDVMM is not a implementation itself.
It is the name of solution which integrates UMP, VCM, CMA and SYS.MMU.

The main purposes of Shared Device Virtual Memory Management(aka SDVMM) are:
1. Inter-process buffer sharing using UMP
2. Device virtual memory management using VCM and SYS.MMU(aka IOMMU)
3. Contiguous memory allocation support using CMA

==================
Related patchset
==================
1. UMP (Unified Memory Provider)
- The UMP is an auxiliary component which enables memory to be shared
  across different applications, drivers and hardware components.
- http://blogs.arm.com/multimedia/249-making-the-mali-gpu-device-driver-open-source/page__cid__133__show__newcomment/
- Suggested by ARM, Not submitted yet.

2. VCM (Virtual Contiguous Memory framework)
- The VCM is a framework to deal with multiple IOMMUs in a system
  with intuitive and abstract objects
- Submitted by Michal Nazarewicz @Samsung-SPRC
- Also submitted by KyongHo Cho @Samsung-SYS.LSI
- http://article.gmane.org/gmane.linux.kernel.mm/56912/match=vcm

3. CMA (Contiguous Memory Allocator)
- The Contiguous Memory Allocator (CMA) is a framework, which allows
  setting up a machine-specific configuration for physically-contiguous
  memory management. Memory for devices is then allocated according
  to that configuration.
- http://lwn.net/Articles/396702/
- http://www.spinics.net/lists/linux-media/msg26486.html
- Submitted by Michal Nazarewicz @Samsung-SPRC

4. SYS.MMU
- System mmu supports address transition from virtual address
  to physical address.
- http://thread.gmane.org/gmane.linux.kernel.samsung-soc/3909
- Submitted by Sangbeom Kim
- Merged by Kukjin Kim, ARM/S5P ARM ARCHITECTURES maintainer.

==================
How to use
==================
+-------------------------------+  SecureId   +---------------------------+
|           Converter           | <---------- |          Renderer         |
+-------------------------------+             +---------------------------+
   ^        |       |        ^                   ^          ^
   |        |  UVA  |        |                   |          |
  UVA       |       |       UVA               SecureId      |
   |        |       |        |                   |          |
+-----+     |       |     +-----+             +-----+    UVA by mmap
| UMP |     |       |     | UMP |             | UMP |       |
| Lib |     |       |     | Lib |             | Lib |       |
+-----+     |       |     +-----+             +-----+       |
   |        |       |        |                   |          |      user space
-----------------------------------------------------------------------------
   |        |       |        |                   |          |    kernel space
   |        v       v        |                   |          |
   |      +-----------+      |                   |    +----------+
   |      | s5p-fimc  |      |                   |    |  s3c-fb  |
   |      +-----------+      |                   |    +----------+
   |        |       |        |                   |      ^   |
+-----+   +-----------+   +-----+             +-----+   |   |
| Ump |<->|    vb2    |<->| Ump |             | Ump |<--+   |
| Drv |   |   sdvmm   |   | Drv |             | Drv |       |
+-----+   +-----------+   +-----+             +-----+       |
            |       |                                       |
+-------------------------------+             +---------------------------+
|              VCM              |             |            VCM            |
+-------------------------------+             +---------------------------+
            |       |                                       |
            |       |                         +---------------------------+
            |       |                         |            CMA            |
            |       |                         +---------------------------+
            |  DVA  |                                       |
            |       |                                       |
+-------------------------------+                           |
|            SYS.MMU            |                           |
+-------------------------------+                           PA
            |       |                                       |
            v       v                                       v
          +-----------+                               +-----------+
          |   FIMC    |                               |   FIMD    |
          +-----------+                               +-----------+

Basic flow
- Output interface for source
1. Allocate discontiguous memory using UMP
2. Get User Virtual Address(aka UVA)
3. Send the UVA to the src(Output interface) buffer of the M2M device.

- Capture interface for destination
1. Getting the UVA from the FB driver by mmap.
2. Get SecureID matched with FB UVA
3. Send a SecureID to Converter process
   SecureID is an unique cookie for the buffer over the process.
4. Converter process gets the UVA using SecureID from UMP Lib.
5. Sned the UVA to the dst(Capture interface) buffer of the M2M device.

- QBUF
1. UVA is sent to VB2.
2. vb2_sdvmm_get_userptr is called.
3. SDVMM finds the SecureID using UVA from UMP.
4. SDVMM finds Device Virtual Address(aka DVA) using SecureID.
   DVA is the virtual address, managed by VCM.
   The address space is only for devices which have own SYS.MMU.

- fimc_dma_run, the callback function of device_run in m2m framework.
1. driver get the DVA from vb2-sdvmm.
2. set the DVA to SFR
3. device access the physical address via SYS.MMU.
   SYS.MMU translate DVA to PA

