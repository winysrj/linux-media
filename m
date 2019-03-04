Return-Path: <SRS0=0You=RH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E77DFC43381
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 12:36:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C10FB208E4
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 12:36:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbfCDMgZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Mar 2019 07:36:25 -0500
Received: from mga14.intel.com ([192.55.52.115]:8220 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726095AbfCDMgZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Mar 2019 07:36:25 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2019 04:36:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,440,1544515200"; 
   d="scan'208";a="128858243"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga008.fm.intel.com with ESMTP; 04 Mar 2019 04:36:22 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id 71C1A207E2; Mon,  4 Mar 2019 14:36:21 +0200 (EET)
Date:   Mon, 4 Mar 2019 14:36:21 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Marco Felsch <m.felsch@pengutronix.de>
Cc:     Ian Arkver <ian.arkver.dev@gmail.com>, hans.verkuil@cisco.com,
        mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        graphics@pengutronix.de
Subject: Re: [PATCH 1/3] media: dt-bindings: add bindings for Toshiba TC358746
Message-ID: <20190304123621.l3ocvdiya5z5wzal@paasikivi.fi.intel.com>
References: <20181218141240.3056-1-m.felsch@pengutronix.de>
 <20181218141240.3056-2-m.felsch@pengutronix.de>
 <20190218100333.qvptfllrd4pyhsyb@paasikivi.fi.intel.com>
 <20190301105235.a23jwiwmxejuv2yf@pengutronix.de>
 <a51ecc47-df19-a48b-3d82-01b21d03972c@gmail.com>
 <20190301130118.jy57g5wcsn7mqclk@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190301130118.jy57g5wcsn7mqclk@pengutronix.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Marco,

On Fri, Mar 01, 2019 at 02:01:18PM +0100, Marco Felsch wrote:
> Hi Ian,
> 
> On 19-03-01 11:07, Ian Arkver wrote:
> > Hi,
> > 
> > On 01/03/2019 10:52, Marco Felsch wrote:
> > > Hi Sakari,
> > > 
> > > On 19-02-18 12:03, Sakari Ailus wrote:
> > > > Hi Marco,
> > > > 
> > > > My apologies for reviewing this so late. You've received good comments
> > > > already. I have a few more.
> > > 
> > > Thanks for your review for the other patches as well =) Sorry for my
> > > delayed response.
> > > 
> > > > On Tue, Dec 18, 2018 at 03:12:38PM +0100, Marco Felsch wrote:
> > > > > Add corresponding dt-bindings for the Toshiba tc358746 device.
> > > > > 
> > > > > Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> > > > > ---
> > > > >   .../bindings/media/i2c/toshiba,tc358746.txt   | 80 +++++++++++++++++++
> > > > >   1 file changed, 80 insertions(+)
> > > > >   create mode 100644 Documentation/devicetree/bindings/media/i2c/toshiba,tc358746.txt
> > > > > 
> > > > > diff --git a/Documentation/devicetree/bindings/media/i2c/toshiba,tc358746.txt b/Documentation/devicetree/bindings/media/i2c/toshiba,tc358746.txt
> > > > > new file mode 100644
> > > > > index 000000000000..499733df744a
> > > > > --- /dev/null
> > > > > +++ b/Documentation/devicetree/bindings/media/i2c/toshiba,tc358746.txt
> > > > > @@ -0,0 +1,80 @@
> > > > > +* Toshiba TC358746 Parallel to MIPI CSI2-TX or MIPI CSI2-RX to Parallel Bridge
> > > > > +
> > > > > +The Toshiba TC358746 is a bridge that converts a Parallel-in stream to MIPI CSI-2 TX
> > > > > +or a MIPI CSI-2 RX stream into a Parallel-out. It is programmable through I2C.
> > > > 
> > > > This is interesting. The driver somehow needs to figure out the direction
> > > > of the data flow if it does not originate from DT. I guess it shouldn't as
> > > > it's not the property of an individual device, albeit in practice in all
> > > > hardware I've seen the direction of the pipeline is determinable and this
> > > > is visible in the kAPI as well. So I'm suggesting no changes due to this in
> > > > bindings, likely we'll need to address it somehow elsewhere going forward.
> > > 
> > > What did you mean with "... and this is visible in the kAPI as well"?
> > > I'm relative new in the linux-media world but I never saw a device which
> > > supports two directions. Our customer which uses that chip use it
> > > only in parallel-in/csi-out mode. To be flexible the switching should be
> > > done by a subdev-ioctl but it is also reasonable to define a default value
> > > within the DT.
> > 
> > The mode is set by a pin strap at reset time (MSEL). It's not programmable
> > by i2c. As far as I can see, looking at the registers, it's also not
> > readable by i2c, so there's no easy way for a driver which supports both
> > modes to see what the pinstrap is set to.
> > 
> > I'm not sure if the driver could tell from the direction of the endpoints
> > it's linked to which mode to use, but if not it'll need to be told somehow
> > and a DT property seems reasonable to me. Given that the same pins are used
> > in each direction I think the direction is most likely to be hard wired and
> > board specific.
> 
> You're absolutly right. Sorry didn't catched this, since it's a bit out of my
> mind.. There 'can be' cases where the MSEL is connected to a GPIO but in
> that case the device needs a hard reset to resample the pin. Also a
> parallel-bus mux must be in front of the device. So I think that
> 'danymic switching' case is currently out of scope. I'm with you to
> define the mode by a DT property is absolutly okay, the property should
> something like:
> 
> (more device specific)
> tc358746,default-mode = <CSI-Tx> /* Parallel-in -> CSI-out */
> tc358746,default-mode = <CSI-Rx> /* CSI-in -> Parallel-out */
> 
> or
> 
> (more generic)
> tc358746,default-dir = <PARALLEL_TO_CSI2>
> tc358746,default-dir = <CSI2_TO_PARALLEL>

The prefix for Toshiba is "toshiba". What would you think of
"toshiba,csi2-direction" with values of either "rx" or "tx"? Or
"toshiba,csi2-mode" with either "master" or "slave", which would be a
little bit more generic, but could be slightly more probable to get wrong
as well.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
