Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:47562 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756630AbdLOWOc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 17:14:32 -0500
Date: Fri, 15 Dec 2017 23:14:30 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Yong <yong.deng@magewell.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Arnd Bergmann <arnd@arndb.de>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Benoit Parrot <bparrot@ti.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 1/3] media: V3s: Add support for Allwinner CSI.
Message-ID: <20171215221430.di72fzaszgnvuzmp@flea.lan>
References: <1501131697-1359-1-git-send-email-yong.deng@magewell.com>
 <1501131697-1359-2-git-send-email-yong.deng@magewell.com>
 <20171121154827.5a35xa6zlqrrvkxx@flea.lan>
 <20171122093306.d30fe641f269d62daa1f66b4@magewell.com>
 <20171122094526.nqxfy2e5jzxw7nl4@flea.lan>
 <20171123091444.4bed66dffeb36ecea8dfa706@magewell.com>
 <20171125160233.skefdpkjy4peh7et@flea.lan>
 <20171204174511.a5be3b521e9a7c7004d32d0d@magewell.com>
 <20171215105047.ist7epuida2uao74@flea.lan>
 <20171215190140.d4df71b202b9803baa6a1e10@magewell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20171215190140.d4df71b202b9803baa6a1e10@magewell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Fri, Dec 15, 2017 at 07:01:40PM +0800, Yong wrote:
> Hi Maxime,
> 
> On Fri, 15 Dec 2017 11:50:47 +0100
> Maxime Ripard <maxime.ripard@free-electrons.com> wrote:
> 
> > Hi Yong,
> > 
> > On Mon, Dec 04, 2017 at 05:45:11PM +0800, Yong wrote:
> > > I just noticed that you are using the second iteration?
> > > Have you received my third iteration?
> > 
> > Sorry for the late reply, and for not coming back to you yet about
> > that test. No, this is still in your v2. I've definitely received your
> > v3, I just didn't have time to update to it yet.
> > 
> > But don't worry, my mail was mostly to know if you had tested that
> > setup on your side to try to nail down the issue on my end, not really
> > a review or comment that would prevent your patch from going in.
> 
> I mean,
> The v2 exactly has a bug which may cause the CSI writing frame to 
> a wrong memory address.

Ah, sorry I misunderstood you then. I'll definitely test your v3..

> BTW, should I send a new version. I have made some improve sine v3.

.. or your v4 :)

Yes, please send a new version.

Maxime

-- 
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
