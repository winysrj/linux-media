Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:43938 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755454AbZJFHZS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Oct 2009 03:25:18 -0400
Received: from epmmp1 (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KR3007T80L4EK@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Oct 2009 16:24:40 +0900 (KST)
Received: from AMDC159 ([106.116.37.153])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0KR300BN60L0D0@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Oct 2009 16:24:40 +0900 (KST)
Date: Tue, 06 Oct 2009 09:23:09 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: Mem2Mem V4L2 devices [RFC]
In-reply-to: <A69FA2915331DC488A831521EAE36FE401553E952D@dlee06.ent.ti.com>
To: "'Karicheri, Muralidharan'" <m-karicheri2@ti.com>,
	"'Ivan T. Ivanov'" <iivanov@mm-sol.com>,
	linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, Tomasz Fujak <t.fujak@samsung.com>,
	Pawel Osciak <p.osciak@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <002201ca4655$dd8dc260$98a94720$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <E4D3F24EA6C9E54F817833EAE0D912AC077151C64F@bssrvexch01.BS.local>
 <1254500705.16625.35.camel@iivanov.int.mm-sol.com>
 <A69FA2915331DC488A831521EAE36FE401553E952D@dlee06.ent.ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Monday, October 05, 2009 10:02 PM Karicheri, Muralidharan wrote:

> There is another use case where there are two Resizer hardware working om the same input frame and
> give two different output frames of different resolution. How do we handle this using the one video
> device approach you
> just described here?

How the hardware is actually designed? I see two possibilities:

1.
[input buffer] --[dma engine]----> [resizer1] --[dma]-> [mem output buffer1]
                               \-> [resizer2] --[dma]-> [mem output buffer2]

2.
[input buffer] ---[dma engine1]-> [resizer1] --[dma]-> [mem output buffer1]
                \-[dma engine2]-> [resizer2] --[dma]-> [mem output buffer2]

In the first case we would really have problems mapping it properly to video
nodes. But we should think if there are any use cases of such design? (in
terms of mem-2-mem device) I know that this Y-type design makes sense as a
part of the pipeline from a sensor or decoder device. But I cannot find any
useful use case for mem2mem version of it.

The second case is much more trivial. One can just create two separate resizer
devices (with their own nodes) or one resizer driver with two hardware
resizers underneath it. In both cases application would simply queue the input
buffer 2 times for both transactions.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


