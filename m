Return-path: <linux-media-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:44964 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751733AbdJSVUg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Oct 2017 17:20:36 -0400
Date: Thu, 19 Oct 2017 14:20:32 -0700
From: Tony Lindgren <tony@atomide.com>
To: Rob Herring <robh@kernel.org>
Cc: Benoit Parrot <bparrot@ti.com>, Tero Kristo <t-kristo@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [Patch 4/6] dt-bindings: media: ti-vpe: Document VPE driver
Message-ID: <20171019212031.GI4394@atomide.com>
References: <20171012192719.15193-1-bparrot@ti.com>
 <20171012192719.15193-5-bparrot@ti.com>
 <20171017210051.6ap3yg7b7viav6cy@rob-hp-laptop>
 <20171018130227.GO25400@ti.com>
 <CAL_Jsq+jy-JN=ppfkyexFqJsbQVw3UGdNrNBVUvmGPHBdoLGkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_Jsq+jy-JN=ppfkyexFqJsbQVw3UGdNrNBVUvmGPHBdoLGkg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Rob Herring <robh@kernel.org> [171019 14:07]:
> On Wed, Oct 18, 2017 at 8:02 AM, Benoit Parrot <bparrot@ti.com> wrote:
> >> > +Example:
> >> > +   vpe {
> >> > +           compatible = "ti,vpe";
> >> > +           ti,hwmods = "vpe";
> >> > +           clocks = <&dpll_core_h23x2_ck>;
> >> > +           clock-names = "fck";
> >> > +           reg =   <0x489d0000 0x120>,
> >> > +                   <0x489d0300 0x20>,
> >> > +                   <0x489d0400 0x20>,
> >> > +                   <0x489d0500 0x20>,
> >> > +                   <0x489d0600 0x3c>,
> >> > +                   <0x489d0700 0x80>,
> >>
> >> Is there other stuff between these regions?
> >
> > No, they listed separately because each sub-region/module is
> > individually mapped and accessed using a starting 0 offset.
> 
> So you are going to use 48KB of virtual memory to map 2KB of
> registers? Because each ioremap uses 8KB (1 page plus 1 guard page)
> last time i looked (which has been a while).
> 
> But it's your platform.

We should have cached regions for all interconnects so this should
not be a problem. Worth checking that the areas are listed in
dra7xx_io_desc[] and for other SoCs too to avoid this issue.

Regards,

Tony
