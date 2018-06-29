Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:42805 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754566AbeF2Rkv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 13:40:51 -0400
Received: by mail-pg0-f65.google.com with SMTP id c10-v6so4290619pgu.9
        for <linux-media@vger.kernel.org>; Fri, 29 Jun 2018 10:40:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180629114331.7617-6-hverkuil@xs4all.nl>
References: <20180629114331.7617-1-hverkuil@xs4all.nl> <20180629114331.7617-6-hverkuil@xs4all.nl>
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Date: Fri, 29 Jun 2018 14:40:49 -0300
Message-ID: <CAAEAJfAmHZD2sjw9NF2Fyv6j+Z-usKJL4YNG5pgfZuyBSqLZkQ@mail.gmail.com>
Subject: Re: [PATCHv5 05/12] media: rename MEDIA_ENT_F_DTV_DECODER to MEDIA_ENT_F_DV_DECODER
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
        Hans Verkuil <hansverk@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 29 June 2018 at 08:43, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hansverk@cisco.com>
>
> The use of 'DTV' is very confusing since it normally refers to Digital
> TV e.g. DVB etc.
>
> Instead use 'DV' (Digital Video), which nicely corresponds to the
> DV Timings API used to configure such receivers and transmitters.
>
> We keep an alias to avoid breaking userspace applications.
>
> Signed-off-by: Hans Verkuil <hansverk@cisco.com>
> ---
>  Documentation/media/uapi/mediactl/media-types.rst | 2 +-
>  drivers/media/i2c/adv7604.c                       | 1 +
>  drivers/media/i2c/adv7842.c                       | 1 +

It would be nice to mention in the commit log
that this patch also sets the function for these drivers.

Regards,
--=20
Ezequiel Garc=C3=ADa, VanguardiaSur
www.vanguardiasur.com.ar
