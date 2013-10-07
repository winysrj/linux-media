Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:51776 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689Ab3JGGkF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Oct 2013 02:40:05 -0400
Message-ID: <52525709.80201@ti.com>
Date: Mon, 7 Oct 2013 12:09:05 +0530
From: Archit Taneja <archit@ti.com>
MIME-Version: 1.0
To: <hverkuil@xs4all.nl>, <laurent.pinchart@ideasonboard.com>
CC: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<tomi.valkeinen@ti.com>
Subject: Re: [PATCH v4 0/4] v4l: VPE mem to mem driver
References: <1376996457-17275-1-git-send-email-archit@ti.com> <1378462346-10880-1-git-send-email-archit@ti.com> <5236AC66.8090201@ti.com>
In-Reply-To: <5236AC66.8090201@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Monday 16 September 2013 12:29 PM, Archit Taneja wrote:
> Hi Hans, Laurent,
>
> On Friday 06 September 2013 03:42 PM, Archit Taneja wrote:
>> VPE(Video Processing Engine) is an IP found on DRA7xx, this series
>> adds VPE as a
>> mem to mem v4l2 driver, and VPDMA as a helper library.
>>
>> The first version of the patch series described VPE in detail, you can
>> have a
>> look at it here:
>>
>> http://www.spinics.net/lists/linux-media/msg66518.html
>>
>> Changes in v4:
>> - Control ID for the driver reserved in v4l2-controls.h
>> - Some fixes/clean ups suggested by Hans.
>> - A small hack done in VPE's probe to use a fixed 64K resource size, this
>>    is needed as the DT bindings will split the addresses accross VPE
>>    submodules, the driver currently works with register offsets from
>> the top
>>    level VPE base. The driver can be modified later to support multiple
>>    ioremaps of the sub modules.
>> - Addition of sync on channel descriptors for input DMA channels, this
>>    ensures the VPDMA list is stalled in the rare case of an input
>> channel's
>>    DMA getting completed after all the output channel DMAs.
>> - Removed the DT and hwmod patches from this series. DRA7xx support is
>> not
>>    yet got in the 3.12 merge window. Will deal with those separately.
>
> I incorporated your comments and suggestions from the previous series.
> Wanted to know if you think it looks good enough to get merged now?

Ping. Any comments on this?

Thanks,
Archit

