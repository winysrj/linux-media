Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:43550 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757346Ab2DXWwb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Apr 2012 18:52:31 -0400
Subject: Re: HVR-1600 QAM recordings with slight glitches in them
From: Andy Walls <awalls@md.metrocast.net>
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Cc: linux-media@vger.kernel.org
Date: Tue, 24 Apr 2012 18:42:23 -0400
In-Reply-To: <jn2ibp$pot$1@dough.gmane.org>
References: <jn2ibp$pot$1@dough.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1335307344.8218.11.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2012-04-22 at 23:30 -0400, Brian J. Murrell wrote:
> Hi,
> 
> I have an HVR-1600 on a 3GHz dual-core P4 running linux 3.2.0.
> 
> Whenever I record from clearqam using this card I frequently get small
> "glitches" in playback.  Playing these same files with mplayer yields
> things like:
> 
> demux_mpg: 24000/1001fps progressive NTSC content detected, switching framerate.
> [mpeg2video @ 0x893a2e0]mb incr damaged
> [mpeg2video @ 0x893a2e0]Warning MVs not available
> [mpeg2video @ 0x893a2e0]concealing 66 DC, 66 AC, 66 MV errors
> 
> demux_mpg: 30000/1001fps NTSC content detected, switching framerate.
> Warning! FPS changed 23.976 -> 29.970  (-5.994005) [4]  
> 
> demux_mpg: 24000/1001fps progressive NTSC content detected, switching framerate.
> 
> demux_mpg: 30000/1001fps NTSC content detected, switching framerate.
> Warning! FPS changed 23.976 -> 29.970  (-5.994005) [4]  
> 
> demux_mpg: 24000/1001fps progressive NTSC content detected, switching framerate.
> [mpeg2video @ 0x893a2e0]invalid cbp at 4 12
> [mpeg2video @ 0x893a2e0]Warning MVs not available
> [mpeg2video @ 0x893a2e0]concealing 198 DC, 198 AC, 198 MV errors
> [mpeg2video @ 0x893a2e0]ac-tex damaged at 11 24
> [mpeg2video @ 0x893a2e0]Warning MVs not available
> [mpeg2video @ 0x893a2e0]concealing 99 DC, 99 AC, 99 MV errors
> 
> demux_mpg: 30000/1001fps NTSC content detected, switching framerate.
> Warning! FPS changed 23.976 -> 29.970  (-5.994005) [4]  
> 
> demux_mpg: 24000/1001fps progressive NTSC content detected, switching framerate.
> 
> demux_mpg: 30000/1001fps NTSC content detected, switching framerate.
> Warning! FPS changed 23.976 -> 29.970  (-5.994005) [4]  
> 
> demux_mpg: 24000/1001fps progressive NTSC content detected, switching framerate.
> 
> demux_mpg: 30000/1001fps NTSC content detected, switching framerate.
> Warning! FPS changed 23.976 -> 29.970  (-5.994005) [4]  
> 
> demux_mpg: 24000/1001fps progressive NTSC content detected, switching framerate.
> 
> demux_mpg: 30000/1001fps NTSC content detected, switching framerate.
> Warning! FPS changed 23.976 -> 29.970  (-5.994005) [4]  
> 
> demux_mpg: 24000/1001fps progressive NTSC content detected, switching framerate.
> [mpeg2video @ 0x893a2e0]ac-tex damaged at 27 0
> [mpeg2video @ 0x893a2e0]ac-tex damaged at 1 1
> [mpeg2video @ 0x893a2e0]ac-tex damaged at 6 2
> [mpeg2video @ 0x893a2e0]slice mismatch
> [mpeg2video @ 0x893a2e0]mb incr damaged
> [mpeg2video @ 0x893a2e0]invalid cbp at 15 6
> [mpeg2video @ 0x893a2e0]mb incr damaged
> [mpeg2video @ 0x893a2e0]ac-tex damaged at 4 8
> [mpeg2video @ 0x893a2e0]slice mismatch
> [mpeg2video @ 0x893a2e0]invalid mb type in B Frame at 21 10
> [mpeg2video @ 0x893a2e0]slice mismatch
> [mpeg2video @ 0x893a2e0]slice mismatch
> [mpeg2video @ 0x893a2e0]mb incr damaged
> [mpeg2video @ 0x893a2e0]slice mismatch
> [mpeg2video @ 0x893a2e0]ac-tex damaged at 12 15
> [mpeg2video @ 0x893a2e0]mb incr damaged
> [mpeg2video @ 0x893a2e0]slice mismatch
> [mpeg2video @ 0x893a2e0]invalid cbp at 14 18
> [mpeg2video @ 0x893a2e0]invalid mb type in B Frame at 12 20
> [mpeg2video @ 0x893a2e0]slice mismatch
> [mpeg2video @ 0x893a2e0]mb incr damaged
> [mpeg2video @ 0x893a2e0]ac-tex damaged at 1 22
> [mpeg2video @ 0x893a2e0]invalid cbp at 1 23
> [mpeg2video @ 0x893a2e0]ac-tex damaged at 20 24
> [mpeg2video @ 0x893a2e0]invalid cbp at 1 25
> [mpeg2video @ 0x893a2e0]mb incr damaged
> [mpeg2video @ 0x893a2e0]slice mismatch
> [mpeg2video @ 0x893a2e0]mb incr damaged
> [mpeg2video @ 0x893a2e0]ac-tex damaged at 13 29
> [mpeg2video @ 0x893a2e0]concealing 990 DC, 990 AC, 990 MV errors
> 
> demux_mpg: 30000/1001fps NTSC content detected, switching framerate.
> Warning! FPS changed 23.976 -> 29.970  (-5.994005) [4]  
> 
> demux_mpg: 24000/1001fps progressive NTSC content detected, switching framerate.
> 
> demux_mpg: 30000/1001fps NTSC content detected, switching framerate.
> Warning! FPS changed 23.976 -> 29.970  (-5.994005) [4]  
> 
> demux_mpg: 24000/1001fps progressive NTSC content detected, switching framerate.
> 
> demux_mpg: 30000/1001fps NTSC content detected, switching framerate.
> Warning! FPS changed 23.976 -> 29.970  (-5.994005) [4]  
> 
> demux_mpg: 24000/1001fps progressive NTSC content detected, switching framerate.
> [mpeg2video @ 0x893a2e0]ac-tex damaged at 14 10
> [mpeg2video @ 0x893a2e0]ac-tex damaged at 9 10
> [mpeg2video @ 0x893a2e0]invalid mb type in P Frame at 2 11
> [mpeg2video @ 0x893a2e0]mb incr damaged
> [mpeg2video @ 0x893a2e0]ac-tex damaged at 24 14
> [mpeg2video @ 0x893a2e0]ac-tex damaged at 9 14
> [mpeg2video @ 0x893a2e0]ac-tex damaged at 3 18
> [mpeg2video @ 0x893a2e0]ac-tex damaged at 16 16
> [mpeg2video @ 0x893a2e0]ac-tex damaged at 10 17
> [mpeg2video @ 0x893a2e0]ac-tex damaged at 10 18
> [mpeg2video @ 0x893a2e0]invalid mb type in P Frame at 9 20
> [mpeg2video @ 0x893a2e0]ac-tex damaged at 10 20
> [mpeg2video @ 0x893a2e0]ac-tex damaged at 11 22
> [mpeg2video @ 0x893a2e0]invalid cbp at 1 22
> [mpeg2video @ 0x893a2e0]ac-tex damaged at 8 23
> [mpeg2video @ 0x893a2e0]ac-tex damaged at 3 24
> [mpeg2video @ 0x893a2e0]invalid cbp at 2 26
> [mpeg2video @ 0x893a2e0]ac-tex damaged at 9 26
> [mpeg2video @ 0x893a2e0]ac-tex damaged at 0 27
> [mpeg2video @ 0x893a2e0]ac-tex damaged at 0 28
> [mpeg2video @ 0x893a2e0]ac-tex damaged at 0 29
> [mpeg2video @ 0x893a2e0]concealing 660 DC, 660 AC, 660 MV errors
> [mpeg2video @ 0x893a2e0]mb incr damaged
> [mpeg2video @ 0x893a2e0]concealing 297 DC, 297 AC, 297 MV errors
> [mpeg2video @ 0x893a2e0]invalid cbp at 1 5
> [mpeg2video @ 0x893a2e0]ac-tex damaged at 1 9
> [mpeg2video @ 0x893a2e0]mb incr damaged
> [mpeg2video @ 0x893a2e0]invalid mb type in B Frame at 5 15
> [mpeg2video @ 0x893a2e0]invalid cbp at 16 18
> [mpeg2video @ 0x893a2e0]mb incr damaged
> [mpeg2video @ 0x893a2e0]mb incr damaged
> [mpeg2video @ 0x893a2e0]invalid mb type in B Frame at 17 21
> [mpeg2video @ 0x893a2e0]invalid mb type in B Frame at 11 22
> [mpeg2video @ 0x893a2e0]invalid cbp at 2 23
> [mpeg2video @ 0x893a2e0]ac-tex damaged at 9 25
> [mpeg2video @ 0x893a2e0]invalid mb type in B Frame at 4 26
> [mpeg2video @ 0x893a2e0]slice mismatch
> [mpeg2video @ 0x893a2e0]concealing 891 DC, 891 AC, 891 MV errors
> 
> demux_mpg: 30000/1001fps NTSC content detected, switching framerate.
> Warning! FPS changed 23.976 -> 29.970  (-5.994005) [4]  
> ...
> demux_mpg: 24000/1001fps progressive NTSC content detected, switching framerate.
> [mpeg2video @ 0x893a2e0]slice mismatch
> [mpeg2video @ 0x893a2e0]invalid cbp at 15 11
> [mpeg2video @ 0x893a2e0]concealing 132 DC, 132 AC, 132 MV errors
> [mpeg2video @ 0x893a2e0]concealing 21 DC, 21 AC, 21 MV errors
> TS_PARSE: COULDN'T SYNC
> 
> I am in particular pointing out the "mpeg2video" errors not the
> framerate switching messages.
> 
> There are no messages whatsoever in the kernel log when this
> happens so whatever is happening the cx18 driver is being silent
> about it.
> 
> I also can't very easily blame the cable signal as an HVR-950Q
> recording from clearqam at the exact same time never has these
> sorts of artifacts.
> 
> Any thoughts why these only happen on the HVR-1600?

Signal level varaition coupled with the HVR-1600's, at times, mediocre
digital tuning side:

Run 'femon' on the cx18's dvb frontend when you have a live QAM capture
ongoing.

Watch for the BER or UNCorrectable block count to increase at about the
same time you view a glitch in the video.  If this is the case, there is
something about the signal the HVR-1600 is having trouble with.  (The
older models don't have the best digital tuner and digital demod
combination out there.)
If the signal shown in femon is at a relatively high level most of the
time, then the cable signal probably has an instantaneous signal that
sometimes overdrives the frontend.  An inline attenuator might make the
problem go away.
If the signal is at a low level, it may drop below threshold
occasionally.  An in line amplifier, installed as close to where the
signal comes into you home as possible, might help.

If it's not signal level related and not DMA related, then it is a
problem with the cx18 driver feeding things to the DVB core, or a
problem with the DVB core itself.

Regards,
Andy

> Cheers,
> b.
> 


