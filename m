Return-path: <mchehab@pedra>
Received: from web30306.mail.mud.yahoo.com ([209.191.69.68]:39380 "HELO
	web30306.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752147Ab1BLVoW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Feb 2011 16:44:22 -0500
Message-ID: <450670.60996.qm@web30306.mail.mud.yahoo.com>
References: <713442.91420.qm@web30304.mail.mud.yahoo.com> <AANLkTinv7sWE+T1ORrr8MD6XRGQj8hG1sZw9UfjSGM-o@mail.gmail.com>
Date: Sat, 12 Feb 2011 13:44:21 -0800 (PST)
From: AW <arne_woerner@yahoo.com>
Subject: Re: PCTV USB2 PAL / adds loud hum to correct audio
To: linux-media@vger.kernel.org
Cc: dheitmueller@kernellabs.com
In-Reply-To: <AANLkTinv7sWE+T1ORrr8MD6XRGQj8hG1sZw9UfjSGM-o@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Devin Heitmueller <dheitmueller@kernellabs.com> wrote:
> > When I use this command  simultaneously:
> > arecord -D front:CARD=PAL,DEV=0 -f S16_LE -c 2 -r 8000  /aux/tmp/bla.wav
> > I get correct audio with strong noise:
> > http://www.wgboome.de./bla.wav
> > (it is from input=1 for copyright  reasons... so there is silence plus 
noise)
> 
> The "-r" argument should  almost certainly be 48000, not 8000.
> 
Maybe...
That device is rather old...
And i didnt tell pactl anything about sample rate...

With the filter from the appendix the noise is gone...
But it feels like a dirty hack, because it would cut out (overly?) loud noise, 
2...

My wild guess is, that the usbaudio driver injects some bad samples 
(0x8000..0x9000) every appr. 256 bytes...

-Arne

appendix:
#include <stdint.h>
#include <unistd.h>

int main() {
uint16_t buf[1000000];
const int r = read(0,buf,sizeof(buf));
for (int i=0; i*sizeof(*buf)<r; i++) {
if (buf[i]/256>=0x80 && buf[i]/256<0x90) continue;
if (write(1,buf+i,2) != 2) break;
}
return 0;
}


