Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D919C282CC
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 16:08:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6A452080F
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 16:08:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730284AbfBEQII (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 11:08:08 -0500
Received: from mga03.intel.com ([134.134.136.65]:1799 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730268AbfBEQII (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Feb 2019 11:08:08 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Feb 2019 08:08:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,564,1539673200"; 
   d="scan'208";a="112575774"
Received: from mrugallf-mobl.ger.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.249.45.208])
  by orsmga007.jf.intel.com with ESMTP; 05 Feb 2019 08:08:05 -0800
Received: by kekkonen.fi.intel.com (Postfix, from userid 1000)
        id B6A3921D9A; Tue,  5 Feb 2019 18:08:03 +0200 (EET)
Date:   Tue, 5 Feb 2019 18:08:03 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Chen-Yu Tsai <wens@csie.org>
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: Re: [PATCH 6/6] media: ov5640: Consolidate JPEG compression mode
 setting
Message-ID: <20190205160802.u47qvkqljggq4azi@kekkonen.localdomain>
References: <20190118085206.2598-1-wens@csie.org>
 <20190118085206.2598-7-wens@csie.org>
 <20190205085539.6nh7rzialcvztuqo@kekkonen.localdomain>
 <CAGb2v64z91fX+1hB+hhfCp7qhn9y5ER3XJfTbPYeyJ4qfUuRiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGb2v64z91fX+1hB+hhfCp7qhn9y5ER3XJfTbPYeyJ4qfUuRiQ@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Feb 05, 2019 at 09:50:47PM +0800, Chen-Yu Tsai wrote:
> On Tue, Feb 5, 2019 at 4:55 PM Sakari Ailus
> <sakari.ailus@linux.intel.com> wrote:
> >
> > Hi Chen-Yu,
> >
> > On Fri, Jan 18, 2019 at 04:52:06PM +0800, Chen-Yu Tsai wrote:
> > > The register value lists for all the supported resolution settings all
> > > include a register address/value pair for setting the JPEG compression
> > > mode. With the exception of 1080p (which sets mode 2), all resolutions
> > > use mode 3.
> > >
> > > The only difference between mode 2 and mode 3 is that mode 2 may have
> > > padding data on the last line, while mode 3 does not add padding data.
> > >
> > > As these register values were from dumps of running systems, and the
> > > difference between the modes is quite small, using mode 3 for all
> > > configurations should be OK.
> > >
> > > Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> > > ---
> > >  drivers/media/i2c/ov5640.c | 34 +++++++++++++++++++++++-----------
> > >  1 file changed, 23 insertions(+), 11 deletions(-)
> > >
> > > diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> > > index 1c1dc401c678..3d2c5de73283 100644
> > > --- a/drivers/media/i2c/ov5640.c
> > > +++ b/drivers/media/i2c/ov5640.c
> > > @@ -85,6 +85,7 @@
> > >  #define OV5640_REG_FORMAT_CONTROL00  0x4300
> > >  #define OV5640_REG_VFIFO_HSIZE               0x4602
> > >  #define OV5640_REG_VFIFO_VSIZE               0x4604
> > > +#define OV5640_REG_JPG_MODE_SELECT   0x4713
> >
> > How has this been tested?
> >
> > The register is referred to as "OV5640_REG_JPEG_MODE_SELECT" below. I can
> > fix it if it's just a typo, but please confirm.
> 
> It's a typo. The datasheet uses the abbreviated form, JPG_MODE_SELECT,
> but all the bitfield names are the full JPEG form. I believe I missed
> the other occurrence while fixing up the names to match the datasheet.
> I appologize for not doing a final compile test.

Thanks, and no problem.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
