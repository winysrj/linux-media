Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:46529 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751405AbdK3T7Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Nov 2017 14:59:16 -0500
Received: by mail-wm0-f66.google.com with SMTP id r78so15325673wme.5
        for <linux-media@vger.kernel.org>; Thu, 30 Nov 2017 11:59:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <a62cc016ab4e397cd822d80967dd840c7dc40d40.1511952403.git.mchehab@s-opensource.com>
References: <c73fcbc4af259923feac19eda4bb5e996b6de0fd.1511952403.git.mchehab@s-opensource.com>
 <a62cc016ab4e397cd822d80967dd840c7dc40d40.1511952403.git.mchehab@s-opensource.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Thu, 30 Nov 2017 19:58:44 +0000
Message-ID: <CA+V-a8tQ8DvEBpHzMJwr-V4FcU+FrV3ofML-FmL_3mbNpGVo=A@mail.gmail.com>
Subject: Re: [PATCH 4/7] media: davinci: fix kernel-doc warnings
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HI Mauro,

Thanks for the patch.

On Wed, Nov 29, 2017 at 12:08 PM, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
> There are several of kernel-doc warnings:
>
>     drivers/media/platform/davinci/vpif_display.c:114: warning: No description found for parameter 'sizes'
>     drivers/media/platform/davinci/vpif_display.c:165: warning: No description found for parameter 'vq'
>     drivers/media/platform/davinci/vpif_display.c:165: warning: Excess function parameter 'vb' description in 'vpif_start_streaming'
>     drivers/media/platform/davinci/vpif_display.c:780: warning: No description found for parameter 'vpif_cfg'
>     drivers/media/platform/davinci/vpif_display.c:780: warning: No description found for parameter 'chan_cfg'
>     drivers/media/platform/davinci/vpif_display.c:780: warning: No description found for parameter 'index'
>     drivers/media/platform/davinci/vpif_display.c:813: warning: No description found for parameter 'vpif_cfg'
>     drivers/media/platform/davinci/vpif_display.c:813: warning: No description found for parameter 'ch'
>     drivers/media/platform/davinci/vpif_display.c:813: warning: No description found for parameter 'index'
>     drivers/media/platform/davinci/vpif_capture.c:121: warning: No description found for parameter 'sizes'
>     drivers/media/platform/davinci/vpif_capture.c:174: warning: No description found for parameter 'vq'
>     drivers/media/platform/davinci/vpif_capture.c:174: warning: Excess function parameter 'vb' description in 'vpif_start_streaming'
>     drivers/media/platform/davinci/vpif_capture.c:636: warning: No description found for parameter 'iface'
>     drivers/media/platform/davinci/vpif_capture.c:647: warning: No description found for parameter 'ch'
>     drivers/media/platform/davinci/vpif_capture.c:647: warning: No description found for parameter 'muxmode'
>     drivers/media/platform/davinci/vpif_capture.c:676: warning: No description found for parameter 'vpif_cfg'
>     drivers/media/platform/davinci/vpif_capture.c:676: warning: No description found for parameter 'chan_cfg'
>     drivers/media/platform/davinci/vpif_capture.c:676: warning: No description found for parameter 'input_index'
>     drivers/media/platform/davinci/vpif_capture.c:712: warning: No description found for parameter 'vpif_cfg'
>     drivers/media/platform/davinci/vpif_capture.c:712: warning: No description found for parameter 'ch'
>     drivers/media/platform/davinci/vpif_capture.c:712: warning: No description found for parameter 'index'
>     drivers/media/platform/davinci/vpif_capture.c:798: warning: No description found for parameter 'std'
>     drivers/media/platform/davinci/vpif_capture.c:798: warning: Excess function parameter 'std_id' description in 'vpif_g_std'
>     drivers/media/platform/davinci/vpif_capture.c:940: warning: No description found for parameter 'fmt'
>     drivers/media/platform/davinci/vpif_capture.c:940: warning: Excess function parameter 'index' description in 'vpif_enum_fmt_vid_cap'
>     drivers/media/platform/davinci/vpif_capture.c:1750: warning: No description found for parameter 'dev'
>
> Fix them.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/platform/davinci/vpif_capture.c | 27 ++++++++++++++-------------
>  drivers/media/platform/davinci/vpif_display.c | 16 ++++++++--------
>  2 files changed, 22 insertions(+), 21 deletions(-)
>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad
