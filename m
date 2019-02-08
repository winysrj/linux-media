Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 684A5C282CB
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 23:18:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FF8320836
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 23:18:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbfBHXR4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 18:17:56 -0500
Received: from mga04.intel.com ([192.55.52.120]:55824 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726353AbfBHXRz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Feb 2019 18:17:55 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Feb 2019 15:17:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,348,1544515200"; 
   d="scan'208";a="318829222"
Received: from sshumihi-mobl.ccr.corp.intel.com (HELO mara.localdomain) ([10.252.20.76])
  by fmsmga005.fm.intel.com with ESMTP; 08 Feb 2019 15:17:51 -0800
Received: from sailus by mara.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gsFP2-0005a0-DG; Sat, 09 Feb 2019 01:17:49 +0200
Date:   Sat, 9 Feb 2019 01:17:47 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, Andrzej Hajda <a.hajda@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Subject: Re: [PATCH v2 3/5] media: sunxi: Add A10 CSI driver
Message-ID: <20190208231746.sjgb7im6xqsawhwz@mara.localdomain>
References: <cover.ba7411f0c7155d0292b38d3dec698e26b5cc813b.1548687041.git-series.maxime.ripard@bootlin.com>
 <c1a7d46f8504decb58ff224b0b5f2f0733282cc6.1548687041.git-series.maxime.ripard@bootlin.com>
 <20190129123949.qdmqnfaym3y42dvj@paasikivi.fi.intel.com>
 <20190206211605.27cq2lxuv3gtyyux@flea>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190206211605.27cq2lxuv3gtyyux@flea>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Maxime,

On Wed, Feb 06, 2019 at 10:16:05PM +0100, Maxime Ripard wrote:
> Hi Sakari,
> 
> Thanks for your review, I have a few questions though, and the rest
> will be addressed in the next version.
> 
> On Tue, Jan 29, 2019 at 02:39:49PM +0200, Sakari Ailus wrote:
> > > +static int csi_notify_complete(struct v4l2_async_notifier *notifier)
> > > +{
> > > +	struct sun4i_csi *csi = container_of(notifier, struct sun4i_csi,
> > > +					     notifier);
> > > +	int ret;
> > > +
> > > +	ret = v4l2_device_register_subdev_nodes(&csi->v4l);
> > > +	if (ret < 0)
> > > +		return ret;
> > > +
> > > +	ret = sun4i_csi_v4l2_register(csi);
> > > +	if (ret < 0)
> > > +		return ret;
> > > +
> > > +	return media_create_pad_link(&csi->src_subdev->entity, csi->src_pad,
> > > +				     &csi->vdev.entity, 0,
> > > +				     MEDIA_LNK_FL_ENABLED |
> > > +				     MEDIA_LNK_FL_IMMUTABLE);
> > 
> > This appears to create a link directly from the sensor entity to the video
> > device entity. Is that intentional? I'd expect to see a CSI-2 receiver
> > sub-device as well, which I don't see being created by the driver.
> > 
> > This is indeed a novel proposal. I have some concerns though.
> > 
> > The user doesn't have access to the configured media bus format (reflecting
> > the format on the CSI-2 bus on receiver's side). It's thus difficult to
> > figure out whether the V4L2 pixel format configured on the video node
> > matches what the sensor outputs. Admittedly, we don't have a perfect
> > solution to that whenever the DMA hardware supports multiple V4L2 pixel
> > formats on a single media bus format. We might need to have a different
> > solution for this one, should it be without that receiver sub-device.
> > 
> > Could you add the CSI-2 receiver sub-device, please?
> 
> Even though the name of the controller is *very* confusing, this isn't
> a MIPI-CSI receiver, but a parallel one that supports RGB and BT656
> buses.

Right.

> 
> > > +	csi->pad.flags = MEDIA_PAD_FL_SINK | MEDIA_PAD_FL_MUST_CONNECT;
> > 
> > Could you make it IMMUTABLE and ENABLED? If there is no need to disable it,
> > that is.
> 
> The link is already created with those flags, and as far as I know it
> doesn't exist for the pads

Oops. And it wasn't even late when I reviewed the patch. :-P Please ignore
the comment --- I agree on the pad flags and the link flags (some lines up)
appear fine, too.

> 
> > > +static int csi_release(struct file *file)
> > > +{
> > > +	struct sun4i_csi *csi = video_drvdata(file);
> > > +	int ret;
> > > +
> > > +	mutex_lock(&csi->lock);
> > > +
> > > +	ret = v4l2_fh_release(file);
> > 
> > v4l2_fh_release() always returns 0. I guess it could be changed to return
> > void. The reason it has int is that it could be used as the release
> > callback as such.
> > 
> > > +	v4l2_pipeline_pm_use(&csi->vdev.entity, 0);
> > > +	pm_runtime_put(csi->dev);
> > > +
> > > +	mutex_unlock(&csi->lock);
> > > +
> > > +	return ret;
> > > +}
> 
> Do you want me to change the construct then?

Please.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
