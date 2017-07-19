Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33222 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751581AbdGSHQc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 03:16:32 -0400
Received: by mail-wm0-f68.google.com with SMTP id 65so2234913wmf.0
        for <linux-media@vger.kernel.org>; Wed, 19 Jul 2017 00:16:32 -0700 (PDT)
Subject: Re: [PATCH] [media] coda: disable BWB for all codecs on CODA 960
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc: kernel@pengutronix.de
References: <20170302101952.16917-1-p.zabel@pengutronix.de>
From: Ian Arkver <ian.arkver.dev@gmail.com>
Message-ID: <594ed2a7-df43-4fb4-b12c-5b215b618087@gmail.com>
Date: Wed, 19 Jul 2017 08:16:29 +0100
MIME-Version: 1.0
In-Reply-To: <20170302101952.16917-1-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On 02/03/17 10:19, Philipp Zabel wrote:
> I don't know what the BWB unit is, I guess W is for write and one of the
> Bs is for burst. All I know is that there repeatedly have been issues
> with it hanging on certain streams (ENGR00223231, ENGR00293425), with
> various firmware versions, sometimes blocking something related to the
> GDI bus or the GDI AXI adapter. There are some error cases that we don't
> know how to recover from without a reboot. Apparently this unit can be
> disabled by setting bit 12 in the FRAME_MEM_CTRL mailbox register to
> zero, so do that to avoid crashes.

Both those FSL ENGR patches to Android and VPU lib are specific to 
decode, with the first being specific to VC1 decode only.

> Side effects are reduced burst lengths when writing out decoded frames
> to memory, so there is an "enable_bwb" module parameter to turn it back
> on.

These side effects are dramatically reducing the VPU throughput during 
H.264 encode as well. Prior to this patch I was just about managing to 
capture and stream 1080p25 H.264. After this change it fell to about 
19fps. Reverting this patch (or presumably using the module param) 
restores the frame rate.

Can we at least make this decode specific? The VPU library patches do it 
in vpu_DecOpen. I'd guess disabling the BWB any time prior to stream 
start would be OK.

It might also be worth adding some sort of /* HACK */ marker, since 
disabling the BWB feels very like a hack to me.

Regards,
Ian
