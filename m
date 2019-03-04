Return-Path: <SRS0=0You=RH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06E9DC43381
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 12:10:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D161220815
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 12:10:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbfCDMKN (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Mar 2019 07:10:13 -0500
Received: from mga04.intel.com ([192.55.52.120]:7556 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725997AbfCDMKN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Mar 2019 07:10:13 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2019 04:10:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,440,1544515200"; 
   d="scan'208";a="304220561"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga005.jf.intel.com with ESMTP; 04 Mar 2019 04:10:06 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id 245A2207E2; Mon,  4 Mar 2019 14:10:05 +0200 (EET)
Date:   Mon, 4 Mar 2019 14:10:05 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Marco Felsch <m.felsch@pengutronix.de>
Cc:     hans.verkuil@cisco.com, mchehab@kernel.org, robh+dt@kernel.org,
        mark.rutland@arm.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, graphics@pengutronix.de
Subject: Re: [PATCH 1/3] media: dt-bindings: add bindings for Toshiba TC358746
Message-ID: <20190304121004.qlqf2guz2yt7vnvu@paasikivi.fi.intel.com>
References: <20181218141240.3056-1-m.felsch@pengutronix.de>
 <20181218141240.3056-2-m.felsch@pengutronix.de>
 <20190218100333.qvptfllrd4pyhsyb@paasikivi.fi.intel.com>
 <20190301105235.a23jwiwmxejuv2yf@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190301105235.a23jwiwmxejuv2yf@pengutronix.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Macro,

On Fri, Mar 01, 2019 at 11:52:35AM +0100, Marco Felsch wrote:
> Hi Sakari,
> 
> On 19-02-18 12:03, Sakari Ailus wrote:
> > Hi Marco,
> > 
> > My apologies for reviewing this so late. You've received good comments
> > already. I have a few more.
> 
> Thanks for your review for the other patches as well =) Sorry for my
> delayed response.
> 
> > On Tue, Dec 18, 2018 at 03:12:38PM +0100, Marco Felsch wrote:
> > > Add corresponding dt-bindings for the Toshiba tc358746 device.
> > > 
> > > Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> > > ---
> > >  .../bindings/media/i2c/toshiba,tc358746.txt   | 80 +++++++++++++++++++
> > >  1 file changed, 80 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/media/i2c/toshiba,tc358746.txt
> > > 
> > > diff --git a/Documentation/devicetree/bindings/media/i2c/toshiba,tc358746.txt b/Documentation/devicetree/bindings/media/i2c/toshiba,tc358746.txt
> > > new file mode 100644
> > > index 000000000000..499733df744a
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/media/i2c/toshiba,tc358746.txt
> > > @@ -0,0 +1,80 @@
> > > +* Toshiba TC358746 Parallel to MIPI CSI2-TX or MIPI CSI2-RX to Parallel Bridge
> > > +
> > > +The Toshiba TC358746 is a bridge that converts a Parallel-in stream to MIPI CSI-2 TX
> > > +or a MIPI CSI-2 RX stream into a Parallel-out. It is programmable through I2C.
> > 
> > This is interesting. The driver somehow needs to figure out the direction
> > of the data flow if it does not originate from DT. I guess it shouldn't as
> > it's not the property of an individual device, albeit in practice in all
> > hardware I've seen the direction of the pipeline is determinable and this
> > is visible in the kAPI as well. So I'm suggesting no changes due to this in
> > bindings, likely we'll need to address it somehow elsewhere going forward.
> 
> What did you mean with "... and this is visible in the kAPI as well"?
> I'm relative new in the linux-media world but I never saw a device which
> supports two directions. Our customer which uses that chip use it
> only in parallel-in/csi-out mode. To be flexible the switching should be
> done by a subdev-ioctl but it is also reasonable to define a default value
> within the DT.

What I meant that the V4L2 sub-device API does not provide any information
on the direction. It is implicit --- MC does, but it does it based on the
links created by the driver.

I agree a DT property would be a good way to tell this, especially now that
there's a related hardware configuration (but which the software cannot
obtain directly).

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
