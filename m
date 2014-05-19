Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f49.google.com ([209.85.192.49]:32777 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbaESLSJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 May 2014 07:18:09 -0400
Received: by mail-qg0-f49.google.com with SMTP id a108so8365342qge.22
        for <linux-media@vger.kernel.org>; Mon, 19 May 2014 04:18:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1400241824-18260-2-git-send-email-k.debski@samsung.com>
References: <1400241824-18260-1-git-send-email-k.debski@samsung.com>
	<1400241824-18260-2-git-send-email-k.debski@samsung.com>
Date: Mon, 19 May 2014 16:48:08 +0530
Message-ID: <CALt3h78q4sk5imcwfXXcdFKh9PMA+uYGd6p_pkgEzQ5OdL_Vog@mail.gmail.com>
Subject: Re: [PATCH 2/2] v4l: s5p-mfc: Limit enum_fmt to output formats of
 current version
From: Arun Kumar K <arun.kk@samsung.com>
To: Kamil Debski <k.debski@samsung.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

Only a small correction.

On Fri, May 16, 2014 at 5:33 PM, Kamil Debski <k.debski@samsung.com> wrote:
> MFC versions support a different set of formats, this specially applies
> to the raw YUV formats. This patch changes enum_fmt, so that it only
> reports formats that are supported by the used MFC version.
>
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc.c        |    3 ++
>  drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    7 ++++
>  drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    |   49 +++++++++++++---------
>  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |   50 ++++++++++++-----------
>  4 files changed, 67 insertions(+), 42 deletions(-)
>

[snip]

> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> index d09c2e1..1ddd152 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> @@ -42,6 +42,7 @@ static struct s5p_mfc_fmt formats[] = {
>                 .codec_mode     = S5P_MFC_CODEC_NONE,
>                 .type           = MFC_FMT_RAW,
>                 .num_planes     = 2,
> +               .versions       = MFC_V6 | MFC_V7,
>         },
>         {
>                 .name           = "4:2:0 2 Planes 64x32 Tiles",
> @@ -49,6 +50,7 @@ static struct s5p_mfc_fmt formats[] = {
>                 .codec_mode     = S5P_MFC_CODEC_NONE,
>                 .type           = MFC_FMT_RAW,
>                 .num_planes     = 2,
> +               .versions       = MFC_V5,
>         },
>         {
>                 .name           = "4:2:0 2 Planes Y/CbCr",
> @@ -56,6 +58,7 @@ static struct s5p_mfc_fmt formats[] = {
>                 .codec_mode     = S5P_MFC_CODEC_NONE,
>                 .type           = MFC_FMT_RAW,
>                 .num_planes     = 2,
> +               .versions       = MFC_V5 | MFC_V6 | MFC_V7,
>         },
>         {
>                 .name           = "4:2:0 2 Planes Y/CrCb",
> @@ -63,6 +66,7 @@ static struct s5p_mfc_fmt formats[] = {
>                 .codec_mode     = S5P_MFC_CODEC_NONE,
>                 .type           = MFC_FMT_RAW,
>                 .num_planes     = 2,
> +               .versions       = MFC_V5 | MFC_V6 | MFC_V7,
>         },
>         {
>                 .name           = "H264 Encoded Stream",
> @@ -70,6 +74,7 @@ static struct s5p_mfc_fmt formats[] = {
>                 .codec_mode     = S5P_MFC_CODEC_H264_ENC,
>                 .type           = MFC_FMT_ENC,
>                 .num_planes     = 1,
> +               .versions       = MFC_V5 | MFC_V6 | MFC_V7,
>         },
>         {
>                 .name           = "MPEG4 Encoded Stream",
> @@ -77,6 +82,7 @@ static struct s5p_mfc_fmt formats[] = {
>                 .codec_mode     = S5P_MFC_CODEC_MPEG4_ENC,
>                 .type           = MFC_FMT_ENC,
>                 .num_planes     = 1,
> +               .versions       = MFC_V5 | MFC_V6 | MFC_V7,
>         },
>         {
>                 .name           = "H263 Encoded Stream",
> @@ -84,6 +90,7 @@ static struct s5p_mfc_fmt formats[] = {
>                 .codec_mode     = S5P_MFC_CODEC_H263_ENC,
>                 .type           = MFC_FMT_ENC,
>                 .num_planes     = 1,
> +               .versions       = MFC_V5 | MFC_V6 | MFC_V7,
>         },
>         {
>                 .name           = "VP8 Encoded Stream",
> @@ -91,6 +98,7 @@ static struct s5p_mfc_fmt formats[] = {
>                 .codec_mode     = S5P_MFC_CODEC_VP8_ENC,
>                 .type           = MFC_FMT_ENC,
>                 .num_planes     = 1,
> +               .versions       = MFC_V6 | MFC_V7,

VP8 encodig is supported only from v7 onwards.
So you can remove MFC_V6 from this.

Otherwise looks good to me.

Regards
Arun
