Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:50431 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756462Ab2HQNGg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 09:06:36 -0400
Received: by lahl5 with SMTP id l5so4106129lah.1
        for <linux-media@vger.kernel.org>; Fri, 17 Aug 2012 06:06:33 -0700 (PDT)
Message-ID: <1345208790.3158.133.camel@deskari>
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
Date: Fri, 17 Aug 2012 16:06:30 +0300
In-Reply-To: <2019849.eCaIrHMssh@avalon>
References: <1345164583-18924-1-git-send-email-laurent.pinchart@ideasonboard.com>
	 <1682445.1yJVVY1ksn@avalon> <1345200709.11073.27.camel@lappyti>
	 <2019849.eCaIrHMssh@avalon>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-NXIbi5QJeo5/5880y2r2"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-NXIbi5QJeo5/5880y2r2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-08-17 at 14:33 +0200, Laurent Pinchart wrote:

> > But first, the data type should be byte, not unsigned long. How would
> > you write 8 bits or 16 bits with your API?
>=20
> u8 and u16 both fit in an unsigned long :-) Please see below.

Ah, I see, so the driver would just discard 24 bits or 16 bits from the
ulong. I somehow thought that if you have 8 bit bus, and you call the
write with ulong, 4 bytes will be written.

> > Then again, I'd hope to have DCS somehow as a separate library, which w=
ould
> > then use DBI/DSI/whatnot to actually send the data.
> >=20
> > I'm not quite sure how easy that is because of the differences between
> > the busses.
> >=20
> > > Is DBI limited to 8-bit data transfers for commands ? Pixels can be
> > > transferred 16-bit at a time, commands might as well. While DCS only
> > > specifies 8-bit command/data, DBI panels that are not DCS compliant c=
an
> > > use 16-bit command/data (the R61505 panel, albeit a SYS-80 panel, doe=
s
> > > so).
> >=20
> > I have to say I don't remember much about DBI =3D). Looking at OMAP's
> > driver, which was made for omap2 and hasn't been much updated since, I
> > see that there are 4 modes, 8/9/12/16 bits. I think that defines how
> > many of the parallel data lines are used.
>=20
> SYS-80 also has an 18-bits mode, where bits 0 and 9 are always ignored wh=
en=20
> transferring instructions and data other than pixels (for pixels the 18-b=
its=20
> bus width can be used to transfer RGB666 in a single clock cycle).
>=20
> See page 87 of=20
> http://read.pudn.com/downloads91/sourcecode/others/348230/e61505_103a.pdf=
.
>=20
> > However, I don't think that matters for the panel driver when it wants
> > to send data. The panel driver should just call dbi_write(buf, buf_len)=
,
> > and the dbi driver would send the data in the buffer according to the
> > bus width.
>=20
> According to the DCS specification, commands and parameters are transferr=
ed=20
> using 8-bit data. Non-DCS panels can however use wider commands and param=
eters=20
> (all commands and parameters are 16-bits wide for the R61505 for instance=
).
>=20
> We can add an API to switch the DBI bus width on the fly. For Renesas har=
dware=20
> this would "just" require shifting bits around to output the 8-bit or 16-=
bit=20
> commands on the right data lines (the R61505 uses D17-D9 in 8-bit mode, w=
hile=20
> the DCS specification mentions D7-D0) based on how the panel is connected=
 and=20
> on which lines the panel expects data.
>=20
> As commands can be expressed on either 8 or 16 bits I would use a 16 type=
 for=20
> them.

I won't put my head on the block, but I don't think DBI has any
restriction on the size of the command. A "command" just means a data
transfer while keeping the D/CX line low, and "data" when the line is
high. Similar transfers for n bytes can be done in both modes.

> For parameters, we can either express everything as u8 * in the DBI bus=
=20
> operations, or use a union similar to i2c_smbus_data
>=20
> union i2c_smbus_data {
>         __u8 byte;
>         __u16 word;
>         __u8 block[I2C_SMBUS_BLOCK_MAX + 2]; /* block[0] is used for leng=
th */
>                                /* and one more for user-space compatibili=
ty */
> };

There's no DBI_BLOCK_MAX, so at least identical union won't work. I
think it's simplest to have u8 * function as a base, and then a few
helpers to write the most common datatypes.

So we could have on the lowest level something like:

dbi_write_command(u8 *buf, size_t size);
dbi_write_data(u8 *buf, size_t size);

And possible helpers:

dbi_write_data(u8 *cmd_buf, size_t cmd_size, u8 *data_buf, size_t
data_size);

dbi_write_dcs(u8 cmd, u8 *data, size_t size);

And variations:

dbi_write_dcs_0(u8 cmd);
dbi_write_dcs_1(u8 cmd, u8 data);

etc. So a simple helper to send 16 bits would be:

dbi_write_data(u16 data)
{
	// or are the bytes the other way around...
	u8 buf[2] =3D { data & 0xff, (data >> 8) & 0xff };
	return dbi_write_data(buf, 2);
}


> Helper functions would be available to perform 8-bit, 16-bit or n*8 bits=
=20
> transfers.
>=20
> Would that work for your use cases ?
>=20
> > Also note that some chips need to change the bus width on the fly. The
> > chip used on N800 wants configuration to be done with 8-bits, and pixel
> > transfers with 16-bits. Who knows why...
>=20
> On which data lines is configuration performed ? D7-D0 ?

I guess so, but does it matter? All the bus driver needs to know is how
to send 8/16/.. bit data. On OMAP we just write the data to a 32 bit
register, and the HW takes the lowest n bits. Do the bits represent the
data lines directly on Renesans?

The omap driver actually only implements 8 and 16 bit modes, not the 9
and 12 bit modes. I'm not sure what kind of shifting is needed for
those.

> > > We might just need to provide fake timings. Video mode timings are at=
 the
> > > core of display support in all drivers so we can't just get rid of th=
em.
> > > The h/v front/back porch and sync won't be used by display drivers fo=
r
> > > DBI/DSI panels anyway.
> >=20
> > Right. But we should probably think if we can, at the panel level, easi=
ly
> > separate conventional panels and smart panels. Then this framework woul=
dn't
> > need to fake the timings, and it'd be up to the higher level to decide =
if
> > and how to fake them. Then again, this is no biggie. Just thought that =
at
> > the lowest level it'd be nice to be "correct" and leave faking to upper
> > layers =3D).
>=20
> But we would then have two different APIs at the lower level depending on=
 the=20
> panel type. I'm not sure that's a good thing.

Different API for what? Why anyway need panel type specific functions.
In the panel struct we could just have an union of the different types
of parameters for different types of panels.

But if this complicates things, it's not a biggie. Just something that
has been in my mind when dealing with smart panels and assigning dummy
video timings for them =3D).

 Tomi


--=-NXIbi5QJeo5/5880y2r2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQLkHWAAoJEPo9qoy8lh71mqAP/1AxV5QslCOliZ+G4LoLLsn3
JYhxg4wxX+nsN7aG2aiLKKSjbIn/gGblAPPgTduv+OKIDgpPQqTGwfIxyTLbeNkg
mh//meMBzuEs2lbOqO3QFPnWIfuebFTlYns7Q6/jlw0ngRPJLQYiyGL+cglIGhj3
Ly8oTVYJqxqY4BnFJRM130CrgH/plhtPLhVxrsmnfA2dfoyQ5RcJTKkMBuZWTWel
jUtOI7OMX+AC7B2AMH9GXQguZGUNjDUkrAtB+D7O7FAG824oxyDWALDgWAwnpAt+
Jzmc3Ko0VbgPWgC1P5gliWsA7JyEZo75aiRBIscbzZpe3HkYUvPAX9r4zYa6QzXw
QRFXi+m6JHUr7veLDRMraCT+AZCpbTtyl543ruaf7Pn/e95tzBRJFF4L2VLojFvC
yZZUK/ifURLjRcxfnuhYZj+fkuBuW/zJrWTAJnQ4KU6381FkrSWEC65QHKKE2r6F
4FRPAxEDc3HyBGGjwi0iNBrDaJ6iVbh/W09E7Pslvk0igGQmIEcOS0ZMWBUilhv9
6ej606MUKH7MGrVNA1f3Os+qGJn6VN35t9enF/kWBaJQ+cCUzoEZ/GuM3DU5+rQg
pqX4w0xq1gFfD9Rg1l/PXEoi3TjYv92PZV6P96TVlvI/xbcJs+VfmafhjBV5+535
2CPmlNMEn4TLboOChIfP
=OVHb
-----END PGP SIGNATURE-----

--=-NXIbi5QJeo5/5880y2r2--

