Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f171.google.com ([209.85.161.171]:52008 "EHLO
        mail-yw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750823AbdISEcu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 00:32:50 -0400
Received: by mail-yw0-f171.google.com with SMTP id p10so1727923ywh.8
        for <linux-media@vger.kernel.org>; Mon, 18 Sep 2017 21:32:49 -0700 (PDT)
Received: from mail-yw0-f177.google.com (mail-yw0-f177.google.com. [209.85.161.177])
        by smtp.gmail.com with ESMTPSA id w199sm3724790yww.39.2017.09.18.21.32.47
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Sep 2017 21:32:48 -0700 (PDT)
Received: by mail-yw0-f177.google.com with SMTP id u205so1262961ywa.5
        for <linux-media@vger.kernel.org>; Mon, 18 Sep 2017 21:32:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d946c138dc7d9657e986bfe37d255a595ad1671c.1505774663.git.chiranjeevi.rapolu@intel.com>
References: <1505342325-9180-1-git-send-email-chiranjeevi.rapolu@intel.com> <d946c138dc7d9657e986bfe37d255a595ad1671c.1505774663.git.chiranjeevi.rapolu@intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 19 Sep 2017 13:32:27 +0900
Message-ID: <CAAFQd5Cqxrbutd-FL3EAJde1q2JmjY+6xHAMGuGjkR3VdpQxQA@mail.gmail.com>
Subject: Re: [PATCH v2] media: ov13858: Fix 4224x3136 video flickering at some vblanks
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

On Tue, Sep 19, 2017 at 7:47 AM, Chiranjeevi Rapolu
<chiranjeevi.rapolu@intel.com> wrote:
> Previously, with crop (0, 0), (4255, 3167), VTS < 0xC9E was resulting in blank
> frames sometimes. This appeared as video flickering. But we need VTS < 0xC9E to
> get ~30fps.
>
> Omni Vision recommends to use crop (0,8), (4255, 3159) for 4224x3136. With this
> crop, VTS 0xC8E is supported and yields ~30fps.
>
> Signed-off-by: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
> ---
> Changes in v2:
>         - Include Tomasz clarifications in the commit message.

Thanks for explanation. It makes perfect sense now.

Reviewed-by: Tomasz Figa <tfiga@chromium.org>

Best regards,
Tomasz
