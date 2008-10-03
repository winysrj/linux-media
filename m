Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.24])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1KlooX-0003sn-TK
	for linux-dvb@linuxtv.org; Fri, 03 Oct 2008 19:51:44 +0200
Received: by ey-out-2122.google.com with SMTP id 25so654021eya.17
	for <linux-dvb@linuxtv.org>; Fri, 03 Oct 2008 10:51:38 -0700 (PDT)
Date: Fri, 3 Oct 2008 19:51:17 +0200 (CEST)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Artem Makhutov <artem@makhutov.org>
In-Reply-To: <48E5CFEF.7010308@makhutov.org>
Message-ID: <alpine.DEB.2.00.0810031904110.4242@ybpnyubfg.ybpnyqbznva>
References: <20080926180112.GI28383@moelleritberatung.de>
	<alpine.DEB.1.10.0809272011420.15691@ybpnyubfg.ybpnyqbznva>
	<48E5CFEF.7010308@makhutov.org>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Find out max used bandwidth in video stream
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

On Fri, 3 Oct 2008, Artem Makhutov wrote:

> Better I explain you, what I want to do:

Thanks, this is helpful:

> According to the specs, the receiver is capable of decoding this formats:
> MPEG-4 H.264 MP@L3.0 (ISO 14496-10): up to 10 Mbps

Sounds like SD video...

> MPEG-4 H.264 HP@L4.0 (ISO 14496-10): up to 25 Mbps

Sounds like HD video...

> Microsoft VC-1 MP@HL (WMV9), AP@L3: up to 25 Mbps

Sounds like Evil...

I would have to look to find out the actual details of each
profile and level to see if there might be any incompatibilities
that would be obvious to someone who knows the specs by heart,
but I am lazy...

In general, SD video of decent quality (or, compared to what
else is out there, superb quality), is sent over sat in MPEG-2
by ZDF/3sat, especially overnight when Theatre takes a pause,
or the ARD Dritte programs at 12110MHz, at up to 10Mbit/sec.

I have read that comparable quality H.264 SD video needs about
half the bandwidth.  In practice, I've seen quoted 2Mbit/sec or
so for the few SD channels currently sent in H.264.

The rates I've seen quoted for HD video from the UK range from
10Mbit/sec for ITV-HD to 15Mbit/sec for BBC-HD and up to 
20Mbit/sec for some Sky UK channels.  These are all 1080i
(some source material is progressive).


> So what I want to do is to fake my providers "IP-TV-Network", as the box is
> using HTTP to communicate whis the ISP this should not be the problem.
> 
> And then stream my DVB-S2 / H264 recordings to the IPTV receiver.

Sounds interesting.  Good luck  :-)

I don't think you need to worry about broadcast bandwidth.


> I am living in Germany, and my satellite dish is setup to Astra 19,2 E.
> I did some recording from Arte HD, Astra HD promo and Anixe HD.

Another thing to note is that while the UK services I mention
use resolution of 1080, many continental broadcasters have for
the moment settled on using 720p50 -- although bandwidth should
be comparable (also of note is that the transmitted resolution
of BBC-HD is currently 1440x1080, so that it needs somewhat
less bandwidth than if it were sent 1-to-1 as 1920x1080).

A further source of information on bandwidth (that you can also
see from your file sizes) would be several internet sat-DX sites
which give lots of information about the bandwidth of the audio
and video streams at time of sampling.  I can't name names off
the top of my head which I know give this info, but I've seen
the data (which has not always been 100% accurate)...


> My PC, Athlon X2 6000+ (2x 3GHz),  is too slow to playback the recordings
> smoothly.

It would be really nice, as soon as there is a way to use the
hardware acceleration in today's graphics cards, to offload
much of the work from your CPU, the way that X11's XvMC for
MPEG-2 helps a few vendors' cards play smoothly on hardware
as old and slow as mine (still need to dig up my arte-HD tests
from a year or three ago sent as MPEG-2 and try them) ...



> > However, in the case of the BBC `Planet Erde' as broadcast,
> > the frames I looked at were all identical every two frames,

> > Other material which likely originated from the BBC was
> > in fact 720p at 50 frames/second -- though it may well
> > have been originally recorded at 1080i or 1080p, and
> > either up- or downscaled, and to me did not look very

> I see, the DVB-Providers are changing the transmission "parameters" during the
> stream... hmmm, that's not good.

Not really -- certainly they do not change (switch) the
parameters during the stream (broadcast) -- but if they
have received a master at 1080i, they need to change (convert)
it to the 720p which is broadcast.

Or it may be that the production is all done in 1080p, and
then from this, masters at 1080i and 720p are made to be
sold to the various broadcasters.  I don't know the details
of the production business.

In any case, the streams you record will always be Xx720p
or Xx1080i, where X is stretched appropriately for display
if needed, the way that 720x or 704x576 SD video is stretched
to the 16:9 aspect ratio 1024x576.  That won't change.


> > Boy, do I type a lot.
> >   
> Yes, you do :)

And with one finger, other hand holding my beer bottle, in
the dark, by the dim glow of my monitor with a black background.

that's why i make so many typing errors, sorry
barry bouwsma

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
