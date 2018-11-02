Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot1-f65.google.com ([209.85.210.65]:36187 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726700AbeKCBgx (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Nov 2018 21:36:53 -0400
Received: by mail-ot1-f65.google.com with SMTP id x4so2206299otg.3
        for <linux-media@vger.kernel.org>; Fri, 02 Nov 2018 09:29:12 -0700 (PDT)
MIME-Version: 1.0
References: <20181005074911.47574-1-hverkuil@xs4all.nl> <20181005074911.47574-8-hverkuil@xs4all.nl>
In-Reply-To: <20181005074911.47574-8-hverkuil@xs4all.nl>
From: Sylwester Nawrocki <sylwester.nawrocki@gmail.com>
Date: Fri, 2 Nov 2018 17:29:00 +0100
Message-ID: <CAB_H8rvec49zb8BNio+brbXFY6eGy9ruPdXeHSWyWyYuhzO_pA@mail.gmail.com>
Subject: Re: [RFC PATCH 07/11] s5p_mfc_dec.c: convert g_crop to g_selection
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
> The g_crop really implemented composition for the CAPTURE stream.
>
> Replace g_crop by g_selection and set the V4L2_FL_QUIRK_INVERTED_CROP
> flag since this is one of the old drivers that predates the selection
> API. Those old drivers allowed g_crop when it really shouldn't have
> since g_crop returns a compose rectangle instead of a crop rectangle.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
