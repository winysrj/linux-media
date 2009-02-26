Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:10744 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935AbZBZMky (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2009 07:40:54 -0500
Received: by yx-out-2324.google.com with SMTP id 8so398229yxm.1
        for <linux-media@vger.kernel.org>; Thu, 26 Feb 2009 04:40:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <S79054AbZBZM2acYeFs/20090226122830Z+688@nic.funet.fi>
References: <S79054AbZBZM2acYeFs/20090226122830Z+688@nic.funet.fi>
Date: Thu, 26 Feb 2009 12:40:51 +0000
Message-ID: <15e616860902260440i79a4407dy9e15a4250f6e93b3@mail.gmail.com>
Subject: Re: [linux-dvb] writing DVB recorder, questions
From: Zaheer Merali <zaheermerali@gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 26, 2009 at 12:28 PM, Juhana Sadeharju <kouhia@nic.funet.fi> wrote:
>
> Hello. I started writing a simple DVB recorder, dvbrec. Perhaps
> it later evolves to program such as Klear, which indeed is
> clearest thing I have seen among DVB programs (but misses subtitles).
>
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
> (2) Do I need to use demux? PES? Filters? I don't understand them.
> Quick intro would be nice as well.
>
> (3) What PID to use for subtitles? channels.conf lists numbers
> 512:650:17 as a last thing. They seem to be video PID (512) and
> audio PID (650). Where is the subtitle PID (DMX_SUBTITLE)?
>
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
> Juhana
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

Hi

In GStreamer this is easy:

If you have a zap style channels.conf file as
~/.gstreamer-0.10/dvb-channels.conf, you can do for example if you
have a channel called BBC ONE: gst-launch dvb://BBC\ ONE ! filesink
location=bbcone.ts

It follows the PAT, PMT and will output the PAT, PMT and all stream
pids including subtitle, teletext, private stream as well as all the
video and audio pids and the PCR PID (if not one of the stream pids).

Zaheer
