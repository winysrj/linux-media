Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:55921 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753918AbeDTHjK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 03:39:10 -0400
Received: by mail-it0-f65.google.com with SMTP id l83-v6so1479668ita.5
        for <linux-media@vger.kernel.org>; Fri, 20 Apr 2018 00:39:10 -0700 (PDT)
Received: from mail-io0-f171.google.com (mail-io0-f171.google.com. [209.85.223.171])
        by smtp.gmail.com with ESMTPSA id d85-v6sm560823itb.23.2018.04.20.00.39.08
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Apr 2018 00:39:08 -0700 (PDT)
Received: by mail-io0-f171.google.com with SMTP id v13-v6so9554931iob.6
        for <linux-media@vger.kernel.org>; Fri, 20 Apr 2018 00:39:08 -0700 (PDT)
MIME-Version: 1.0
References: <20180419154124.17512-1-paul.kocialkowski@bootlin.com> <20180419154124.17512-3-paul.kocialkowski@bootlin.com>
In-Reply-To: <20180419154124.17512-3-paul.kocialkowski@bootlin.com>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Fri, 20 Apr 2018 07:38:57 +0000
Message-ID: <CAPBb6MVuyN+NdCrLQaM-7Rv0SyutgQjORBU=rZvq-dKs6RDjQA@mail.gmail.com>
Subject: Re: [PATCH v2 02/10] media-request: Add a request complete operation
 to allow m2m scheduling
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-sunxi@googlegroups.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        robh+dt@kernel.org, mark.rutland@arm.com,
        Maxime Ripard <maxime.ripard@bootlin.com>, wens@csie.org,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        kyungmin.park@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        p.zabel@pengutronix.de, arnd@arndb.de,
        Tomasz Figa <tfiga@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 20, 2018 at 12:43 AM Paul Kocialkowski <
paul.kocialkowski@bootlin.com> wrote:

> When using the request API in the context of a m2m driver, the
> operations that come with a m2m run scheduling call in their
> (m2m-specific) ioctl handler are delayed until the request is queued
> (for instance, this includes queuing buffers and streamon).

> Thus, the m2m run scheduling calls are not called in due time since the
> request AP's internal plumbing will (rightfully) use the relevant core
> functions directly instead of the ioctl handler.

> This ends up in a situation where nothing happens if there is no
> run-scheduling ioctl called after queuing the request.

> In order to circumvent the issue, a new media operation is introduced,
> called at the time of handling the media request queue ioctl. It gives
> m2m drivers a chance to schedule a m2m device run at that time.

> The existing req_queue operation cannot be used for this purpose, since
> it is called with the request queue mutex held, that is eventually needed
> in the device_run call to apply relevant controls.

> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> ---
>   drivers/media/media-request.c | 3 +++
>   include/media/media-device.h  | 2 ++
>   2 files changed, 5 insertions(+)

> diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
> index 415f7e31019d..28ac5ccfe6a2 100644
> --- a/drivers/media/media-request.c
> +++ b/drivers/media/media-request.c
> @@ -157,6 +157,9 @@ static long media_request_ioctl_queue(struct
media_request *req)
>                  media_request_get(req);
>          }

> +       if (mdev->ops->req_complete)
> +               mdev->ops->req_complete(req);
> +
>          return ret;
>   }

> diff --git a/include/media/media-device.h b/include/media/media-device.h
> index 07e323c57202..c7dcf2079cc9 100644
> --- a/include/media/media-device.h
> +++ b/include/media/media-device.h
> @@ -55,6 +55,7 @@ struct media_entity_notify {
>    * @req_alloc: Allocate a request
>    * @req_free: Free a request
>    * @req_queue: Queue a request
> + * @req_complete: Complete a request
>    */
>   struct media_device_ops {
>          int (*link_notify)(struct media_link *link, u32 flags,
> @@ -62,6 +63,7 @@ struct media_device_ops {
>          struct media_request *(*req_alloc)(struct media_device *mdev);
>          void (*req_free)(struct media_request *req);
>          int (*req_queue)(struct media_request *req);
> +       void (*req_complete)(struct media_request *req);

This is called *before* the request is actually run, isn't it? In that
case, wouldn't something like "req_schedule" be less confusing?
req_complete implies that the request is already completed.
