Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212Ab0DFFdW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Apr 2010 01:33:22 -0400
Message-ID: <4BBAC79B.5030107@redhat.com>
Date: Tue, 06 Apr 2010 02:33:15 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 04/15] V4L/DVB: ir-core: Add logic to decode IR protocols
 at the IR core
References: <cover.1270142346.git.mchehab@redhat.com>	 <20100401145632.7b1b98d5@pedra>	 <1270251567.3027.55.camel@palomino.walls.org> <4BB69A95.5000705@redhat.com>	 <1270314992.9169.40.camel@palomino.walls.org>  <4BB7C795.20506@redhat.com>	 <1270384551.4979.47.camel@palomino.walls.org>	 <4BB8D3D6.5010706@infradead.org> <1270431911.3506.25.camel@palomino.walls.org> <4BBA2D05.2080505@infradead.org>
In-Reply-To: <4BBA2D05.2080505@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> Andy Walls wrote:
>> I have an RC-5 decoder in cx23885-input.c that isn't as clean as the NEC
>> protocol decoder I developed.  The cx23885-input.c RC-5 decoder is not a
>> very explicit state machine however (it is a bit hack-ish).
> 
> The state machine seems to be working fine with the code, but I think I
> found the issue: it was expecting 14 bits after the start+toggle bits, instead
> of a total of 14 bits. I'll fix it. I'll probably end by simplifying it to have
> only 3 states: inactive, mark-space and trailer.

Done. I've re-written the state machine logic. The code is now simpler to understand,
require less processing and works properly with RC-5.

Instead of generating an intermediate code, like the code in ir-functions, it measures
directly the length of each pulse or space event and generate the corresponding bit directly,
putting it into a shift register. At the end of the 14 bits reception, the shift register
will contain the scancode.

When compared with saa7134 original RC5 decoder, this code is much more reliable, since it doesn't
propagate the errors, if the frequency is not precisely 36 kHz.

I tested here with my device and it is properly recognizing the Hauppauge Grey IR keys.

Both NEC and RC-5 decoders can run in parallel.


The patch here:

http://git.linuxtv.org/mchehab/ir.git?a=commitdiff;h=37b215ea1280a621d652469cd35328a208f8ef77

And the complete code:

http://git.linuxtv.org/mchehab/ir.git?a=blob;f=drivers/media/IR/ir-rc5-decoder.c;h=a62277b625a8ed78028e7060a677598eeae03ffe;hb=37b215ea1280a621d652469cd35328a208f8ef77

I'll likely send an email to the ML with the RC patches that are on my experimental tree,
to properly document, and merge it at the -git, together with the other pending requests.

-- 

Cheers,
Mauro
