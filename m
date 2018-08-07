Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f67.google.com ([209.85.161.67]:41755 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727224AbeHGJIN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2018 05:08:13 -0400
Received: by mail-yw1-f67.google.com with SMTP id q129-v6so4552320ywg.8
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2018 23:55:20 -0700 (PDT)
Received: from mail-yw1-f48.google.com (mail-yw1-f48.google.com. [209.85.161.48])
        by smtp.gmail.com with ESMTPSA id v185-v6sm248633ywc.94.2018.08.06.23.55.20
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Aug 2018 23:55:20 -0700 (PDT)
Received: by mail-yw1-f48.google.com with SMTP id r184-v6so4556965ywg.6
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2018 23:55:20 -0700 (PDT)
MIME-Version: 1.0
References: <20180724140621.59624-1-tfiga@chromium.org> <20180724140621.59624-2-tfiga@chromium.org>
 <37a8faea-a226-2d52-36d4-f9df194623cc@xs4all.nl> <CAAFQd5BgGEBmd8gNGc-qqtUtLo=Mh8U+TVTWRsKYMv1LmeBQMA@mail.gmail.com>
 <1532601401.4879.10.camel@pengutronix.de>
In-Reply-To: <1532601401.4879.10.camel@pengutronix.de>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 7 Aug 2018 15:55:08 +0900
Message-ID: <CAAFQd5BttOq_-DRyj0jr5-WF84JJdBwTFciSoQqY0bsonJbDPA@mail.gmail.com>
Subject: Re: [PATCH 1/2] media: docs-rst: Document memory-to-memory video
 decoder interface
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>, kamil@wypas.org,
        a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        jtp.park@samsung.com,
        =?UTF-8?B?VGlmZmFueSBMaW4gKOael+aFp+ePiik=?=
        <tiffany.lin@mediatek.com>,
        =?UTF-8?B?QW5kcmV3LUNUIENoZW4gKOmZs+aZuui/qik=?=
        <andrew-ct.chen@mediatek.com>, todor.tomov@linaro.org,
        nicolas@ndufresne.ca,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dave.stevenson@raspberrypi.org,
        Ezequiel Garcia <ezequiel@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 26, 2018 at 7:36 PM Philipp Zabel <p.zabel@pengutronix.de> wrote:
>
> On Thu, 2018-07-26 at 19:20 +0900, Tomasz Figa wrote:
> [...]
> > > You might want to mention that if there are insufficient buffers, then
> > > VIDIOC_CREATE_BUFS can be used to add more buffers.
> > >
> >
> > This might be a bit tricky, since at least s5p-mfc and coda can only
> > work on a fixed buffer set and one would need to fully reinitialize
> > the decoding to add one more buffer, which would effectively be the
> > full resolution change sequence, as below, just with REQBUFS(0),
> > REQBUFS(N) replaced with CREATE_BUFS.
>
> The coda driver supports CREATE_BUFS on the decoder CAPTURE queue.
>
> The firmware indeed needs a fixed frame buffer set, but these buffers
> are internal only and in a coda specific tiling format. The content of
> finished internal buffers is copied / detiled into the external CAPTURE
> buffers, so those can be added at will.

Thanks for clarifying. I forgot about that internal copy indeed.

Best regards,
Tomasz
