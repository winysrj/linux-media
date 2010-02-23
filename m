Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:9493 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab0BWJlc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 04:41:32 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from eu_spt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0KYA00LLEG95I640@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 23 Feb 2010 09:41:29 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0KYA00MVUG940J@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 23 Feb 2010 09:41:28 +0000 (GMT)
Date: Tue, 23 Feb 2010 10:39:57 +0100
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: [PATCH/RFC v1 0/4] Multi-plane video buffer support for V4L2 API
 and videobuf
In-reply-to: <4B82C3A5.7070707@redhat.com>
To: 'Mauro Carvalho Chehab' <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	kyungmin.park@samsung.com
Message-id: <000c01cab46c$2925c810$7b715830$%osciak@samsung.com>
Content-language: pl
References: <1266855010-2198-1-git-send-email-p.osciak@samsung.com>
 <4B82C3A5.7070707@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

thank you for your comments.


>From: Mauro Carvalho Chehab [mailto:mchehab@redhat.com]
>Pawel Osciak wrote:
>> Only streaming I/O has been tested, read/write might not work correctly.
>> vivi has been adapted for testing and demonstration purposes, but other drivers
>> will not compile. Tests have been made on vivi and on an another driver for an
>> embedded device (those involved dma-contig and USERPTR as well). I am not
>> attaching that driver, as I expect nobody would be able to compile/test it
>> anyway.
>
>It would be interesting if you could add userptr support for videobuf-vmalloc, and
>test all supported modes with vivi. This helps to test the changes against existing
>userspace applications before needing to touch on all drivers.


Ok, I will, shouldn't be much of a problem.


Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center


