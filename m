Return-path: <linux-media-owner@vger.kernel.org>
Received: from claranet-outbound-smtp05.uk.clara.net ([195.8.89.38]:47930 "EHLO
	claranet-outbound-smtp05.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753823Ab2J2OLZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Oct 2012 10:11:25 -0400
From: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] saa7134: Add pm_qos_request to fix video corruption
Date: Mon, 29 Oct 2012 14:11 +0000
Message-ID: <13391942.y8AEurCsVE@f17simon>
In-Reply-To: <1351517548.2503.18.camel@palomino.walls.org>
References: <1350906611-17498-1-git-send-email-simon.farnsworth@onelan.co.uk> <2183412.VijGEEfCXd@f17simon> <1351517548.2503.18.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1403877.srZ72dVBTJ"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart1403877.srZ72dVBTJ
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Monday 29 October 2012 09:32:27 Andy Walls wrote:
> On Mon, 2012-10-29 at 13:02 +0000, Simon Farnsworth wrote:
> > It will affect other drivers as well; the basic cause is that modern chips
> > can enter a package deep sleep state that affects both CPU speed and latency
> > to start of DMA. On older systems, this couldn't happen - the Northbridge
> > kept running at all times, and DMA latencies were low.
> > 
> > However, on the Intel Sandybridge system I'm testing with, the maximum wake
> > latency from deep sleep is 109 microseconds; the SAA7134's internal FIFO can't
> > hold onto data for that long, and overflows, resulting in the corruption I'm
> > seeing. The pm QoS request fixes this for me, by telling the PM subsystem
> > that the SAA7134 cannot cope with a long latency on the first write of a DMA
> > transfer.
> > 
> > Now, some media bridges (like the ones driven by the cx18 driver) can cope
> > with very high latency before the beginning of a DMA burst. Andy Walls has
> > worked on the cx18 driver to cope in this situation, so it doesn't fail even
> > with the 109 microsecond DMA latency we have on Sandybridge.
> 
> Well if brdige wake-up DMA latency is the problem, it is alos the case
> that the CX23418 has a *lot* of on board memory with which to collect
> video and compress it.  (And lets face it, the CX23418 is an SoC with
> two ARM cores and a lot of dedicated external memory, as opposed to the
> SAA7134 with 1 kB of FIFO.)   That hardware helps quite a bit, if the
> PCI bus is slow to wake up.
> 
> I found a SAA7134 sheet for you:
> 
> http://www.nxp.com/documents/data_sheet/SAA7134HL.pdf
> 
> Section 6.4.3 has a short description of the behaviour when the FIFO
> overflows.

That's a good description of what I'm seeing, so fits with the idea that it's
FIFO underflow.
> 
> But this sheet (close enough):
> 
> http://www.nxp.com/documents/data_sheet/SAA7133HL.pdf
> 
> Has much nicer examples of the programmed levels of the FIFO in section
> 6.4.3.  That 1 kB is for everything: raw VBI, Y, U, V, MPEG, and Audio.
> So you're lucky if one full line of video fits in the FIFO.
> 
And that datasheet suggests that my 31 usec request is too high; in the
"fastidious" configuration, I'd need a latency of 22 usec, not 31.

Does anyone have register-level documentation for the SAA7134, to confirm the
maximum tolerated latency with the FIFO configuration Linux uses?

> > Others, like the SAA7134, just don't have that much buffering, and we need
> > to ask the pm core to cope with it. I suspect that most old drivers will need
> > updating if anyone wants to use them with modern systems; either they'll have
> > an architecture like the cx18 series, and the type of work Andy has done will
> > fix the problem, or they'll behave like the saa7134, and need a pm_qos request
> > to ensure that the CPU package (and thus memory controller) stay awake.
> 
> Unless the chip has a lot of internal memory and processing resources, I
> suspect a pm_qos solution is needed to ensure the PCI bus responds in
> time.
> 
> This is a system level issue though.  Having the drivers decide what QoS
> they need in the absences of total system requirements, is the right
> thing for the home user.  It might not be very friendly for a
> professional solution where someone is trying to tune the use of the
> system IO bandwidth and CPU resources.
> 
> The ivtv driver and cx18 driver unconditionally bumping up their PCI
> latency timer to 64 cycles minimum always bugged me: drivers shouldn't
> be deciding QoS in a vaccuum.  But, then again, user complaints went
> away and the 64 PCI cycles seemed to be a minimum QoS that everyone
> needed.  Also both drivers have a ivtv/cx18_pci_latency module option to
> override the behaviour anyway.
> 
So, one trick that the pm_qos request infrastructure gives us is that I only
request reduced latency when we are actually streaming. It's up to the pm core
to determine what that means - e.g. keep CPU awake, program chipset registers,
ignore the request completely.

The other part of this is that I'm flagging my QoS requirements; if the wakeup
latency is higher than I'm requesting, I'll fail - that is clearly wrong. On
the other hand, if you have reasons to want lower wakeup latencies, the core
will combine all requests (both userspace and kernelspace), and choose the
minimum. If you're sophisticated enough to accept the problems involved in not
waking up in time to service DMA requests, you're probably also up to the task
of changing the kernel slightly to not request lower latencies.
-- 
Simon Farnsworth
Software Engineer
ONELAN Ltd
http://www.onelan.com

--nextPart1403877.srZ72dVBTJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAABAgAGBQJQjo53AAoJEIKsye9/dtRWKKQIAIsSiBQkxijSXloB55DOpXFS
LyBiPC1hY33A3eOIMvnow5llo9t/KuQTSQQ8zQWB3p9Z35Udam+/JP1EI33lCCn+
fCRD/+BCdt/L/bUexKQAYQhf2y1lPHvYfYC43JV7hNmZxyiboylKqrbolSWz5SUv
YdkVYRbOJZWDQ+GJsAMfSLImocwo18l92unbJj2WGNAIAjh0jlF43UFLM4amejSr
aAL0ol0ItvCC1RxvrgVhVIJwJ8MAeB339A6KLo6MKy2Em99M21CVdXElHega+jh7
9ymfQprKmKleJUn2QCzpTY2clGWBdaM0o9nt1Nv/MQUQNOCkXpePc4UjCEKGs08=
=r1KD
-----END PGP SIGNATURE-----

--nextPart1403877.srZ72dVBTJ--

