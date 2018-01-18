Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:31127 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754927AbeARNCo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Jan 2018 08:02:44 -0500
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20180118130242epoutp0273fa2d34b8b86cf5f1bb16edd9e789dd~K6SNTgJXF1047710477epoutp02E
        for <linux-media@vger.kernel.org>; Thu, 18 Jan 2018 13:02:42 +0000 (GMT)
Subject: Re: [Patch v6 02/12] [media] s5p-mfc: Adding initial support for
 MFC v10.10
From: Smitha T Murthy <smitha.t@samsung.com>
To: Philippe Ombredanne <pombredanne@nexb.com>
Cc: "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE"
        <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, a.hajda@samsung.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        pankaj.dubey@samsung.com, krzk@kernel.org,
        m.szyprowski@samsung.com, s.nawrocki@samsung.com,
        Rob Herring <robh+dt@kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>
In-Reply-To: <CAOFm3uHyNt3k+_n3SvSP-BNFeEeu1CO6PpEbxs9JU0MxsHm=Jg@mail.gmail.com>
Date: Thu, 18 Jan 2018 18:06:21 +0530
Message-ID: <1516278981.22129.12.camel@smitha-fedora>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
References: <CGME20171208093637epcas1p217ea0e337333ebf6918bc0418753d2af@epcas1p2.samsung.com>
        <1512724105-1778-1-git-send-email-smitha.t@samsung.com>
        <1512724105-1778-3-git-send-email-smitha.t@samsung.com>
        <CAOFm3uHyNt3k+_n3SvSP-BNFeEeu1CO6PpEbxs9JU0MxsHm=Jg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2017-12-08 at 14:25 +0100, Philippe Ombredanne wrote:
> Smitha,
> 
> On Fri, Dec 8, 2017 at 10:08 AM, Smitha T Murthy <smitha.t@samsung.com> wrote:
> > Adding the support for MFC v10.10, with new register file and
> > necessary hw control, decoder, encoder and structural changes.
> >
> > CC: Rob Herring <robh+dt@kernel.org>
> > CC: devicetree@vger.kernel.org
> > Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
> > Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
> > Acked-by: Rob Herring <robh@kernel.org>
> []
> > --- /dev/null
> > +++ b/drivers/media/platform/s5p-mfc/regs-mfc-v10.h
> > @@ -0,0 +1,36 @@
> > +/*
> > + * Register definition file for Samsung MFC V10.x Interface (FIMV) driver
> > + *
> > + * Copyright (c) 2017 Samsung Electronics Co., Ltd.
> > + *     http://www.samsung.com/
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> 
> Have you considered using the new SPDX ids instead of this fine legalese? e.g.:
> 
> // SPDX-License-Identifier: GPL-2.0
> 
> This is much shorter and neater (unless you are a legalese lover of
> course!)  Check also Thomas doc patches and Linus comments on why he
> prefers the C++ comment style for these.
> 
> And even better could be this more compact form? I am a big fan of the
> C++ style comments for these (and so is Linus)
> 
> // SPDX-License-Identifier: GPL-2.0
> // Copyright (c) 2017 Samsung Electronics Co., Ltd.
> // Register definition file for Samsung MFC V10.x Interface (FIMV) driver
> 
> You can also read this fine article from a fellow Samsung colleague
> [1]. And if you ever consider doing this for all Samsung's past,
> present and future contributions, you will have my deep gratitude
> 
> [1] https://blogs.s-osg.org/linux-kernel-license-practices-revisited-spdx/
> 
Ok I will change to the SPDX license in the next patch series for the
v10 register file. Correspondingly for the MFC driver's files I will
update the license as a separate patch and submit.
