Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:46785 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752767AbeADOFI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Jan 2018 09:05:08 -0500
Date: Thu, 4 Jan 2018 15:05:06 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Yong <yong.deng@magewell.com>
Cc: =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Rick Chang <rick.chang@mediatek.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [linux-sunxi] [PATCH v4 0/2] Initial Allwinner V3s CSI Support
Message-ID: <20180104140506.6owumj2pujux6sga@flea.lan>
References: <1513935138-35223-1-git-send-email-yong.deng@magewell.com>
 <1513950408.841.81.camel@megous.com>
 <20171225111526.4663f997f5d6bfc6cf157f10@magewell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oykwcvhw3gr6zz5p"
Content-Disposition: inline
In-Reply-To: <20171225111526.4663f997f5d6bfc6cf157f10@magewell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--oykwcvhw3gr6zz5p
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 25, 2017 at 11:15:26AM +0800, Yong wrote:
> Hi,
>=20
> On Fri, 22 Dec 2017 14:46:48 +0100
> Ond=C5=99ej Jirman <megous@megous.com> wrote:
>=20
> > Hello,
> >=20
> > Yong Deng p=C3=AD=C5=A1e v P=C3=A1 22. 12. 2017 v 17:32 +0800:
> > > This patchset add initial support for Allwinner V3s CSI.
> > >=20
> > > Allwinner V3s SoC have two CSI module. CSI0 is used for MIPI interface
> > > and CSI1 is used for parallel interface. This is not documented in
> > > datasheet but by testing and guess.
> > >=20
> > > This patchset implement a v4l2 framework driver and add a binding=20
> > > documentation for it.=20
> > >=20
> > > Currently, the driver only support the parallel interface. And has be=
en
> > > tested with a BT1120 signal which generating from FPGA. The following
> > > fetures are not support with this patchset:
> > >   - ISP=20
> > >   - MIPI-CSI2
> > >   - Master clock for camera sensor
> > >   - Power regulator for the front end IC
> > >=20
> > > Thanks for Ond=C5=99ej Jirman's help.
> > >=20
> > > Changes in v4:
> > >   * Deal with the CSI 'INNER QUEUE'.
> > >     CSI will lookup the next dma buffer for next frame before the
> > >     the current frame done IRQ triggered. This is not documented
> > >     but reported by Ond=C5=99ej Jirman.
> > >     The BSP code has workaround for this too. It skip to mark the
> > >     first buffer as frame done for VB2 and pass the second buffer
> > >     to CSI in the first frame done ISR call. Then in second frame
> > >     done ISR call, it mark the first buffer as frame done for VB2
> > >     and pass the third buffer to CSI. And so on. The bad thing is
> > >     that the first buffer will be written twice and the first frame
> > >     is dropped even the queued buffer is sufficient.
> > >     So, I make some improvement here. Pass the next buffer to CSI
> > >     just follow starting the CSI. In this case, the first frame
> > >     will be stored in first buffer, second frame in second buffer.
> > >     This mothed is used to avoid dropping the first frame, it
> > >     would also drop frame when lacking of queued buffer.
> > >   * Fix: using a wrong mbus_code when getting the supported formats
> > >   * Change all fourcc to pixformat
> > >   * Change some function names
> > >=20
> > > Changes in v3:
> > >   * Get rid of struct sun6i_csi_ops
> > >   * Move sun6i-csi to new directory drivers/media/platform/sunxi
> > >   * Merge sun6i_csi.c and sun6i_csi_v3s.c into sun6i_csi.c
> > >   * Use generic fwnode endpoints parser
> > >   * Only support a single subdev to make things simple
> > >   * Many complaintion fix
> > >=20
> > > Changes in v2:=20
> > >   * Change sunxi-csi to sun6i-csi
> > >   * Rebase to media_tree master branch=20
> > >=20
> > > Following is the 'v4l2-compliance -s -f' output, I have test this
> > > with both interlaced and progressive signal:
> > >=20
> > > # ./v4l2-compliance -s -f
> > > v4l2-compliance SHA   : 6049ea8bd64f9d78ef87ef0c2b3dc9b5de1ca4a1
> > >=20
> > > Driver Info:
> > >         Driver name   : sun6i-video
> > >         Card type     : sun6i-csi
> > >         Bus info      : platform:csi
> > >         Driver version: 4.15.0
> > >         Capabilities  : 0x84200001
> > >                 Video Capture
> > >                 Streaming
> > >                 Extended Pix Format
> > >                 Device Capabilities
> > >         Device Caps   : 0x04200001
> > >                 Video Capture
> > >                 Streaming
> > >                 Extended Pix Format
> > >=20
> > > Compliance test for device /dev/video0 (not using libv4l2):
> > >=20
> > > Required ioctls:
> > >         test VIDIOC_QUERYCAP: OK
> > >=20
> > > Allow for multiple opens:
> > >         test second video open: OK
> > >         test VIDIOC_QUERYCAP: OK
> > >         test VIDIOC_G/S_PRIORITY: OK
> > >         test for unlimited opens: OK
> > >=20
> > > Debug ioctls:
> > >         test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
> > >         test VIDIOC_LOG_STATUS: OK (Not Supported)
> > >=20
> > > Input ioctls:
> > >         test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
> > >         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
> > >         test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
> > >         test VIDIOC_ENUMAUDIO: OK (Not Supported)
> > >         test VIDIOC_G/S/ENUMINPUT: OK
> > >         test VIDIOC_G/S_AUDIO: OK (Not Supported)
> > >         Inputs: 1 Audio Inputs: 0 Tuners: 0
> > >=20
> > > Output ioctls:
> > >         test VIDIOC_G/S_MODULATOR: OK (Not Supported)
> > >         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
> > >         test VIDIOC_ENUMAUDOUT: OK (Not Supported)
> > >         test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
> > >         test VIDIOC_G/S_AUDOUT: OK (Not Supported)
> > >         Outputs: 0 Audio Outputs: 0 Modulators: 0
> > >=20
> > > Input/Output configuration ioctls:
> > >         test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
> > >         test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
> > >         test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
> > >         test VIDIOC_G/S_EDID: OK (Not Supported)
> > >=20
> > > Test input 0:
> > >=20
> > >         Control ioctls:
> > >                 test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK (Not Support=
ed)
> > >                 test VIDIOC_QUERYCTRL: OK (Not Supported)
> > >                 test VIDIOC_G/S_CTRL: OK (Not Supported)
> > >                 test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
> > >                 test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supp=
orted)
> > >                 test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
> > >                 Standard Controls: 0 Private Controls: 0
> >=20
> > I'm not sure if your driver passes control queries to the subdev. It
> > did not originally, and I'm not sure you picked up the change from my
> > version of the driver. "Not supported" here seems to indicate that it
> > does not.
> >=20
> > I'd be interested what's the recommended practice here. It sure helps
> > with some apps that expect to be able to modify various input controls
> > directly on the /dev/video# device. These are then supported out of the
> > box.
> >=20
> > It's a one-line change. See:
> >=20
> > https://www.kernel.org/doc/html/latest/media/kapi/v4l2-controls.html#in
> > heriting-controls
>=20
> I think this is a feature and not affect the driver's main function.
> I just focused on making the CSI main function to work properly in=20
> the initial version. Is this feature mandatory or most commonly used?

I agree here. Adding more and more features along the iterations is
just the best way to never get something merged.

Let's focus on a good basis that this driver provides, merge that, and
then build on top of it.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--oykwcvhw3gr6zz5p
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlpONJEACgkQ0rTAlCFN
r3Q9Yg//XhGMLOo9SOrIpaSZvMCK9isLrftMCJtYu6+X6Mx9c8liyzrLGoNvHcDR
Inv9px0DavmLQcs8BGlwz/aTo7HHCWcJJr7JD2CleUdMlxn0N8Jd1bXXHnWuF+oC
mblG8S7vyF2z7IkZL8p0dEBU/4YOPOnkxhV26PK+d1gMB5Ele/95rtgDUwQ97/Ms
Cl5qI89FCrbedp4yEVUeFJPmAuu19w/phWHhwp72RVD6YaAi33sSdEk7jIiF2Hf5
bFhjGYQGIKcjgQlt/pWFMMrUH47SqoCB1/q0y0ji8Fx3vPUsGo8jmiPwuJy/Ndmz
crHb8W7uFym8vxxuRbk1QAFkVNYzzF5fP2zPPgC5Wkw/VP9GMrMZW3gIfXPmcnay
rhFV6/6DZ7jARzXq1SizoNgSAjDyzUO0JatlMWBywNUond5kMPDlXZ//sBhLdodl
UwI+RkPY2Bvpt4UQOU2ShY9TCzfYBitvDbBhvCh1gwdAccdT6KBzJVltEyz6HfiT
Swbadv22YNd0DRngFyJBM+7XQhb5tLVz5LDfIKO8ZM62+TSmOFwftpY+OWHn2t/e
qx91CV2xZy6Q4nCzkG0r1M7ZQyfT9N2sEHRLXe0/844eNRz++BRXfSpbCv6pY3YJ
w74BChsVkh8QsEPbahmbssW7AFMFxnKEkakHdjzEiZOZSfOi3cY=
=GuLV
-----END PGP SIGNATURE-----

--oykwcvhw3gr6zz5p--
