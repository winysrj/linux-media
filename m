Return-path: <mchehab@pedra>
Received: from 47-67.174.81.serverdedicati.seflow.net ([81.174.67.47]:53826
	"EHLO vps.virtual-bit.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752338Ab1CTU1n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Mar 2011 16:27:43 -0400
From: Lucio Crusca <lucio@sulweb.org>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: AF9015 problems
Date: Sun, 20 Mar 2011 21:27:39 +0100
Cc: linux-media@vger.kernel.org
References: <201103202010.33892.lucio@sulweb.org> <4D865783.20808@iki.fi>
In-Reply-To: <4D865783.20808@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103202127.39722.lucio@sulweb.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> Could you say which are missing freqs and bandwidth of those freqs?

The missing frequences are all in the 8MHz bands, while the 4 services it finds 
are the only services in the 7MHz bands. The 4 services it finds are all "RAI" 
services, which is the national tv here, just in case it helps knowing that.

When I scan for services with the TV decoder, RAI services are always the first 
to be found and I'm quite convinced that's because they have the lowest 
frequencies among all. 205500 KHz seems also to be the last frequency with 
7MHz bandwidth. The TV decoder, after RAI services, skips immediately to 8MHz 
bands.

The TV decoder finds a number of services at 594000 KHz/8MHz bandwidth 
(Mediaset), and then others at higher frequences. Between 205500 and 594000 
KHz there appears to be nothing also for the TV decoder.
