Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28F72C43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 18:14:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F338820645
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 18:14:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728735AbfCESOc (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 13:14:32 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:36511 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728640AbfCESOb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 13:14:31 -0500
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1h1Ea5-00042o-Ry; Tue, 05 Mar 2019 19:14:21 +0100
Received: from mfe by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1h1Ea3-00051v-GR; Tue, 05 Mar 2019 19:14:19 +0100
Date:   Tue, 5 Mar 2019 19:14:19 +0100
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     Jacopo Mondi <jacopo@jmondi.org>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Ian Arkver <ian.arkver.dev@gmail.com>, hans.verkuil@cisco.com,
        mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        graphics@pengutronix.de
Subject: Re: [PATCH 1/3] media: dt-bindings: add bindings for Toshiba TC358746
Message-ID: <20190305181419.kqdaqnjte3v7663f@pengutronix.de>
References: <20181218141240.3056-1-m.felsch@pengutronix.de>
 <20181218141240.3056-2-m.felsch@pengutronix.de>
 <20190218100333.qvptfllrd4pyhsyb@paasikivi.fi.intel.com>
 <20190301105235.a23jwiwmxejuv2yf@pengutronix.de>
 <a51ecc47-df19-a48b-3d82-01b21d03972c@gmail.com>
 <20190301130118.jy57g5wcsn7mqclk@pengutronix.de>
 <20190304123621.l3ocvdiya5z5wzal@paasikivi.fi.intel.com>
 <20190304165528.n4sqxjhfsplmt5km@pengutronix.de>
 <20190304181747.ax7nvbvhdul4vtna@kekkonen.localdomain>
 <20190305084902.vzaqr53q77oy2o7r@uno.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190305084902.vzaqr53q77oy2o7r@uno.localdomain>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 19:04:09 up 45 days, 22:46, 50 users,  load average: 0.02, 0.05,
 0.02
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Rob,

I think you didn't followed the discussion in detail so I will ask you
personal. In short the tc358746 can act as parallel-in -> csi-out or as
csi->in -> parallel-out device. The phyiscal pins are always the same
only the internal timings are different. So we have two ports with two
endpoints.

Now the question is how we determine the mode. We have two approaches:
1)
  port@0 -> input port
  port@1 -> output port

  pro:
  + no extra vendor specific binding is needed to determine the mode

  con:
  - input/output endpoint can be parallel or mipi-csi2.

2)
  port@0 -> parallel port
  port@1 -> mipi-csi2 port

  pro:
  + input/output endpoint are fixed to parallel or mipi

  con:
  - vendor specific binding is needed to determine the mode

Thanks for your comments :)

Regards,
Marco

On 19-03-05 09:49, Jacopo Mondi wrote:
> Hi Sakari, Marco,
> 
> On Mon, Mar 04, 2019 at 08:17:48PM +0200, Sakari Ailus wrote:
> > Hi Marco,
> >
> > On Mon, Mar 04, 2019 at 05:55:28PM +0100, Marco Felsch wrote:
> > > > > (more device specific)
> > > > > tc358746,default-mode = <CSI-Tx> /* Parallel-in -> CSI-out */
> > > > > tc358746,default-mode = <CSI-Rx> /* CSI-in -> Parallel-out */
> > > > >
> > > > > or
> > > > >
> > > > > (more generic)
> > > > > tc358746,default-dir = <PARALLEL_TO_CSI2>
> > > > > tc358746,default-dir = <CSI2_TO_PARALLEL>
> > > >
> > > > The prefix for Toshiba is "toshiba". What would you think of
> > > > "toshiba,csi2-direction" with values of either "rx" or "tx"? Or
> > > > "toshiba,csi2-mode" with either "master" or "slave", which would be a
> > > > little bit more generic, but could be slightly more probable to get wrong
> > > > as well.
> > >
> > > You're right mixed the prefix with the device.. If we need to introduce
> > > a property I would prefer the "toshiba,csi2-direction" one. I said if
> > > because as Jacopo mentioned we can avoid the property by define port@0
> > > as input and port@1 as output. I tink that's the best solution, since we
> > > can avoid device specific bindings and it's common to use the last port
> > > as output (e.g. video-mux).
> >
> > The ports represent hardware and I think I would avoid reordering them. I
> > wonder what would the DT folks prefer.
> >
> 
> I might have missed why you mention re-ordering? :)
> 
> > The device specific property is to the point at least: it describes an
> > orthogonal part of the device configuration. That's why I'd pick that if I
> > were to choose. But I'll let Rob to comment on this.
> 
> That's true indeed. Let's wait for inputs from DT people, I'm fine
> with both approaches.
> 
> Thanks
>    j
> 
> >
> > --
> > Regards,
> >
> > Sakari Ailus
> > sakari.ailus@linux.intel.com



-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
