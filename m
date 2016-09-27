Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:34186 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754250AbcI0HwS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Sep 2016 03:52:18 -0400
Subject: Re: media: rockchip-vpu: I should place the huffman table at kernel
 or userspace ?
To: Randy Li <randy.li@rock-chips.com>, linux-media@vger.kernel.org
References: <5de5d305-0ecc-a994-d133-63d55c8b1741@rock-chips.com>
Cc: "linux-rockchip@lists.infradead.org"
        <linux-rockchip@lists.infradead.org>,
        "nicolas.dufresne@collabora.co.uk" <nicolas.dufresne@collabora.co.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <84ce2871-be3b-bf9f-ba0e-75de8c7d4824@xs4all.nl>
Date: Tue, 27 Sep 2016 09:52:12 +0200
MIME-Version: 1.0
In-Reply-To: <5de5d305-0ecc-a994-d133-63d55c8b1741@rock-chips.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27/09/16 05:43, Randy Li wrote:
> Hello:
>   I have just done a JPEG HW encoder for the RK3288. I have been told
> that I can't use the standard way to generate huffman table, the VPU
> supports only 10 levels with a different huffman table.
>   If I send the huffman table through the v4l2 extra control, the memory
> copy is requested, although the data is not very large(2 x 64 bytes) but
> still a overhead. The other way is to place them in the kernel driver,
> and just define the quality every time it encode a picture. But storing
> in kernel would make the driver a little bigger(2 x 11 x 64 bytes) and
> beyond the FIFO job.
>   So where Should I place the huffman table?

Put it in the driver. It's less than 1.5 kB, so really small.

I'm not sure what you mean with 'beyond the FIFO job' though.

My understanding is that there 10 quality levels, each with its own 
huffman table?

So the driver would implement the V4L2_CID_JPEG_COMPRESSION_QUALITY control
and for each quality level it picks a table. Makes sense to me.

Regards,

	Hans
