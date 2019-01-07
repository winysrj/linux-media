Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F23EC43387
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 15:17:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 280E02087F
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 15:17:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727725AbfAGPRO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 10:17:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:19425 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727242AbfAGPRN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Jan 2019 10:17:13 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jan 2019 07:17:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,451,1539673200"; 
   d="scan'208";a="112767071"
Received: from bachmicx-mobl.ger.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.252.57.24])
  by fmsmga007.fm.intel.com with ESMTP; 07 Jan 2019 07:17:03 -0800
Received: by kekkonen.fi.intel.com (Postfix, from userid 1000)
        id 49A6621D0B; Mon,  7 Jan 2019 17:16:59 +0200 (EET)
Date:   Mon, 7 Jan 2019 17:16:59 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Akinobu Mita <akinobu.mita@gmail.com>
Cc:     linux-media@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH 12/12] media: mt9m001: set all mbus format field when
 G_FMT and S_FMT ioctls
Message-ID: <20190107151658.rp2qwcg3goesp7a4@kekkonen.localdomain>
References: <1545498774-11754-1-git-send-email-akinobu.mita@gmail.com>
 <1545498774-11754-13-git-send-email-akinobu.mita@gmail.com>
 <20190107113243.dte4yqioqy33cwe5@kekkonen.localdomain>
 <CAC5umyjrnxZ4FdGsmy9UZ5FSx16RQwDu2StRg67Kov=pxZrodw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAC5umyjrnxZ4FdGsmy9UZ5FSx16RQwDu2StRg67Kov=pxZrodw@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Jan 07, 2019 at 11:18:47PM +0900, Akinobu Mita wrote:
> 2019年1月7日(月) 20:32 Sakari Ailus <sakari.ailus@linux.intel.com>:
> >
> > Hi Mita-san,
> >
> > On Sun, Dec 23, 2018 at 02:12:54AM +0900, Akinobu Mita wrote:
> > > This driver doesn't set all members of mbus format field when the
> > > VIDIOC_SUBDEV_{S,G}_FMT ioctls are called.
> > >
> > > This is detected by v4l2-compliance.
> > >
> > > Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > > ---
> > >  drivers/media/i2c/mt9m001.c | 7 +++++++
> > >  1 file changed, 7 insertions(+)
> > >
> > > diff --git a/drivers/media/i2c/mt9m001.c b/drivers/media/i2c/mt9m001.c
> > > index f4afbc9..82b89d5 100644
> > > --- a/drivers/media/i2c/mt9m001.c
> > > +++ b/drivers/media/i2c/mt9m001.c
> > > @@ -342,6 +342,9 @@ static int mt9m001_get_fmt(struct v4l2_subdev *sd,
> > >       mf->code        = mt9m001->fmt->code;
> > >       mf->colorspace  = mt9m001->fmt->colorspace;
> > >       mf->field       = V4L2_FIELD_NONE;
> > > +     mf->ycbcr_enc   = V4L2_YCBCR_ENC_DEFAULT;
> > > +     mf->quantization = V4L2_QUANTIZATION_DEFAULT;
> > > +     mf->xfer_func   = V4L2_XFER_FUNC_DEFAULT;
> >
> > Instead of setting the fields individually, would it be feasible to just
> > assign mt9m001->fmt to mf?
> 
> The data type of mt9m001->fmt is struct mt9m001_datafmt, so it can't
> simply assign to mf.

Oh, good point. There are still three places in the driver where you're
setting effectively the same fields; if there is a way to reasonably
address that, it'd be nice to do that. Up to you.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
