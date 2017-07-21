Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:37087 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752871AbdGUHzo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Jul 2017 03:55:44 -0400
Received: by mail-wr0-f177.google.com with SMTP id 33so22633765wrz.4
        for <linux-media@vger.kernel.org>; Fri, 21 Jul 2017 00:55:43 -0700 (PDT)
Subject: Re: [PATCH v3 22/23] camss: Use optimal clock frequency rates
Cc: mchehab@kernel.org, hans.verkuil@cisco.com, s.nawrocki@samsung.com,
        sakari.ailus@iki.fi, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
References: <201707192319.2CeMkOEJ%fengguang.wu@intel.com>
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <23d32af2-13cc-617d-c2a9-cb16aea9542d@linaro.org>
Date: Fri, 21 Jul 2017 10:55:41 +0300
MIME-Version: 1.0
In-Reply-To: <201707192319.2CeMkOEJ%fengguang.wu@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 19.07.2017 18:59, kbuild test robot wrote:
> Hi Todor,
> 
> [auto build test ERROR on linuxtv-media/master]
> [also build test ERROR on v4.13-rc1]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Todor-Tomov/Qualcomm-8x16-Camera-Subsystem-driver/20170718-055348
> base:   git://linuxtv.org/media_tree.git master
> config: i386-allmodconfig (attached as .config)
> compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> All errors (new ones prefixed by >>):
> 
>    ERROR: "__udivdi3" [fs/ufs/ufs.ko] undefined!
>>> ERROR: "__udivdi3" [drivers/media/platform/qcom/camss-8x16/qcom-camss.ko] undefined!
>    ERROR: "__divdi3" [drivers/media/platform/qcom/camss-8x16/qcom-camss.ko] undefined!

Just FYI,
I'll switch to using the proper division functions/macros so this error
will be fixed in the next version of the patchset.

> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> 

-- 
Best regards,
Todor Tomov
