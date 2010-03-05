Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:36427 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753274Ab0CERUu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Mar 2010 12:20:50 -0500
Subject: Re: [ivtv-devel] [UNKNOWN IVTV CARD]: vendor/device: 14f1:5b7a
 subsystem vendor/device: 1179:0111
From: Andy Walls <awalls@radix.net>
To: Discussion list for development of the IVTV driver
	<ivtv-devel@ivtvdriver.org>
Cc: linux-media@vger.kernel.org
In-Reply-To: <47A58786-CE52-4BAE-A841-E9949416B0CE@larrson.id.au>
References: <18F7CF02-654B-479D-A767-35C5DE1A50D4@larrson.id.au>
	 <1263751227.3067.13.camel@palomino.walls.org>
	 <47A58786-CE52-4BAE-A841-E9949416B0CE@larrson.id.au>
Content-Type: text/plain
Date: Fri, 05 Mar 2010 12:20:05 -0500
Message-Id: <1267809605.3078.53.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-02-26 at 18:32 +1100, Thomas wrote:
> On 18/01/2010, at 5:00 AM, Andy Walls wrote:
> > 
> > If you want this card supported:
> > 
> > 1.  Could you provide pictures of this Toshiba card (front and back)? or
> > at least a list of chips on the card and whatever the label on the metal
> 
> Sorry for such a really long delay from my end. Because of size of the pictures, I put all of them on imageshack:
> http://yfrog.com/i3dsc01294uj
> http://yfrog.com/6udsc01295ij
> http://yfrog.com/0ddsc01296mj
> 
> Cheers,
> Thomas


Thanks for the pictures.  I'll try to see what I can do.

At least now I know the DVB-T demodulator is an STV0361, for which there
does not appear to be any Linux driver yet.  The programming information
and reference manual for the STV0361 and STV0360 do not seem to be
publicly available.  The likelyhood of DVB-T ever working under Linux
for this card is low.

I still can't see what tuner chip is in use: it's inside the larger
metal can farthest from the miniPCI card edge connector.  I assume the
depressions on the can press down onto the two most important chips in
the tuner assembly to act as a heat sink for those chips.  To get analog
broadcast video (or DVB-T) working, I'd need to know what tuner chips
are in use in that metal can.

So with the information so far, I only have reasonable hope of
developing support for this card's baseband Compsite video, S-video, and
audio inputs.  Is that still worth it to you?

Regards,
Andy

