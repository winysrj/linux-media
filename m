Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi1-f193.google.com ([209.85.167.193]:34595 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726707AbeKCB00 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Nov 2018 21:26:26 -0400
Received: by mail-oi1-f193.google.com with SMTP id f21-v6so2050283oig.1
        for <linux-media@vger.kernel.org>; Fri, 02 Nov 2018 09:18:48 -0700 (PDT)
MIME-Version: 1.0
References: <20181005074911.47574-1-hverkuil@xs4all.nl> <20181005074911.47574-7-hverkuil@xs4all.nl>
In-Reply-To: <20181005074911.47574-7-hverkuil@xs4all.nl>
From: Sylwester Nawrocki <sylwester.nawrocki@gmail.com>
Date: Fri, 2 Nov 2018 17:18:36 +0100
Message-ID: <CAB_H8rsBO8fUSACxvLj+APJpSbZMoPHaE+OWPZV4hBSy-o6crQ@mail.gmail.com>
Subject: Re: [RFC PATCH 06/11] exynos-gsc: replace v4l2_crop by v4l2_selection
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
> Replace the use of struct v4l2_crop by struct v4l2_selection.
> Also drop the unused gsc_g_crop function.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
