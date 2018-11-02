Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi1-f194.google.com ([209.85.167.194]:41005 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727465AbeKCBlR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Nov 2018 21:41:17 -0400
Received: by mail-oi1-f194.google.com with SMTP id y192-v6so2055260oie.8
        for <linux-media@vger.kernel.org>; Fri, 02 Nov 2018 09:33:35 -0700 (PDT)
MIME-Version: 1.0
References: <20181005074911.47574-1-hverkuil@xs4all.nl> <20181005074911.47574-10-hverkuil@xs4all.nl>
In-Reply-To: <20181005074911.47574-10-hverkuil@xs4all.nl>
From: Sylwester Nawrocki <sylwester.nawrocki@gmail.com>
Date: Fri, 2 Nov 2018 17:33:24 +0100
Message-ID: <CAB_H8ruTQGSjqxfmLeQoF9Ue4Ve9L9oECMzKnt5h=HK4bOko=w@mail.gmail.com>
Subject: Re: [RFC PATCH 09/11] s5p-g2d: convert g/s_crop to g/s_selection
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
> Replace g/s_crop by g/s_selection and set the V4L2_FL_QUIRK_INVERTED_CROP
> flag since this is one of the old drivers that predates the selection
> API. Those old drivers allowed g_crop when it really shouldn't have since
> g_crop returns a compose rectangle instead of a crop rectangle for the
> CAPTURE stream, and vice versa for the OUTPUT stream.
>
> Also drop the now unused vidioc_cropcap.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
