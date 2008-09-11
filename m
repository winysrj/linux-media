Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gregoire.favre@gmail.com>) id 1KdlVg-00020t-HG
	for linux-dvb@linuxtv.org; Thu, 11 Sep 2008 14:42:57 +0200
Received: by yw-out-2324.google.com with SMTP id 3so103943ywj.41
	for <linux-dvb@linuxtv.org>; Thu, 11 Sep 2008 05:42:52 -0700 (PDT)
Date: Thu, 11 Sep 2008 14:42:46 +0200
To: linux-dvb@linuxtv.org
Message-ID: <20080911124246.GB3263@gmail.com>
References: <48C70F88.4050701@linuxtv.org>
	<E1KdLOn-0002ri-00.goga777-bk-ru@f147.mail.ru>
	<48C80D58.3010705@linuxtv.org>
	<200809110151.08382.liplianin@tut.by>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200809110151.08382.liplianin@tut.by>
From: Gregoire Favre <gregoire.favre@gmail.com>
Subject: Re: [linux-dvb] S2API simple szap-s2 utility
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Thu, Sep 11, 2008 at 01:51:08AM +0300, Igor M. Liplianin wrote:
> There is a program to zap satellite channels with S2API:
> =

> http://liplianindvb.sourceforge.net/cgi-bin/hgwebdir.cgi/szap-s2/archive/=
tip.tar.gz
> =

> For easy understanding and quickly testing S2API (and even viewing TV wit=
h =

> mplayer) =


Great, I just compiled the s2 driver from
http://linuxtv.org/hg/~stoth/s2/
and loaded modules with scripts/rmmod load which shows :

i2c-adapter i2c-4: SMBus Quick command not supported, can't probe for
chips
OmniVision ov7670 sensor driver, at your service
wm8775' 2-001b: chip found @ 0x36 (cx88[0])
i2c-adapter i2c-4: SMBus Quick command not supported, can't probe for
chips
saa7146: register extension 'budget dvb'.
saa7146: register extension 'budget_av'.
cx23885 driver version 0.0.1 loaded
cx2388x blackbird driver version 0.0.6 loaded
cx88/2: registering cx8802 driver, type: blackbird access: shared
cx88[0]/2: subsystem: 0070:6902, board: Hauppauge WinTV-HVR4000
DVB-S/S2/T/Hybrid [card=3D68]
cx88[0]/2: cx8802 probe failed, err =3D -19
cx88[1]/2: subsystem: 14f1:0084, board: Geniatech DVB-S [card=3D52]
cx88[1]/2: cx8802 probe failed, err =3D -19

So I loose one card in this process which isn't a big problem.

But my big problem is that with every channel I try, I get an error :
szap-s2 -n 13
reading channels from file '/home/greg/.szap/channels.conf'
zapping to 13 'BBCHD':
delivery DVB-S, modulation QPSK
sat 2, frequency 10847 MHz V, symbolrate 22000000, coderate auto,
rolloff 0.35
vpid 0x090e, apid 0x090f, sid 0x1b1c
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
FE_SET_PROPERTY failed: Operation not supported
status 01 | signal 9b02 | snr 81ea | ber 0000ff00 | unc fffffffe | =

status 01 | signal 9fee | snr 82cb | ber 0000ff00 | unc fffffffe | =

status 01 | signal a00c | snr 8283 | ber 0000ff08 | unc fffffffe | =


What did I do wrong ?

Thanks.
-- =

Gr=E9goire FAVRE  http://gregoire.favre.googlepages.com  http://www.gnupg.o=
rg
               http://picasaweb.google.com/Gregoire.Favre

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
