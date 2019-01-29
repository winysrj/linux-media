Return-Path: <SRS0=OvUS=QF=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E6EDC169C4
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 13:20:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66A152147A
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 13:20:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbfA2NUY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 29 Jan 2019 08:20:24 -0500
Received: from mga02.intel.com ([134.134.136.20]:15138 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbfA2NUX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Jan 2019 08:20:23 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2019 05:20:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,537,1539673200"; 
   d="scan'208";a="120377237"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga008.fm.intel.com with ESMTP; 29 Jan 2019 05:20:18 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id 9F217205C8; Tue, 29 Jan 2019 15:20:15 +0200 (EET)
Date:   Tue, 29 Jan 2019 15:20:15 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Ken Sloat <ken.sloat@ohmlinxelectronics.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, yong.deng@magewell.com,
        mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        maxime.ripard@bootlin.com, wens@csie.org,
        kieran.bingham@ideasonboard.com, laurent.pinchart@ideasonboard.com,
        jean-michel.hautbois@vodalys.com,
        Nate Drude <nate.drude@ohmlinxelectronics.com>,
        devicetree@vger.kernel.org
Subject: Re: devicetree: media: Documentation of Bt.656 Bus DT bindings
Message-ID: <20190129132015.tvtzycrzr46kotbt@paasikivi.fi.intel.com>
References: <CAPo_4QDW0r22ZTqtS_NDFWB3NFLBx9YEGgWKb-P9A3t_TBAFMQ@mail.gmail.com>
 <c4d68627-b26a-6402-daf4-5cd103ec9fd0@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4d68627-b26a-6402-daf4-5cd103ec9fd0@xs4all.nl>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Ken, Hans,

On Mon, Jan 28, 2019 at 02:11:54PM +0100, Hans Verkuil wrote:
> +Sakari

Thanks for cc'ing me!

> 
> On 1/24/19 3:53 AM, Ken Sloat wrote:
> > There are a number of v4l2 subdevices in the kernel that support a
> > Bt.656 bus also known as "embedded sync." Previously in older versions
> > of the kernel (and in the current 4.14 LTS kernel), the standard way
> > to enable this in device tree on a parallel bus was to simply omit all
> > hysync and vsync flags.
> > 
> > During some other kernel development I was doing, it was brought to my
> > attention that there is now a standard defined binding in
> > "video-interfaces.txt" called "bus-type" that should be used in order
> > to enable Bt.656 mode. While omitting the flags still appears to work
> > because of other assumptions made in v4l2-fwnode driver, this method
> > is now outdated and improper.
> > 
> > However, I have noticed that several dt binding docs have not been
> > updated to reflect this change and still reference the old method:
> > 
> > Documentation/devicetree/bindings/media/sun6i-csi.txt
> > /* If hsync-active/vsync-active are missing,
> >    embedded BT.656 sync is used */
> > 
> > Documentation/devicetree/bindings/media/i2c/tvp5150.txt
> > "If none of hsync-active, vsync-active and field-even-active is specified,
> > the endpoint is assumed to use embedded BT.656 synchronization."
> > 
> > Documentation/devicetree/bindings/media/i2c/adv7604.txt
> > "If none of hsync-active, vsync-active and pclk-sample is specified the
> >   endpoint will use embedded BT.656 synchronization."
> > 
> > and amazingly even
> > Documentation/devicetree/bindings/media/video-interfaces.txt in one of
> > the code snippets
> > /* If hsync-active/vsync-active are missing,
> >    embedded BT.656 sync is used */

Yeah, these are the old bindings indeed.

> > 
> > In order to avoid future confusion in the matter and ensure that the
> > proper bindings are used, I am proposing submitting patches to update
> > these docs to at minimum remove these statements and maybe even adding
> > additional comments specifying the optional property and value for
> > Bt.656 where missing. I wanted to open a discussion here first before
> > doing this though. Thoughts?

I agree. If a device supports different busses on the same port, then the
bus-type property is needed. This is often the case for Bt.656 and parallel
(Bt.601?) interfaces.

This should be documented so that new devices would use the bus type. The
existing bindings still need to be supported in drivers though.

I cc'd the devicetree list as well.

> > 
> > Thanks,
> > Ken Sloat
> > 
> 
> I certainly agree that this should be updated to make it all consistent.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
