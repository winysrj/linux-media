Return-Path: <SRS0=0You=RH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29237C43381
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 09:40:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02FAB20863
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 09:40:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbfCDJku (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Mar 2019 04:40:50 -0500
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:55883 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbfCDJkt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2019 04:40:49 -0500
X-Originating-IP: 2.224.242.101
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 37BBE40006;
        Mon,  4 Mar 2019 09:40:44 +0000 (UTC)
Date:   Mon, 4 Mar 2019 10:41:16 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Marco Felsch <m.felsch@pengutronix.de>
Cc:     Ian Arkver <ian.arkver.dev@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        hans.verkuil@cisco.com, mchehab@kernel.org, robh+dt@kernel.org,
        mark.rutland@arm.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, graphics@pengutronix.de
Subject: Re: [PATCH 1/3] media: dt-bindings: add bindings for Toshiba TC358746
Message-ID: <20190304094116.jk55nz3s3d6ki54p@uno.localdomain>
References: <20181218141240.3056-1-m.felsch@pengutronix.de>
 <20181218141240.3056-2-m.felsch@pengutronix.de>
 <20190218100333.qvptfllrd4pyhsyb@paasikivi.fi.intel.com>
 <20190301105235.a23jwiwmxejuv2yf@pengutronix.de>
 <a51ecc47-df19-a48b-3d82-01b21d03972c@gmail.com>
 <20190301130118.jy57g5wcsn7mqclk@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6osofgpxipbd6zyp"
Content-Disposition: inline
In-Reply-To: <20190301130118.jy57g5wcsn7mqclk@pengutronix.de>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--6osofgpxipbd6zyp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Marco, Ian,

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
>
> So we can add the 'maybe' dynamic switching later on.
>

I think if you model the bindings with one endpoint per input/output port,
you can just parse the endpoints, using the bus hints that are now
available, and deduct the bus types and thus the conversion directions
without introducing any custom property.

Thanks
   j


--6osofgpxipbd6zyp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlx88rwACgkQcjQGjxah
Vjyy4Q/+L0OdxbWqGSw8OascaoYGR71jJMORj06VswDijYZoj4PtV1yVPP18Q2eT
+HFrfeJu7z2Ps+qDkHU6wD8GZUEnKK05R1T8RbclSe9hBzE96hlaRMiPFKKaApRE
hIdT6q82FRTKwKCGqKQv2XkQksfzmu3a5RAceP6ts5mxO+cmyqB5om5ETBoi2qeB
dIL1sVgTT51nBN39c/Wcg3KC0fa0Mb/J5nmuKvW8rbM3B1V/vxbcY01Xa0X70x+z
abIiDNa3iduemSs2wMH0vu3W8dnJ5o3iQFurTJMXTv3EN057KZhl4krn6WQDMssC
vcu/SsciD1REKtWaHepz+JqhF5GRFbqbBJgr+30Xha5et93fr8Iv+eKQ+bOsfTZ2
d6Lb1zI2ZqFNQpz5bp08h3I1sq9bGwx/dC0OmqU52M461IfHdATt6GmxKWFy/cYZ
DATwmQlirGuU3guW4Td3C27wfuaP20OeoaHWsuVO6vMsruN5DDtwbwriTISPEi2Y
D1YbjNQIsXgsSYUMLH/fwgalHCcYyPtCrrgCx26vWZf7H5CDhkNePVMePJ53DH2T
8OfOoIPp6zNGUsKK+ENAjpZT6Fy1ok3MBFaFl2eOXP+YOQt6Zy7EZyJqCUMPKV+T
ReYk6p1Qke4wXeiRYBARneZUNLa5whWZdh0ecqTOE74SiXoR8OM=
=O1zE
-----END PGP SIGNATURE-----

--6osofgpxipbd6zyp--
