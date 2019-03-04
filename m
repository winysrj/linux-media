Return-Path: <SRS0=0You=RH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBF25C43381
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 18:17:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C204520675
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 18:17:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbfCDSRy (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Mar 2019 13:17:54 -0500
Received: from mga06.intel.com ([134.134.136.31]:5286 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726111AbfCDSRy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Mar 2019 13:17:54 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2019 10:17:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,440,1544515200"; 
   d="scan'208";a="137986633"
Received: from schmiger-mobl3.ger.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.249.45.12])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Mar 2019 10:17:51 -0800
Received: by kekkonen.fi.intel.com (Postfix, from userid 1000)
        id 4E98021E9B; Mon,  4 Mar 2019 20:17:48 +0200 (EET)
Date:   Mon, 4 Mar 2019 20:17:48 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Marco Felsch <m.felsch@pengutronix.de>
Cc:     Ian Arkver <ian.arkver.dev@gmail.com>, hans.verkuil@cisco.com,
        mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        graphics@pengutronix.de
Subject: Re: [PATCH 1/3] media: dt-bindings: add bindings for Toshiba TC358746
Message-ID: <20190304181747.ax7nvbvhdul4vtna@kekkonen.localdomain>
References: <20181218141240.3056-1-m.felsch@pengutronix.de>
 <20181218141240.3056-2-m.felsch@pengutronix.de>
 <20190218100333.qvptfllrd4pyhsyb@paasikivi.fi.intel.com>
 <20190301105235.a23jwiwmxejuv2yf@pengutronix.de>
 <a51ecc47-df19-a48b-3d82-01b21d03972c@gmail.com>
 <20190301130118.jy57g5wcsn7mqclk@pengutronix.de>
 <20190304123621.l3ocvdiya5z5wzal@paasikivi.fi.intel.com>
 <20190304165528.n4sqxjhfsplmt5km@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190304165528.n4sqxjhfsplmt5km@pengutronix.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Marco,

On Mon, Mar 04, 2019 at 05:55:28PM +0100, Marco Felsch wrote:
> > > (more device specific)
> > > tc358746,default-mode = <CSI-Tx> /* Parallel-in -> CSI-out */
> > > tc358746,default-mode = <CSI-Rx> /* CSI-in -> Parallel-out */
> > > 
> > > or
> > > 
> > > (more generic)
> > > tc358746,default-dir = <PARALLEL_TO_CSI2>
> > > tc358746,default-dir = <CSI2_TO_PARALLEL>
> > 
> > The prefix for Toshiba is "toshiba". What would you think of
> > "toshiba,csi2-direction" with values of either "rx" or "tx"? Or
> > "toshiba,csi2-mode" with either "master" or "slave", which would be a
> > little bit more generic, but could be slightly more probable to get wrong
> > as well.
> 
> You're right mixed the prefix with the device.. If we need to introduce
> a property I would prefer the "toshiba,csi2-direction" one. I said if
> because as Jacopo mentioned we can avoid the property by define port@0
> as input and port@1 as output. I tink that's the best solution, since we
> can avoid device specific bindings and it's common to use the last port
> as output (e.g. video-mux).

The ports represent hardware and I think I would avoid reordering them. I
wonder what would the DT folks prefer.

The device specific property is to the point at least: it describes an
orthogonal part of the device configuration. That's why I'd pick that if I
were to choose. But I'll let Rob to comment on this.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
