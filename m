Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:53599 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbZAWUKq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2009 15:10:46 -0500
Subject: Re: [RFC] Need testers for s5h1409 tuning fix
From: Andy Walls <awalls@radix.net>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <412bdbff0901231136l6967b5bbj8a3cfd4832ab102e@mail.gmail.com>
References: <412bdbff0901212045t1287a403h57ba05cbd71d5224@mail.gmail.com>
	 <1232733940.3907.37.camel@palomino.walls.org>
	 <412bdbff0901231136l6967b5bbj8a3cfd4832ab102e@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 23 Jan 2009 15:10:41 -0500
Message-Id: <1232741441.3907.67.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2009-01-23 at 14:36 -0500, Devin Heitmueller wrote:
> On Fri, Jan 23, 2009 at 1:05 PM, Andy Walls <awalls@radix.net> wrote:
> > Holy cow! the thing tunes fast now!
> >
> > One burst error I received seemed much more devasting to mplayer's
> > decoder than it usually does though.  (I guess fast tuning or relocking
> > may have it's disadvantages, but decoding errant streams as sanely as
> > possible is more a software decoder's problem.)
> >
> > Propagation conditions here today are much better than in recent days
> > due to weather changes (it's close to 50 F!).  I'll test tonight around
> > sunset and later when things get colder, to get more more data points
> > for what happens when burts errors occur.
> >
> > But right now, it looks very good. :D
> >
> > Regards,
> > Andy
> 
> Glad to hear that it is working well for you.
> 
> Could you please clarify what you mean by "burst error"?

A momentary deep channel fade.  I'm located > 75 miles from the TV
broadcasters.  Lots of opportunity for weather effects or aircraft to
come between my location and the broadcast towers.

In fact, rotary wing aircraft fly by to the north of my location within
eye-sight and earshot during the day somewhat regularly during the week.
They always momentarily disrupt reception as they pass by.

Before mplayer would log one maybe two lines of errors during such an
event.  With the change in place, mplayer now logs > 24 lines worth of
errors.  I assume, that's because with the change in place the 8-VSB
demodulator is now reacting faster to the poor channel condition.

For eaxmple,  Here's what mplayer will blurt out during a burst error
with the change in place:

a52: CRC check failed!
a52: error at resampling
[mpeg2video @ 0xab61c0]invalid mb type in I Frame at 23 22  0%  0.9% 1 0 28%    
[mpeg2video @ 0xab61c0]skipped MB in I frame at 14 25
[mpeg2video @ 0xab61c0]invalid mb type in I Frame at 1 28
[mpeg2video @ 0xab61c0]ac-tex damaged at 1 29
[mpeg2video @ 0xab61c0]concealing 333 DC, 333 AC, 333 MV errors
[mpeg2video @ 0xab61c0]skipped MB in I frame at 7 2634  6%  0%  0.9% 1 0 28%    
[mpeg2video @ 0xab61c0]skipped MB in I frame at 4 6
[mpeg2video @ 0xab61c0]skipped MB in I frame at 19 10
[mpeg2video @ 0xab61c0]skipped MB in I frame at 41 24
[mpeg2video @ 0xab61c0]concealing 220 DC, 220 AC, 220 MV errors
[mpeg2video @ 0xab61c0]ac-tex damaged at 6 19635/14635  6%  0%  0.9% 1 0 28%    
[mpeg2video @ 0xab61c0]concealing 176 DC, 176 AC, 176 MV errors
[mpeg2video @ 0xab61c0]00 motion_type at 25 5637/14637  6%  0%  0.9% 1 0 28%    
[mpeg2video @ 0xab61c0]concealing 135 DC, 135 AC, 135 MV errors
[mpeg2video @ 0xab61c0]invalid mb type in B Frame at 42 27  0%  0.9% 1 0 28%    
[mpeg2video @ 0xab61c0]concealing 44 DC, 44 AC, 44 MV errors
[mpeg2video @ 0xab61c0]ac-tex damaged at 37 2639/14639  6%  0%  0.9% 1 0 28%    
[mpeg2video @ 0xab61c0]00 motion_type at 3 28
[mpeg2video @ 0xab61c0]ac-tex damaged at 0 29
[mpeg2video @ 0xab61c0]concealing 176 DC, 176 AC, 176 MV errors
[mpeg2video @ 0xab61c0]00 motion_type at 22 2740/14640  6%  0%  0.9% 1 0 28%    
[mpeg2video @ 0xab61c0]mb incr damaged
[mpeg2video @ 0xab61c0]00 motion_type at 1 27
[mpeg2video @ 0xab61c0]00 motion_type at 4 28
[mpeg2video @ 0xab61c0]ac-tex damaged at 6 29
[mpeg2video @ 0xab61c0]concealing 132 DC, 132 AC, 132 MV errors
[mpeg2video @ 0xab61c0]00 motion_type at 34 2641/14641  6%  0%  0.9% 1 0 28%    
[mpeg2video @ 0xab61c0]concealing 176 DC, 176 AC, 176 MV errors
[mpeg2video @ 0xab61c0]slice mismatch0.406 14643/14643  6%  0%  0.9% 1 0 29%    
[mpeg2video @ 0xab61c0]concealing 968 DC, 968 AC, 968 MV errors
[mpeg2video @ 0xab61c0]invalid mb type in I Frame at 28 6%  0%  0.9% 1 0 29%    
[mpeg2video @ 0xab61c0]ac-tex damaged at 24 9
[mpeg2video @ 0xab61c0]invalid mb type in I Frame at 1 27
[mpeg2video @ 0xab61c0]skipped MB in I frame at 1 28
[mpeg2video @ 0xab61c0]invalid mb type in I Frame at 1 29
[mpeg2video @ 0xab61c0]concealing 1276 DC, 1276 AC, 1276 MV errors
[mpeg2video @ 0xab61c0]skipped MB in I frame at 15 196  6%  0%  0.9% 1 0 28%    
[mpeg2video @ 0xab61c0]skipped MB in I frame at 36 22
[mpeg2video @ 0xab61c0]ac-tex damaged at 13 26
[mpeg2video @ 0xab61c0]concealing 352 DC, 352 AC, 352 MV errors


Before, I'd only get a few (2 to 6) lines upon such an event.


> For my record keeping, could you please confirm which hardware you are
> doing the testing with?  This is important since there could be an
> issue with your demod/tuner combination.

HVR-1600 MCE.  It has an MXL5005s with a CX24227 (S5H1409).

Look in

	 linux/drivers/media/video/cx18/cx18-dvb.c

to see how it's being set up.


> It would be good if you could provide some actual data regarding
> before and after the patch.Typically I run Kaffeine from the command
> line, which prints out the tuning time to stdout.  For example, here
> are the times Robert saw when he tested my patch:
> 
> Before the change:
> Tuning delay: 2661 ms
> Tuning delay: 474 ms
> Tuning delay: 472 ms
> Tuning lock fail after 5000ms
> Tuning delay: 2000 ms
> Tuning delay: 2685 ms
> Tuning delay: 475 ms
> 
> After the change:
> Tuning delay: 594 ms
> Tuning delay: 570 ms
> Tuning delay: 574 ms
> Tuning delay: 671 ms
> Tuning delay: 570 ms
> Tuning delay: 673 ms
> 
> If you could provide something comparable, it would be useful.

Will do.  Any other tools you know of offhand besides kaffine that
provide such info?


> Thank you for taking the time to test.

Your welcome.

Regards,
Andy


> Devin


