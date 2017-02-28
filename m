Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:33870 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751135AbdB1SOa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Feb 2017 13:14:30 -0500
Received: by mail-io0-f176.google.com with SMTP id 90so14970708ios.1
        for <linux-media@vger.kernel.org>; Tue, 28 Feb 2017 10:13:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1487770071-5157-1-git-send-email-bgolaszewski@baylibre.com>
References: <1487770071-5157-1-git-send-email-bgolaszewski@baylibre.com>
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date: Tue, 28 Feb 2017 17:21:10 +0100
Message-ID: <CAMpxmJU=CBxRPcK0jgbktdPJZtbdbviE_sphFSBdTjfvaYtYDg@mail.gmail.com>
Subject: Re: [PATCH] media: vpif: request enable-gpios
To: Sekhar Nori <nsekhar@ti.com>, Kevin Hilman <khilman@baylibre.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Russell King <linux@armlinux.org.uk>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: arm-soc <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-02-22 14:27 GMT+01:00 Bartosz Golaszewski <bgolaszewski@baylibre.com>:
> This change is needed to make vpif capture work on the da850-evm board
> where the capture function must be selected on the UI expander.
>
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> ---
>  drivers/media/platform/davinci/vpif_capture.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>

Disregard this patch - we need to determine a better solution for this
functionality.

Thanks,
Bartosz
