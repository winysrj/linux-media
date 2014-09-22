Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:40720 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaIVDzz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Sep 2014 23:55:55 -0400
Received: by mail-lb0-f178.google.com with SMTP id z12so3449152lbi.9
        for <linux-media@vger.kernel.org>; Sun, 21 Sep 2014 20:55:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <541ECD1D.5020605@xs4all.nl>
References: <541ECD1D.5020605@xs4all.nl>
From: Pawel Osciak <pawel@osciak.com>
Date: Mon, 22 Sep 2014 12:47:32 +0900
Message-ID: <CAMm-=zDBM=dPohTZd28yFQMctGHUSb_wFobbTPJVt93ggn8M1Q@mail.gmail.com>
Subject: Re: RFC: vb2: replace alloc_ctx by struct device * in vb2_queue
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,
I'm not very much against it, but I'm not sure how option 2 is
significantly simpler than option 1. It's just one cast away from
being the same, unless you have some more rework in mind, e.g. making
vb2 aware of devices somehow and skip driver's involvement for
example?
Thanks,
Pawel

On Sun, Sep 21, 2014 at 10:05 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Marek, Pawel,
>
> Currently for dma_config (and the dma_sg code that I posted before) drivers have
> to allocate a alloc_ctx context, but in practice that just contains a device pointer.
>
> Is there any reason why we can't just change in struct vb2_queue:
>
>         void                            *alloc_ctx[VIDEO_MAX_PLANES];
>
> to:
>
>         struct device                   *alloc_ctx[VIDEO_MAX_PLANES];
>
> or possibly even just:
>
>         struct device                   *alloc_ctx;
>
> That simplifies the code quite a bit and I don't see and need for anything
> else. The last option would make it impossible to have different allocation
> contexts for different planes, but that might be something that Samsumg needs.
>
> Regards,
>
>         Hans



-- 
Best regards,
Pawel Osciak
