Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi1-f194.google.com ([209.85.167.194]:42334 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbeKCBt5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Nov 2018 21:49:57 -0400
Received: by mail-oi1-f194.google.com with SMTP id h23-v6so2076164oih.9
        for <linux-media@vger.kernel.org>; Fri, 02 Nov 2018 09:42:13 -0700 (PDT)
MIME-Version: 1.0
References: <20181005074911.47574-1-hverkuil@xs4all.nl> <20181005074911.47574-11-hverkuil@xs4all.nl>
In-Reply-To: <20181005074911.47574-11-hverkuil@xs4all.nl>
From: Sylwester Nawrocki <sylwester.nawrocki@gmail.com>
Date: Fri, 2 Nov 2018 17:42:01 +0100
Message-ID: <CAB_H8rudia6fCQfVekjjwTt4M=cw1C7qEKmokWiwvG-5Nj_tkw@mail.gmail.com>
Subject: Re: [RFC PATCH 10/11] v4l2-ioctl: remove unused vidioc_g/s_crop
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
> Now that all drivers have dropped vidioc_g/s_crop we can remove
> support for them in the V4L2 core.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
