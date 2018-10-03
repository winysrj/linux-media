Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f194.google.com ([209.85.208.194]:38816 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbeJCN4F (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 3 Oct 2018 09:56:05 -0400
Received: by mail-lj1-f194.google.com with SMTP id v7-v6so3633495ljg.5
        for <linux-media@vger.kernel.org>; Wed, 03 Oct 2018 00:08:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20181003070656.193854-1-keiichiw@chromium.org>
References: <20181003070656.193854-1-keiichiw@chromium.org>
From: Keiichi Watanabe <keiichiw@chromium.org>
Date: Wed, 3 Oct 2018 16:08:58 +0900
Message-ID: <CAD90VcbBUcpwLsY0sHim+mML6esSjZA2ocX0Ff-YiZxBsLTZ+w@mail.gmail.com>
Subject: Re: [PATCH] media: vivid: Support 480p for webcam capture
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Ricky Liang <jcliang@chromium.org>,
        Shik Chen <shik@chromium.org>,
        Keiichi Watanabe <keiichiw@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I think 480p is a common frame size and it's worth supporting in vivid.
But, my patch might be ad-hoc. Actually, I'm not sure which values are
suitable for the intervals.

We might want to add a more flexible/extensible way to specify frame sizes.
e.g. passing frame sizes and intervals as module parameters

Kei

On Wed, Oct 3, 2018 at 4:06 PM, Keiichi Watanabe <keiichiw@chromium.org> wrote:
> Support 640x480 as a frame size for video input devices of vivid.
>
> Signed-off-by: Keiichi Watanabe <keiichiw@chromium.org>
> ---
>  drivers/media/platform/vivid/vivid-vid-cap.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
> index 58e14dd1dcd3..da80bf4bc365 100644
> --- a/drivers/media/platform/vivid/vivid-vid-cap.c
> +++ b/drivers/media/platform/vivid/vivid-vid-cap.c
> @@ -51,7 +51,7 @@ static const struct vivid_fmt formats_ovl[] = {
>  };
>
>  /* The number of discrete webcam framesizes */
> -#define VIVID_WEBCAM_SIZES 5
> +#define VIVID_WEBCAM_SIZES 6
>  /* The number of discrete webcam frameintervals */
>  #define VIVID_WEBCAM_IVALS (VIVID_WEBCAM_SIZES * 2)
>
> @@ -59,6 +59,7 @@ static const struct vivid_fmt formats_ovl[] = {
>  static const struct v4l2_frmsize_discrete webcam_sizes[VIVID_WEBCAM_SIZES] = {
>         {  320, 180 },
>         {  640, 360 },
> +       {  640, 480 },
>         { 1280, 720 },
>         { 1920, 1080 },
>         { 3840, 2160 },
> @@ -75,6 +76,8 @@ static const struct v4l2_fract webcam_intervals[VIVID_WEBCAM_IVALS] = {
>         {  1, 5 },
>         {  1, 10 },
>         {  1, 15 },
> +       {  1, 15 },
> +       {  1, 25 },
>         {  1, 25 },
>         {  1, 30 },
>         {  1, 50 },
> --
> 2.19.0.605.g01d371f741-goog
>
