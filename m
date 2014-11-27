Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:34126 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751120AbaK0Qog (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Nov 2014 11:44:36 -0500
Date: Thu, 27 Nov 2014 17:40:56 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Boris Brezillon <boris@free-electrons.com>,
	Mike Turquette <mturquette@linaro.org>,
	Chen-Yu Tsai <wens@csie.org>,
	Emilio Lopez <emilio@elopez.com.ar>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: Re: [PATCH 3/9] clk: sunxi: Add prcm mod0 clock driver
Message-ID: <20141127174056.6697cde3@bbrezillon>
In-Reply-To: <20141126211318.GN25249@lukather>
References: <54743DE1.7020704@redhat.com>
	<20141126211318.GN25249@lukather>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Wed, 26 Nov 2014 22:13:18 +0100
Maxime Ripard <maxime.ripard@free-electrons.com> wrote:

[...]

> 
> I remember someone (Chen-Yu? Boris?) saying that the 1wire clock was
> not really a mod0 clk. From what I could gather from the source code,
> it seems to have a wider m divider, so we could argue that it should
> need a new compatible.

Wasn't me :-).

Regarding the rest of the discussion I miss some context, but here's
what I remember decided us to choose the MFD approach for the PRCM
block:

1) it's embedding several unrelated functional blocks (reset, clk, and
some other things I don't remember).
2) none of the functionalities provided by the PRCM were required in
the early boot stage
3) We wanted to represent the HW blocks as they are really described in
the memory mapping instead of splitting small register chunks over the
DT.

Can someone sum-up the current issue you're trying to solve ?

IMHO, if you really want to split those functionalities over the DT
(some nodes under clks and other under reset controller), then I
suggest to use..............
(Maxime, please stop smiling :P)
..............

SYSCON

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
