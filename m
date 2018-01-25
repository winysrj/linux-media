Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:64251 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750769AbeAYLzd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Jan 2018 06:55:33 -0500
Date: Thu, 25 Jan 2018 13:55:29 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        "H . Nikolaus Schaller" <hns@goldelico.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v3 0/3] media: ov9650: support device tree probing
Message-ID: <20180125115529.lfarlhakoh4x4vc6@paasikivi.fi.intel.com>
References: <1516547656-3879-1-git-send-email-akinobu.mita@gmail.com>
 <20180121163314.GN24926@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180121163314.GN24926@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jan 21, 2018 at 05:33:14PM +0100, jacopo mondi wrote:
> Hello Akinobu,
> 
> On Mon, Jan 22, 2018 at 12:14:13AM +0900, Akinobu Mita wrote:
> > This patchset adds device tree probing for ov9650 driver. This contains
> > an actual driver change and a newly added binding documentation part.
> >
> > * Changelog v3
> > - Add Reviewed-by: tags
> > - Add MAINTAINERS entry
> >
> > * Changelog v2
> > - Split binding documentation, suggested by Rob Herring and Jacopo Mondi
> > - Improve the wording for compatible property in the binding documentation,
> >   suggested by Jacopo Mondi
> > - Improve the description for the device node in the binding documentation,
> >   suggested by Sakari Ailus
> > - Remove ov965x_gpio_set() helper and open-code it, suggested by Jacopo Mondi
> >   and Sakari Ailus
> > - Call clk_prepare_enable() in s_power callback instead of probe, suggested
> >   by Sakari Ailus
> > - Unify clk and gpio configuration in a single if-else block and, also add
> >   a check either platform data or fwnode is actually specified, suggested
> >   by Jacopo Mondi
> > - Add CONFIG_OF guards, suggested by Jacopo Mondi
> >
> > Akinobu Mita (3):
> >   media: ov9650: support device tree probing
> >   media: MAINTAINERS: add entry for ov9650 driver
> >   media: ov9650: add device tree binding
> 
> As you've closed my comments on v1/v2, for driver and device tree bindings:
> 
> Reviewed-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> 
> No need to resend just to add the tags, but in case you have to, please
> add them.

Thanks, guys!

Applied in order 2, 3 and 1 --- the DT changes come before driver changes.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
