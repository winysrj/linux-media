Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:59887 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750859AbcJUIx1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Oct 2016 04:53:27 -0400
Subject: Re: [PATCH v3] [media] vb2: Add support for capture_dma_bidirectional
 queue flag
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <1477034705-5829-1-git-send-email-thierry.escande@collabora.com>
 <20161021074845.GZ9460@valkosipuli.retiisi.org.uk>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
From: Thierry Escande <thierry.escande@collabora.com>
Message-ID: <f3a6dbd1-62d6-826c-e89a-282ce51eeab4@collabora.com>
Date: Fri, 21 Oct 2016 10:53:22 +0200
MIME-Version: 1.0
In-Reply-To: <20161021074845.GZ9460@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 21/10/2016 09:48, Sakari Ailus wrote:
> Hi Thierry,
>
> On Fri, Oct 21, 2016 at 09:25:05AM +0200, Thierry Escande wrote:
>> From: Pawel Osciak <posciak@chromium.org>
>>
>> When this flag is set for CAPTURE queues by the driver on calling
>> vb2_queue_init(), it forces the buffers on the queue to be
>> allocated/mapped with DMA_BIDIRECTIONAL direction flag instead of
>> DMA_FROM_DEVICE. This allows the device not only to write to the
>> buffers, but also read out from them. This may be useful e.g. for codec
>> hardware which may be using CAPTURE buffers as reference to decode
>> other buffers.
>>
>> This flag is ignored for OUTPUT queues as we don't want to allow HW to
>> be able to write to OUTPUT buffers.
>>
>> Signed-off-by: Pawel Osciak <posciak@chromium.org>
>> Tested-by: Pawel Osciak <posciak@chromium.org>
>> Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
>>
>
> Please also check where dma_dir is being used especially in memory type
> implementation. There are several comparisons to DMA_FROM_DEVICE which will
> have a different result if DMA_BIDIRECTIONAL is used instead.
Nice catch, thanks.

How about a macro like this:

#define VB2_DMA_DIR_CAPTURE(d) \
		((d) == DMA_FROM_DEVICE || (d) == DMA_BIDIRECTIONAL)

Regards,
  Thierry

