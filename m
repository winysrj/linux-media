Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:44289 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750891AbeEQI7Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 04:59:24 -0400
Received: by mail-lf0-f67.google.com with SMTP id h197-v6so7573845lfg.11
        for <linux-media@vger.kernel.org>; Thu, 17 May 2018 01:59:23 -0700 (PDT)
Subject: Re: [PATCH] rcar-vin: sync which hardware buffer to start capture
 from
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
References: <20180516232218.27154-1-niklas.soderlund+renesas@ragnatech.se>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <7cb4f4f3-a8a4-66a9-0ed0-375d42fffbe4@cogentembedded.com>
Date: Thu, 17 May 2018 11:59:21 +0300
MIME-Version: 1.0
In-Reply-To: <20180516232218.27154-1-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

On 5/17/2018 2:22 AM, Niklas Söderlund wrote:

> When starting the VIN capture procedure we are not guaranteed that the
> first buffer writing to is VnMB1 to which we assigned the first buffer

    Written, perhaps?

> queued. This is problematic for two reasons. Buffers might not be
> dequeued in the same order they where queued for capture. Future
> features planed for the VIN driver is support for outputing frames in

    Outputting.

> SEQ_TB/BT format and to do that it's important that capture starts from
> the first buffer slot, VnMB1.
> 
> We are guaranteed that capturing always happens in sequence (VnMB1 ->
> VnMB2 -> VnMB3 -> VnMB1). So drop up to two frames when starting
> capturing so that the driver always returns buffers in the same order
> they are queued and prepare for SEQ_TB/BT output.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>   drivers/media/platform/rcar-vin/rcar-dma.c | 16 +++++++++++++++-
>   drivers/media/platform/rcar-vin/rcar-vin.h |  2 ++
>   2 files changed, 17 insertions(+), 1 deletion(-)

[...]

MBR, Sergei
