Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761AbaK0KLf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Nov 2014 05:11:35 -0500
Message-ID: <5476F8AB.2000601@redhat.com>
Date: Thu, 27 Nov 2014 11:10:51 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Chen-Yu Tsai <wens@csie.org>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>,
	Boris Brezillon <boris@free-electrons.com>,
	Mike Turquette <mturquette@linaro.org>,
	Emilio Lopez <emilio@elopez.com.ar>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH 3/9] clk: sunxi: Add prcm mod0 clock driver
References: <20141126211318.GN25249@lukather> <5476E3A5.4000708@redhat.com> <CAGb2v652m0bCdPWFF4LWwjcrCJZvnLibFPw8xXJ3Q-Ge+_-p7g@mail.gmail.com>
In-Reply-To: <CAGb2v652m0bCdPWFF4LWwjcrCJZvnLibFPw8xXJ3Q-Ge+_-p7g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 11/27/2014 10:28 AM, Chen-Yu Tsai wrote:
> Hi,
>
> On Thu, Nov 27, 2014 at 4:41 PM, Hans de Goede <hdegoede@redhat.com> wrote:

<snip>

>> I notice that you've not responded to my proposal to simple make the clock
>> node a child node of the clocks node in the dt, that should work nicely, and
>> avoid the need for any kernel level changes to support it, I'm beginning to
>> think that that is probably the best solution.
>
> Would that not cause an overlap of the io regions, and cause one of them
> to fail? AFAIK the OF subsystem doesn't like overlapping resources.

No the overlap check is done by the platform dev resource code, and of_clk_declare
does not use that. So the overlap would be there, but not an issue (in theory
I did not test this).

Thinking more about this, I believe that using the MFD framework for the prcm seems
like a mistake to me. It gains us nothing, since we have no irq to de-multiplex or
some such. We're not using MFD for the CMU, why use it for CMU2 (which the prcm
effectively is) ?

So I think it would be best to remove the prcm node from the dt, and simply put the
different blocks inside it directly under the soc node, this will work fine with
current kernels, since as said we do not use any MFD features, we use it to
create platform devs and assign resources, something which will happen automatically
if we put the nodes directly under the soc node, since then simple-bus will do the
work for us.

And then in a release or 2 we can remove the mfd prcm driver from the kernel, and we
have the same functionality we have now with less code.

We could then also chose to move the existing prcm clock nodes to of_clk_declare
(this will work once they are nodes directly under soc with a proper reg property).
and the ir-clk can use allwinner,sun4i-a10-mod0-clk compatible and can live under
either clocks or soc, depending on what we want to do with the other prcm clocks.

Regards,

Hans
