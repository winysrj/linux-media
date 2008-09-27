Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1Kjf1l-0003Mq-KK
	for linux-dvb@linuxtv.org; Sat, 27 Sep 2008 21:00:26 +0200
Received: by ey-out-2122.google.com with SMTP id 25so395529eya.17
	for <linux-dvb@linuxtv.org>; Sat, 27 Sep 2008 12:00:22 -0700 (PDT)
Date: Sat, 27 Sep 2008 20:59:46 +0200 (CEST)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Artem Makhutov <artem@makhutov.org>
In-Reply-To: <20080926180112.GI28383@moelleritberatung.de>
Message-ID: <alpine.DEB.1.10.0809272011420.15691@ybpnyubfg.ybpnyqbznva>
References: <20080926180112.GI28383@moelleritberatung.de>
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

As nobody has yet to jump on this that I've seen, I may as
well have a go...

On Fri, 26 Sep 2008, Artem Makhutov wrote:

> I have recorded some h264 encoded videos.
> 
> I would like to find out the parametes on how the video was encoded.

Someone who is familiar with the H.264 encoding possibilities
would need to answer this -- though perhaps a very verbose
setting of a player might be able to spew tons of debug info,
perhaps including the details of each frame.


> Especially what maximum bitrate is used by the stream.

When you say `maximum', do you mean the peak of, say, each
slice of bandwidth between, for example, the timestamps
recorded in the stream that you have on disk?

It should be possible to find this, but I'm not aware of
any utility which does this.

Or, might you mean maximum average bandwidth over intervals
of one second?  That's easier, if you refer to the stream
in general, and not what you already have written to disk.

Take a look at the `dvbtraffic' utility in `dvb-apps'.
This can show, at intervals of one second, the number of
packets and bandwidth of all or some of the PIDs within
a transponder.  By watching this over time, concentrating
on the video PID of your stream, you can see whether the
bitrate remains fairly constant or varies depending on
available bandwidth/image complexity, plus you can get a
feel for the range of bitrate the stream requires.


> And how can I find out if the video is using 1080i or 1080p?

Use a machine like mine (300MHz CPU) which can only display
two or three frames per second typically, on scenes full
of motion.  If moving objects appear jagged, then the source
is interlaced.  If each frame appears sharp but the difference
between frames is noticeable, then the source is progressive.

This assumes that, like me, you are using `mplayer' with
the option `-nosound' that causes every frame to be decoded
and displayed.  Other players I've tried appear to default
to the mplayer `-framedrop' option for my slow machine (with
SD MPEG-2 video, of course) so that I see random frames.

For example, the BBC series `Planet Earth' is a delight to
watch as it slowly makes its way across my screen, as it is
broadcast for the most part by the BBC with 25 full frames
per second -- apart from the credits superimposed at the
end, which are interlaced and look awful with no video
processing to de-interlace them.  The `Making Of' that
follows on the BBC hour-long program is largely upscaled
interlaced 576i standard definition.

Similarly, 24fps film stock will usually be a nice sharp
progressive frame.  Unless the video mastering has botched
the field ordering, which happens dismayingly often with
films transferred to SD 576i, but can be restored with the
computationally expensive `phase' option with `mplayer'.

Other BBC-HD video snippets that I grabbed for testing
are interlaced (concert recordings) and are nowhere near
as pleasing to the eye on a simple LCD screen.

I'm going to guess from your e-mail headers that you are
in the same general part of the world as I am, although
you haven't mentioned exactly which sources you have used
for your H.264 video snippets.


What I've read is that there is no official 1080 progressive
standard for broadcasting used in Europe (was on the Internet,
Must Be True) and that presently all 1080 content is sent
as interlaced, but if the source consisted of progressive
25fps material, it is essentially progressive and needs no
deinterlacing.

Now, if your headers indicate your location and you have
made recordings from the EinsFestival showcases, these are
720-line progressive broadcasts with 50 frames per second.
However, in the case of the BBC `Planet Erde' as broadcast,
the frames I looked at were all identical every two frames,
so that for all practical purposes, it was comparable to
the BBC broadcast, only lower resolution.  But I haven't
studied these recordings I made.

Other material which likely originated from the BBC was
in fact 720p at 50 frames/second -- though it may well
have been originally recorded at 1080i or 1080p, and
either up- or downscaled, and to me did not look very
good, detail-wise.


Boy, do I type a lot.


barry bouwsma

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
