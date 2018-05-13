Return-path: <linux-media-owner@vger.kernel.org>
Received: from avasout06.plus.net ([212.159.14.18]:56806 "EHLO
        avasout06.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751762AbeEMTBn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 May 2018 15:01:43 -0400
Subject: Re: [PATCH] [media] gspca: Stop using GFP_DMA for buffers for USB
 bulk transfers
To: Hans de Goede <hdegoede@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
References: <20180505082208.32553-1-hdegoede@redhat.com>
From: Adam Baker <linux@baker-net.org.uk>
Message-ID: <2e774de2-eda8-775e-4164-8b48fbadcbd6@baker-net.org.uk>
Date: Sun, 13 May 2018 19:54:09 +0100
MIME-Version: 1.0
In-Reply-To: <20180505082208.32553-1-hdegoede@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/05/18 09:22, Hans de Goede wrote:
> The recent "x86 ZONE_DMA love" discussion at LSF/MM pointed out that some
> gspca sub-drivvers are using GFP_DMA to allocate buffers which are used
> for USB bulk transfers, there is absolutely no need for this, drop it.
> 

The documentation for kmalloc() says
  GFP_DMA - Allocation suitable for DMA.

end at least in sq905.c the allocation is passed to the USB stack that
then uses it for DMA.

Looking a bit closer the "suitable for DMA" label that GFP_DMA promises
is not really a sensible thing for kmalloc() to determine as it is
dependent on the DMA controller in question. The USB stack now ensures
that everything works correctly as long as the memory is allocated with
kmalloc() so acked by me for sq905.c but, is anyone taking care of
fixing the kmalloc() documentation?

Adam Baker
