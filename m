Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:33309 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751178AbdCGM0r (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Mar 2017 07:26:47 -0500
Received: by mail-it0-f52.google.com with SMTP id w124so6851735itb.0
        for <linux-media@vger.kernel.org>; Tue, 07 Mar 2017 04:25:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1487268481-6127-1-git-send-email-bgolaszewski@baylibre.com>
References: <1487268481-6127-1-git-send-email-bgolaszewski@baylibre.com>
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date: Tue, 7 Mar 2017 12:50:34 +0100
Message-ID: <CAMpxmJXbJn8oEhB8g_6AsDxZPqDQf7eTnqkUwr_dMP=BNL+q+Q@mail.gmail.com>
Subject: Re: [PATCH] media: vpif: use a configurable i2c_adapter_id for vpif display
To: Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: arm-soc <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org,
        Sekhar Nori <nsekhar@ti.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-02-16 19:08 GMT+01:00 Bartosz Golaszewski <bgolaszewski@baylibre.com>:
> The vpif display driver uses a static i2c adapter ID of 1 but on the
> da850-evm board in DT boot mode the i2c adapter ID is actually 0.
>
> Make the adapter ID configurable like it already is for vpif capture.
>
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> Acked-by: Kevin Hilman <khilman@baylibre.com>
> ---

Hi Mauro, Prabhakar,

can we get an ack on this? Sekhar already merged the rest of the
patches that need this to make vpif display work on the da850-evm
board. I think it's best if it goes through his tree.

Thanks,
Bartosz
