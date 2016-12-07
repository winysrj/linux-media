Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:36529 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753266AbcLGRW5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Dec 2016 12:22:57 -0500
Received: by mail-pf0-f170.google.com with SMTP id 189so78399234pfz.3
        for <linux-media@vger.kernel.org>; Wed, 07 Dec 2016 09:22:50 -0800 (PST)
From: Kevin Hilman <khilman@baylibre.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-media@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>,
        Axel Haslam <ahaslam@baylibre.com>,
        Bartosz =?utf-8?Q?Go=C5=82aszewski?= <bgolaszewski@baylibre.com>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 3/5] [media] davinci: vpif_capture: fix start/stop streaming locking
References: <20161207050826.23174-1-khilman@baylibre.com>
        <20161207050826.23174-4-khilman@baylibre.com>
        <5753609.tAY8Gxp3ld@avalon>
Date: Wed, 07 Dec 2016 09:22:48 -0800
In-Reply-To: <5753609.tAY8Gxp3ld@avalon> (Laurent Pinchart's message of "Wed,
        07 Dec 2016 16:47:34 +0200")
Message-ID: <m2eg1jejrr.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart <laurent.pinchart@ideasonboard.com> writes:

> Hi Kevin,
>
> Thank you for the patch.
>
> On Tuesday 06 Dec 2016 21:08:24 Kevin Hilman wrote:
>> Video capture subdevs may be over I2C and may sleep during xfer, so we
>> cannot do IRQ-disabled locking when calling the subdev.
>> 
>> The IRQ-disabled locking is meant to protect the DMA queue list
>> throughout the rest of the driver, so update the locking in
>> [start|stop]_streaming to protect just this list.
>> 
>> Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Signed-off-by: Kevin Hilman <khilman@baylibre.com>
>
> I would also add a comment to document the irqlock field as protecting the 
> dma_queue list only. Something like
>
> -	/* Used in video-buf */
> +	/* Protects the dma_queue field */
> 	spinlock_t irqlock;
>
> With that,
>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

OK, will update the comment.  Thanks for the review,

Kevin
