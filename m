Return-path: <mchehab@pedra>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:29874 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab0IIJ21 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Sep 2010 05:28:27 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8; format=flowed
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L8H0036G3NDTU60@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 09 Sep 2010 10:28:25 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L8H009A23NCHC@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 09 Sep 2010 10:28:25 +0100 (BST)
Date: Thu, 09 Sep 2010 18:26:25 +0900
From: Pawel Osciak <p.osciak@samsung.com>
Subject: Re: [PATCH/RFC v1 0/7] Videobuf2 framework
In-reply-to: <1284023988-23351-1-git-send-email-p.osciak@samsung.com>
To: Pawel Osciak <p.osciak@samsung.com>
Cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, t.fujak@samsung.com
Message-id: <4C88A841.5090207@samsung.com>
References: <1284023988-23351-1-git-send-email-p.osciak@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On 09/09/2010 06:19 PM, Pawel Osciak wrote:
> Hello,
>
> These patches add a new driver framework for Video for Linux 2 driver
> - Videobuf2.

Sorry, I failed to mention that these patches depend on the multi-planar
API extensions, but do not require multi-planar support in drivers and 
in vivi.

Videobuf2 supports multi-planes, but can be used normally with current,
single-planar API and drivers.

Multi-planar API is available on this list and can also be pulled from here:

The following changes since commit 67ac062a5138ed446a821051fddd798a01478f85:

    V4L/DVB: Fix regression for BeholdTV Columbus (2010-08-24 10:39:32 
-0300)

are available in the git repository at:
    git://git.infradead.org/users/kmpark/linux-2.6-samsung 
v4l/multiplane-api

Pawel Osciak (4):
        v4l: Add multi-planar API definitions to the V4L2 API
        v4l: Add multi-planar ioctl handling code
        v4l: Add compat functions for the multi-planar API
        v4l: fix copy sizes in compat32 for ext controls

   drivers/media/video/v4l2-compat-ioctl32.c |  229 +++++++++++++---
   drivers/media/video/v4l2-ioctl.c          |  420 
++++++++++++++++++++++++++---
   include/linux/videodev2.h                 |  124 +++++++++-
   include/media/v4l2-ioctl.h                |   16 ++
   4 files changed, 709 insertions(+), 80 deletions(-)

-- 
Best regards,
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center
