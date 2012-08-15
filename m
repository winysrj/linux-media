Return-path: <linux-media-owner@vger.kernel.org>
Received: from drsnuggles.stderr.nl ([94.142.244.14]:55501 "EHLO
	drsnuggles.stderr.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab2HOSCz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 14:02:55 -0400
Date: Wed, 15 Aug 2012 18:51:53 +0200
From: Matthijs Kooijman <matthijs@stdin.nl>
To: linux-media@vger.kernel.org
Cc: Luis Henriques <luis.henriques@canonical.com>,
	Jarod Wilson <jarod@redhat.com>
Subject: (still) NULL pointer crashes with nuvoton_cir driver
Message-ID: <20120815165153.GJ21274@login.drsnuggles.stderr.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cirKC40IaKCFO5vh"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--cirKC40IaKCFO5vh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

(Please keep me CC'd, I'm not on the list)

Hi folks,

I've been suffering from a NULL pointer crash while initializing the
nuvoton_cir driver. It occurs 100% reliable on a 3.5 kernel when I
bombard my receiver with IR signals during bootup.

It seems that 9ef449c: [media] rc: Postpone ISR registration attempts to
fix this very issue, but does not fix it completely.

The error I'm seeing is a NULL pointer dereference at
ir_raw_event_store_with_filter+0xd. I couldn't get gdb to disassemble
this function for some reason, but given the low offset, it's probably
very early in the fuction (code taken from linux-media master):

    int ir_raw_event_store_with_filter(struct rc_dev *dev, struct ir_raw_event *ev)
    {
	    if (!dev->raw)
		return -EINVAL;

	    /* Ignore spaces in idle mode */
	    if (dev->idle && !ev->pulse)
		    return 0;

I suspect that the NULL pointer is because dev is NULL.

The only place where ir_raw_event_store_with_filter is called by
nuvoton_cir is in nvt_process_rx_ir_data:

    ir_raw_event_store_with_filter(nvt->rdev, &rawir);

This would mean nvt->rdev is NULL.

I couldn't get at a backtrace, but the backtrace I got from running 3.2
was:
    ir_raw_event_store_with_filter
    nvt_process_rx_ir_data
    nvt_get_rx_ir_data
    nvt_cir_isr

In other words, the ISR is fired before nvt->rdev is initialized.

Looking at nvt_probe, I see that nvt->rdev is indeed assigned _after_
the request_irq calls are made, which would explain the crash I'm
seeing.

I was going to prepare a patch to move rdev initialization further up
(for all ir drivers involved in the previous "Postpone ISR registration
patch", except ene_cir.c and windbond_cir.c which seem to have that
already), but I'm not sure if this is sufficient.

In particular, I'm not sure if it's ok to start firing IRQ's before
rc_register_device is called. rc_register_device also calls
ir_raw_event_register to init rdev->raw, which is again used by
ir_raw_event_store_with_filter.

I'm currently compiling a 3.5 kernel with just the rdev initialization
moved up to see if this will fix my problem at all, but I'd like your
view on this in the meantime as well.

Gr.

Matthijs

--cirKC40IaKCFO5vh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAlAr06kACgkQz0nQ5oovr7wJRwCg3RJZTkoLy2TY8cKVqVbmRPbe
+7IAoNu7PeOeua8J6HxgEBswJd1xbSXR
=A+3d
-----END PGP SIGNATURE-----

--cirKC40IaKCFO5vh--
