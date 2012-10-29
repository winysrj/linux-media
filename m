Return-path: <linux-media-owner@vger.kernel.org>
Received: from claranet-outbound-smtp01.uk.clara.net ([195.8.89.34]:34235 "EHLO
	claranet-outbound-smtp01.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755619Ab2J2NDM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Oct 2012 09:03:12 -0400
From: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] saa7134: Add pm_qos_request to fix video corruption
Date: Mon, 29 Oct 2012 13:02:51 +0000
Message-ID: <2183412.VijGEEfCXd@f17simon>
In-Reply-To: <20121029095817.0bad37b3@infradead.org>
References: <1350906611-17498-1-git-send-email-simon.farnsworth@onelan.co.uk> <3124636.sEoNQbeq5Q@f17simon> <20121029095817.0bad37b3@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3205630.JfefSMQLPF"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart3205630.JfefSMQLPF
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Monday 29 October 2012 09:58:17 Mauro Carvalho Chehab wrote:
> I prefer if you don't c/c me on that ;) Patchwork is the main source that I use
> on my patch reviews.
> 
Noted.

> Btw, I saw your patch yesterday (and skipped it, for now), as I never played
> with those pm QoS stuff before, nor I ever noticed anything like what you
> reported on saa7134 (but I can't even remember the last time I tested something
> on a saa7134 board ;) - so, it can be some new bug).
> 
> So, I'll postpone its review to when I have some time to actually test it
> especially as the same issue might also be happening on other drivers.
> 
It will affect other drivers as well; the basic cause is that modern chips
can enter a package deep sleep state that affects both CPU speed and latency
to start of DMA. On older systems, this couldn't happen - the Northbridge
kept running at all times, and DMA latencies were low.

However, on the Intel Sandybridge system I'm testing with, the maximum wake
latency from deep sleep is 109 microseconds; the SAA7134's internal FIFO can't
hold onto data for that long, and overflows, resulting in the corruption I'm
seeing. The pm QoS request fixes this for me, by telling the PM subsystem
that the SAA7134 cannot cope with a long latency on the first write of a DMA
transfer.

Now, some media bridges (like the ones driven by the cx18 driver) can cope
with very high latency before the beginning of a DMA burst. Andy Walls has
worked on the cx18 driver to cope in this situation, so it doesn't fail even
with the 109 microsecond DMA latency we have on Sandybridge.

Others, like the SAA7134, just don't have that much buffering, and we need
to ask the pm core to cope with it. I suspect that most old drivers will need
updating if anyone wants to use them with modern systems; either they'll have
an architecture like the cx18 series, and the type of work Andy has done will
fix the problem, or they'll behave like the saa7134, and need a pm_qos request
to ensure that the CPU package (and thus memory controller) stay awake.
-- 
Simon Farnsworth
Software Engineer
ONELAN Ltd
http://www.onelan.com

--nextPart3205630.JfefSMQLPF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAABAgAGBQJQjn5/AAoJEIKsye9/dtRWahAH/0BD1NqjnFyrOubwxUwm5f4j
/uUqY06Aum2+RbOdwlxlEmfW+EBJCuJywg5Y/HFHvPJzST9iJ5Wq2VoJfpt4BSOa
h8wBJ2cjKtQ5Tj6rs1VgX/Db1+UU1D2Tg72Ic62KvIhPQeCZ+V3lyqyoPMJ0/MJZ
r/LSbDdZZEJaUGUijbDpPX6laSiLzT3YajfXJQd8gwMGjkUzX9EnGl+A1AugFf5v
3i+2o6OZn/qKNLJO8Yaf9caGvF6wCaav9jhboxdTljkgq9NqjfhxOQbsL9VXl2V7
jYJOgr/rUcbWwHB15wB0JYI5l96KQagpu9ZBwX7eEHi7iddALeWhYUbcf7b8oOQ=
=lRx9
-----END PGP SIGNATURE-----

--nextPart3205630.JfefSMQLPF--

