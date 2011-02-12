Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:58080 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753014Ab1BLXeK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Feb 2011 18:34:10 -0500
Subject: Re: PCTV USB2 PAL / adds loud hum to correct audio
From: Andy Walls <awalls@md.metrocast.net>
To: AW <arne_woerner@yahoo.com>
Cc: linux-media@vger.kernel.org, dheitmueller@kernellabs.com
In-Reply-To: <450670.60996.qm@web30306.mail.mud.yahoo.com>
References: <713442.91420.qm@web30304.mail.mud.yahoo.com>
	 <AANLkTinv7sWE+T1ORrr8MD6XRGQj8hG1sZw9UfjSGM-o@mail.gmail.com>
	 <450670.60996.qm@web30306.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 12 Feb 2011 18:34:17 -0500
Message-ID: <1297553657.2413.66.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, 2011-02-12 at 13:44 -0800, AW wrote:
> Devin Heitmueller <dheitmueller@kernellabs.com> wrote:
> > > When I use this command  simultaneously:
> > > arecord -D front:CARD=PAL,DEV=0 -f S16_LE -c 2 -r 8000  /aux/tmp/bla.wav
> > > I get correct audio with strong noise:
> > > http://www.wgboome.de./bla.wav
> > > (it is from input=1 for copyright  reasons... so there is silence plus 
> noise)
> > 
> > The "-r" argument should  almost certainly be 48000, not 8000.
> > 
> Maybe...
> That device is rather old...
> And i didnt tell pactl anything about sample rate...

I find audio at 8 ksps very unusual for a TV capture device.


> With the filter from the appendix the noise is gone...
> But it feels like a dirty hack, because it would cut out (overly?) loud noise, 
> 2...
> 
> My wild guess is, that the usbaudio driver injects some bad samples 
> (0x8000..0x9000) every appr. 256 bytes...

I looked at the data.  It is mostly hovering around 0, but you have
bursts of very negative values periodically:

(These values are shown as little endian, so swap the bytes to consider the value)

0000630: faff fdff f9ff fbff 1080 1080 1080 1080  ................
0000640: 1080 1080 faff fbff 1080 1080 8888 8888  ................
0000650: 1080 1080 fbff fcff fbff fcff fdff fdff  ................
...
0002fe0: 0000 0000 0100 0100 ffff 0000 1080 1080  ................
0002ff0: 1080 1080 1080 1080 1080 1080 1080 1080  ................
0003000: 8888 8888 0100 0000 ffff ffff 0000 0000  ................

0x8010 is -32752 and 0x8888 is -30584.

The data set contains no large positive values (nothing in the range
0x1000-0x7fff).

The valuex 0x10 and 0x80 do remind me of the YUV values for black: Y =
0x10, U = 0x80, V = 0x80.  Maybe some video data is getting thrown in
with the audio?

Regards,
Andy

> -Arne
> 
> appendix:
> #include <stdint.h>
> #include <unistd.h>
> 
> int main() {
> uint16_t buf[1000000];
> const int r = read(0,buf,sizeof(buf));
> for (int i=0; i*sizeof(*buf)<r; i++) {
> if (buf[i]/256>=0x80 && buf[i]/256<0x90) continue;
> if (write(1,buf+i,2) != 2) break;
> }
> return 0;
> }
> 


