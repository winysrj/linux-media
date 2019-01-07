Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A06BAC43387
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 15:15:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7249F2087F
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 15:15:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729488AbfAGPPa (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 10:15:30 -0500
Received: from mga12.intel.com ([192.55.52.136]:34981 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727574AbfAGPPa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Jan 2019 10:15:30 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jan 2019 07:15:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,451,1539673200"; 
   d="scan'208";a="136045028"
Received: from bachmicx-mobl.ger.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.252.57.24])
  by fmsmga001.fm.intel.com with ESMTP; 07 Jan 2019 07:15:28 -0800
Received: by kekkonen.fi.intel.com (Postfix, from userid 1000)
        id 9E13521D0B; Mon,  7 Jan 2019 17:15:23 +0200 (EET)
Date:   Mon, 7 Jan 2019 17:15:23 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Akinobu Mita <akinobu.mita@gmail.com>
Cc:     linux-media@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH 03/12] media: mt9m001: convert to SPDX license identifer
Message-ID: <20190107151522.5eh5oluj22pck3sf@kekkonen.localdomain>
References: <1545498774-11754-1-git-send-email-akinobu.mita@gmail.com>
 <1545498774-11754-4-git-send-email-akinobu.mita@gmail.com>
 <20190107113708.oex222eb6ndd3hou@kekkonen.localdomain>
 <CAC5umyjG7i+1OJSZLoUSAmgqrfVR8QZ-aREEpM3ssMDEbgbGJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAC5umyjG7i+1OJSZLoUSAmgqrfVR8QZ-aREEpM3ssMDEbgbGJw@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Jan 07, 2019 at 11:20:29PM +0900, Akinobu Mita wrote:
> 2019年1月7日(月) 20:37 Sakari Ailus <sakari.ailus@linux.intel.com>:
> >
> > Hi Mita-san,
> >
> > On Sun, Dec 23, 2018 at 02:12:45AM +0900, Akinobu Mita wrote:
> > > Replace GPL license statements with SPDX license identifiers (GPL-2.0).
> > >
> > > Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > > ---
> > >  drivers/media/i2c/mt9m001.c | 5 +----
> > >  1 file changed, 1 insertion(+), 4 deletions(-)
> > >
> > > diff --git a/drivers/media/i2c/mt9m001.c b/drivers/media/i2c/mt9m001.c
> > > index a1a85ff..65ff59d 100644
> > > --- a/drivers/media/i2c/mt9m001.c
> > > +++ b/drivers/media/i2c/mt9m001.c
> > > @@ -1,11 +1,8 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > >  /*
> > >   * Driver for MT9M001 CMOS Image Sensor from Micron
> > >   *
> > >   * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
> > > - *
> > > - * This program is free software; you can redistribute it and/or modify
> > > - * it under the terms of the GNU General Public License version 2 as
> > > - * published by the Free Software Foundation.
> > >   */
> > >
> > >  #include <linux/videodev2.h>
> >
> > The MODULE_LICENSE macro at the end of the file lists "GPL" as the license,
> > i.e. including later versions. I'm not sure what was the intention
> > originally. I guess it's safer to stick to 2.0, at least unless the
> > original author is able to shed some light into this.
> 
> I've come across the same thought, and I found the following conversation.
> 
> https://lkml.org/lkml/2018/6/24/457
> 
> So I think MODULE_LICENSE() mismatch can be resolved in the future.

I don't see a reason to postpone it. Strictly speaking, for GPL 2+ we'd
need an approval from anyone who has submitted patches to the file. For GPL
v2 it'd be just a patch that fixes the MODULE_LICENSE.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
