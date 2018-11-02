Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi1-f195.google.com ([209.85.167.195]:35921 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbeKCBZz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Nov 2018 21:25:55 -0400
Received: by mail-oi1-f195.google.com with SMTP id r127-v6so2035586oie.3
        for <linux-media@vger.kernel.org>; Fri, 02 Nov 2018 09:18:17 -0700 (PDT)
MIME-Version: 1.0
References: <20181005074911.47574-1-hverkuil@xs4all.nl> <20181005074911.47574-4-hverkuil@xs4all.nl>
In-Reply-To: <20181005074911.47574-4-hverkuil@xs4all.nl>
From: Sylwester Nawrocki <sylwester.nawrocki@gmail.com>
Date: Fri, 2 Nov 2018 17:18:06 +0100
Message-ID: <CAB_H8rsVrpnK26KXJTBr_sSMD-8D0poGDSO2y4nZM_ngHYOtyw@mail.gmail.com>
Subject: Re: [RFC PATCH 03/11] v4l2-ioctl: add QUIRK_INVERTED_CROP
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, niklas.soderlund+renesas@ragnatech.se,
        tfiga@chromium.org, Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 5 Oct 2018 at 09:49, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Some old Samsung drivers use the legacy crop API incorrectly:
> the crop and compose targets are swapped. Normally VIDIOC_G_CROP
> will return the CROP rectangle of a CAPTURE stream and the COMPOSE
> rectangle of an OUTPUT stream.
>
> The Samsung drivers do the opposite. Note that these drivers predate
> the selection API.
>
> If this 'QUIRK' flag is set, then the v4l2-ioctl core will swap
> the CROP and COMPOSE targets as well.
>
> That way backwards compatibility is ensured and we can convert the
> Samsung drivers to the selection API.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
