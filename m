Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:52534 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756537Ab1CAXiM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Mar 2011 18:38:12 -0500
Date: Wed, 2 Mar 2011 00:38:06 +0100
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: "Martin Bugge \(marbugge\)" <marbugge@cisco.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC] HDMI-CEC proposal
Message-ID: <20110301233806.GA4969@minime.bse>
References: <4D6CC36B.50009@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6CC36B.50009@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Mar 01, 2011 at 10:59:07AM +0100, Martin Bugge (marbugge) wrote:
> CEC is a protocol that provides high-level control functions between
> various audiovisual products.
> It is an optional supplement to the High-Definition Multimedia
> Interface Specification (HDMI).
> Physical layer is a one-wire bidirectional serial bus that uses the
> industry-standard AV.link protocol.

Apart from CEC being twice as fast as AV.link and using 3.6V
instead of 5V, CEC does look like an extension to the frame format
defined in EN 50157-2-2 for multiple data bytes.

So, how about adding support for EN 50157-2-* messages as well?
SCART isn't dead yet.

EN 50157-2-1 is tricky in that it requires devices to override
data bits like it is done for ack bits to announce their status.
There is a single message type with 21 bits.

For EN 50157-2-2 the only change necessary would be to tell the
application that it has to use AV.link commands instead of CEC
commands. In theory one could mix AV.link and CEC on a single
wire as they can be distinguished by their start bits.

EN 50157-2-3 allows 7 vendors to register their own applications
with up to 100 data bits per message. I doubt we can support
these if they require bits on the wire to be modified.
As they still didn't make use of the reserved value to extend the
application number space beyond 7, chances are no vendor ever
applied for a number.

Just my 2 cents.

  Daniel
