Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:36260 "EHLO
        mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751102AbdFTLFH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Jun 2017 07:05:07 -0400
MIME-Version: 1.0
In-Reply-To: <20170620082933.GA31799@amd>
References: <1496860453-6282-1-git-send-email-steve_longerbeam@mentor.com>
 <e7e4669c-2963-b9e1-edd7-02731a6e0f9c@xs4all.nl> <c0b69c93-b9cd-25e8-ea36-fc0600efdb69@gmail.com>
 <e4f152de-6e75-7654-178e-e6dcf9ad12f3@xs4all.nl> <43887f25-bb73-9020-0909-d275c319aaad@mentor.com>
 <20170620082933.GA31799@amd>
From: Fabio Estevam <festevam@gmail.com>
Date: Tue, 20 Jun 2017 08:05:05 -0300
Message-ID: <CAOMZO5A_LjYzzDTG9KmEHxb2F0=1Pj2Wm8s5maKS8pxce-HX3A@mail.gmail.com>
Subject: Re: Shawn Guo: your attetion is needed here Re: [PATCH v8 00/34] i.MX
 Media Driver
To: Pavel Machek <pavel@ucw.cz>
Cc: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
        Mark Rutland <mark.rutland@arm.com>,
        andrew-ct.chen@mediatek.com, minghsiu.tsai@mediatek.com,
        sakari.ailus@linux.intel.com, Nick Dyer <nick@shmanahar.org>,
        songjun.wu@microchip.com, Hans Verkuil <hverkuil@xs4all.nl>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        devel@driverdev.osuosl.org, markus.heiser@darmarit.de,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        shuah@kernel.org, Russell King - ARM Linux <linux@armlinux.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>, mchehab@kernel.org,
        bparrot@ti.com, "robh+dt@kernel.org" <robh+dt@kernel.org>,
        horms+renesas@verge.net.au, Tiffany Lin <tiffany.lin@mediatek.com>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        niklas.soderlund+renesas@ragnatech.se,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jean-Christophe TROTIN <jean-christophe.trotin@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 20, 2017 at 5:29 AM, Pavel Machek <pavel@ucw.cz> wrote:

> Hmm. I changed the subject to grab Shawn's attetion.
>
> But his acks should not be needed for forward progress. Yes, it would
> be good, but he does not react -- so just reorder the series so that
> dts changes come last, then apply the parts you can apply: driver can
> go in.
>
> And actually... if maintainer does not respond at all, there are ways
> to deal with that, too...

Shawn has already applied the dts part of the series and they show up
in linux-next.
