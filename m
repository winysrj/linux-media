Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:49296 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab1F3KCp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2011 06:02:45 -0400
Date: Thu, 30 Jun 2011 12:02:56 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-media@vger.kernel.org
Subject: tm6000 hangs after starting playback
Message-ID: <20110630100256.GA3150@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I have a piece of software that uses libvlc to playback analog video using
V4L2. When stress-testing the software by repeatedly starting and stopping
playback, the device I use (TerraTec Cinergy Hybrid Stick [0ccd:00a5]) goes
into a very strange state, where it hangs when dequeuing a buffer. This is
to where I traced the problem:

	videobuf_dqbuf() ->
		stream_next_buffer() ->
			videobuf_waiton() ->
				wait_event_interruptible()

When the device enters this particular state, the vb->done wait queue is
never woken. I was able to trace the cause of that further down to a problem
with ISOC transfers from the device no longer working properly:

	tm6000_irq_callback() ->
		tm6000_isoc_copy()

In this particular state, *all* ISO packet descriptors report an actual
transfer length of 0. This in turn seems to be the reason why the wait queue
is never woken (buffer_filled() is never called).

I've tried to unload and reload the tm6000 module when this issue occurs, but
that doesn't help. The problem persists the next time playback is started.
The only thing that seems to help is disconnecting and reconnecting the
device or, alternatively, reset the USB device using the USBDEVFS_RESET
ioctl.

I'm wondering whether this is a known problem, or if there is anything I can
do to help track this down further.

Cheers,
Thierry

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk4MSdAACgkQZ+BJyKLjJp82yQCeJExH6vayse/8jOKBumQocDsQ
KBIAnAw2GZBzPrfjM9StWL04leZCGqSX
=+7DY
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
