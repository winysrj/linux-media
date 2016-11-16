Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34672 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752300AbcKPNhH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 08:37:07 -0500
Date: Wed, 16 Nov 2016 07:37:04 -0600
From: Rob Herring <robh@kernel.org>
To: Jiancheng Xue <xuejiancheng@hisilicon.com>
Cc: mark.rutland@arm.com, mchehab@kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, yanhaifeng@hisilicon.com,
        hermit.wangheming@hisilicon.com, elder@linaro.org,
        bin.chen@linaro.org, Ruqiang Ju <juruqiang@huawei.com>
Subject: Re: [PATCH] [media] ir-hix5hd2: make hisilicon,power-syscon property
 deprecated
Message-ID: <20161116133704.uj6bubfocosfljpc@rob-hp-laptop>
References: <1479195092-20090-1-git-send-email-xuejiancheng@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1479195092-20090-1-git-send-email-xuejiancheng@hisilicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 15, 2016 at 03:31:32PM +0800, Jiancheng Xue wrote:
> From: Ruqiang Ju <juruqiang@huawei.com>
> 
> The clock of IR can be provided by the clock provider and controlled
> by common clock framework APIs.
> 
> Signed-off-by: Ruqiang Ju <juruqiang@huawei.com>
> Signed-off-by: Jiancheng Xue <xuejiancheng@hisilicon.com>
> ---
>  .../devicetree/bindings/media/hix5hd2-ir.txt       |  6 +++---

Acked-by: Rob Herring <robh@kernel.org>

>  drivers/media/rc/ir-hix5hd2.c                      | 25 ++++++++++++++--------
>  2 files changed, 19 insertions(+), 12 deletions(-)
