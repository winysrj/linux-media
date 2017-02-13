Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve1eur01on0055.outbound.protection.outlook.com ([104.47.1.55]:33376
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751007AbdBMJdR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 04:33:17 -0500
From: Thomas Axelsson <Thomas.Axelsson@cybercom.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: Device Tree formatting for multiple virtual channels in
 ti-vpe/cal driver?
Date: Mon, 13 Feb 2017 09:33:13 +0000
Message-ID: <DB5PR0701MB1909ABA116D35327C973642888590@DB5PR0701MB1909.eurprd07.prod.outlook.com>
References: <DB5PR0701MB1909024C800EFCDE9AD9C4A588440@DB5PR0701MB1909.eurprd07.prod.outlook.com>
 <20170212221629.GB16975@valkosipuli.retiisi.org.uk>
In-Reply-To: <20170212221629.GB16975@valkosipuli.retiisi.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

> -----Original Message-----
> From: Sakari Ailus [mailto:sakari.ailus@iki.fi]
> Sent: den 12 februari 2017 23:17
> To: Thomas Axelsson <Thomas.Axelsson@cybercom.com>
> Cc: linux-media@vger.kernel.org
> Subject: Re: Device Tree formatting for multiple virtual channels in ti-v=
pe/cal
> driver?
>=20
> Hi Thomas,
>=20
> On Fri, Feb 10, 2017 at 09:34:46AM +0000, Thomas Axelsson wrote:
> > Hi,
> >
> > I have a TI AM571x CPU, and I'm trying to add support for multiple
> > MIPI
> > CSI-2 virtual channels per PHY (port) to the ti-vpe/cal.c driver
> > (CAMSS/CAL peripheral, ch. 8 in Datasheet [1]). This CPU can have more
> > contexts (virtual channels) per PHY than what it has DMA handlers.
> > Each PHY may have up to 8 contexts, and there are 2 PHYs, but there
> > are only 8 DMA channels in total. It is not required to use DMA to
> > receive data from the context.
>=20
> Is there a use case for receiving more than eight streams concurrently? I
> have to admit that this does appear quite exotic if 8 would not suffice. =
How
> does the data end up to the system memory if there's no DMA? PIO...?
>=20
> What are the limitations otherwise --- how many PHYs can be used
> simultaneously? Are the 8 DMAs shared among all?
>=20

I cannot envision such a use case at the moment, but one can choose to not=
=20
send a video stream to the DMAs, and instead send it only to the VIP (Video=
=20
Input Port), which has its own DMA. However, I will never use all DMAs, so=
=20
just handing them out to each context will suffice in my case, and I do not=
=20
intend to use the VIP. I will probably skip adding Device Tree support for=
=20
specifying specific DMAs and VIP.

Both PHYs can be used at the same time. The 8 DMAs are shared by the two=20
PHYs.

> >
> > Since it will be very useful to specify which contexts will use DMA
> > and which will not, the proper place to do this seems to be the device =
tree.
> >
> > This becomes rather messy though, since it needs to be specified in
> > the device tree node pointed to by the remote-endpoint field - yet,
> > it's decided by the capabilities of the master component (in this case
> > the CAL), so the remote-endpoint is a weird place to put it.
> >
> > I have made an example [2] using the Device Tree example in
> > Documentation/devicetree/bindings/media/ti-cal.txt (my own comments).
> > In the ar0330_1 endpoint, I have:
> > * Put multiple virtual channels in "reg", as in
> >   Documentation/devicetree/bindings/mipi/dsi/mipi-dsi-bus.txt,
> > * Added "dma-write" for specifying which virtual channels should get
> written
> >   directly to memory through DMA,
> > * Added "vip" just to show that a Virtual Channel can go somewhere else
> than
> >   through DMA write.
> > * Added "pix-proc" to show that pixel processing might be applied to so=
me
> of the
> >   Virtual Channels.
> >
> > What is your advice on how to properly move forward with adding support
> like this?
> >
> > Thank you in advance.
> >
> > Best regards,
> > Thomas Axelsson
> >
> >
> > [1] http://www.ti.com/lit/gpn/am5716
> >
> > [2]
> > --------------------------------------------------
> > cal: cal@4845b000 {
> >     compatible =3D "ti,dra72-cal";
> >     ti,hwmods =3D "cal";
> >
> >     /* snip */
> >
> >     ports {
> >         #address-cells =3D <1>;
> >         #size-cells =3D <0>;
> >         csi2_0: port@0 {
> >             reg =3D <0>;                         /* PHY index, must mat=
ch port index */
> >             status =3D "okay";                   /* Enable */
> >             endpoint {
> >                 slave-mode;
> >                 remote-endpoint =3D <&ar0330_1>;
> >             };
> >         };
> >         csi2_1: port@1 {
> >             reg =3D <1>;                         /* PHY Index */
> >         };
> >     };
> > };
> >
> > i2c5: i2c@4807c000 {
> >     ar0330@10 {
> >         compatible =3D "ti,ar0330";
> >         reg =3D <0x10>;
> >         port {
> >             #address-cells =3D <1>;
> >             #size-cells =3D <0>;
> >             ar0330_1: endpoint {
> >                 reg =3D <0 1 2>;                 /* Virtual Channels */
> >                 dma-write =3D <0 2>;             /* Virtual Channels th=
at will use
> >                                                   Write DMA */
> >                 vip =3D <1>;                     /* Virtual Channel to =
send on to
> >                                                   Video Input Port */
> >                 pix-proc =3D <2>;                /* Virtual channels to=
 apply pixel
> >                                                   processing on */
> >                 clock-lanes =3D <1>;             /* Clock lane indices =
*/
> >                 data-lanes =3D <0 2 3 4>;        /* Data lane indices *=
/
> >                 remote-endpoint =3D <&csi2_0>;
> >             };
> >         };
> >     };
> > };
>=20
> --
> Kind regards,
>=20
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk


I have dug some more in V4L2, and realized that simply expanding the remote=
=20
endpoint "reg", to contain an array of values representing virtual=20
channels, will prevent identifying virtual channels on a higher level (both=
=20
ioctl and v4l2_subdev owner). This makes it impossible to configure virtual=
=20
channel level options, like video format. I need to be able to configure a=
=20
different video format for each virtual channel.

The following sequence diagram illustrates the problem:

         CAL             sensor chip          =20
          |                   |
          |------- probe ---->|
          |                   |
          |<------ subdev ----|
          |                   |
   map subdev to PHY          |
          |                   |
  4 VCs from remote "reg"     |
   - map to contexts          |
          |                   |
          :                   :
          |------- get_fmt -->|   Which VC!?
          |                   |
          |<------ err? ------|
          |                   |                userspace
          |                   |                   |
          |                   |<- ioctl: get_fmt -|   Which VC!?
          |                   |                   |
          |                   |-------- err? ---->|
          |                   |                   |


Is this approached aligned with the V4L2 design? How will I handle the=20
above scenario in such case?


I have started to think that I will need to move virtual channel mapping up=
=20
to "endpoint" level in the Device Tree, i.e. only have one value in the=20
remote endpoint "reg", but have an endpoint for each virtual channel (both=
=20
"local" and remote endpoint, since they map 1:1). In that case, each=20
virtual channel will get its unique v4l2_subdev, with which I can separate=
=20
the virtual channels within the driver and in the ioctls.

By changing the endpoints to map to virtual channels, the endpoints will no=
=20
longer map to PHYs, and the lane configuration does no longer make sense to=
=20
have in the endpoint configurations, but rather on the port level. I'm=20
feeling that I will start to leave the V4L2 Device Tree design.

Any thoughts?

Best Regards,
Thomas Axelsson
