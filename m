Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bane.moelleritberatung.de ([77.37.2.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <artem@makhutov.org>) id 1LEivj-0000nO-7b
	for linux-dvb@linuxtv.org; Mon, 22 Dec 2008 12:26:36 +0100
Message-ID: <494F7969.3020100@makhutov.org>
Date: Mon, 22 Dec 2008 12:26:33 +0100
From: Artem Makhutov <artem@makhutov.org>
MIME-Version: 1.0
To: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
References: <20081220224557.GF12059@titan.makhutov-it.de>
	<alpine.DEB.2.00.0812210301090.22383@ybpnyubfg.ybpnyqbznva>
	<1229827473.2557.11.camel@pc10.localdom.local>
	<20081221135926.GI12059@titan.makhutov-it.de>
	<alpine.DEB.2.00.0812211524260.22383@ybpnyubfg.ybpnyqbznva>
In-Reply-To: <alpine.DEB.2.00.0812211524260.22383@ybpnyubfg.ybpnyqbznva>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] How to stream DVB-S2 channels over network?
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

Hi,

BOUWSMA Barry schrieb:
> On Sun, 21 Dec 2008, Artem Makhutov wrote:
> 
>> I have recorded the stream to a file and will try to playback it under windows.
>> My CPU is too slow to playback the stream without GPU acceleration under linux.
> 
> A common occurrence, I say, fondling my beloved 200MHz
> production machine that records four streams flawlessly
> (save for two devices being USB1 and thus only good for
> radio or selected TV clamped to a maximum bitrate, for
> now)
> 
> 
> I pass all my recordings through a two-pass process to
> check for problems (for radio, obviously just one pass)
> 
> I have a script that extracts the audio payload using a
> hack to `dvb_mpegtools' and passes it to `mpg123'.  The
> `dvb_mpegtools' serves to check the integrity of the
> Transport Stream (usually when bad weather affects my
> satellite reception, or when my DVB-T receiving antenna
> is placed in a poor location); `mpg123 -v -t' zips through
> the file and spits out any corrupted audio frames.
> 
> (The version of mpg123 I use doesn't seem to do anything
> with the CRC when used, and it gets confused when the
> CRC is toggled during a stream, which has happened a few
> times during recordings I've made.  That's something
> which I should work on, because I have a few recordings
> with audible blorps that pass the `mpg123' test, probably
> due to flipped bits in the payload rather than dropped
> data.)
> 
> 
> Then I use `mplayer' to check the video, using the
> options `-nosound -vo null' and in the case of MPEG-2
> video, `-vc ffmpeg12'.  This will spit out errors due
> to corruption of the video data -- though you need to
> hack in some newlines if you want to actually see the
> PTS timestamp where the error(s) occurred.
> 
> For H.264 video, there is no alternative to `-vc ffh264'
> that I know of, but it will similarly spew out errors
> if there's damage to your source.
> 
> Sure, it takes my machines more than a day to chew through
> an hour of H.264 1080i video, but I know whether I need
> to re-record the programme later to get a clean file that
> I can watch in some ten years when people throw away the
> gamer machines of today.  Yeah, I'm cheap.  What of it?
> 
> 
> That's a lot easier than suffering eyestrain watching a
> screen for some scarcely-visible corruption, which I
> used to do long ago...

Thats interesting. Thanks.

I have replayed the recorded video file on Windows and I saw some
artifacts in the stream. So the stream is corrupted.

Today I have also replaced my 60cm dish with a 80cm one.

Now I have much less curruptions in the stream.

The most interesting thing is, that I had absolutly no corruptions in
the stream under windows with the 60cm dish, and under Linux I still
have some corruptions with the 80cm dish.

So the reception is much better with windows then with linux...

Regards, Artem




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
