Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 203.161.84.42.static.amnet.net.au ([203.161.84.42]
	helo=goeng.com.au) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tom@goeng.com.au>) id 1KYHzX-0000F7-EK
	for linux-dvb@linuxtv.org; Wed, 27 Aug 2008 12:11:08 +0200
From: "Thomas Goerke" <tom@goeng.com.au>
To: stev391@email.com
References: <20080827061320.298E2104F0@ws1-3.us4.outblaze.com>
In-Reply-To: <20080827061320.298E2104F0@ws1-3.us4.outblaze.com>
Date: Wed, 27 Aug 2008 18:11:35 +0800
Message-ID: <003201c9082d$4b7fff80$e27ffe80$@com.au>
MIME-Version: 1.0
Content-Language: en-au
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Compro VideoMate E650 hybrid PCIe DVB-T and analog
	TV/FM capture card
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

> Thanks for doing that, it appears that the two cards (E800F and E650)
> have the same subvendor and product ids. Also the same i2c output...
> 
> So this means that if I make a patch for DVB support in one, it will
> automatically be loaded for the other.  This however does pose a
> dilemma when looking at the analog side of the card.  However this can
> be hopefully tackled at a later stage.
> 
> The key registers that I'm after are the states of:
> VID_A_INT_MSK
> VID_B_INT_MSK
> VID_C_INT_MSK
> 
> As I need to determine which port has the digital stream connected to
> it.
> 
> Typically these are zero when not in use, so if you run the program
> when the tuner is not in use then run the DVB program you should see a
> change in state of one of these only.
> 
> Can you also tune to an analog channel as well and let me know which
> one it is on (a, b or c).
> 
> Thanks,
> 
> Stephen.
> 
> 
> --
> Be Yourself @ mail.com!
> Choose From 200+ Email Addresses
> Get a Free Account at www.mail.com


Stephen,

I managed to install a copy of D-scaler (v4.1.11) which contained regspy
from http://www.dscaler.org/downloads.htm, but was unable to get regspy nor
d-scaler to recognize the Compro E800 card.  Thus I have been unable to get
the register dump you requested.  I can try again if you think that regspy
can be made to work with the card and any suggestions here would be
appreciated.

Tom


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
