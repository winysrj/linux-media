Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-07.arcor-online.net ([151.189.21.47])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1KL6Py-0002t5-FA
	for linux-dvb@linuxtv.org; Tue, 22 Jul 2008 03:11:57 +0200
From: hermann pitton <hermann-pitton@arcor.de>
To: Goga777 <goga777@bk.ru>
In-Reply-To: <20080721141300.2ff0c582@bk.ru>
References: <200807170023.57637.ajurik@quick.cz>
	<3efb10970807170320w39377ae9p9db0081dda9c3f5f@mail.gmail.com>
	<487F3365.4070306@chaosmedia.org>
	<3efb10970807171311t46d075cdudef4b34cc069c265@mail.gmail.com>
	<20080718112256.6da5bdf9@bk.ru> <1216382683l.8087l.2l@manu-laptop>
	<1216609233.2909.27.camel@pc10.localdom.local>
	<20080721141300.2ff0c582@bk.ru>
Date: Tue, 22 Jul 2008 03:05:54 +0200
Message-Id: <1216688754.3198.38.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Re : szap - p - r options (was - T S2-3200 driver)
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

Am Montag, den 21.07.2008, 14:13 +0400 schrieb Goga777:
> > > > > > with szap2 you also can tune to FTA channels using the option "-
> > > > p"
> > > > and read
> > > > > > the stream from your frontend dvr (/dev/dvb/adapter0/dvr0) with
> > > > mplayer for
> > > > > > example..
> > > > 
> > > > 
> > > > btw, could someone explain me what's difference between szap - r and
> > > > szap - p options ?
> > > > 
> > > > when should I use -r options. when - p or both -r -p ???
> > > > 
> > > >   -r        : set up /dev/dvb/adapterX/dvr0 for TS recording
> > > >   -p        : add pat and pmt to TS recording (implies -r)
> > > 
> > > I would guess that -r will just enable the dvr0 output so that you can 
> > > record it by dumping it to a file, whereas -p will do the same plus pat 
> > > and pmt which means that the stream will contain the necessary tables 
> > > to select one of the channels (this pis probably needed by the app that 
> > > will record/play the stream).
> > > IOn brief try both and see whihc one works ;-)
> > > HTH
> > > Bye
> > > Manu
> > > 
> > > 
> > 
> > Hi,
> > 
> > last time I tried -p did not work at all.
> 
> how did you recognize it ? what should be happen with - p option ?
> did option -r work during you
> 
> Goga
> 

That was on a try to get BBC HD h.264 not S2.
http://www.lyngsat.com/28east.html

It takes a wrong vpid. With -r only some audio, with -p is also nothing
better when trying to play it with mplayer.

zapping to 594 'BBC HD':
sat 0, frequency = 10847 MHz V, symbolrate 22000000, vpid = 0x2000, apid = 0x0917 sid = 0x0919
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
couldn't find pmt-pid for sid 0919

Adding 8192 for filtering in the channels.conf makes mplayer working by
switching to BBC HD with the TAB key.

BBC HD:10847:v:0:22000:8192:2327:2329:6940

PARSE_PAT: section_len: 29, section 0/0
PROG: 0 (1-th of 5), PMT: 16
PROG: 6903 (2-th of 5), PMT: 256
PROG: 6904 (3-th of 5), PMT: 257
PROG: 6940 (4-th of 5), PMT: 258
PROG: 6945 (5-th of 5), PMT: 259
COLLECT_SECTION, start: 64, size: 184, collected: 184
SKIP: 0+1, TID: 0, TLEN: 29, COLLECTED: 184

Just +258 on the vpid did not help.

-demuxer lavf dumps

LAVF: Program 6940
==> Found video stream: 5
[lavf] Video stream found, -vid 5
======= VIDEO Format ======
  biSize 82
  biWidth 1440
  biHeight 1080
  biPlanes 0
  biBitCount 0
  biCompression 875967048='H264'
  biSizeImage 0
Unknown extra header dump: [0] [0] [0] [1] [9] [10] [0] [0] [0] [1] [67] [64] [40] [28] [ac] [53] [b0] [16] [81] [13] [f7] [85] [88] [0] [0] [3] [0] [8] [0] [0] [3] [1] [94] [a0] [0] [0] [0] [1] [68] [fe] [3c] [b0]
===========================

On vlc this did work for switching to it.

/usr/local/bin/vlc dvb:// :dvb-adapter=0 :dvb-frequency=10847000 :dvb-srate=22000000 :programs=6940

Kaffeine works as well, but often is crashing during A/V sync attempts after start.
Interestingly, sometimes I can record for hours in sync, but usually audio is soon behind. 
It is also x86_64 and an AMD Quad.

Cheers,
Hermann
 



 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
