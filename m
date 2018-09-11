Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f193.google.com ([209.85.219.193]:42845 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbeIKIuO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Sep 2018 04:50:14 -0400
Received: by mail-yb1-f193.google.com with SMTP id j8-v6so8804565ybg.9
        for <linux-media@vger.kernel.org>; Mon, 10 Sep 2018 20:52:57 -0700 (PDT)
Received: from mail-yw1-f43.google.com (mail-yw1-f43.google.com. [209.85.161.43])
        by smtp.gmail.com with ESMTPSA id 12-v6sm6118097yww.77.2018.09.10.20.52.55
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Sep 2018 20:52:55 -0700 (PDT)
Received: by mail-yw1-f43.google.com with SMTP id x67-v6so8704800ywg.0
        for <linux-media@vger.kernel.org>; Mon, 10 Sep 2018 20:52:55 -0700 (PDT)
MIME-Version: 1.0
References: <20180724140621.59624-1-tfiga@chromium.org> <bed0d45d-d5c0-d2dc-03d7-eedf99246182@xs4all.nl>
In-Reply-To: <bed0d45d-d5c0-d2dc-03d7-eedf99246182@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 11 Sep 2018 12:52:43 +0900
Message-ID: <CAAFQd5C3pMyVBokWs4QS-O3jckFXY-7eG-ayD357v8TDyU5zTA@mail.gmail.com>
Subject: Re: [PATCH 0/2] Document memory-to-memory video codec interfaces
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>, kamil@wypas.org,
        a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        jtp.park@samsung.com, Philipp Zabel <p.zabel@pengutronix.de>,
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
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 10, 2018 at 6:14 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> Hi Tomasz,
>
> On 07/24/2018 04:06 PM, Tomasz Figa wrote:
> > This series attempts to add the documentation of what was discussed
> > during Media Workshops at LinuxCon Europe 2012 in Barcelona and then
> > later Embedded Linux Conference Europe 2014 in D=C3=BCsseldorf and then
> > eventually written down by Pawel Osciak and tweaked a bit by Chrome OS
> > video team (but mostly in a cosmetic way or making the document more
> > precise), during the several years of Chrome OS using the APIs in
> > production.
> >
> > Note that most, if not all, of the API is already implemented in
> > existing mainline drivers, such as s5p-mfc or mtk-vcodec. Intention of
> > this series is just to formalize what we already have.
> >
> > It is an initial conversion from Google Docs to RST, so formatting is
> > likely to need some further polishing. It is also the first time for me
> > to create such long RST documention. I could not find any other instanc=
e
> > of similar userspace sequence specifications among our Media documents,
> > so I mostly followed what was there in the source. Feel free to suggest
> > a better format.
> >
> > Much of credits should go to Pawel Osciak, for writing most of the
> > original text of the initial RFC.
>
> I'm adding this here as a result of an irc discussion, since it applies
> to both encoders and decoders:
>
> How to handle non-square pixel aspect ratios?
>
> Decoders would have to report it through VIDIOC_CROPCAP, so this needs
> to be documented when the application should call this, but I don't
> think we can provide this information today for encoders.

Thanks for heads up. Will document that VIDIOC_CROPCAP needs to return it.

Best regards,
Tomasz
