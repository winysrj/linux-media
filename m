Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:37400 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753140AbdCNQVl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Mar 2017 12:21:41 -0400
Received: by mail-it0-f52.google.com with SMTP id g138so2792271itb.0
        for <linux-media@vger.kernel.org>; Tue, 14 Mar 2017 09:21:40 -0700 (PDT)
Message-ID: <1489508491.28116.8.camel@ndufresne.ca>
Subject: Re: [PATCH v5 15/39] [media] v4l2: add a frame interval error event
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Russell King - ARM Linux <linux@armlinux.org.uk>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, mchehab@kernel.org, nick@shmanahar.org,
        markus.heiser@darmarIT.de, p.zabel@pengutronix.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, shuah@kernel.org,
        sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Date: Tue, 14 Mar 2017 12:21:31 -0400
In-Reply-To: <20170313104538.GF21222@n2100.armlinux.org.uk>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
         <1489121599-23206-16-git-send-email-steve_longerbeam@mentor.com>
         <5b0a0e76-2524-4140-5ccc-380a8f949cfa@xs4all.nl>
         <ec05e6e0-79f2-2db2-bde9-4aed00d76faa@gmail.com>
         <6b574476-77df-0e25-a4d1-32d4fe0aec12@xs4all.nl>
         <5d5cf4a4-a4d3-586e-cd16-54f543dfcce9@gmail.com>
         <aa6a5a1d-18fd-8bed-a349-2654d2d1abe0@xs4all.nl>
         <20170313104538.GF21222@n2100.armlinux.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-aXxNYMRbWOl51MuU+KnB"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-aXxNYMRbWOl51MuU+KnB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le lundi 13 mars 2017 =C3=A0 10:45 +0000, Russell King - ARM Linux a =C3=A9=
crit=C2=A0:
> On Mon, Mar 13, 2017 at 11:02:34AM +0100, Hans Verkuil wrote:
> > On 03/11/2017 07:14 PM, Steve Longerbeam wrote:
> > > The event must be user visible, otherwise the user has no indication
> > > the error, and can't correct it by stream restart.
> >=20
> > In that case the driver can detect this and call vb2_queue_error. It's
> > what it is there for.
> >=20
> > The event doesn't help you since only this driver has this issue. So no=
body
> > will watch this event, unless it is sw specifically written for this So=
C.
> >=20
> > Much better to call vb2_queue_error to signal a fatal error (which this
> > apparently is) since there are more drivers that do this, and vivid sup=
ports
> > triggering this condition as well.
>=20
> So today, I can fiddle around with the IMX219 registers to help gain
> an understanding of how this sensor works.=C2=A0=C2=A0Several of the regi=
sters
> (such as the PLL setup [*]) require me to disable streaming on the
> sensor while changing them.
>=20
> This is something I've done many times while testing various ideas,
> and is my primary way of figuring out and testing such things.
>=20
> Whenever I resume streaming (provided I've let the sensor stop
> streaming at a frame boundary) it resumes as if nothing happened.=C2=A0=
=C2=A0If I
> stop the sensor mid-frame, then I get the rolling issue that Steve
> reports, but once the top of the frame becomes aligned with the top of
> the capture, everything then becomes stable again as if nothing happened.
>=20
> The side effect of what you're proposing is that when I disable streaming
> at the sensor by poking at its registers, rather than the capture just
> stopping, an error is going to be delivered to gstreamer, and gstreamer
> is going to exit, taking the entire capture process down.

Indeed, there is no recovery attempt in GStreamer code, and it's hard
for an higher level programs to handle this. Nothing prevents from
adding something of course, but the errors are really un-specific, so
it would be something pretty blind. For what it has been tested, this
case was never met, usually the error is triggered by a USB camera
being un-plugged, a driver failure or even a firmware crash. Most of
the time, this is not recoverable.

My main concern here based on what I'm reading, is that this driver is
not even able to notice immediately that a produced frame was corrupted
(because it's out of sync). From usability perspective, this is really
bad. Can't the driver derive a clock from some irq and calculate for
each frame if the timing was correct ? And if not mark the buffer with
V4L2_BUF_FLAG_ERROR ?

>=20
> This severely restricts the ability to be able to develop and test
> sensor drivers.
>=20
> So, I strongly disagree with you.
>=20
> Loss of capture frames is not necessarily a fatal error - as I have been
> saying repeatedly.=C2=A0=C2=A0In Steve's case, there's some unknown inter=
action
> between the source and iMX6 hardware that is causing the instability,
> but that is simply not true of other sources, and I oppose any idea that
> we should cripple the iMX6 side of the capture based upon just one
> hardware combination where this is a problem.

Indeed, it happens all the time with slow USB port and UVC devices.
Though, the driver is well aware, and mark the buffers with
V4L2_BUF_FLAG_ERROR.

>=20
> Steve suggested that the problem could be in the iMX6 CSI block - and I
> note comparing Steve's code with the code in FSL's repository that there
> are some changes that are missing in Steve's code to do with the CCIR656
> sync code setup, particularly for >8 bit.=C2=A0=C2=A0The progressive CCIR=
656 8-bit
> setup looks pretty similar though - but I think what needs to be asked
> is whether the same problem is visible using the FSL/NXP vendor kernel.
>=20
>=20
> * - the PLL setup is something that requires research at the moment.
> Sony's official position (even to their customers) is that they do not
> supply the necessary information, instead they expect customers to tell
> them the capture settings they want, and Sony will throw the values into
> a spreadsheet, and they'll supply the register settings back to the
> customer.=C2=A0=C2=A0Hence, the only way to proceed with a generic driver=
 for
> this sensor is to experiment, and experimenting requires the ability to
> pause the stream at the sensor while making changes.=C2=A0=C2=A0Take this=
 away,
> and we're stuck with the tables-of-register-settings-for-set-of-fixed-
> capture-settings approach.=C2=A0=C2=A0I've made a lot of progress away fr=
om this
> which is all down to the flexibility afforded by _not_ killing the
> capture process.
>=20
--=-aXxNYMRbWOl51MuU+KnB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAljIGIsACgkQcVMCLawGqBxCeQCdFXP+h0tRwqYm+CEUD9XQPpST
hd8An1MToB8rrzKbIs7z7j3T3D5bfN36
=9Wtr
-----END PGP SIGNATURE-----

--=-aXxNYMRbWOl51MuU+KnB--
