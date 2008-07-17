Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n76.bullet.mail.sp1.yahoo.com ([98.136.44.48])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <free_beer_for_all@yahoo.com>) id 1KJWaf-0000rq-Qa
	for linux-dvb@linuxtv.org; Thu, 17 Jul 2008 18:44:27 +0200
Date: Thu, 17 Jul 2008 09:43:51 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <442414.53319.qm@web46110.mail.sp1.yahoo.com>
Subject: [linux-dvb] Anatomy of the TerraTec Cinergy HTC USB XS HD stick
Reply-To: free_beer_for_all@yahoo.com
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

Hey kids, even *you* can take apart daddy's new toy, so get your
jewellers screwdrivers ready!

First off is the grey plastic that covers three of the four sides
of the stick, by gently prying it up from the ends -- lift it
slightly straight out from each side and it separates cleanly
from the white box without that satisfying snap.

Revealed are four sets of the smallest crosshead screws that
you will want to see.  Remove *one* from each pair; they simply
attach to a metal plate which holds the case together, lest you,
like me, not only lose most of the screws, but the plates as well.

Now the white box separates without effort into its two halves.
The meat of the box is still attached with two more screws to
one of those halves, and it pays to remove those screws, safely
placing them in a spot where you'll accidentally set them flying
from your workspace into your heavy shag carpet.

At this point, you see that the device consists of two circuit
boards, connected with spacers, that look as if they should be a
socket and plug pair, but don't seem to want to act that way.
You know the sound of a snapping circuit board does wonders for
science, so I'm not sure why I couldn't convince myself of that.

There is one `empia' chip to be seen within the nether regions
between the boards.  The outer side labelled `TOP' has little
of interest -- the IR sensor and LED and other discrete
components.  It also has the RF connector and tuner attached
sandwiched between the boards, but there is a metal housing
that appears to be well attached to the board, hiding its innards
from discovery.

The part number of the Empia chip is virtually impossible to make
out with just eyeballs and a weak light, but I'd almost want to
claim it's EM2884.  If there's another chip on that side, I'm
not able to see it.

On the side of the package labelled `BOT' are seen two Micronas
ships, a DRX 3926KA1, and an AVF 4910BA1.  There's also an 8-pin
ACE24C32, which should be the EEPROM.  The DRX series appears to
be Analog or DVB or ATSC demod/decoding, while the AVF chip
should be an analog/composite/S-video decoder.

Now that I look more closely, it appears that the metal case
of the tuner actually consists of a top that should pop off and
is not itself soldered to the circuit board, but that first
requires separating the sandwich, and I'm too much a wuss to
have passed that point (this stick isn't cheap in comparison
with many others).  The connectors holding it together mock me
and stubbornly refuse to be separated.

If I can trust my hacking on code which I haven't bothered to
understand, claiming that the tuner is an XC5000 fails to
attach a tuner, while claiming it's an XC3028 fails to fail to
attach, but doesn't say anything more.

Admittedly, I want it to be an XC5000 as if I've read properly,
that supports 256QAM for DVB-C, which the XC3028 does not, and
if that's true, then this stick won't be the DVB-C USB solution
I hoped for...  But there may be something else there entirely.


Armed with this knowledge, I could think about posting initial
hacks to identify this device at plugin.


Say kids, wasn't that fun?  Now be sure to hide all the little
pieces where daddy won't find them, including all those SMD
components you knocked off when your screwdriver slipped, and
be sure to keep it a secret, okay?  And next week we're gonna
do something even *more* exciting, so get your powertools ready!


Yours &c. &c.,
Uncle Drunkard


      


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
