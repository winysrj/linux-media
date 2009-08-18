Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:40714 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbZHRTaY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2009 15:30:24 -0400
Received: by ewy3 with SMTP id 3so1867710ewy.18
        for <linux-media@vger.kernel.org>; Tue, 18 Aug 2009 12:30:24 -0700 (PDT)
Date: Tue, 18 Aug 2009 21:30:18 +0200 (CEST)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: =?UTF-8?Q?P=C3=A1sztor_Szil=C3=A1rd?= <don@tricon.hu>
cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Anysee E30 C Plus + MPEG-4?
In-Reply-To: <20090818210107.2a6a5146.don@tricon.hu>
Message-ID: <alpine.DEB.2.01.0908182107300.27276@ybpnyubfg.ybpnyqbznva>
References: <20090818170820.3d999fb9.don@tricon.hu> <alpine.DEB.2.01.0908181959241.27276@ybpnyubfg.ybpnyqbznva> <20090818210107.2a6a5146.don@tricon.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 18 Aug 2009, Pásztor Szilárd wrote:

> direction so I'm a step further now. With scan -vv I could find the video PIDs
> for the HD channels and indeed they were missing in my channels.conf (values
> were 0) as scan detected them as "OTHER", but with a "type 0x1b" addition with
> which I don't know what to do for the time being...

Okay, so you are using a `channels.conf' file, which is used for
tuning directly by `mplayer' into a particular service.

The `scan' utility you use does not recognise the H.264 video 
service as a video stream, which is why you don't get that as
your video PID.  A common problem, I would guess.


> After adding the correct PID values, mplayer still can't demux the incoming
> stream but the video is there, and with -dumpvideo a h264 elementary stream
> gets produced in the file that can be played back if I specify -demuxer
> h264es on the command line. What are beyond me now are:
> 1) how can mplayer not demux the stream if it can dump the video out
> (shouldn't a video dump involve a demux operation before all?)

`mplayer' does not (yet?) understand native H.264 video.  Whether
this is purely an `mplayer' limitation, or something which also
will affect other players, I cannot say -- I haven't looked into
this.

As a result, even if you have both the video and audio PIDs in
your stream, you still need the additional PID from which 
`mplayer' can get the needed identification of the video as H.264.
This is found in the PMT PID (for BBC-HD in my example, 258 or
whatever 3-digit PID was there -- my memory is going...)

I said it before and I'll say it again, what `mplayer' needs is
 -- I mean, I don't know if it would be possible for `mplayer' to
identify the video as H.264, but for me, it needs this additional
PID stream to do that.  That is something for the `mplayer' 
developers or for someone more familiar with H.264 in DVB to
answer.

I'm guessing your `channels.conf' file is simple with one field
for video and one for audio, but no extra fields.  If this is the
case, then what you will need to do as a test would be to write
more of the stream to a file; the example I gave in my earlier
reply for BBC-HD is what I pass to `dvbstream'.  Then `mplayer'
should be able to play this file with no problems.



> 2) is it a missing feature of mplayer that no metastream is processed that
> would carry the necessary information about the muxed streams? It would be

Like I say, I don't know if the video stream alone contains the
needed info that in theory `mplayer' could identify it as H.264.
Although it is outside of your reception as is BBC-HD via 
satellite, the british ITV HD service is broadcast as H.264 but
without a stream identifying it as such.  As a result, I've had
to hack `mplayer' to treat the video as such in order to be able
to watch the recordings I've made.

Note that my observations are made about `mplayer' from almost a
year ago, and if there have been changes made since, such as a 
more comprehensive `channels.conf' file, I'm not aware of them.


Hope this helps to understand your problem a bit better...

barry bouwsma
