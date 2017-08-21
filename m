Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:37965 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751814AbdHUKDM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Aug 2017 06:03:12 -0400
MIME-Version: 1.0
In-Reply-To: <1502614485-2150-4-git-send-email-arvind.yadav.cs@gmail.com>
References: <1502614485-2150-1-git-send-email-arvind.yadav.cs@gmail.com> <1502614485-2150-4-git-send-email-arvind.yadav.cs@gmail.com>
From: Alexey Klimov <klimov.linux@gmail.com>
Date: Mon, 21 Aug 2017 11:03:11 +0100
Message-ID: <CALW4P+JFdde5_KYNNEB+VaNJd_jB2pqXHt6bMoMaTfh+qjHyhA@mail.gmail.com>
Subject: Re: [PATCH 3/3] [media] radio: constify usb_device_id
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: Antti Palosaari <crope@iki.fi>, mchehab@kernel.org,
        ezequiel@vanguardiasur.com.ar,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        royale@zerezo.com, sean@mess.org,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arvind,

thanks for the patch!

On Sun, Aug 13, 2017 at 9:54 AM, Arvind Yadav <arvind.yadav.cs@gmail.com> wrote:
> usb_device_id are not supposed to change at runtime. All functions
> working with usb_device_id provided by <linux/usb.h> work with
> const usb_device_id. So mark the non-const structs as const.
>
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>

For dsbr100, radio-mr800 and radio-ma901 please feel free to use:

Acked-by: Alexey Klimov <klimov.linux@gmail.com>


> ---
>  drivers/media/radio/dsbr100.c                 | 2 +-
>  drivers/media/radio/radio-keene.c             | 2 +-
>  drivers/media/radio/radio-ma901.c             | 2 +-
>  drivers/media/radio/radio-mr800.c             | 2 +-
>  drivers/media/radio/radio-raremono.c          | 2 +-
>  drivers/media/radio/radio-shark.c             | 2 +-
>  drivers/media/radio/radio-shark2.c            | 2 +-
>  drivers/media/radio/si470x/radio-si470x-usb.c | 2 +-
>  drivers/media/radio/si4713/radio-usb-si4713.c | 2 +-
>  9 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/media/radio/dsbr100.c b/drivers/media/radio/dsbr100.c
> index 53bc8c0..8521bb2 100644


[...]

Best regards,
Alexey
