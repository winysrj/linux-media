Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:38831 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab1HWW3a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Aug 2011 18:29:30 -0400
Received: by iye16 with SMTP id 16so870501iye.1
        for <linux-media@vger.kernel.org>; Tue, 23 Aug 2011 15:29:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1314135816.2140.16.camel@localhost>
References: <CAATJ+fu5JqVmyY=zJn_CM_Eusst_YWKG2B2MAuu5fqELYYsYqA@mail.gmail.com>
	<CAATJ+ft9HNqLA62ZZkkEP6EswXC1Jhq=FBcXU+OHCkXTKpqeUA@mail.gmail.com>
	<1313949634.2874.13.camel@localhost>
	<CAATJ+fv6x6p5kimJs4unWGQ_PU36hp29Rafu8BDCcRAABtAfgQ@mail.gmail.com>
	<CAL9G6WUFddsFM2V46xXCDWEfhfCR0n5G-8S4JSYwLLkmZnYu7g@mail.gmail.com>
	<CAATJ+fsUWPjh5aq38triZOu0-DmU=nCbd77qUzxUn5kiDiaR+w@mail.gmail.com>
	<CAATJ+ftemL4NYTQLxLw4vmXpD+nFfxrUVjmapUt9EzYJNqH6FQ@mail.gmail.com>
	<1314135816.2140.16.camel@localhost>
Date: Wed, 24 Aug 2011 08:29:29 +1000
Message-ID: <CAATJ+fvWLX+heuiF9aCUMSHZi_a0us=oT4itMAY2ypmh8KeuXw@mail.gmail.com>
Subject: Re: [PATCH] Re: Afatech AF9013 [TEST ONLY] AF9015 stream buffer size
 aligned with max packet size.
From: Jason Hecker <jwhecker@gmail.com>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: Josu Lazkano <josu.lazkano@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I think what might happening is that TS packets are getting chopped, as device seems to want
> to align to max packet size.

Oh, I also noticed that the Linux driver uses a smaller USB packet
count than Windows.  Is there any discernible reason for this?  Lag on
DVB isn't an issue for me and probably everyone else due to the stream
going to secondary storage first.

Great, I'll try it out later.  I have been studying the source code
and noticed that the bus locking mechanism is TODOed and may be part
of the problem.  My symptom is that Tuner A fails when Tuner B is
started and I have a theory that somehow the TDA18271 is getting some
I2C data and being corrupted because of a gating problem with the I2C
signal.  The TDA18271 can change the last 2 bits of it's default I2C
address by setting a voltage on its AS pin (presumably with resistor
dividers) but I haven't delved in to determine if this what Leadtek
have done - both tuners might be set to address 0xC0.  I can only
truly test this by putting CRO probe on and seeing if the I2C is going
down the wrong path at the wrong time.

I just wish ITE/Afa would release their data sheet to the public and
make it as detailed and USEFUL as the TDA18271 data sheet.  This
obfuscation, need for NDAs and a half arsed data sheet and bloody
sniffing Windows USB transactions for programming clues is such a
waste of time and I fail to see how it benefits ITE to do this.  The
Afatech chips are 4+ years old anyway - what's the problem?  If anyone
wants to send me the data sheets and more importantly the DESIGN
MANUAL from the devkit I'd be most grateful.
