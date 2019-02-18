Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEF9FC43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 12:00:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B72CE2147C
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 12:00:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730104AbfBRMAj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 07:00:39 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45474 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728394AbfBRMAj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 07:00:39 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id A370E634C7B;
        Mon, 18 Feb 2019 13:59:45 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1gvhaL-0003gx-Da; Mon, 18 Feb 2019 13:59:45 +0200
Date:   Mon, 18 Feb 2019 13:59:45 +0200
From:   "sakari.ailus@iki.fi" <sakari.ailus@iki.fi>
To:     Rob Herring <robh@kernel.org>
Cc:     Ken Sloat <KSloat@aampglobal.com>,
        "eugen.hristev@microchip.com" <eugen.hristev@microchip.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "ludovic.desroches@microchip.com" <ludovic.desroches@microchip.com>,
        "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] media: atmel-isc: Update device tree binding
 documentation
Message-ID: <20190218115945.oevov3zatqnttrwx@valkosipuli.retiisi.org.uk>
References: <20190204141756.234563-1-ksloat@aampglobal.com>
 <20190204141756.234563-2-ksloat@aampglobal.com>
 <20190214154422.GA18167@bogus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190214154422.GA18167@bogus>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Feb 14, 2019 at 09:44:22AM -0600, Rob Herring wrote:
> On Mon, Feb 04, 2019 at 02:18:14PM +0000, Ken Sloat wrote:
> > From: Ken Sloat <ksloat@aampglobal.com>
> 
> Needs a better subject, not one that applies to any change. Update with 
> what?
> 
> > Update device tree binding documentation specifying how to
> > enable BT656 with CRC decoding and specify properties for
> > default parallel bus type.
> > 
> > Signed-off-by: Ken Sloat <ksloat@aampglobal.com>
> > ---
> >  Changes in v2:
> >  -Use correct media "bus-type" dt property.
> > 
> >  Changes in v3:
> >  -Specify default bus type.
> >  -Document optional parallel bus flags.
> > 
> >  .../devicetree/bindings/media/atmel-isc.txt       | 15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/media/atmel-isc.txt b/Documentation/devicetree/bindings/media/atmel-isc.txt
> > index bbe0e87c6188..db3749a3964f 100644
> > --- a/Documentation/devicetree/bindings/media/atmel-isc.txt
> > +++ b/Documentation/devicetree/bindings/media/atmel-isc.txt
> > @@ -21,6 +21,21 @@ Required properties for ISC:
> >  - pinctrl-names, pinctrl-0
> >  	Please refer to pinctrl-bindings.txt.
> >  
> > +Optional properties for ISC:
> > +- bus-type
> > +	When set to 6, Bt.656 decoding (embedded sync) with CRC decoding
> > +	is enabled. If omitted, then the default bus-type is parallel and
> > +	the additional properties to follow can be specified:
> > +- hsync-active
> > +	Active state of the HSYNC signal, 0/1 for LOW/HIGH respectively.
> > +	If unspecified, this signal is set as active HIGH.
> > +- vsync-active
> > +	Active state of the VSYNC signal, 0/1 for LOW/HIGH respectively.
> > +	If unspecified, this signal is set as active HIGH.
> > +- pclk-sample
> > +	Sample data on rising (1) or falling (0) edge of the pixel clock
> > +	signal. If unspecified, data is sampled on the rising edge.
> 
> These are all common properties, right? No need to redefine them. Just 
> reference the common doc. Maybe the default needs to be stated here if 
> different or not defined.

Yeah, video-interfaces.txt does not define the defaults; it's hardware
specific.

-- 
Sakari Ailus
