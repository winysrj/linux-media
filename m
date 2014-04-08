Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:27369 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756706AbaDHKvn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Apr 2014 06:51:43 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N3P007AHKU41D00@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 08 Apr 2014 11:51:40 +0100 (BST)
Message-id: <5343D4BD.4090809@samsung.com>
Date: Tue, 08 Apr 2014 12:51:41 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Kamil Debski <k.debski@samsung.com>, 'John Sheu' <sheu@google.com>,
	linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, posciak@google.com, arun.m@samsung.com,
	kgene.kim@samsung.com, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 4/4] v4l2-mem2mem: allow reqbufs(0) with "in use" MMAP
 buffers
References: <1394578325-11298-1-git-send-email-sheu@google.com>
 <1394578325-11298-5-git-send-email-sheu@google.com>
 <06c801cf526f$7b0498a0$710dc9e0$%debski@samsung.com>
In-reply-to: <06c801cf526f$7b0498a0$710dc9e0$%debski@samsung.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 2014-04-07 16:41, Kamil Debski wrote:
> Pawel, Marek,
>
> Before taking this to my tree I wanted to get an ACK from one of the
> videobuf2 maintainers. Could you spare a moment to look through this
> patch?

It's not a bug, it is a feature. This was one of the fundamental design 
requirements to allow applications to track if the memory is used or not.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

