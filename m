Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n59.bullet.mail.sp1.yahoo.com ([98.136.44.43])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <free_beer_for_all@yahoo.com>) id 1KFxZR-0008LL-24
	for linux-dvb@linuxtv.org; Mon, 07 Jul 2008 22:44:27 +0200
Date: Mon, 7 Jul 2008 13:43:44 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Peter Beutner <p.beutner@gmx.net>
In-Reply-To: <485FB75E.4030606@gmx.net>
MIME-Version: 1.0
Message-ID: <517484.26175.qm@web46103.mail.sp1.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Broken ttusb-dec DVB support since, well, year(s)
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

Sorry to take so long to reply.  kernel@ dropped and replaced
by dvb@.  Patch worked for me.

--- On Mon, 6/23/08, Peter Beutner <p.beutner@gmx.net> wrote:

> >> sometime in the not-too-recent past and which resulted in breaking
> >> the support which early 2.6.1x kernels had for my Hauppauge
> >> DEC-3000s DVB-S device.

> So only dvb-s support is broken. The DEC-2000t (hopefully) still works.
> If there is still somebody around using that thing ;)
> Honestly, I wasn't aware that the DEC-3000s has ever really worked.

Well, it has, shall we say, ``issues'' or Wiki-material.

Lessee:  (specifics are based on european reception)
USB1 -- acceptable for radio, or VIC Screenpeaks video; had
worked for high-quality ARD video from NDR+ and MDR+, which
seemed to be clamped to no more than 7 or 8Mbit/sec peaks,
whatever fit well into USB1, but those particular channels
are/will be history.  Unsuitable for video now from the
remaining ARD transponders, except the new BR-alpha and SR
(rarely exceed 4Mbit/sec, due to most of the bandwidth on
that transponder being CBR audio).  Probably suitable for
commercial or other bandwidth-pinched broadcasters in other
lands where visible blocking artifacts don't matter, and
well over five/six stations per transponder is the norm.
But that's a general USB1/2 issue, not specific to this.

Repackages the TS for delivery via USB which is then repacked.
The timestamps get, um, manipulated (cycle at about half the
time of normal TS timestamps) which causes problems during
certain seeks in mplayer, or somehow seeks get messed up.

This repackaging also appears to have the effect of slightly
smoothing bitrate bursts on the TS, so that it is possible
to get uncorrupted video from this device where other USB1
devices with the same signal fail, but not for an extended
sequence of running water and such continuous high bandwidth
video.

For some reason, corrupts certain radio streams every ten or
20 seconds or so; only heard on the ORF Oe2 160kbit/sec Joint
stereo stations, never heard on FM4 from the same transponder,
or from BBC7, another 160kbit/sec Joint Stereo station.  The
corruption is audible and cannot be detected by mpg123 or the
like, as the 480-byte frames remain as such, while within the
payload of the mp2 gets somehow repeated or something (analyzed
once, but can't remember definitively) -- the CRC may show a
problem but is mostly ignored.

Limited normally to a single SD MPEG video PID and accompanying
mp2 audio stream with the same PCR.  Can't snarf PMT, 2nd audio,
H.264, 1080i MPEG, AC3, teletext, etc etc etc.

Under Linux, does not appear capable of delivering the 22kHz
band-switching signal to allow tuning to 11,7-12,75GHz channels
from ten or so simple LNBs, unless passed through another receiver
tuned to a high-band channel of the appropriate polarization.
However successfully switches a DiSEqC multischalter to receive
all bands and such with no hackery.  No o'scope here so I haven't
investigated.

Does not power up by itself.  Consumes a significant amount of
power after manually powered on and used.  Luckily this has not
been a real problem since the last europe-wide power outage,
apart from my power bill.

Occasionally seems to get stuck tuned to the previous channel
viewed and then the timing data for the video gets broken or
alternatively totally hosed; less often will deliver hopelessly
completely corrupted video in the PVA data, with audio mostly
or partly intact, from which only a power cycle will recover.

Cannot coexist and simultaneously operate with, in my case, a
Hauppauge WinTV Nova-S USB (1.x) older device on the same USB
controller, without going boom on 2.6.14 (haven't tried the
latest kernels), which would be either foolish (except I limit
my use of those two to low-bandwidth audio/video) or not a
problem as I use a separate EHCI-able card as well as the built-
in UHCI and therefore don't need to panic.

Therefore, after acquiring adequate other devices that perform
more reliably, I've limited my use of it to recording audio TS
data that will be stripped to only the mp2 payload Real Soon Now.
I'd retire it if I would backport recently-added code to work for
a different USB receiver, but haven't really missed having that.


However does allow one to connect via RGB SCART a TV, so I did
not need to worry about upgrading my (then 160MHz CPU, now 200MHz)
hardware to view something.  And it can support a CAM, not that
I've had interest in that.  And has an (unusable?) s/pdif coax
output.  Never tried under another OS.


There's probably something in there that would lead one to believe
that it never really worked, about as much as I'll never be able to
really run a marathon again after you send your bunch of goons
around to smash my kneecaps into a pulp...

The fact that I'm able to use it may be unrelated to how I'm working
to build my upper-body strength before you track down my IP address.



> >> In any case, with my particular device, in order to use more
> >> recent kernels, I've had to add a ``case 0:'' line to the
> >> ``case 3:'' seen above in order to get the previous behaviour
> >> where no check was made.

> Indeed I added the above code only for the dec2000-t model. Since I have no
> idea how that stuff works on the dec3000, probably the best thing to do is to
> revert to the old behaviour for dec3000s models, i.e. just pretend we always have
> a signal. Something like the attached patch. Does that help?

Oh, you want me to try it, or just to say that it can't be
any worse than the hack I'm using now (though yours is better)

I'll have to wait until my DEC is not busy making radio recordings
to try it for positive verification...

(days pass, twiddles thumbs)

Works for me.  Patch applied to a week-ish-old 2.6.26-rc8, delivered
stream with no errors reported..


> >> was added, I don't know if my device is unique, or whether the
> >> number of DVB-S users of this code is miniscule, as nobody else
> >> has complained that I've seen.

> well, i remember at least one report on the linux-dvb ml a long time ago
> and iirc I have posted the same patch there, but it didn't help.
> We never figured out how to make that particular dec3000s work.

I recall seeing something, back when I had no regular 'net access
and had to make an overnight trip two or three times a year to a
large town and try to update as much of my source repositories as
possible in a few hours while reading for the newest info, but
then not being able to contribute in an up-to-date fashion.  At
that time I had my hack workarounds to get it working, so...

Sorry that I haven't been able to contribute in any meaningful sense
until, well, I would say now, but I can't see that I've contributed
anything meaningful, so I'll have to take a gamble and say, sometime
before the turn of the century...


thanks,
barry bouwsma


      


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
