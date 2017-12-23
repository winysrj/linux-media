Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:37093 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757086AbdLWP6d (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Dec 2017 10:58:33 -0500
Received: by mail-wr0-f194.google.com with SMTP id f8so19422500wre.4
        for <linux-media@vger.kernel.org>; Sat, 23 Dec 2017 07:58:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <68e5073e-bc9e-ddeb-edf0-21938d63f34a@maciej.szmigiero.name>
References: <cover.1513982691.git.mail@maciej.szmigiero.name> <68e5073e-bc9e-ddeb-edf0-21938d63f34a@maciej.szmigiero.name>
From: Philippe Ombredanne <pombredanne@nexb.com>
Date: Sat, 23 Dec 2017 16:57:51 +0100
Message-ID: <CAOFm3uE38UikJ=qP9TCa8Vpe2O7Z-qRWqE_11Ap7YFY75+FGug@mail.gmail.com>
Subject: Re: [PATCH v5 6/6] [media] cxusb: add analog mode support for Medion MD95700
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andy Walls <awalls@md.metrocast.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Dec 23, 2017 at 12:19 AM, Maciej S. Szmigiero
<mail@maciej.szmigiero.name> wrote:
> This patch adds support for analog part of Medion 95700 in the cxusb
> driver.
>
> What works:
> * Video capture at various sizes with sequential fields,
> * Input switching (TV Tuner, Composite, S-Video),
> * TV and radio tuning,
> * Video standard switching and auto detection,
> * Radio mode switching (stereo / mono),
> * Unplugging while capturing,
> * DVB / analog coexistence,
> * Raw BT.656 stream support.
>
> What does not work yet:
> * Audio,
> * VBI,
> * Picture controls.
>
> Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
> ---
>  drivers/media/usb/dvb-usb/Kconfig        |   16 +-
>  drivers/media/usb/dvb-usb/Makefile       |    3 +
>  drivers/media/usb/dvb-usb/cxusb-analog.c | 1914 ++++++++++++++++++++++++++++++
>  drivers/media/usb/dvb-usb/cxusb.c        |    2 -
>  drivers/media/usb/dvb-usb/cxusb.h        |  106 ++
>  5 files changed, 2037 insertions(+), 4 deletions(-)
>  create mode 100644 drivers/media/usb/dvb-usb/cxusb-analog.c

<snip>

> index 000000000000..969d82b24f41
> --- /dev/null
> +++ b/drivers/media/usb/dvb-usb/cxusb-analog.c
> @@ -0,0 +1,1914 @@
> +// SPDX-License-Identifier: GPL-2.0+

Thanks! For the SPDX tags usage:

Acked-by: Philippe Ombredanne <pombredanne@nexb.com>
