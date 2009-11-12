Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout5.samsung.com ([203.254.224.35]:45724 "EHLO
	mailout5.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759905AbZKLBae (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2009 20:30:34 -0500
Received: from epmmp1 (mailout5.samsung.com [203.254.224.35])
 by mailout1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KSZ000SB2UWYS@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 12 Nov 2009 10:30:32 +0900 (KST)
Received: from JSGOODMAIN ([12.23.109.106])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0KSZ006NA2TW47@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 12 Nov 2009 10:29:56 +0900 (KST)
Date: Thu, 12 Nov 2009 10:35:16 +0900
From: Jinsung Yang <jsgood.yang@samsung.com>
Subject: RE: [RFC] Global video buffers pool / Samsung SoC's
In-reply-to: <Pine.LNX.4.64.0911111926560.4072@axis700.grange>
To: 'Guennadi Liakhovetski' <g.liakhovetski@gmx.de>
Cc: 'Harald Welte' <laforge@gnumonks.org>,
	'Linux Media Mailing List' <linux-media@vger.kernel.org>,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>
Message-id: <009b01ca6338$63859e20$2a90da60$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252
Content-language: ko
Content-transfer-encoding: 7BIT
References: <20091111071250.GV4047@prithivi.gnumonks.org>
 <Pine.LNX.4.64.0911111926560.4072@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, thank you for your reply.
Harald may be in flight now :)

> One question to your SoCs though - do they have SRAM? usable and
> sufficient for graphics buffers? In any case any such implementation will
> have to be able to handle RAMs other than main system memory too,
> including card memory, NUMA, sparse RAM, etc., which is probably obvious
> anyway.
All Samsung SoCs have no SRAMs for graphic buffers, just having system
memory.
And what is worse, in case of 2 system memory banks,
some kinds of hardware need to allocate buffers to improve performance at
each bank separately.
This is just a kind of sample, Samsung SoCs have many special cases.
(Of course, we are trying to add IOMMU to resolve buffer issues at next SoCs
products)

Best Regards
--
Jinsung, Yang <jsgood.yang@samsung.com>
AP Development Team
System LSI, Semiconductor Business
SAMSUNG Electronics Co., LTD

