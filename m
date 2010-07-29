Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:43037 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab0G2HFS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jul 2010 03:05:18 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
Received: from eu_spt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L6B00IN550RA160@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 29 Jul 2010 08:05:15 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L6B00BWN50RTR@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 29 Jul 2010 08:05:15 +0100 (BST)
Date: Thu, 29 Jul 2010 09:03:42 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: JPEG hw decoder
In-reply-to: <AANLkTinj_xPSTfd81F4zLGNYcPb7=4OB-wr604rBGW20@mail.gmail.com>
To: 'rd bairva' <rbairva@gmail.com>, linux-media@vger.kernel.org
Message-id: <004201cb2eec$2d7f7b40$887e71c0$%osciak@samsung.com>
Content-language: pl
References: <AANLkTin4r_NrQbzXoTWoJJRCUXX9mjfgtrJ9yTPLW5_W@mail.gmail.com>
 <Pine.LNX.4.64.1007282110130.23907@axis700.grange>
 <AANLkTikfgYhdZ=3HogiB0j7iXuu0bqBZVkwFONz59SOM@mail.gmail.com>
 <Pine.LNX.4.64.1007290808100.16266@axis700.grange>
 <AANLkTinj_xPSTfd81F4zLGNYcPb7=4OB-wr604rBGW20@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>rd bairva wrote:
>  If I write the jpeg driver using v4l2-mem2mem.
>  Than i think i need to write custom applications for the kernel
>  driver. Are there some application available to use this v4l2-mem2mem?

There is no other interface for jpeg codec hardware in V4L2 as far
as I am aware anyway. That's why mem2mem has been developed in the first
place. Mem2mem has just been released (in 2.6.35), so you have to give
it some time. That said, I don't think you will find any other (non-mem2mem)
V4L2-based applications for jpeg hardware either. Somebody might prove
me wrong on this though...

Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center


