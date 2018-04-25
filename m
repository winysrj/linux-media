Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f68.google.com ([209.85.213.68]:45990 "EHLO
        mail-vk0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751602AbeDYJMH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Apr 2018 05:12:07 -0400
Received: by mail-vk0-f68.google.com with SMTP id 203so13386439vka.12
        for <linux-media@vger.kernel.org>; Wed, 25 Apr 2018 02:12:06 -0700 (PDT)
Received: from mail-vk0-f53.google.com (mail-vk0-f53.google.com. [209.85.213.53])
        by smtp.gmail.com with ESMTPSA id 52sm206908uat.28.2018.04.25.02.12.04
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Apr 2018 02:12:05 -0700 (PDT)
Received: by mail-vk0-f53.google.com with SMTP id q189so13399672vkb.0
        for <linux-media@vger.kernel.org>; Wed, 25 Apr 2018 02:12:04 -0700 (PDT)
MIME-Version: 1.0
References: <1522376100-22098-1-git-send-email-yong.zhi@intel.com> <1522376100-22098-8-git-send-email-yong.zhi@intel.com>
In-Reply-To: <1522376100-22098-8-git-send-email-yong.zhi@intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 25 Apr 2018 09:11:53 +0000
Message-ID: <CAAFQd5DL06QZc+fkN1uqcUNWjTf-miK_Do6cCybusdkm6pZqmg@mail.gmail.com>
Subject: Re: [PATCH v6 07/12] intel-ipu3: css: Add static settings for image pipeline
To: Yong Zhi <yong.zhi@intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

On Fri, Mar 30, 2018 at 11:15 AM Yong Zhi <yong.zhi@intel.com> wrote:

> This adds coeff, config parameters etc const definitions for
> IPU3 programming.

> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> ---
>   drivers/media/pci/intel/ipu3/ipu3-tables.c | 9609
++++++++++++++++++++++++++++
>   drivers/media/pci/intel/ipu3/ipu3-tables.h |   66 +
>   2 files changed, 9675 insertions(+)
>   create mode 100644 drivers/media/pci/intel/ipu3/ipu3-tables.c
>   create mode 100644 drivers/media/pci/intel/ipu3/ipu3-tables.h

I believe none of the 6 revisions of this patch actually reached the
mailing lists. It's too big. Could we do something about it? Splitting into
smaller patches might help, but we should provide a link in cover letter to
a public git branch where the whole series can be found applied to current
Linux.

Best regards,
Tomasz
