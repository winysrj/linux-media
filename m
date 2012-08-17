Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:55442 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757841Ab2HQKvz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 06:51:55 -0400
Received: by lahd3 with SMTP id d3so2065526lah.0
        for <linux-media@vger.kernel.org>; Fri, 17 Aug 2012 03:51:52 -0700 (PDT)
Message-ID: <1345200709.11073.27.camel@lappyti>
Subject: Re: [RFC 3/5] video: panel: Add MIPI DBI bus support
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	Bryan Wu <bryan.wu@canonical.com>,
	Richard Purdie <rpurdie@rpsys.net>,
	Marcus Lorentzon <marcus.lorentzon@linaro.org>,
	Sumit Semwal <sumit.semwal@ti.com>,
	Archit Taneja <archit@ti.com>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	Inki Dae <inki.dae@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Date: Fri, 17 Aug 2012 13:51:49 +0300
In-Reply-To: <1682445.1yJVVY1ksn@avalon>
References: <1345164583-18924-1-git-send-email-laurent.pinchart@ideasonboard.com>
	 <1345164583-18924-4-git-send-email-laurent.pinchart@ideasonboard.com>
	 <1345194182.3158.66.camel@deskari> <1682445.1yJVVY1ksn@avalon>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Nhjdg7wkrswexoU3GwIf"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-Nhjdg7wkrswexoU3GwIf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-08-17 at 12:02 +0200, Laurent Pinchart wrote:
> Hi Tomi,
>=20
> Thank you for the review.
>=20
> On Friday 17 August 2012 12:03:02 Tomi Valkeinen wrote:
> > On Fri, 2012-08-17 at 02:49 +0200, Laurent Pinchart wrote:
> > > +/*
> > > ---------------------------------------------------------------------=
----
> > > ---- + * Bus operations
> > > + */
> > > +
> > > +void panel_dbi_write_command(struct panel_dbi_device *dev, unsigned =
long
> > > cmd) +{
> > > +	dev->bus->ops->write_command(dev->bus, cmd);
> > > +}
> > > +EXPORT_SYMBOL_GPL(panel_dbi_write_command);
> > > +
> > > +void panel_dbi_write_data(struct panel_dbi_device *dev, unsigned lon=
g
> > > data) +{
> > > +	dev->bus->ops->write_data(dev->bus, data);
> > > +}
> > > +EXPORT_SYMBOL_GPL(panel_dbi_write_data);
> > > +
> > > +unsigned long panel_dbi_read_data(struct panel_dbi_device *dev)
> > > +{
> > > +	return dev->bus->ops->read_data(dev->bus);
> > > +}
> > > +EXPORT_SYMBOL_GPL(panel_dbi_read_data);
> >=20
> > I'm not that familiar with how to implement bus drivers, can you
> > describe in pseudo code how the SoC's DBI driver would register these?
>=20
> Sure.
>=20
> The DBI bus driver first needs to create a panel_dbi_bus_ops instance:
>=20
> static const struct panel_dbi_bus_ops sh_mobile_lcdc_dbi_bus_ops =3D {
>         .write_command =3D lcdc_dbi_write_command,
>         .write_data =3D lcdc_dbi_write_data,
>         .read_data =3D lcdc_dbi_read_data,
> };

Thanks for the example, I think it cleared up things a bit.

As I mentioned earlier, I really think "panel" is not right here. While
the whole framework may be called panel framework, the bus drivers are
not panels, and we should support external chips also, which are not
panels either.

> > I think write/read data functions are a bit limited. Shouldn't they be
> > something like write_data(const u8 *buf, int size) and read_data(u8
> > *buf, int len)?
>=20
> Good point. My hardware doesn't support multi-byte read/write operations=
=20
> directly so I haven't thought about adding those.

OMAP HW doesn't support it either. Well, not quite true, as OMAP's
system DMA could be used to write a buffer to the DBI output. But that's
really the same as doing the write with a a loop with CPU.

But first, the data type should be byte, not unsigned long. How would
you write 8 bits or 16 bits with your API? And second, if the function
takes just u8, you'd need lots of calls to do simple writes.=20

> Can your hardware group command + data writes in a single operation ? If =
so we=20
> should expose that at the API level as well.

No it can't. But with DCS that is a common operation, so we could have
some helpers to send command + data with one call. Then again, I'd hope
to have DCS somehow as a separate library, which would then use
DBI/DSI/whatnot to actually send the data.

I'm not quite sure how easy that is because of the differences between
the busses.

> Is DBI limited to 8-bit data transfers for commands ? Pixels can be=20
> transferred 16-bit at a time, commands might as well. While DCS only spec=
ifies=20
> 8-bit command/data, DBI panels that are not DCS compliant can use 16-bit=
=20
> command/data (the R61505 panel, albeit a SYS-80 panel, does so).

I have to say I don't remember much about DBI =3D). Looking at OMAP's
driver, which was made for omap2 and hasn't been much updated since, I
see that there are 4 modes, 8/9/12/16 bits. I think that defines how
many of the parallel data lines are used.

However, I don't think that matters for the panel driver when it wants
to send data. The panel driver should just call dbi_write(buf, buf_len),
and the dbi driver would send the data in the buffer according to the
bus width.

Also note that some chips need to change the bus width on the fly. The
chip used on N800 wants configuration to be done with 8-bits, and pixel
transfers with 16-bits. Who knows why...

So I think this, and generally most of the configuration, should be
somewhat dynamic, so that the panel driver can change them when it
needs.

> > Something that's totally missing is configuring the DBI bus. There are =
a
> > bunch of timing related values that need to be configured. See
> > include/video/omapdss.h struct rfbi_timings. While the struct is OMAP
> > specific, if I recall right most of the values match to the MIPI DBI
> > spec.
>=20
> I've left that out currently, and thought about passing that information =
as=20
> platform data to the DBI bus driver. That's the easiest solution, but I a=
gree=20
> that it's a hack. Panel should expose their timing requirements to the DB=
I=20
> host. API wise that wouldn't be difficult (we only need to add timing=20
> information to the panel platform data and add a function to the DBI API =
to=20
> retrieve it), one of challenges might be to express it in a way that's bo=
th=20
> universal enough and easy to use for DBI bus drivers.

As I pointed above, I think the panel driver shouldn't expose it, but
the panel driver should somehow set it. Or at least allowed to change it
in some manner. This is actually again, the same problem as with enable
and transfer: who controls what's going on.

How I think it should work is something like:

mipi_dbi_set_timings(dbi_dev, mytimings);
mipi_dbi_set_bus_width(dbi_dev, 8);
mipi_dbi_write(dbi_dev, ...);
mipi_dbi_set_bus_width(dbi_dev, 16);
start_frame_transfer(dbi_dev, ...);

> > And this makes me wonder, you use DBI bus for SYS-80 panel. The busses
> > may look similar in operation, but are they really so similar when you
> > take into account the timings (and perhaps something else, it's been
> > years since I read the MIPI DBI spec)?
>=20
> I'll have to check all the details. SYS-80 is similar to DBI-B, but suppo=
rts a=20
> wider bus width of 18 bits. I think the interfaces are similar enough to =
use a=20
> single bus implementation, possibly with quirks and/or options (see SCCB=
=20
> support in I2C for instance, with flags to ignore acks, force a stop bit=
=20
> generation, ...). We would duplicate lots of code if we had two different=
=20
> implementations, and would prevent a DBI panel to be attached to a SYS-80=
 host=20
> and vice-versa (the format is known to work).

Ah ok, if a DBI panel can be connected to SYS-80 output and vice versa,
then I agree they are similar enough.

> We might just need to provide fake timings. Video mode timings are at the=
 core=20
> of display support in all drivers so we can't just get rid of them. The h=
/v=20
> front/back porch and sync won't be used by display drivers for DBI/DSI pa=
nels=20
> anyway.

Right. But we should probably think if we can, at the panel level,
easily separate conventional panels and smart panels. Then this
framework wouldn't need to fake the timings, and it'd be up to the
higher level to decide if and how to fake them. Then again, this is no
biggie. Just thought that at the lowest level it'd be nice to be
"correct" and leave faking to upper layers =3D).

 Tomi


--=-Nhjdg7wkrswexoU3GwIf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQLiJFAAoJEPo9qoy8lh71ykAP/2OlDF/eKj0uyj8RhDqxjrCk
kCDpeypbkQQIqk/sn/6D98kfg2/3qFfwpxIOyPo1tkqbsPXkcaLzIH/tfzkGEUVS
3OrSG4DhcpfBRpBNKzUorSTubW7xRK1r+i3sOWQd7pLxf7dRcVoOa4gAkXBoGiY4
0RCdTfUDPDLmd+uKXaJqbcBJ9tiFG49xm62+0HuCXlcRynhzOJNrS7YHzG9seGtT
4ABPANHQTOXSFCXMKPdBx3Zpj8XD6czKf+wGhSgaBL1/vRe31DEGZTJ64rnRszA/
KEfY2NEzqwS6xRCfAcXwDTyRm+fuyCwtoxLfGb9Mi+agg09C1MiShISNAc9+yhqE
ShmI+ei6JthKIDUG9VOxvjdcYl69is+2FOEMs7Oe9j45dZExOmulvDBioHSO/UIr
ECOzhqnjEJNs26+EHVCWdiXVlHYu33sxyFukXD1QKs5VnF2OXLv10ILTVDwQLvD+
y71UQCQSq1jfT0EZUazLmrBIa3xZrkFZzR9dpBMCi2l+dMj6IB2CaBoNtNGG9Y3Q
1LUBHjKqF7n786HS/9fMDLW4Utd4PsZVblQCZFj5ZoGE8QHz+vYchl/1g06JJ5ed
YNzFg/WwjNRUF+nbHk1vftJCedVj2BrapGq7GqGzQikkfy6f810TYjnoWMVl1dUe
MgxkS9MdcqGXhu5bBtke
=+RCM
-----END PGP SIGNATURE-----

--=-Nhjdg7wkrswexoU3GwIf--

