Return-Path: <SRS0=0You=RH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22C3DC43381
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 16:55:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE7C720643
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 16:55:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbfCDQzi (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Mar 2019 11:55:38 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:34491 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbfCDQzh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2019 11:55:37 -0500
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1h0qsD-0003U3-TT; Mon, 04 Mar 2019 17:55:29 +0100
Received: from mfe by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1h0qsC-00060u-Hp; Mon, 04 Mar 2019 17:55:28 +0100
Date:   Mon, 4 Mar 2019 17:55:28 +0100
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Ian Arkver <ian.arkver.dev@gmail.com>, hans.verkuil@cisco.com,
        mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        graphics@pengutronix.de
Subject: Re: [PATCH 1/3] media: dt-bindings: add bindings for Toshiba TC358746
Message-ID: <20190304165528.n4sqxjhfsplmt5km@pengutronix.de>
References: <20181218141240.3056-1-m.felsch@pengutronix.de>
 <20181218141240.3056-2-m.felsch@pengutronix.de>
 <20190218100333.qvptfllrd4pyhsyb@paasikivi.fi.intel.com>
 <20190301105235.a23jwiwmxejuv2yf@pengutronix.de>
 <a51ecc47-df19-a48b-3d82-01b21d03972c@gmail.com>
 <20190301130118.jy57g5wcsn7mqclk@pengutronix.de>
 <20190304123621.l3ocvdiya5z5wzal@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190304123621.l3ocvdiya5z5wzal@paasikivi.fi.intel.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 17:48:07 up 44 days, 21:30, 47 users,  load average: 0.01, 0.02,
 0.00
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sakari,

On 19-03-04 14:36, Sakari Ailus wrote:
> Hi Marco,
> 
> On Fri, Mar 01, 2019 at 02:01:18PM +0100, Marco Felsch wrote:
> > Hi Ian,
> > 
> > On 19-03-01 11:07, Ian Arkver wrote:
> > > Hi,
> > > 
> > > On 01/03/2019 10:52, Marco Felsch wrote:
> > > > Hi Sakari,
> > > > 
> > > > On 19-02-18 12:03, Sakari Ailus wrote:
> > > > > Hi Marco,
> > > > > 
> > > > > My apologies for reviewing this so late. You've received good comments
> > > > > already. I have a few more.
> > > > 
> > > > Thanks for your review for the other patches as well =) Sorry for my
> > > > delayed response.
> > > > 
> > > > > On Tue, Dec 18, 2018 at 03:12:38PM +0100, Marco Felsch wrote:
> > > > > > Add corresponding dt-bindings for the Toshiba tc358746 device.
> > > > > > 
> > > > > > Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> > > > > > ---
> > > > > >   .../bindings/media/i2c/toshiba,tc358746.txt   | 80 +++++++++++++++++++
> > > > > >   1 file changed, 80 insertions(+)
> > > > > >   create mode 100644 Documentation/devicetree/bindings/media/i2c/toshiba,tc358746.txt
> > > > > > 
> > > > > > diff --git a/Documentation/devicetree/bindings/media/i2c/toshiba,tc358746.txt b/Documentation/devicetree/bindings/media/i2c/toshiba,tc358746.txt
> > > > > > new file mode 100644
> > > > > > index 000000000000..499733df744a
> > > > > > --- /dev/null
> > > > > > +++ b/Documentation/devicetree/bindings/media/i2c/toshiba,tc358746.txt
> > > > > > @@ -0,0 +1,80 @@
> > > > > > +* Toshiba TC358746 Parallel to MIPI CSI2-TX or MIPI CSI2-RX to Parallel Bridge
> > > > > > +
> > > > > > +The Toshiba TC358746 is a bridge that converts a Parallel-in stream to MIPI CSI-2 TX
> > > > > > +or a MIPI CSI-2 RX stream into a Parallel-out. It is programmable through I2C.
> > > > > 
> > > > > This is interesting. The driver somehow needs to figure out the direction
> > > > > of the data flow if it does not originate from DT. I guess it shouldn't as
> > > > > it's not the property of an individual device, albeit in practice in all
> > > > > hardware I've seen the direction of the pipeline is determinable and this
> > > > > is visible in the kAPI as well. So I'm suggesting no changes due to this in
> > > > > bindings, likely we'll need to address it somehow elsewhere going forward.
> > > > 
> > > > What did you mean with "... and this is visible in the kAPI as well"?
> > > > I'm relative new in the linux-media world but I never saw a device which
> > > > supports two directions. Our customer which uses that chip use it
> > > > only in parallel-in/csi-out mode. To be flexible the switching should be
> > > > done by a subdev-ioctl but it is also reasonable to define a default value
> > > > within the DT.
> > > 
> > > The mode is set by a pin strap at reset time (MSEL). It's not programmable
> > > by i2c. As far as I can see, looking at the registers, it's also not
> > > readable by i2c, so there's no easy way for a driver which supports both
> > > modes to see what the pinstrap is set to.
> > > 
> > > I'm not sure if the driver could tell from the direction of the endpoints
> > > it's linked to which mode to use, but if not it'll need to be told somehow
> > > and a DT property seems reasonable to me. Given that the same pins are used
> > > in each direction I think the direction is most likely to be hard wired and
> > > board specific.
> > 
> > You're absolutly right. Sorry didn't catched this, since it's a bit out of my
> > mind.. There 'can be' cases where the MSEL is connected to a GPIO but in
> > that case the device needs a hard reset to resample the pin. Also a
> > parallel-bus mux must be in front of the device. So I think that
> > 'danymic switching' case is currently out of scope. I'm with you to
> > define the mode by a DT property is absolutly okay, the property should
> > something like:
> > 
> > (more device specific)
> > tc358746,default-mode = <CSI-Tx> /* Parallel-in -> CSI-out */
> > tc358746,default-mode = <CSI-Rx> /* CSI-in -> Parallel-out */
> > 
> > or
> > 
> > (more generic)
> > tc358746,default-dir = <PARALLEL_TO_CSI2>
> > tc358746,default-dir = <CSI2_TO_PARALLEL>
> 
> The prefix for Toshiba is "toshiba". What would you think of
> "toshiba,csi2-direction" with values of either "rx" or "tx"? Or
> "toshiba,csi2-mode" with either "master" or "slave", which would be a
> little bit more generic, but could be slightly more probable to get wrong
> as well.

You're right mixed the prefix with the device.. If we need to introduce
a property I would prefer the "toshiba,csi2-direction" one. I said if
because as Jacopo mentioned we can avoid the property by define port@0
as input and port@1 as output. I tink that's the best solution, since we
can avoid device specific bindings and it's common to use the last port
as output (e.g. video-mux).

Regards,
Marco

> -- 
> Regards,
> 
> Sakari Ailus
> sakari.ailus@linux.intel.com
> 

