Return-path: <mchehab@pedra>
Received: from mailout4.samsung.com ([203.254.224.34]:39649 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682Ab1CAKvd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Mar 2011 05:51:33 -0500
Received: from epmmp2 (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LHD007M6KTWAQ20@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 01 Mar 2011 19:51:32 +0900 (KST)
Received: from AMDC159 ([106.116.37.153])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LHD005OTKTIR3@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 01 Mar 2011 19:51:32 +0900 (KST)
Date: Tue, 01 Mar 2011 11:51:17 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [st-ericsson] v4l2 vs omx for camera
In-reply-to: <1298975145.24906.60.camel@localhost>
To: 'Edward Hervey' <bilboed@gmail.com>
Cc: 'Nicolas Pitre' <nicolas.pitre@linaro.org>,
	'Kyungmin Park' <kmpark@infradead.org>,
	'Linus Walleij' <linus.walleij@linaro.org>,
	linaro-dev@lists.linaro.org,
	'Harald Gustafsson' <harald.gustafsson@ericsson.com>,
	'Hans Verkuil' <hverkuil@xs4all.nl>,
	'Discussion of the development of and with GStreamer'
	<gstreamer-devel@lists.freedesktop.org>,
	johan.mossberg.lml@gmail.com,
	'ST-Ericsson LT Mailing List' <st-ericsson@lists.linaro.org>,
	linux-media@vger.kernel.org,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>
Message-id: <000701cbd7fe$9b1c4fa0$d154eee0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-language: pl
Content-transfer-encoding: 7BIT
References: <AANLkTik=Yc9cb9r7Ro=evRoxd61KVE=8m7Z5+dNwDzVd@mail.gmail.com>
 <AANLkTinDFMMDD-F-FsccCTvUvp6K3zewYsGT1BH9VP1F@mail.gmail.com>
 <201102100847.15212.hverkuil@xs4all.nl>
 <201102171448.09063.laurent.pinchart@ideasonboard.com>
 <AANLkTikg0Oj6nq6h_1-d7AQ4NQr2UyMuSemyniYZBLu3@mail.gmail.com>
 <1298578789.821.54.camel@deumeu>
 <AANLkTi=Twg-hzngyrpU_=o1yxQ3qVtiJf-Qhj--OubPu@mail.gmail.com>
 <AANLkTini7xuQ2kcrWbfGSUomdoPkLLJiik2soer8SL+X@mail.gmail.com>
 <alpine.LFD.2.00.1102261408010.22034@xanadu.home>
 <002b01cbd724$8e528bc0$aaf7a340$%szyprowski@samsung.com>
 <1298975145.24906.60.camel@localhost>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Tuesday, March 01, 2011 11:26 AM Edward Hervey wrote:

> On Mon, 2011-02-28 at 09:50 +0100, Marek Szyprowski wrote:
> > Hello,
> [...]
> >
> > I'm not sure that highmem is the right solution. First, this will force
> > systems with rather small amount of memory (like 256M) to use highmem just
> > to support DMA allocable memory. It also doesn't solve the issue with
> > specific memory requirement for our DMA hardware (multimedia codec needs
> > video memory buffers from 2 physical banks).
> 
>   Could you explain why a codec would require memory buffers from 2
> physical banks ?
> 

Well, this is rather a question to hardware engineer who designed it. 

I suspect that the buffers has been split into 2 regions and placed in 2 different
memory banks to achieve the performance required to decode/encode full hd h264
movie. Video codec has 2 AXI master interfaces and I expect it is able to perform
2 transaction to the memory at once.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


