Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bane.moelleritberatung.de ([77.37.2.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <artem@makhutov.org>) id 1KlfVc-0005Kn-0U
	for linux-dvb@linuxtv.org; Fri, 03 Oct 2008 09:55:33 +0200
Message-ID: <48E5CFEF.7010308@makhutov.org>
Date: Fri, 03 Oct 2008 09:55:27 +0200
From: Artem Makhutov <artem@makhutov.org>
MIME-Version: 1.0
To: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
References: <20080926180112.GI28383@moelleritberatung.de>
	<alpine.DEB.1.10.0809272011420.15691@ybpnyubfg.ybpnyqbznva>
In-Reply-To: <alpine.DEB.1.10.0809272011420.15691@ybpnyubfg.ybpnyqbznva>
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

Hello,

BOUWSMA Barry schrieb:
> As nobody has yet to jump on this that I've seen, I may as
> well have a go...
>   
Thank you for the info!
> On Fri, 26 Sep 2008, Artem Makhutov wrote:
>
>   
>> I have recorded some h264 encoded videos.
>>
>> I would like to find out the parametes on how the video was encoded.
>>     
>
> Someone who is familiar with the H.264 encoding possibilities
> would need to answer this -- though perhaps a very verbose
> setting of a player might be able to spew tons of debug info,
> perhaps including the details of each frame.
>   
Yes, I will try this out.
>   
>> Especially what maximum bitrate is used by the stream.
>>     
>
> When you say `maximum', do you mean the peak of, say, each
> slice of bandwidth between, for example, the timestamps
> recorded in the stream that you have on disk?
>   
I am not sure. I think that I need to know the peak.
> It should be possible to find this, but I'm not aware of
> any utility which does this.
>
> Or, might you mean maximum average bandwidth over intervals
> of one second?  That's easier, if you refer to the stream
> in general, and not what you already have written to disk.
>
> Take a look at the `dvbtraffic' utility in `dvb-apps'.
> This can show, at intervals of one second, the number of
> packets and bandwidth of all or some of the PIDs within
> a transponder.  By watching this over time, concentrating
> on the video PID of your stream, you can see whether the
> bitrate remains fairly constant or varies depending on
> available bandwidth/image complexity, plus you can get a
> feel for the range of bitrate the stream requires.
>   
Yes I will try this out.

Better I explain you, what I want to do:

I have a ADB IPTV receiver:

https://store.adbglobal.com/store/pdf/3810TW%20IPTV%20development%20STB%20-v1.pdf

According to the specs, the receiver is capable of decoding this formats:

MPEG-4 H.264 MP@L3.0 (ISO 14496-10): up to 10 Mbps
MPEG-4 H.264 HP@L4.0 (ISO 14496-10): up to 25 Mbps
Microsoft VC-1 MP@HL (WMV9), AP@L3: up to 25 Mbps
Resolution: 1080i, 720p, 576p, 576i

The problem is that the decoder is "locked" by my ISP provider.
So what I want to do is to fake my providers "IP-TV-Network", as the box is
using HTTP to communicate whis the ISP this should not be the problem.

And then stream my DVB-S2 / H264 recordings to the IPTV receiver.

So I want to find out if the receiver is capable of playing back my 
recording,
before I will put a lot of work into it.

>> And how can I find out if the video is using 1080i or 1080p?
>>     
>
> Use a machine like mine (300MHz CPU) which can only display
> two or three frames per second typically, on scenes full
> of motion.  If moving objects appear jagged, then the source
> is interlaced.  If each frame appears sharp but the difference
> between frames is noticeable, then the source is progressive.
>
> This assumes that, like me, you are using `mplayer' with
> the option `-nosound' that causes every frame to be decoded
> and displayed.  Other players I've tried appear to default
> to the mplayer `-framedrop' option for my slow machine (with
> SD MPEG-2 video, of course) so that I see random frames.
>
> For example, the BBC series `Planet Earth' is a delight to
> watch as it slowly makes its way across my screen, as it is
> broadcast for the most part by the BBC with 25 full frames
> per second -- apart from the credits superimposed at the
> end, which are interlaced and look awful with no video
> processing to de-interlace them.  The `Making Of' that
> follows on the BBC hour-long program is largely upscaled
> interlaced 576i standard definition.
>
> Similarly, 24fps film stock will usually be a nice sharp
> progressive frame.  Unless the video mastering has botched
> the field ordering, which happens dismayingly often with
> films transferred to SD 576i, but can be restored with the
> computationally expensive `phase' option with `mplayer'.
>
> Other BBC-HD video snippets that I grabbed for testing
> are interlaced (concert recordings) and are nowhere near
> as pleasing to the eye on a simple LCD screen.
>
> I'm going to guess from your e-mail headers that you are
> in the same general part of the world as I am, although
> you haven't mentioned exactly which sources you have used
> for your H.264 video snippets.
>   
I am living in Germany, and my satellite dish is setup to Astra 19,2 E.
I did some recording from Arte HD, Astra HD promo and Anixe HD.

My PC, Athlon X2 6000+ (2x 3GHz),  is too slow to playback the 
recordings smoothly.
Sometimes it drops some frames, or I loose the sound. So I wanted to
let my IPTV receiver to do this job.
> What I've read is that there is no official 1080 progressive
> standard for broadcasting used in Europe (was on the Internet,
> Must Be True) and that presently all 1080 content is sent
> as interlaced, but if the source consisted of progressive
> 25fps material, it is essentially progressive and needs no
> deinterlacing.
>
> Now, if your headers indicate your location and you have
> made recordings from the EinsFestival showcases, these are
> 720-line progressive broadcasts with 50 frames per second.
>   
I missed them :(
> However, in the case of the BBC `Planet Erde' as broadcast,
> the frames I looked at were all identical every two frames,
> so that for all practical purposes, it was comparable to
> the BBC broadcast, only lower resolution.  But I haven't
> studied these recordings I made.
>
> Other material which likely originated from the BBC was
> in fact 720p at 50 frames/second -- though it may well
> have been originally recorded at 1080i or 1080p, and
> either up- or downscaled, and to me did not look very
> good, detail-wise.
>   
I see, the DVB-Providers are changing the transmission "parameters" 
during the stream... hmmm, that's not good.
> Boy, do I type a lot.
>   
Yes, you do :)

Thanks, Artem


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
