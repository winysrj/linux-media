Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924AbaLCJt5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Dec 2014 04:49:57 -0500
Message-ID: <547EDCA0.4040805@redhat.com>
Date: Wed, 03 Dec 2014 10:49:20 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Chen-Yu Tsai <wens@csie.org>,
	Boris Brezillon <boris@free-electrons.com>,
	Mike Turquette <mturquette@linaro.org>,
	Emilio Lopez <emilio@elopez.com.ar>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH 3/9] clk: sunxi: Add prcm mod0 clock driver
References: <20141126211318.GN25249@lukather> <5476E3A5.4000708@redhat.com> <CAGb2v652m0bCdPWFF4LWwjcrCJZvnLibFPw8xXJ3Q-Ge+_-p7g@mail.gmail.com> <5476F8AB.2000601@redhat.com> <20141127190509.GR25249@lukather> <54787A8A.6040209@redhat.com> <20141202154524.GD30256@lukather>
In-Reply-To: <20141202154524.GD30256@lukather>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 12/02/2014 04:45 PM, Maxime Ripard wrote:

 >> Ok, so thinking more about this, I'm still convinced that the MFD
>> framework is only getting in the way here.
>
> You still haven't said of what exactly it's getting in the way of.

Of using of_clk_define to bind to the mod0 clk in the prcm, because the
ir_clk node does not have its own reg property when the mfd framework is
used and of_clk_define requires the node to have its own reg property.

>> But I can see having things represented in devicetree properly, with
>> the clocks, etc. as child nodes of the prcm being something which we
>> want.
>
> Clocks and reset are the only thing set so far, because we need
> reference to them from the DT itself, nothing more.
>
> We could very much have more devices instatiated from the MFD itself.
>
>> So since all we are using the MFD for is to instantiate platform
>> devices under the prcm nodes, and assign an io resource for the regs
>> to them, why not simply make the prcm node itself a simple-bus.
>
> No, this is really not a bus. It shouldn't be described at all as
> such. It is a device, that has multiple functionnalities in the system
> => MFD. It really is that simple.

Ok, I can live with that, but likewise the clocks node is not a bus either!

So it should not have a simple-bus compatible either, and as such we cannot
simply change the mod0 driver from of_clk_define to a platform driver because
then we need to instantiate platform devs for the mod0 clock nodes, which
means making the clock node a simple-bus.

I can see your logic in wanting the ir_clk prcm sub-node to use the
mod0 compatible string, so how about we make the mod0 driver both
register through of_declare and as a platform driver. Note this means
that it will try to bind twice to the ir_clk node, since of_clk_declare
will cause it to try and bind there too AFAIK.

The of_clk_declare bind will fail though because there is no regs
property, so this double bind is not an issue as long as we do not
log errors on the first bind failure.

Note that the ir_clk node will still need an "ir-clk" compatible as
well for the MFD to find it and assign the proper resources to it.

But this way we will have the clk driver binding to the mod0 clk compatible,
which is what you want, while having the MFD assign resources on the
fact that it is the ir-clk node, so that things will still work if
there are multiple mod0 clks in the prcm.

>> This does everything the MFD prcm driver currently does, without
>> actually needing a specific kernel driver, and as added bonus this
>> will move the definition of the mfd function reg offsets out of the
>> kernel and into the devicetree where they belong in the first place.
>
> Which was nacked in the first place because such offsets are not
> supposed to be in the DT.
>
> Really, we have something that work here, there's no need to refactor
> it.

Ok, but that does bring us back to the original problem wrt the ir-clk,
see above for how I think we should solve this then. If you agree I
can implement the proposed fix.

Regards,

Hans
