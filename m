Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:58469 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753243AbdHTUJu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Aug 2017 16:09:50 -0400
Date: Sun, 20 Aug 2017 21:09:48 +0100
From: Sean Young <sean@mess.org>
To: Shawn Guo <shawnguo@kernel.org>
Cc: Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Baoyou Xie <xie.baoyou@sanechips.com.cn>,
        Xin Zhou <zhou.xin8@sanechips.com.cn>,
        Jun Nie <jun.nie@linaro.org>, Shawn Guo <shawn.guo@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 0/3] Add ZTE zx-irdec remote control driver
Message-ID: <20170820200947.pvyj7fqlorfq56l5@gofer.mess.org>
References: <1501420993-21977-1-git-send-email-shawnguo@kernel.org>
 <20170818125418.GM7608@dragon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170818125418.GM7608@dragon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 18, 2017 at 08:54:20PM +0800, Shawn Guo wrote:
> On Sun, Jul 30, 2017 at 09:23:10PM +0800, Shawn Guo wrote:
> > From: Shawn Guo <shawn.guo@linaro.org>
> > 
> > The series adds dt-bindings and remote control driver for IRDEC block
> > found on ZTE ZX family SoCs.
> > 
> > Changes for v2:
> >  - Add one patch to move generic NEC scancode composing and protocol
> >    type detection code from ir_nec_decode() into an inline shared
> >    function, which can be reused by zx-irdec driver.
> > 
> > Shawn Guo (3):
> >   rc: ir-nec-decoder: move scancode composing code into a shared
> >     function
> >   dt-bindings: add bindings document for zx-irdec
> >   rc: add zx-irdec remote control driver
> 
> Hi Sean,
> 
> We are getting close to 4.14 merge window.  Can we get this into -next
> for a bit exposure, if you are fine with the patches?

The rc pull requests have been merged into the media_tree, so they should
now get exposure in linux-next.

https://git.linuxtv.org/media_tree.git/

Thanks,

Sean
