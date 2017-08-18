Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750966AbdHRM4E (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Aug 2017 08:56:04 -0400
Date: Fri, 18 Aug 2017 20:54:20 +0800
From: Shawn Guo <shawnguo@kernel.org>
To: Sean Young <sean@mess.org>, Rob Herring <robh+dt@kernel.org>
Cc: devicetree@vger.kernel.org,
        Baoyou Xie <xie.baoyou@sanechips.com.cn>,
        Xin Zhou <zhou.xin8@sanechips.com.cn>,
        Jun Nie <jun.nie@linaro.org>, Shawn Guo <shawn.guo@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 0/3] Add ZTE zx-irdec remote control driver
Message-ID: <20170818125418.GM7608@dragon>
References: <1501420993-21977-1-git-send-email-shawnguo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1501420993-21977-1-git-send-email-shawnguo@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jul 30, 2017 at 09:23:10PM +0800, Shawn Guo wrote:
> From: Shawn Guo <shawn.guo@linaro.org>
> 
> The series adds dt-bindings and remote control driver for IRDEC block
> found on ZTE ZX family SoCs.
> 
> Changes for v2:
>  - Add one patch to move generic NEC scancode composing and protocol
>    type detection code from ir_nec_decode() into an inline shared
>    function, which can be reused by zx-irdec driver.
> 
> Shawn Guo (3):
>   rc: ir-nec-decoder: move scancode composing code into a shared
>     function
>   dt-bindings: add bindings document for zx-irdec
>   rc: add zx-irdec remote control driver

Hi Sean,

We are getting close to 4.14 merge window.  Can we get this into -next
for a bit exposure, if you are fine with the patches?

Shawn
