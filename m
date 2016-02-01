Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f172.google.com ([209.85.160.172]:35096 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbcBAVho (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Feb 2016 16:37:44 -0500
Received: by mail-yk0-f172.google.com with SMTP id r207so119231175ykd.2
        for <linux-media@vger.kernel.org>; Mon, 01 Feb 2016 13:37:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56AF5DB5.6000402@samsung.com>
References: <1452533428-12762-1-git-send-email-dianders@chromium.org>
	<1452533428-12762-5-git-send-email-dianders@chromium.org>
	<56AF5DB5.6000402@samsung.com>
Date: Mon, 1 Feb 2016 13:37:43 -0800
Message-ID: <CAD=FV=URO2kMHJD+XTMsWw29VjGAX43fgzi_s+FsyBrjJo8FgA@mail.gmail.com>
Subject: Re: [PATCH v6 4/5] videobuf2-dc: Let drivers specify DMA attrs
From: Doug Anderson <dianders@chromium.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Russell King <linux@arm.linux.org.uk>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Tomasz Figa <tfiga@chromium.org>,
	Pawel Osciak <pawel@osciak.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 1, 2016 at 5:29 AM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> Hello,
>
> On 2016-01-11 18:30, Douglas Anderson wrote:
>>
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
>> Signed-off-by: Douglas Anderson <dianders@chromium.org>
>
>
> Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

Added both your ans Mauro's acks to the current patch in RMK's patch
tracker.  You can see the patch at
<http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=8508/2>

Note that Javier has tested this series upstream on a Samsung
Chromebook and validated that the allocations are working as intended,
even if MFC is a bit tricky to get working properly upstream.


-Doug
