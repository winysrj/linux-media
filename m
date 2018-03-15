Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752810AbeCOWzL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Mar 2018 18:55:11 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Maciej Purski <m.purski@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
From: Stephen Boyd <sboyd@kernel.org>
In-Reply-To: <f13fb12b-54e6-104b-4ec0-192d1bb72cc8@samsung.com>
Cc: David Airlie <airlied@linux.ie>,
        Michael Turquette <mturquette@baylibre.com>,
        Kamil Debski <kamil@wypas.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Thibault Saunier <thibault.saunier@osg.samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Russell King <linux@armlinux.org.uk>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Hoegeun Kwon <hoegeun.kwon@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Jeongtae Park <jtp.park@samsung.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
References: <1519055046-2399-1-git-send-email-m.purski@samsung.com>
 <CGME20180219154456eucas1p15f4073beaf61312238f142f217a8bb3c@eucas1p1.samsung.com>
 <1519055046-2399-2-git-send-email-m.purski@samsung.com>
 <b67b5043-f5e5-826a-f0b8-f7cf722c61e6@arm.com>
 <f13fb12b-54e6-104b-4ec0-192d1bb72cc8@samsung.com>
Message-ID: <152115450981.111154.2342657732967302796@swboyd.mtv.corp.google.com>
Subject: Re: [PATCH 1/8] clk: Add clk_bulk_alloc functions
Date: Thu, 15 Mar 2018 15:55:09 -0700
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Quoting Marek Szyprowski (2018-02-20 01:36:03)
> Hi Robin,
> 
> On 2018-02-19 17:29, Robin Murphy wrote:
> >
> > Seeing how every subsequent patch ends up with the roughly this same 
> > stanza:
> >
> >     x = devm_clk_bulk_alloc(dev, num, names);
> >     if (IS_ERR(x)
> >         return PTR_ERR(x);
> >     ret = devm_clk_bulk_get(dev, x, num);
> >
> > I wonder if it might be better to simply implement:
> >
> >     int devm_clk_bulk_alloc_get(dev, &x, num, names)
> >
> > that does the whole lot in one go, and let drivers that want to do 
> > more fiddly things continue to open-code the allocation.
> >
> > But perhaps that's an abstraction too far... I'm not all that familiar 
> > with the lie of the land here.
> 
> Hmmm. This patchset clearly shows, that it would be much simpler if we
> get rid of clk_bulk_data structure at all and let clk_bulk_* functions
> to operate on struct clk *array[]. Typically the list of clock names
> is already in some kind of array (taken from driver data or statically
> embedded into driver), so there is little benefit from duplicating it
> in clk_bulk_data. Sadly, I missed clk_bulk_* api discussion and maybe
> there are other benefits from this approach.
> 
> If not, I suggest simplifying clk_bulk_* api by dropping clk_bulk_data
> structure and switching to clock ptr array:
> 
> int clk_bulk_get(struct device *dev, int num_clock, struct clk *clocks[],
>                   const char *clk_names[]);
> int clk_bulk_prepare(int num_clks, struct clk *clks[]);
> int clk_bulk_enable(int num_clks, struct clk *clks[]);
> ...
> 

If you have an array of pointers to names of clks then we can put the
struct clk pointers adjacent to them at the same time. I suppose the
problem there is that some drivers want to mark that array of pointers
to names as const. And then we can't update the clk pointers next to
them.

This is the same design that regulators has done so that's why it's
written like this for clks. Honestly, we're talking about a handful of
pointers here so I'm not sure it really matters much. Just duplicate the
pointer and be done if you want to mark the array of names as const or
have your const 'setup' structure point to the bulk_data array that you
define statically non-const somewhere globally.
