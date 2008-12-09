Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.172])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1L9wDi-0000fc-4f
	for linux-dvb@linuxtv.org; Tue, 09 Dec 2008 07:37:25 +0100
Received: by ug-out-1314.google.com with SMTP id x30so848432ugc.16
	for <linux-dvb@linuxtv.org>; Mon, 08 Dec 2008 22:37:18 -0800 (PST)
Date: Tue, 9 Dec 2008 07:38:20 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Pavel Hofman <pavel.hofman@insite.cz>
In-Reply-To: <493D6ABC.5060400@insite.cz>
Message-ID: <alpine.DEB.2.00.0812090600440.14915@ybpnyubfg.ybpnyqbznva>
References: <49346726.7010303@insite.cz> <4934D218.4090202@verbraak.org>
	<4935B72F.1000505@insite.cz>
	<c74595dc0812022332s2ef51d1cn907cbe5e4486f496@mail.gmail.com>
	<c74595dc0812022347j37e83279mad4f00354ae0e611@mail.gmail.com>
	<49371511.1060703@insite.cz> <493BE666.8030007@insite.cz>
	<alpine.DEB.2.00.0812071856470.11349@ybpnyubfg.ybpnyqbznva>
	<493D6ABC.5060400@insite.cz>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Technisat HD2 cannot szap/scan
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

On Mon, 8 Dec 2008, Pavel Hofman wrote:

> Thanks a lot for your offer. I have a dual LNB (4 degrees apart), LNB0 points
> to Astra19.2E, LNB1 points to Astra23.5E. I am able to tune both satellites

Dobre rano...

I wrote my reply yesterday evening after spending sixteen
hours outside in search of beer, with temperatures slightly
to either side of zero.  It is amazing how my brain shuts
itself down in cold weather.  The fact that those hours
were spent on a bicycle probably contributed to being so
tired that I could not think properly -- and to waking to
find the impression of my keyboard in my face.

Anyway, as you noted in a later reply, you are in fact
receiving 28E instead of 19E2, so we agree there :-)

I said that you would need to move your sat dish slightly
to receive 19+23E instead of 23+28E.  This is not entirely
correct -- it may also be that your LNB is not properly
installed for 19+23E.

I am going to assume that the double LNB is similar to
those with 6 degree separation, intended for Astra/Hotbird
(19+13) or Sirius/Thor (5E+1W) where the LNB looks sort of
the Bad-ASCII-Art drawing I will attempt below -- and that
you use a normal 23 or 40mm mount on one of the two feeds.

If, however, your double LNB is a custom device, fit for
a specific dish, and so that the prime focus of your dish
is found between the two LNB heads, then you do not have
the flexibility that I hope you have.  Likewise, if you
have two separate LNBs mounted on a multifeed adapter,
as is my case with one dish receiving 19E2, 13E, and 23E5,
with that dish not a standard 80cm offset dish for which
most double LNBs with fixed separation are designed --
thus I need a wider separation; plus the flexibility of
making slight changes to the separation between LNB heads
allows me to fine-tune the signal for the strongest signal.

   _               \
  | |               \
  | =====D           |
  | |                |
  | =====D ----------|  Dish, prime focus and feedarm
  |_|                |
                     |
                    /
                   /

Hey, I *did* say Bad-ASCII-Art[tm].  This is a view looking
from the top.  Or the bottom (connectors visible).  But not
the side.  Let us say, looking down from above the dish.

Now, imagine the following satellite positions to the
left (looking south, seen from above the dish) of the above 
diagram:

 19E2
 23E5 ----- D ish
 28E

Remember that you can draw a line from the upper (in the
diagram) head of the LNB to the centre of the dish, and
then bounce it off like a mirror and so you see it is
actually bouncing towards 28E -- in spite of being in the
path from the dish to 19E.

So, rather than move the dish and lose your prime focus
at 23E5, which I am assuming is more important to you --
also as 19E2 likely has more than a strong enough signal
for you, whether you are in Cheb or Ostrava -- you simply
need to move your double LNB.

The proper way would to be to re-mount the LNB so that
instead of the bottom LNB as shown above -- or, if looking
at the dish from above and behind, and looking in the
direction of the satellites, the LNB on the left --
instead of this being at the centre and attached to the
feedarm, the other LNB, seen at the top in the diagram
above, is attached to the feedarm.

That solution means that your 23E5 LNB is no longer at
DiSEqC position 1/2 or 2/2 as it is now, but is to be
found at the other position.  So your new scans and
channels.conf files will need to reflect this, and will
no longer be the same as your older ones.


An easier but temporary solution is to rotate your double
LNB in its mount, so that instead of the feed cables
coming in at the bottom, they are on the top -- simply
turn the LNB assembly upside-down.  Voila!  The LNB head
which was on the left is suddenly on the right.  The
position that had been 23E5 is unchanged; the other
DiSEqC position is no longer 28E but now 19E2, and you
should then be able to tune in free-to-air german,
french, spanish, and even a lower quality version of
CT24 without DVB subtitles.


After you do the above to verify you can tune 19E2,
then you should re-mount the LNB as I describe; as an
alternative, you *can* move your dish to point its
prime focus directly at 19E2, and the 4 degree offset
will then be at 23E5, which will be slightly weaker
than before.  So you probably would rather remount
the LNB.



> now, nevertheless your channel.conf's for them would probably help.

There's an old 19E2 scan result in native 8-bit (not
UTF-8) encoding which you can find at
http://webhotel.chrillesen.dk/~barry/scan-result-astra1-2008-08-27
which is made by a very hacked `scan' and custom
script^W hack to generate it -- it isn't up-to-date
but at this Astra position, changes are relatively
few, and it's a start.

If you need more recent scan results, or those for 28E
or 23E5, I'll have to upload them, or better, make a
newer scan, less than a month old, with UTF-8 output...


Disclaimer:  If any of the above does not make sense,
then I shall claim that it is because I am still in
pain all over, and did not sleep long enough.  Which also
means I'm not going to spend all day today again in
search of more beer, which was my original plan, before
the rain and snow returns...

barry bouwsma
well fit *snigger*

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
