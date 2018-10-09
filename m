Return-path: <linux-media-owner@vger.kernel.org>
Received: from mleia.com ([178.79.152.223]:39650 "EHLO mail.mleia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726451AbeJISal (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 Oct 2018 14:30:41 -0400
Subject: Re: [PATCH 4/7] mfd: ds90ux9xx: add TI DS90Ux9xx de-/serializer MFD
 driver
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Wolfram Sang <wsa@the-dreams.de>, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20181008211205.2900-5-vz@mleia.com>
 <201810091225.bXf3OJJ8%fengguang.wu@intel.com>
From: Vladimir Zapolskiy <vz@mleia.com>
Message-ID: <69f6121a-7d9b-b85c-ddc3-9d88986e0433@mleia.com>
Date: Tue, 9 Oct 2018 14:14:12 +0300
MIME-Version: 1.0
In-Reply-To: <201810091225.bXf3OJJ8%fengguang.wu@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/09/2018 07:08 AM, kbuild test robot wrote:
> Hi Vladimir,
> 
> I love your patch! Perhaps something to improve:
> 
> [auto build test WARNING on ljones-mfd/for-mfd-next]
> [also build test WARNING on v4.19-rc7 next-20181008]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Vladimir-Zapolskiy/mfd-pinctrl-add-initial-support-of-TI-DS90Ux9xx-ICs/20181009-090135
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git for-mfd-next
> config: i386-allyesconfig (attached as .config)
> compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> Note: it may well be a FALSE warning. FWIW you are at least aware of it now.
> http://gcc.gnu.org/wiki/Better_Uninitialized_Warnings
> 

And it is a false positive.

--
Best wishes,
Vladimir
