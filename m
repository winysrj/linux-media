Return-path: <linux-media-owner@vger.kernel.org>
Received: from va-smtp01.263.net ([54.88.144.211]:56275 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964858AbcBRA7Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2016 19:59:25 -0500
Received: from mail-ig0-f181.google.com (localhost.localdomain [127.0.0.1])
	by va-smtp01.263.net (Postfix) with ESMTP id 555129F72C
	for <linux-media@vger.kernel.org>; Thu, 18 Feb 2016 08:59:20 +0800 (CST)
Received: by mail-ig0-f181.google.com with SMTP id 5so2108387igt.0
        for <linux-media@vger.kernel.org>; Wed, 17 Feb 2016 16:59:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAD=FV=V8tZvvqVCC4CMD9T-PYL+_3DojGq8jBEtm1raMYzw=3Q@mail.gmail.com>
References: <1455705673-25484-1-git-send-email-jung.zhao@rock-chips.com>
	<1455705771-25771-1-git-send-email-jung.zhao@rock-chips.com>
	<CAD=FV=V8tZvvqVCC4CMD9T-PYL+_3DojGq8jBEtm1raMYzw=3Q@mail.gmail.com>
Date: Thu, 18 Feb 2016 08:59:17 +0800
Message-ID: <CAD82f72vPddBJeDuRCG38-sopk6BPrY49ggAugeGQC_GUg-Fyw@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] [NOT FOR REVIEW] videobuf2-dc: Let drivers specify
 DMA attrs
From: Jung Zhao <jung.zhao@rock-chips.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Tomasz Figa <tfiga@chromium.org>,
	"open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <posciak@chromium.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Doug,
Thanks for your work. I will fix this mistake.

2016-02-18 0:12 GMT+08:00 Doug Anderson <dianders@chromium.org>:
> Hi,
>
> On Wed, Feb 17, 2016 at 2:42 AM, Jung Zhao <jung.zhao@rock-chips.com> wrote:
>> From: Tomasz Figa <tfiga@chromium.org>
>>
>> DMA allocations might be subject to certain reqiurements specific to the
>> hardware using the buffers, such as availability of kernel mapping (for
>> contents fix-ups in the driver). The only entity that knows them is the
>> driver, so it must share this knowledge with vb2-dc.
>>
>> This patch extends the alloc_ctx initialization interface to let the
>> driver specify DMA attrs, which are then stored inside the allocation
>> context and will be used for all allocations with that context.
>>
>> As a side effect, all dma_*_coherent() calls are turned into
>> dma_*_attrs() calls, because the attributes need to be carried over
>> through all DMA operations.
>>
>> Signed-off-by: Tomasz Figa <tfiga@chromium.org>
>> Signed-off-by: Jung Zhao <jung.zhao@rock-chips.com>
>> ---
>> Changes in v2: None
>>
>>  drivers/media/v4l2-core/videobuf2-dma-contig.c | 33 +++++++++++++++++---------
>>  include/media/videobuf2-dma-contig.h           | 11 ++++++++-
>>  2 files changed, 32 insertions(+), 12 deletions(-)
>
> This patch is already present in linuxnext.  I submitted it to Russell
> King's Patch Tracking System a bit ago and got notice that it landed.
> Checking linuxnext today I see:
>
> ccc66e738252 ARM: 8508/2: videobuf2-dc: Let drivers specify DMA attrs
>
> -Doug
>
> _______________________________________________
> Linux-rockchip mailing list
> Linux-rockchip@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-rockchip



-- 
Best Regards,
Jung

****************************************
福州瑞芯微电子有限公司 (Rockchip)
赵俊 (Jung Zhao)
算法工程师 (Algorithm Engineer)
+86-591-83991906-8944
****************************************
