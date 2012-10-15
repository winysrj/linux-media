Return-path: <linux-media-owner@vger.kernel.org>
Received: from drsnuggles.stderr.nl ([94.142.244.14]:58143 "EHLO
	drsnuggles.stderr.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab2JOLck (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Oct 2012 07:32:40 -0400
Date: Mon, 15 Oct 2012 13:01:11 +0200
From: Matthijs Kooijman <matthijs@stdin.nl>
To: linux-media@vger.kernel.org,
	Luis Henriques <luis.henriques@canonical.com>,
	Jarod Wilson <jarod@redhat.com>,
	Stephan Raue <stephan@openelec.tv>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: (still) NULL pointer crashes with nuvoton_cir driver
Message-ID: <20121015110111.GD17159@login.drsnuggles.stderr.nl>
References: <20120815165153.GJ21274@login.drsnuggles.stderr.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SjisD3HoSC+I0Thv"
Content-Disposition: inline
In-Reply-To: <20120815165153.GJ21274@login.drsnuggles.stderr.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--SjisD3HoSC+I0Thv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Folks,

> I've been suffering from a NULL pointer crash while initializing the
> nuvoton_cir driver. It occurs 100% reliable on a 3.5 kernel when I
> bombard my receiver with IR signals during bootup.
>
> It seems that 9ef449c: [media] rc: Postpone ISR registration attempts to
> fix this very issue, but does not fix it completely.

I've looked a bit more closely at the code and I do not really
understand why this commit actually fixed the crash for some (ite-cir)
users. Looking at the bugreport linked to in that commit [1], users
report their bug is fixed, but I don't really understand why. Perhaps
the window for this race condition is just made smaller, but not
entirely eliminated?

Note that the actual patch tested by the Launchpad users (which is
included in the Ubuntu kernel) is a smaller patch than the one in git,
but the essence is still the same.

[1]: http://bugs.launchpad.net/bugs/972723

> In particular, I'm not sure if it's ok to start firing IRQ's before
> rc_register_device is called. rc_register_device also calls
> ir_raw_event_register to init rdev->raw, which is again used by
> ir_raw_event_store_with_filter.
It seems this particular thing did not cause a (reproducible) problem,
since ir_raw_event_store_with_filter bails out when rdev->raw is NULL
(returning -EINVAL, but that's ignored by nvt_process_rx_ir_data).

Still, since there is still a small time window in which rdev->raw is
not NULL, but not completely initialized either, I believe that the irqs
should not be registered until after rc_register_device was called.


I've also looked at the USB IR drivers and it seems some potentially
have the same problem. In particular, usb_fill_int_urb (for iguanair and
ati-remote) or redrat3_enable_detector (for redrat3) is called before
rc_register_device and other initialization, but I don't know the USB
subsystem well enough to know if this is really a problem or if simply
moving th usb_fill_int_urb / redrat3_enable_detector would help at all.

The mceusb, streamzap and gpio-ir-recv drivers look like they initialize the interrupt
usb at the end and shouldn't suffer from this problem.


I'll send a patch series for this bug in a minute. It also fixes some
problem in cleanup of ene-ir I noticed while reading the code and
renames some of the cleanup labels (which should make the last patch
easier to review). I've tried to separate changes as much as possible,
if there's anything you'd like to see different, just let me know.

Since I only have nuvoton-cir hardware, the changes to the other drivers
are compile-tested only (but the drivers are similar enough that I
expect no problems there).

Gr.

Matthijs

--SjisD3HoSC+I0Thv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAlB77PcACgkQz0nQ5oovr7y9rgCfYLs5G/c6cryuatI4594hlvQg
S3oAn2yfqAPjGuBMyoPOdSDB4tVH7qWr
=oZus
-----END PGP SIGNATURE-----

--SjisD3HoSC+I0Thv--
