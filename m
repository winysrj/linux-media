Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:47006 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731064AbeGRPbz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Jul 2018 11:31:55 -0400
Received: by mail-yb0-f194.google.com with SMTP id c3-v6so1935398ybi.13
        for <linux-media@vger.kernel.org>; Wed, 18 Jul 2018 07:53:38 -0700 (PDT)
Received: from mail-yb0-f180.google.com (mail-yb0-f180.google.com. [209.85.213.180])
        by smtp.gmail.com with ESMTPSA id j83-v6sm3298021ywg.96.2018.07.18.07.53.35
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Jul 2018 07:53:36 -0700 (PDT)
Received: by mail-yb0-f180.google.com with SMTP id x10-v6so1937067ybl.10
        for <linux-media@vger.kernel.org>; Wed, 18 Jul 2018 07:53:35 -0700 (PDT)
MIME-Version: 1.0
References: <1529033373-15724-1-git-send-email-yong.zhi@intel.com> <1529033373-15724-3-git-send-email-yong.zhi@intel.com>
In-Reply-To: <1529033373-15724-3-git-send-email-yong.zhi@intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 18 Jul 2018 23:53:22 +0900
Message-ID: <CAAFQd5AH3voHmJq3h1AqULJTFWH=BTWmB76k7f78q9FHaDMXfg@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] v4l: Document Intel IPU3 meta data uAPI
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Yong Zhi <yong.zhi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>, chao.c.li@intel.com,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro, Hans,

On Fri, Jun 15, 2018 at 12:30 PM Yong Zhi <yong.zhi@intel.com> wrote:
>
> These meta formats are used on Intel IPU3 ImgU video queues
> to carry 3A statistics and ISP pipeline parameters.
>
> V4L2_META_FMT_IPU3_3A
> V4L2_META_FMT_IPU3_PARAMS
>
> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> Signed-off-by: Chao C Li <chao.c.li@intel.com>
> Signed-off-by: Rajmohan Mani <rajmohan.mani@intel.com>
> ---
>  Documentation/media/uapi/v4l/meta-formats.rst      |    1 +
>  .../media/uapi/v4l/pixfmt-meta-intel-ipu3.rst      |  174 ++
>  include/uapi/linux/intel-ipu3.h                    | 2816 ++++++++++++++++++++

The documentation seems to be quite extensive in current version. Do
you think it's more acceptable now? Would you be able to take a look?

We obviously need to keep working on the user space framework (and
we're in process of figuring out how we can proceed further), but
having the driver bit-rotting downstream might not be a very
encouraging factor. ;)

Best regards,
Tomasz
