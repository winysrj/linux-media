Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:42455 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755147Ab2HQLmh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 07:42:37 -0400
Received: by lagr15 with SMTP id r15so2311531lag.35
        for <linux-media@vger.kernel.org>; Fri, 17 Aug 2012 04:42:34 -0700 (PDT)
Message-ID: <1345203751.3158.99.camel@deskari>
Subject: Re: [RFC 0/5] Generic panel framework
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
Date: Fri, 17 Aug 2012 14:42:31 +0300
In-Reply-To: <15644929.x7ZB0fPYJx@avalon>
References: <1345164583-18924-1-git-send-email-laurent.pinchart@ideasonboard.com>
	 <1345192694.3158.49.camel@deskari> <15644929.x7ZB0fPYJx@avalon>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-VAhwn8HaoPhm4iVBbvZQ"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-VAhwn8HaoPhm4iVBbvZQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-08-17 at 13:10 +0200, Laurent Pinchart wrote:

> What kind of directory structure do you have in mind ? Panels are already=
=20
> isolated in drivers/video/panel/ so we could already ditch the panel- pre=
fix=20
> in drivers.

The same directory also contains files for the framework and buses. But
perhaps there's no need for additional directories if the amount of
non-panel files is small. And you can easily see from the name that they
are not panel drivers (e.g. mipi_dbi_bus.c).

> Would you also create include/video/panel/ ?

Perhaps that would be good. Well, having all the files prefixed with
panel- is not bad as such, but just feel extra.

> > ---
> >=20
> > Should we aim for DT only solution from the start? DT is the direction =
we
> > are going, and I feel the older platform data stuff would be deprecated
> > soon.
>=20
> Don't forget about non-ARM architectures :-/ We need panel drivers for SH=
 as=20
> well, which doesn't use DT. I don't think that would be a big issue, a DT=
-
> compliant solution should be easy to use through board code and platform =
data=20
> as well.

I didn't forget about them as I didn't even think about them ;). I
somehow had the impression that other architectures would also use DT,
sooner or later. I could be mistaken, though.

And true, it's not a big issue to support both DT and non-DT versions,
but I've been porting omap stuff for DT and keeping the old platform
data stuff also there, and it just feels burdensome. For very simple
panels it's easy, but when you've passing lots of parameters the code
starts to get longer.

> > This one would be rather impossible with the upper layer handling the
> > enabling of the video stream. Thus I see that the panel driver needs to
> > control the sequences, and the Sharp panel driver's enable would look
> > something like:
> >=20
> > regulator_enable(...);
> > sleep();
> > dpi_enable_video();
> > sleep();
> > gpip_set(..);
>=20
> I have to admit I have no better solution to propose at the moment, even =
if I=20
> don't really like making the panel control the video stream. When several=
=20
> devices will be present in the chain all of them might have similar annoy=
ing=20
> requirements, and my feeling is that the resulting code will be quite mes=
sy.=20
> At the end of the day the only way to really find out is to write an=20
> implementation.

If we have a chain of devices, and each device uses the bus interface
from the previous device in the chain, there shouldn't be a problem. In
that model each device can handle the task however is best for it.

I think the problems come from the divided control we'll have. I mean,
if the panel driver would decide itself what to send to its output, and
it would provide the data (think of an i2c device), this would be very
simple. And it actually is for things like configuration data etc, but
not so for video stream.

> > It could cause some locking issues, though. First the panel's remove
> > could take a lock, but the remove sequence would cause the display
> > driver to call disable on the panel, which could again try to take the
> > same lock...
>=20
> We have two possible ways of calling panel operations, either directly (p=
anel-
> >bus->ops->enable(...)) or indirectly (panel_enable(...)).
>=20
> The former is what V4L2 currently does with subdevs, and requires display=
=20
> drivers to hold a reference to the panel. The later can do without a dire=
ct=20
> reference only if we use a global lock, which is something I would like t=
o=20

Wouldn't panel_enable() just do the same panel->bus->ops->enable()
anyway, and both require a panel reference? I don't see the difference.

> avoid. A panel-wide lock wouldn't work, as the access function would need=
 to=20
> take the lock on a panel instance that can be removed at any time.

Can't this be handled with some kind of get/put refcounting? If there's
a ref, it can't be removed.

Generally about locks, if we define that panel ops may only be called
exclusively, does it simplify things? I think we can make such
requirements, as there should be only one display framework that handles
the panel. Then we don't need locking for things like enable/disable.

Of course we need to be careful about things where calls come from
"outside" the display framework. I guess one such thing is rmmod, but if
that causes a notification to the display framework, which again handles
locking, it shouldn't be a problem.

Another thing to be careful about is if the panel internally uses irqs,
workqueues, sysfs files or such. In that case it needs to handle
locking.

 Tomi


--=-VAhwn8HaoPhm4iVBbvZQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQLi4nAAoJEPo9qoy8lh71EJ0QAJwilwuDC1p2408vlpTdzXos
M6W0j9ZoAkd8TxBIhalwJtbhZCRyIUztwX7gN/mlhCqLWEQRrtmu7VXouSoxBfe2
ycwoaIs94suupIUIYRv/RXlcmZhVhn897uVIxgXmR34fEtT3G0wkGlHUBa1Gapml
NFC19zbRHqROu+dpHBG76fDUc61woVRBPGAEVJuxIKOdMhlPFxy08rjDC08IAQqA
n/M7WlGP0/4diG9Eb2MHljDjL85sSm0dcddyQO+xEeA6HG/LvvH/wapNfLme5GOv
mcuJYi+smzESYEqtnWKW2J9azyn+jkH6dKquMfyigIyFTgOTFSWjlsMWH759hBfI
3TucSImBUK6J+Paohll/BJOoFns1e3d+lb36lwA8ouKTfI+JT46h4EnSuOWPcFU8
Oclmu+r0kNNysmF43FQTYbLDQ/wi9DRAvTtxbc1AuL5iFKX43yR9Ct/VRFzkpDst
+KgVRJgoOjGkyurSjd5DT2hAeeecS2PXA14oRhGS3ePf74G57XhK4yHlFdVHtQPX
/g9WTQP/XIXmc91R0WfX2CfDooDZDuNw75RsumfcZ+gxRmLmWzwmPmCnA0OJpVWE
mQefEk5SQw1/VtBZP2as8tlpu22+i1Ur61Gq5+T+uGMeDfO2oTcKo4Z8MvSFFxuz
Wvx8OzMf/UdDoZtMT0iV
=qbm2
-----END PGP SIGNATURE-----

--=-VAhwn8HaoPhm4iVBbvZQ--

