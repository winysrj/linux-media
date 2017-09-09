Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:56624 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753686AbdIIP1J (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 9 Sep 2017 11:27:09 -0400
Date: Sat, 9 Sep 2017 17:27:06 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-i2c@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH v4 3/6] i2c: add docs to clarify DMA handling
Message-ID: <20170909152705.tmnenengi4aqy3tc@ninjato>
References: <20170817141449.23958-1-wsa+renesas@sang-engineering.com>
 <20170817141449.23958-4-wsa+renesas@sang-engineering.com>
 <20170827083748.248e2430@vento.lan>
 <20170908085640.42wzzgd2s2roikyd@ninjato>
 <20170908080756.7d8d81d7@vento.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="dbaktt5fhjqvv3l6"
Content-Disposition: inline
In-Reply-To: <20170908080756.7d8d81d7@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--dbaktt5fhjqvv3l6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> Yes, but the statistics that 10% of I2C bus master drivers
> are DMA-safe is not true, if you take those into account ;-)
>=20
> Perhaps you could write it as (or something similar):
>=20
> 	At this time of writing, only +10% of I2C bus master
> 	drivers for non-remote boards have DMA support implemented. =20

No, this is confusing IMO. Being remote has nothing to with DMA. What
has to do with DMA is that these are using USB as communication channel.
And USB clearly needs DMA-safe buffers. The encapsulation needs DMA-safe
buffers. So, I think the new sentence "other subsystems might impose"
mentions that.

Let me recap what this series is for:

a) It makes clear that I2C subsystem does not require DMA-safety because
for the reasons given in the textfile.

If I2C is encapsulated over USB, then DMA-safety is of course required,
but this comes from USB. So, those USB-I2C master drivers need to do
something to make sure DMA-safety is guaranteed because i2c_msg buffers
don't need to be DMA safe because of a). They could use the newly
introduced features, but they don't have to.

b) a flag for DMA safe i2c_msgs is added

So, for messages we know to be DMA safe, we can flag that. Drivers
could check that and use a bounce buffer if the flag is not set.
However, this is all optional. Your drivers can still choose to not
check the flag and everything will stay as before. Check patch 5 for a
use case.

c) helper functions for bounce buffers are added

These are *helper* functions for drivers wishing to do DMA. A super
simple bounce buffer support. Check patch 4 for a use case. Again, this
is optional. Drivers can implement their own bounce buffer support. Or,
as in your case, if you know that your buffers are good, then don't use
any of this and things will keep going.


This all is to allow bus master drivers to opt-in for DMA safety if they
want to do DMA directly. Because currently, with a lot of i2c_msgs on
stack, this is more or less working accidently.

And, yes, I know I have to add this new flag to a few central places in
client drivers. Otherwise, master drivers checking for DMA safety will
initially have a performance regression. This is scheduled for V5 and
mentioned in this series.

> In the past, on lots of drivers, the i2c_xfer logic just used to assume
> that the I2C client driver allocated a DMA-safe buffer, as it just used to
> pass whatever buffer it receives directly to USB core. We did an effort to
> change it, as it can be messy, but I'm not sure if this is solved everywh=
ere.

Good, I can imagine this being some effort. But again, this is because
USB needs the DMA-safety, not I2C. AFAICS, most i2c_msgs are register
accesses and thus, small messages.

> The usage of I2C at the media subsystem predates the I2C subsystem.
> at V4L2 drivers, a great effort was done to port it to fully use the
> I2C subsystem when it was added upstream, but there were some problems
> a the initial implementation of the i2c subsystem that prevented its
> usage for the DVB drivers. By the time such restrictions got removed,
> it was too late, as there were already a large amount of drivers relying
> on i2c "low level" functions.

Didn't know that, but this is good to know! Thanks.

> Even on the drivers that use i2c_add_adapter(), the usage of DMA can't
> be get by the above grep, as the DMA usage is actually at drivers/usb.

Ok. But as said before, what works now will continue to work. This
series is about clarifying that i2c_msg buffers need not to be DMA safe
and offering some helpers for those bus master drivers wanting to opt-in
to be sure.

Clearer now?

Regards,

   Wolfram


--dbaktt5fhjqvv3l6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlm0CEUACgkQFA3kzBSg
KbYFMxAAsnFi1g6FqVXiH4/+euK/bEZtFnKEOOqrrzOJY0y4STGEr7veeSLX2nWf
gipTl6Pk2Q/za8OHvSJgKi9JxAi3g3FZ0aEO496ohL5lIS4xgxnQP8qtQZ8DcHhK
pyuCmDLDTl6Yp3TQ2CfYdxrE31MwyZb4pNsTeE/ohamm5IQ5lwoQjjce7wVspDNR
N1Qic2Dk2vxwYnta2mjV4ICT3N1OpVQd8Pg+BE3L5fWeEeaCUo8onj3gfGeEQ4PV
2zYuXEELDCPldigUYJo4uF59hgM7CsCcceCFNk08Dj/NXk6gcigkITMzcKYBscQm
pfAEhOMGL3luuJfKMhDgChjACO0gzNjn1XE4Ym9sA1Px6ib+461RksO7S7r3QisR
VeKHpEaXjeIaj3WIwqpeLTLzzrRynhpHriAg4EMywSwaBeZEzdXmjPdtAU7vSbTB
OBBbrQnmxCuYDzS6fbiKCrPO+9rVh0KpQcVD8P8YSmaGin/9eTp2gmQItus/Vy3m
7MQlfn5Wb9ahhq9ggAAsVkZBV/5Bd/VkWIP5OaZvQ+GxWyJdGPfo3YoOtjnw1RFe
LwmUcjOvvDwL9BmUG8PXkNEEioKind51HYBGhYMIo1Qul//DAqWS24d5vuBqrNvA
s2/Lf5HUh11cVM+mPNF26DHOQmNPwfYprjfJZogDHrZrDW2kUsQ=
=xQe4
-----END PGP SIGNATURE-----

--dbaktt5fhjqvv3l6--
