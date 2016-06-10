Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:51580 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156AbcFJMh0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2016 08:37:26 -0400
Subject: Re: [PATCH v4 18/44] [media] dma-mapping: Use unsigned long for
 dma_attrs
To: Fabien DESSENNE <fabien.dessenne@st.com>,
	Andrew Morton <akpm@linux-foundation.org>
References: <1465553521-27303-1-git-send-email-k.kozlowski@samsung.com>
 <1465553521-27303-19-git-send-email-k.kozlowski@samsung.com>
 <575AB26E.4020401@st.com>
Cc: "hch@infradead.org" <hch@infradead.org>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Message-id: <575AB481.6070303@samsung.com>
Date: Fri, 10 Jun 2016 14:37:21 +0200
MIME-version: 1.0
In-reply-to: <575AB26E.4020401@st.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/10/2016 02:28 PM, Fabien DESSENNE wrote:
> Hi
> 
> On 06/10/2016 12:11 PM, Krzysztof Kozlowski wrote:
>> Split out subsystem specific changes for easier reviews. This will be
>> squashed with main commit.
>>
>> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
>> ---
>>  drivers/media/platform/sti/bdisp/bdisp-hw.c    | 26 +++++++---------------
> 
> For bdisp: Acked-by: Fabien Dessenne <fabien.dessenne@st.com>
> 
> 
> The other part deals with v4l2-core, I let Mauro (ot other) review/ack
> it. I also think it would be better to split this patch in two patches

In case Mauro misses this patch, I will split it on next iteration.

Thanks,
Krzysztof

> (bdisp / v4l2-core)
>>  drivers/media/v4l2-core/videobuf2-dma-contig.c | 30 +++++++++++---------------
>>  drivers/media/v4l2-core/videobuf2-dma-sg.c     | 19 ++++------------
>>  include/media/videobuf2-dma-contig.h           |  7 ++----
>>  4 files changed, 26 insertions(+), 56 deletions(-)

