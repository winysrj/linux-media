Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f193.google.com ([209.85.219.193]:45696 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727595AbeIEKOQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Sep 2018 06:14:16 -0400
Received: by mail-yb1-f193.google.com with SMTP id h22-v6so2222906ybg.12
        for <linux-media@vger.kernel.org>; Tue, 04 Sep 2018 22:45:48 -0700 (PDT)
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com. [209.85.219.174])
        by smtp.gmail.com with ESMTPSA id l3-v6sm356254ywd.98.2018.09.04.22.45.47
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Sep 2018 22:45:47 -0700 (PDT)
Received: by mail-yb1-f174.google.com with SMTP id t71-v6so2235983ybi.7
        for <linux-media@vger.kernel.org>; Tue, 04 Sep 2018 22:45:47 -0700 (PDT)
MIME-Version: 1.0
References: <20180724140621.59624-1-tfiga@chromium.org> <20180724140621.59624-2-tfiga@chromium.org>
 <CAPBb6MXT4jiQXfgzq8fpXSQTsdcF0UZLB=RQ6itH5-JZx-27FA@mail.gmail.com>
In-Reply-To: <CAPBb6MXT4jiQXfgzq8fpXSQTsdcF0UZLB=RQ6itH5-JZx-27FA@mail.gmail.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 5 Sep 2018 14:45:35 +0900
Message-ID: <CAAFQd5CALOiC1-8XSrnZxevBmHa=tTM8t37joGz6Fqu_GqgeAg@mail.gmail.com>
Subject: Re: [PATCH 1/2] media: docs-rst: Document memory-to-memory video
 decoder interface
To: Alexandre Courbot <acourbot@chromium.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Pawel Osciak <posciak@chromium.org>, kamil@wypas.org,
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
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 31, 2018 at 5:27 PM Alexandre Courbot <acourbot@chromium.org> wrote:
>
> Hi Tomasz, just a few thoughts I came across while writing the
> stateless codec document:
>
> On Tue, Jul 24, 2018 at 11:06 PM Tomasz Figa <tfiga@chromium.org> wrote:
> [snip]
> > +****************************************
> > +Memory-to-memory Video Decoder Interface
> > +****************************************
>
> Since we have a m2m stateless decoder interface, can we call this the
> m2m video *stateful* decoder interface? :)

I guess it could make sense indeed. Let's wait for some other opinions, if any.

>
> > +Conventions and notation used in this document
> > +==============================================
> [snip]
> > +Glossary
> > +========
>
> I think these sections apply to both stateless and stateful. How about
> moving then into dev-codec.rst and mentioning that they apply to the
> two following sections?

Or maybe we could put them into separate rst files and source them at
the top of each interface documentation? Personally, I'm okay with
either. On a related note, I'd love to see some kind of glossary
lookup on mouse hoover, so that I don't have to scroll back and forth.
:)

Best regards,
Tomasz
