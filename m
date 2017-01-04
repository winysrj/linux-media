Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f179.google.com ([209.85.161.179]:34100 "EHLO
        mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752425AbdADRC7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2017 12:02:59 -0500
Received: by mail-yw0-f179.google.com with SMTP id t125so319588680ywc.1
        for <linux-media@vger.kernel.org>; Wed, 04 Jan 2017 09:02:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1483547351-5792-2-git-send-email-ayaka@soulik.info>
References: <1483547351-5792-1-git-send-email-ayaka@soulik.info> <1483547351-5792-2-git-send-email-ayaka@soulik.info>
From: Daniel Stone <daniel@fooishbar.org>
Date: Wed, 4 Jan 2017 17:02:57 +0000
Message-ID: <CAPj87rPbM2Qm0v8S5++5Qpgv51AWxgTpRoAXaY8-CL2_hCSC6g@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] drm_fourcc: Add new P010, P016 video format
To: Randy Li <ayaka@soulik.info>
Cc: dri-devel <dri-devel@lists.freedesktop.org>,
        =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Li Randy <randy.li@rock-chips.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Vetter, Daniel" <daniel.vetter@intel.com>, mchehab@kernel.org,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Randy,

On 4 January 2017 at 16:29, Randy Li <ayaka@soulik.info> wrote:
> index 90d2cc8..23c8e99 100644
> --- a/drivers/gpu/drm/drm_fourcc.c
> +++ b/drivers/gpu/drm/drm_fourcc.c
> @@ -165,6 +165,9 @@ const struct drm_format_info *__drm_format_info(u32 format)
>                 { .format = DRM_FORMAT_UYVY,            .depth = 0,  .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 2, .vsub = 1 },
>                 { .format = DRM_FORMAT_VYUY,            .depth = 0,  .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 2, .vsub = 1 },
>                 { .format = DRM_FORMAT_AYUV,            .depth = 0,  .num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1 },
> +               /* FIXME a pixel in Y for P010 is 10 bits */
> +               { .format = DRM_FORMAT_P010,            .depth = 0,  .num_planes = 2, .cpp = { 1, 2, 0 }, .hsub = 2, .vsub = 2 },

It seems like P010 stores each Y component in a 16-bit value, with the
bottom 6 bits ignored. So I think cpp here should be 2.

Cheers,
Daniel
