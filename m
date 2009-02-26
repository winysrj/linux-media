Return-path: <linux-media-owner@vger.kernel.org>
Received: from rouge.crans.org ([138.231.136.3]:48325 "EHLO rouge.crans.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754499AbZBZNiJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2009 08:38:09 -0500
Message-ID: <49A69374.3000703@crans.org>
Date: Thu, 26 Feb 2009 14:04:52 +0100
From: Brice Dubost <dubost@crans.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: linux-dvb@linuxtv.org, kouhia@nic.funet.fi
Subject: Re: [linux-dvb] writing DVB recorder, questions
References: <S79054AbZBZM2acYeFs/20090226122830Z+688@nic.funet.fi>
In-Reply-To: <S79054AbZBZM2acYeFs/20090226122830Z+688@nic.funet.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Juhana Sadeharju wrote:
> Hello. I started writing a simple DVB recorder, dvbrec. Perhaps
> it later evolves to program such as Klear, which indeed is
> clearest thing I have seen among DVB programs (but misses subtitles).
> 

Hello

> The complete stream has too much of data: 10 GB per hour.
> As solution, existing recorders seems to pick only parts of the
> whole stream (audio and video of one channel), missing many
> features, including subtitles. The idea seems to be to drop
> the parts that are unwanted and unknown (to author).
> 
> Perfect recording requires more. My idea is to pick all what comes
> and drop the known parts: audio and video of the unwanted channels.
> This leaves subtitles, alternative languages, robovoice, epg,
> text-tv, etc. intact.
> 
> Xine plays poorly the output of "dvbstream -o 8192". I yet don't
> know why. Xine people may take this early hint and think about
> playing the complete DVB stream with a configurable way to play it.
> 
> Questions:
> 
> (1) In dvbstream, what happens when 8192 is only PID? I have stared
> at the code but cannot figure out how the device is configured. I want
> all data from the DVB device like "dvbstream -o 8192" does.
> Then I may parse the stream on my own.
> 

If you put 8192 at being the only pid you get the whole MPEG2-TS stream
of the transponder

> (2) Do I need to use demux? PES? Filters? I don't understand them.
> Quick intro would be nice as well.
> 
> (3) What PID to use for subtitles? channels.conf lists numbers
> 512:650:17 as a last thing. They seem to be video PID (512) and
> audio PID (650). Where is the subtitle PID (DMX_SUBTITLE)?
> 

I think you have only the audio video and pmt in this ouput format

The pid subtitle change from channel to channel.

> (4) I have followed Xine's way, but my program ends to
> "Unable to read PAT filter". The polled and read FD is a demux FD.
> How the demux should be used?
> 
> I will ask more questions later. Recording video and audio has
> been easy, but subtitles, EPG, etc. are quite a different story.
> 
> PS. I'm now trying to read PAT/PTM but I get nothing from
> demux FD. I'm following xine-lib, but apparently not enough well.
> 

What I can propose to you is to use mumudvb. (http://mumudvb.braice.net )

It has been made for streaming channels but you can use it indirectly
for saving (and I think it can be easily modified to fit you needs)

The good point for you is that mumudvb is able to find all the pids for
audio, video, PCR, ac3, dts, aac, subtitling, teletext and the mandatory
PAT, EIT (wich contains EPG), NIT, SDT, TDT, PMT and send them
automatically with the channel. You just have to give the tuning parameters.

So you don't have to care about demuxing and sorting data. The second
point is that it can stream all the channels of a transponder, so you
can record more than one channel at the same time.

for recording you can use mplayer in the following way

mplayer -dumpfile filename.mpg -dumpstream udp://ip:port


Hope this will helps you

Best regards

-- 
Brice
