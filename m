Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:40391 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030890Ab2HQIiY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 04:38:24 -0400
Received: by lagk11 with SMTP id k11so1876030lag.2
        for <linux-media@vger.kernel.org>; Fri, 17 Aug 2012 01:38:21 -0700 (PDT)
Message-ID: <1345192694.3158.49.camel@deskari>
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
Date: Fri, 17 Aug 2012 11:38:14 +0300
In-Reply-To: <1345164583-18924-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1345164583-18924-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-T5ADZV/xlOD6S0v/f4qb"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-T5ADZV/xlOD6S0v/f4qb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, 2012-08-17 at 02:49 +0200, Laurent Pinchart wrote:

> I will appreciate all reviews, comments, criticisms, ideas, remarks, ... =
If

Oookay, where to start... ;)

A few cosmetic/general comments first.

I find the file naming a bit strange. You have panel.c, which is the
core framework, panel-dbi.c, which is the DBI bus, panel-r61517.c, which
is driver for r61517 panel...

Perhaps something in this direction (in order): panel-core.c,
mipi-dbi-bus.c, panel-r61517.c? And we probably end up with quite a lot
of panel drivers, perhaps we should already divide these into separate
directories, and then we wouldn't need to prefix each panel with
"panel-" at all.

---

Should we aim for DT only solution from the start? DT is the direction
we are going, and I feel the older platform data stuff would be
deprecated soon.

---

Something missing from the intro is how this whole thing should be used.
It doesn't help if we know how to turn on the panel, we also need to
display something on it =3D). So I think some kind of diagram/example of
how, say, drm would use this thing, and also how the SoC specific DBI
bus driver would be done, would clarify things.

---

We have discussed face to face about the different hardware setups and
scenarios that we should support, but I'll list some of them here for
others:

1) We need to support chains of external display chips and panels. A
simple example is a chip that takes DSI in, and outputs DPI. In that
case we'd have a chain of SoC -> DSI2DPI -> DPI panel.

In final products I think two external devices is the maximum (at least
I've never seen three devices in a row), but in theory and in
development environments the chain can be arbitrarily long. Also the
connections are not necessarily 1-to-1, but a device can take one input
while it has two outputs, or a device can take two inputs.

Now, I think two external devices is a must requirement. I'm not sure if
supporting more is an important requirement. However, if we support two
devices, it could be that it's trivial to change the framework to
support n devices.

2) Panels and display chips are all but standard. They very often have
their own sequences how to do things, have bugs, or implement some
feature in slightly different way than some other panel. This is why the
panel driver should be able to control or define the way things happen.

As an example, Sharp LQ043T1DG01 panel
(www.sharpsme.com/download/LQ043T1DG01-SP-072106pdf). It is enabled with
the following sequence:

- Enable VCC and AVDD regulators
- Wait min 50ms
- Enable full video stream (pck, syncs, pixels) from SoC
- Wait min 0.5ms
- Set DISP GPIO, which turns on the display panel

Here we could split the enabling of panel to two parts, prepare (in this
case starts regulators and waits 50ms) and finish (wait 0.5ms and set
DISP GPIO), and the upper layer would start the video stream in between.

I realize this could be done with the PANEL_ENABLE_* levels in your RFC,
but I don't think the concepts quite match:

- PANEL_ENABLE_BLANK level is needed for "smart panels", as we need to
configure them and send the initial frame at that operating level. With
dummy panels there's really no such level, there's just one enable
sequence that is always done right away.

- I find waiting at the beginning of a function very ugly (what are we
waiting for?) and we'd need that when changing the panel to
PANEL_ENABLE_ON level.

- It's still limited if the panel is a stranger one (see following
example).

Consider the following theoretical panel enable example, taken to absurd
level just to show the general problem:

- Enable regulators
- Enable video stream
- Wait 50ms
- Disable video stream
- Set enable GPIO
- Enable video stream

This one would be rather impossible with the upper layer handling the
enabling of the video stream. Thus I see that the panel driver needs to
control the sequences, and the Sharp panel driver's enable would look
something like:

regulator_enable(...);
sleep();
dpi_enable_video();
sleep();
gpip_set(..);

Note that even with this model we still need the PANEL_ENABLE levels you
have.

---

I'm not sure I understand the panel unload problem you mentioned. Nobody
should have direct references to the panel functions, so there shouldn't
be any automatic references that would prevent module unloading. So when
the user does rmmod panel-mypanel, the panel driver's remove will be
called. It'll unregister itself from the panel framework, which causes
notifications and the display driver will stop using the panel. After
that nobody has pointers to the panel, and it can safely be unloaded.

It could cause some locking issues, though. First the panel's remove
could take a lock, but the remove sequence would cause the display
driver to call disable on the panel, which could again try to take the
same lock...

 Tomi


--=-T5ADZV/xlOD6S0v/f4qb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQLgL2AAoJEPo9qoy8lh71AacP/imlUzYYxAvQukgGKDdm5M3o
caEo62bsSS5ZFhhMx09cavHk9w4T9bw4V/A+SzW3DK4S8xe7bKMsVo4fzA/axMVQ
xP+pdX2w2QKmTmH6rHHK1LxuWAJgBd2splxJNFi6pPDqtLCW1lrWiaXp+BwxfquS
FYXeihrqZGopBKjCMfQv9t28xgoV/d6aSCEueb8J+2x8cz3QWk2ozl/l0JaGylUz
Ep03VeWQ7OGooaislVEJIbKRQwqnGM99r2s29vuviLuWIpBpC23DpEhdon61rfWX
F7p3/D8J4SrXixy/crDGeGCWaFBkuZ/j7f7pF1D/+ukYhHX7y18Hksf56YQ6fokE
S9HLZYUUmUuUvzfseee2dc0vP/L9WC1Z1upjw44OHUdMfnjKqHxRrGUk93JTATEA
xPFDU1LmiYWZRNqQ5xROTe4NuycKXhmCRDKFN+rcbzRwM2+eVm46klKBT10extFB
gWkdTnrf33S4uo37L3W8iNgTTbXsbJo1Ajp3M0UTBQilyd9C5+wPNR0QYSuK7pVS
rX0zN9Jqn700yDYrmgXgJT+W50sLNFP8ZktnMiS+NeUxPKHWRyURRWjzQ/VoKEwe
ch6OfHV17qaaV/5JYrqKLf3U1HKkKc4MLKzR8z0e6PFhV+q1N2iFmTgBlAQ/ZRty
UJuVyP8szfLLenhnT4uD
=Rexm
-----END PGP SIGNATURE-----

--=-T5ADZV/xlOD6S0v/f4qb--

