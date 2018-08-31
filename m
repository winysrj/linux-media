Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:35801 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727202AbeHaMd3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Aug 2018 08:33:29 -0400
Received: by mail-it0-f45.google.com with SMTP id 139-v6so6222331itf.0
        for <linux-media@vger.kernel.org>; Fri, 31 Aug 2018 01:27:09 -0700 (PDT)
Received: from mail-io0-f170.google.com (mail-io0-f170.google.com. [209.85.223.170])
        by smtp.gmail.com with ESMTPSA id n140-v6sm2048903itb.37.2018.08.31.01.27.08
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 Aug 2018 01:27:08 -0700 (PDT)
Received: by mail-io0-f170.google.com with SMTP id 75-v6so9763915iou.11
        for <linux-media@vger.kernel.org>; Fri, 31 Aug 2018 01:27:08 -0700 (PDT)
MIME-Version: 1.0
References: <20180724140621.59624-1-tfiga@chromium.org> <20180724140621.59624-2-tfiga@chromium.org>
In-Reply-To: <20180724140621.59624-2-tfiga@chromium.org>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Fri, 31 Aug 2018 17:26:56 +0900
Message-ID: <CAPBb6MXT4jiQXfgzq8fpXSQTsdcF0UZLB=RQ6itH5-JZx-27FA@mail.gmail.com>
Subject: Re: [PATCH 1/2] media: docs-rst: Document memory-to-memory video
 decoder interface
To: Tomasz Figa <tfiga@chromium.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Pawel Osciak <posciak@chromium.org>, kamil@wypas.org,
        a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        jtp.park@samsung.com, p.zabel@pengutronix.de,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        andrew-ct.chen@mediatek.com, todor.tomov@linaro.org,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dave.stevenson@raspberrypi.org, ezequiel@collabora.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz, just a few thoughts I came across while writing the
stateless codec document:

On Tue, Jul 24, 2018 at 11:06 PM Tomasz Figa <tfiga@chromium.org> wrote:
[snip]
> +****************************************
> +Memory-to-memory Video Decoder Interface
> +****************************************

Since we have a m2m stateless decoder interface, can we call this the
m2m video *stateful* decoder interface? :)

> +Conventions and notation used in this document
> +==============================================
[snip]
> +Glossary
> +========

I think these sections apply to both stateless and stateful. How about
moving then into dev-codec.rst and mentioning that they apply to the
two following sections?
