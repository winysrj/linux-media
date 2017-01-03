Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f169.google.com ([209.85.161.169]:34763 "EHLO
        mail-yw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757921AbdACK5U (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Jan 2017 05:57:20 -0500
Received: by mail-yw0-f169.google.com with SMTP id t125so285133420ywc.1
        for <linux-media@vger.kernel.org>; Tue, 03 Jan 2017 02:57:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1483347004-32593-2-git-send-email-ayaka@soulik.info>
References: <1483347004-32593-1-git-send-email-ayaka@soulik.info> <1483347004-32593-2-git-send-email-ayaka@soulik.info>
From: Daniel Stone <daniel@fooishbar.org>
Date: Tue, 3 Jan 2017 10:57:19 +0000
Message-ID: <CAPj87rPJh03i3qtNSTn_JRomusoq1CVYjpjsG+85QcRCL2sX9Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] drm_fourcc: Add new P010 video format
To: Randy Li <ayaka@soulik.info>
Cc: dri-devel <dri-devel@lists.freedesktop.org>,
        "Vetter, Daniel" <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Sean Paul <seanpaul@chromium.org>,
        David Airlie <airlied@linux.ie>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        randy.li@rock-chips.com, mchehab@kernel.org,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Randy,

On 2 January 2017 at 09:50, Randy Li <ayaka@soulik.info> wrote:
> P010 is a planar 4:2:0 YUV with interleaved UV plane, 10 bits
> per channel video format. Rockchip's vop support this
> video format(little endian only) as the input video format.
>
> Signed-off-by: Randy Li <ayaka@soulik.info>
> ---
>  include/uapi/drm/drm_fourcc.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/include/uapi/drm/drm_fourcc.h b/include/uapi/drm/drm_fourcc.h
> index 9e1bb7f..d2721da 100644
> --- a/include/uapi/drm/drm_fourcc.h
> +++ b/include/uapi/drm/drm_fourcc.h
> @@ -119,6 +119,7 @@ extern "C" {
>  #define DRM_FORMAT_NV61                fourcc_code('N', 'V', '6', '1') /* 2x1 subsampled Cb:Cr plane */
>  #define DRM_FORMAT_NV24                fourcc_code('N', 'V', '2', '4') /* non-subsampled Cr:Cb plane */
>  #define DRM_FORMAT_NV42                fourcc_code('N', 'V', '4', '2') /* non-subsampled Cb:Cr plane */
> +#define DRM_FORMAT_P010                fourcc_code('P', '0', '1', '0') /* 2x2 subsampled Cr:Cb plane 10 bits per channel */

Thanks, this looks good, but I have two requests. Firstly, the
Microsoft page here also mentions that P016 is a preferred format
along P010, so please add P016 as well:
https://msdn.microsoft.com/en-us/library/windows/desktop/bb970578(v=vs.85).aspx

I don't see much use of the other (P21x/P41x/Yxxx) formats defined
there, so there's probably no use going wild and adding them just yet.

Secondly, please update the format_info table in drm_fourcc.c for
these two formats, to avoid throwing a WARN_ON every time they are
used.

Cheers,
Daniel
