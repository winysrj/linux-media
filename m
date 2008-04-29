Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-03.arcor-online.net ([151.189.21.43])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1JqnrM-0006m0-O2
	for linux-dvb@linuxtv.org; Tue, 29 Apr 2008 13:19:02 +0200
From: hermann pitton <hermann-pitton@arcor.de>
To: Frederic CAND <frederic.cand@anevia.com>
In-Reply-To: <4816E5DA.7010204@anevia.com>
References: <4816E5DA.7010204@anevia.com>
Date: Tue, 29 Apr 2008 13:17:45 +0200
Message-Id: <1209467866.3247.45.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] KNC TV Station DVR Tuner Sound Issue
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

Hi Frederic,

Am Dienstag, den 29.04.2008, 11:09 +0200 schrieb Frederic CAND:
> Dear all,
> 
> I recently had to change v4l drivers to support my WinTV HVR 1300.
> I have issues making my HVR work but that's not the point here.
> My problem is that since I updated kernel + drivers, I can't manage to 
> make sound work when I'm using the tuner input. Sound jack input works 
> when I'm using SVideo or Composite Video, but not when I'm using tuner.
> 
> Here are the options I'm using
> tuner : port2=0
> saa7134: oss=1 disable_ir=1
> saa7134-oss: rate=48000

the rate=48000 is only valid for external analog input and disables
sound from tuner. Have a look at the saa7134-oss mixer under such
conditions.

You must use default rate of 32000 for dma sound from tuner.

The saa7134-oss is also soon deprecated and replaced by saa7134-alsa.

If you are considering using recent v4l-dvb mercurial stuff, which
should be best for the HVR1300 and reporting bugs on saa7134-empress,
you might still have your old saa7134-oss module around and some others
like the old video_buf now loaded, since not deleted on upgrade.

After make rmmod and rminstall with current v4l-dvb you should delete
such remaining modules on older kernels too before make install.

Cheers,
Hermann

> # lsmod
> Module                  Size  Used by
> r8169                  17360  0
> e100                   23556  0
> cx8802                 10372  0
> firmware_class          4032  0
> cx2341x                 8516  0
> cx8800                 19256  0
> cx88xx                 49636  2 cx8802,cx8800
> i2c_algo_bit            3908  1 cx88xx
> tveeprom               11472  1 cx88xx
> btcx_risc               2376  3 cx8802,cx8800,cx88xx
> saa7134_oss             9416  0
> saa7134_empress         4292  0
> saa6752hs               7180  0
> saa7134                95820  2 saa7134_oss,saa7134_empress
> video_buf              13444  6 
> cx8802,cx8800,cx88xx,saa7134_oss,saa7134_empress,saa7134
> compat_ioctl32           512  2 cx8800,saa7134
> ir_kbd_i2c              3856  1 saa7134
> ir_common              22788  3 cx88xx,saa7134,ir_kbd_i2c
> videodev               22464  4 cx8800,cx88xx,saa7134_empress,saa7134
> v4l1_compat            12100  2 saa7134,videodev
> tuner                  48424  0
> v4l2_common            11392  7 
> cx2341x,cx8800,cx88xx,saa7134_empress,saa7134,videodev,tuner
> hwmon_vid               1856  0
> via686a                 8328  0
> i2c_isa                 1408  1 via686a
> i2c_core               12560  9 
> cx88xx,i2c_algo_bit,tveeprom,saa6752hs,saa7134,ir_kbd_i2c,tuner,via686a,i2c_isa
> ipt_REJECT              2048  3
> iptable_filter           960  1
> ip_tables               7176  1 iptable_filter
> 
> 
> With this I have sound only when selecting SVideo or Composite input, 
> but not when in tuner mode. Anyone has a clue ?
> 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
