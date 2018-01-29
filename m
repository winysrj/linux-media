Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:35794 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751273AbeA2XM6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 18:12:58 -0500
MIME-Version: 1.0
In-Reply-To: <c86097d7-dade-01e5-3826-3f22f9ca4b4f@infradead.org>
References: <1517217696-17816-1-git-send-email-yong.deng@magewell.com> <c86097d7-dade-01e5-3826-3f22f9ca4b4f@infradead.org>
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 30 Jan 2018 00:12:56 +0100
Message-ID: <CAK8P3a1W2VC3CEUvPLKoE7FGU1Osm53YQ-F892wqNekn-h8m1A@mail.gmail.com>
Subject: Re: [PATCH v7 2/2] media: V3s: Add support for Allwinner CSI.
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Yong Deng <yong.deng@magewell.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Rick Chang <rick.chang@mediatek.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        DTML <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 29, 2018 at 10:49 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 01/29/2018 01:21 AM, Yong Deng wrote:
>> Allwinner V3s SoC features two CSI module. CSI0 is used for MIPI CSI-2
>> interface and CSI1 is used for parallel interface. This is not
>> documented in datasheet but by test and guess.
>>
>> This patch implement a v4l2 framework driver for it.
>>
>> Currently, the driver only support the parallel interface. MIPI-CSI2,
>> ISP's support are not included in this patch.
>>
>> Tested-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>> Signed-off-by: Yong Deng <yong.deng@magewell.com>
>> ---
>
>
> A previous version (I think v6) had a build error with the use of
> PHYS_OFFSET, so Kconfig was modified to depend on ARM and ARCH_SUNXI
> (one of which seems to be overkill).  As is here, the COMPILE_TEST piece is
> meaningless for all arches except ARM.  If you care enough for COMPILE_TEST
> (and I would), then you could make COMPILE_TEST useful on any arch by
> removing the "depends on ARM" (the ARCH_SUNXI takes care of that) and by
> having an alternate value for PHYS_OFFSET, like so:
>
> +#if defined(CONFIG_COMPILE_TEST) && !defined(PHYS_OFFSET)
> +#define PHYS_OFFSET    0
> +#endif
>
> With those 2 changes, the driver builds for me on x86_64.

I think the PHYS_OFFSET really has to get removed from the driver, it's
wrong on ARM as well.

      Arnd
