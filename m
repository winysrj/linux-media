Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f68.google.com ([209.85.208.68]:38476 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933353AbeGJOnR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 10:43:17 -0400
MIME-Version: 1.0
In-Reply-To: <20180710080114.31469-5-paul.kocialkowski@bootlin.com>
References: <20180710080114.31469-1-paul.kocialkowski@bootlin.com> <20180710080114.31469-5-paul.kocialkowski@bootlin.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Tue, 10 Jul 2018 22:36:19 +0800
Message-ID: <CAGb2v65MO9xmKQz5LuydwqwvVB-_bbM=FeqbsRwJbh-5km9XCQ@mail.gmail.com>
Subject: Re: [PATCH v5 04/22] dt-bindings: sram: sunxi: Add A13, A20, A23 and
 H3 dedicated bindings
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Marco Franchi <marco.franchi@nxp.com>,
        Icenowy Zheng <icenowy@aosc.io>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Keiichi Watanabe <keiichiw@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Smitha T Murthy <smitha.t@samsung.com>,
        Tom Saeger <tom.saeger@oracle.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Benoit Parrot <bparrot@ti.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Pawel Osciak <posciak@chromium.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Randy Li <ayaka@soulik.info>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 10, 2018 at 4:00 PM, Paul Kocialkowski
<paul.kocialkowski@bootlin.com> wrote:
> This introduces dedicated bindings for the system control blocks found
> on the A13, A20, A23 and H3 sunxi platforms.
>
> Since the controllers on the A33 are the very same as those on the A23,
> no specific compatible is introduced for it.
>
> These bindings are introduced to allow reflecting the differences that
> exist between these controllers, that may become significant to driver
> implementations.
>
> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

Not sure if there's a difference between A10 and A20, if you don't count
the NMI that we have a separate node for. But anyway,

Reviewed-by: Chen-Yu Tsai <wens@csie.org>
