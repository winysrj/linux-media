Return-path: <linux-media-owner@vger.kernel.org>
Received: from claranet-outbound-smtp05.uk.clara.net ([195.8.89.38]:57591 "EHLO
	claranet-outbound-smtp05.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751388Ab2JSRHA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Oct 2012 13:07:00 -0400
From: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
To: intel-gfx@lists.freedesktop.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, bhelgaas@google.com,
	linux-pci@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@infradead.org
Subject: Re: [Intel-gfx] GPU RC6 breaks PCIe to PCI bridge connected to CPU PCIe slot on SandyBridge systems
Date: Fri, 19 Oct 2012 18:06:41 +0100
Message-ID: <2244094.6Dmq15viKH@f17simon>
In-Reply-To: <2233216.7bl6QCud67@f17simon>
References: <1704067.2NCOGYajHN@f17simon> <3896332.1fABn9rFR8@f17simon> <2233216.7bl6QCud67@f17simon>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4058091.mohbLKXv11"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart4058091.mohbLKXv11
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Friday 19 October 2012 17:10:17 Simon Farnsworth wrote:
> Mauro, Linux-Media
> 
> I have an issue where an SAA7134-based TV capture card connected via a PCIe to
> PCI bridge chip works when the GPU is kept out of RC6 state, but sometimes
> "skips" updating lines of the capture when the GPU is in RC6. We've confirmed
> that a CX23418 based chip doesn't have the problem, so the question is whether
> the SAA7134 and the saa7134 driver are at fault, or whether it's the PCIe bus.
> 
> This manifests as a regression, as I had no problems with kernel 3.3 (which
> never enabled RC6 on the Intel GPU), but I do have problems with 3.5 and with
> current Linus git master. I'm happy to try anything, 
> 
> I've attached lspci -vvxxxxx output (suitable for feeding to lspci -F) for
> when the corruption is present (lspci.faulty) and when it's not
> (lspci.working). The speculation is that the SAA7134 is somehow more
> sensitive to the changes in timings that RC6 introduces than the CX23418, and
> that someone who understands the saa7134 driver might be able to make it less
> sensitive.
> 
And timings are definitely the problem; I have a userspace provided pm_qos
request asking for 0 exit latency, but I can see CPU cores entering C6. I'll
take this problem to an appropriate list.

There is still be a bug in the SAA7134 driver, as the card clearly wants a
pm_qos request when streaming to stop the DMA latency becoming too high; this
doesn't directly affect me, as my userspace always requests minimal DMA
latency anyway, so consider this message as just closing down the thread for
now, and as a marker for the future (if people see such corruption, the
saa7134 driver needs a pm_qos request when streaming that isn't currently
present).
-- 
Simon Farnsworth
Software Engineer
ONELAN Ltd
http://www.onelan.com

--nextPart4058091.mohbLKXv11
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAABAgAGBQJQgYimAAoJEIKsye9/dtRWos4H/jaQFkVCaajyMsUJvu7Doe3/
6XxuEdETC/4YX4SCzbTfRUQ7NaKHP/0H0YxeRQdsFnU640QLApQ8RrRKBZ5EUD2Y
xG36GKSWyGxJ9MLnSEDFy6z3xL8qRkq9oTASkDkKshP/oZsZDwIooqEUy/QhX3Sb
jUxumcyNsfbrcApFhNOkzDavl7n/KdjB0NuwZh7+ZUnljYHqse9dGpsrovPPoJzA
KfvXzzI672IPHEGPtpkbUP3/eZrcJ71Te+JXeWf2COx39DtuWCSZHu3+IpT5dYEk
bx1CuYA+kw6WxPBhOC3hk9Dptryj0JbBCtAdLvT7xrhPw1sS+dUsEvz/LRxr3m0=
=QFbN
-----END PGP SIGNATURE-----

--nextPart4058091.mohbLKXv11--

