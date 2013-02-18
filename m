Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:50484 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757121Ab3BRTvL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Feb 2013 14:51:11 -0500
Message-ID: <51228671.3070906@schinagl.nl>
Date: Mon, 18 Feb 2013 20:52:17 +0100
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: dvb-t.portugal@sapo.pt
CC: linux-media@vger.kernel.org
Subject: Re: DVB-T
References: <20130218154328.Horde._dC4E75SZhxRIkwgUdZgH-A@mail.sapo.pt>
In-Reply-To: <20130218154328.Horde._dC4E75SZhxRIkwgUdZgH-A@mail.sapo.pt>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'd be happy to apply it (even confirt it to a patch for you ;)

but two things that I notice:

I think you listed the same transponder 6 times (with the channels in 
the comments).

One transponder for all channels on that transponder is enough ;)

While google (translating) any info on portugal DVB-T I found the 
following (translated link)

http://translate.google.com/translate?sl=pt&tl=en&js=n&prev=_t&hl=en&ie=UTF-8&eotf=1&u=http%3A%2F%2Ftdt.telecom.pt%2Fquando%2F

A snipped:
  (ask the shop because your equipment must be compatible with the DVB-T 
technology and MPEG-4/H.264 with the standard.)

So is this DVB-T2? Is this DVB-T1 with MPEG-4 over it? (Is that called 
dvb-t2 aswell?)

If you can answer these question, i'll push your changes.

On 02/18/13 16:43, dvb-t.portugal@sapo.pt wrote:
> Hello.
>
> I am sending the file for DVB-T in Portugal (excluding Madeira and
> Azores) retrieved at Lisbon.

