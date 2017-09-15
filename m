Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f180.google.com ([209.85.161.180]:44413 "EHLO
        mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750838AbdIOHOk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 03:14:40 -0400
Received: by mail-yw0-f180.google.com with SMTP id r85so953506ywg.1
        for <linux-media@vger.kernel.org>; Fri, 15 Sep 2017 00:14:40 -0700 (PDT)
Received: from mail-yw0-f172.google.com (mail-yw0-f172.google.com. [209.85.161.172])
        by smtp.gmail.com with ESMTPSA id b123sm86738ywa.45.2017.09.15.00.14.37
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Sep 2017 00:14:38 -0700 (PDT)
Received: by mail-yw0-f172.google.com with SMTP id u11so340269ywh.7
        for <linux-media@vger.kernel.org>; Fri, 15 Sep 2017 00:14:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1505342325-9180-1-git-send-email-chiranjeevi.rapolu@intel.com>
References: <1505342325-9180-1-git-send-email-chiranjeevi.rapolu@intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 15 Sep 2017 16:14:17 +0900
Message-ID: <CAAFQd5DOdQfS0Vj0SZ0PG+7dWpObca-5LS7amO0t-k4QyAcFSQ@mail.gmail.com>
Subject: Re: [PATCH v1] media: ov13858: Fix 4224x3136 video flickering at some vblanks
To: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Yeh, Andy" <andy.yeh@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Yang, Hyungwoo" <hyungwoo.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chiranjeevi,

On Thu, Sep 14, 2017 at 7:38 AM, Chiranjeevi Rapolu
<chiranjeevi.rapolu@intel.com> wrote:
> Previously, the sensor was outputting blank every other frame at 4224x3136
> video when vblank was in the range [79, 86]. This resulted in video
> flickering.
>
> Omni Vision recommends us to use their settings for crop start/end for
> 4224x3136.

The change of register values itself doesn't give any information
about what is changed. Could you explain the following:
- What is the "crop" in this case?
- What value was it set to before and why was it wrong?
- What is the new value and why is it good?

Best regards,
Tomasz
