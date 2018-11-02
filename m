Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f193.google.com ([209.85.219.193]:35314 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbeKBXME (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Nov 2018 19:12:04 -0400
Received: by mail-yb1-f193.google.com with SMTP id z2-v6so839226ybj.2
        for <linux-media@vger.kernel.org>; Fri, 02 Nov 2018 07:04:49 -0700 (PDT)
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com. [209.85.219.178])
        by smtp.gmail.com with ESMTPSA id z11-v6sm11371623ywl.36.2018.11.02.07.04.46
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Nov 2018 07:04:47 -0700 (PDT)
Received: by mail-yb1-f178.google.com with SMTP id p144-v6so819950yba.11
        for <linux-media@vger.kernel.org>; Fri, 02 Nov 2018 07:04:46 -0700 (PDT)
MIME-Version: 1.0
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
 <1540851790-1777-4-git-send-email-yong.zhi@intel.com> <20181102104908.609177e5@coco.lan>
In-Reply-To: <20181102104908.609177e5@coco.lan>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 2 Nov 2018 23:04:33 +0900
Message-ID: <CAAFQd5B_OVV-Nh0uOGHdQE4eSKcs5N8Nn1t-Zz-GbvgpB9P38A@mail.gmail.com>
Subject: Re: [PATCH v7 03/16] v4l: Add Intel IPU3 meta data uAPI
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Yong Zhi <yong.zhi@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        Cao Bing Bu <bingbu.cao@intel.com>, chao.c.li@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Fri, Nov 2, 2018 at 10:49 PM Mauro Carvalho Chehab
<mchehab+samsung@kernel.org> wrote:
>
> Em Mon, 29 Oct 2018 15:22:57 -0700
> Yong Zhi <yong.zhi@intel.com> escreveu:
[snip]
> > +struct ipu3_uapi_awb_config_s {
> > +     __u16 rgbs_thr_gr;
> > +     __u16 rgbs_thr_r;
> > +     __u16 rgbs_thr_gb;
> > +     __u16 rgbs_thr_b;
> > +     struct ipu3_uapi_grid_config grid;
> > +} __attribute__((aligned(32))) __packed;
>
> Hmm... Kernel defines a macro for aligned attribute:
>
>         include/linux/compiler_types.h:#define __aligned(x)             __attribute__((aligned(x)))
>

First, thanks for review!

Maybe I missed something, but last time I checked, it wasn't
accessible from UAPI headers in userspace.

> I'm not a gcc expert, but it sounds weird to first ask it to align
> with 32 bits and then have __packed (with means that pads should be
> removed).
>
> In other words, I *guess* is it should either be __packed
> or __aligned(32).
>
> Not that it would do any difference, in practice, as this
> specific struct has a size with is multiple of 32 bits, but
> let's do the right annotation here, not mixing two incompatible
> alignment requirements.
>

My understanding was that __packed makes the compiler not insert any
alignment between particular fields of the struct, while __aligned
makes the whole struct be aligned at given boundary, if placed in
another struct. If I didn't miss anything, having both should make
perfect sense here.

Best regards,
Tomasz
