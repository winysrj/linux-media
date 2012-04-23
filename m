Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53014 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752833Ab2DWRH5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 13:07:57 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1SMMjz-0005KJ-R2
	for linux-media@vger.kernel.org; Mon, 23 Apr 2012 19:07:55 +0200
Received: from d67-193-214-242.home3.cgocable.net ([67.193.214.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 23 Apr 2012 19:07:55 +0200
Received: from brian by d67-193-214-242.home3.cgocable.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 23 Apr 2012 19:07:55 +0200
To: linux-media@vger.kernel.org
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: HVR-1600: Skipped encoder MPEG, MDL 63, 62 times - it must have
 dropped out of rotation
Date: Mon, 23 Apr 2012 13:07:45 -0400
Message-ID: <jn4292$6te$1@dough.gmane.org>
References: <jn1a43$vlj$1@dough.gmane.org> <1335128213.2602.23.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8F1A40EB0AB272E549A0AC78"
In-Reply-To: <1335128213.2602.23.camel@palomino.walls.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8F1A40EB0AB272E549A0AC78
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 12-04-22 04:56 PM, Andy Walls wrote:
>=20
> If, in your system, IRQ service for device A under some circumstances
> has precendence over IRQ service for the CX23418 and hence holds off it=
s
> service; and the irq handler in the driver for device A decides to
> perform some some long I/O operations with device A; then it doesn't
> matter how fast your CPU is.=20

Yes, quite true.  I was forgetting about how nasty an irq handler can be
on other hardware.

> You may wish to use perf or ftrace, or some other tool/method of
> measuring kernel interrupt handling latency to find out what causes any=

> delays from the CX23418 raising its IRQ line to cx18_irq_handler() bein=
g
> called by the kernel.

Excellent idea.  I'm afraid I'm quite (read: very) green in the area of
kernel performance profiling.  But I'm smart.  Looking around, it seems
that with ftrace, I am looking for the irqsoff tracer, is that correct?
 Unfortunately my kernel doesn't have that one:

# cat /sys/kernel/debug/tracing/available_tracers
blk function_graph mmiotrace wakeup_rt wakeup function nop

I can't seem to find any useful information on using perf to analyze ISR
latency.  Any pointers?

Cheers,
b.


--------------enig8F1A40EB0AB272E549A0AC78
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk+VjGEACgkQl3EQlGLyuXCoAACgiDbGkuvGQaO+jMUEemK04Y5o
fysAn2iR+HucWKxOratz8RdDsvHX4oln
=tmyo
-----END PGP SIGNATURE-----

--------------enig8F1A40EB0AB272E549A0AC78--

