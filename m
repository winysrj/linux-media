Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-bw0-f18.google.com ([209.85.218.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gregoire.favre@gmail.com>) id 1LIWIo-0005a6-Ov
	for linux-dvb@linuxtv.org; Thu, 01 Jan 2009 23:46:08 +0100
Received: by bwz11 with SMTP id 11so13296617bwz.17
	for <linux-dvb@linuxtv.org>; Thu, 01 Jan 2009 14:45:33 -0800 (PST)
Date: Thu, 1 Jan 2009 23:45:28 +0100
To: linux-dvb@linuxtv.org
Message-ID: <20090101224528.GC3592@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
From: Gregoire Favre <gregoire.favre@gmail.com>
Subject: [linux-dvb] What tools for S2API ?
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

Hello,

my Hauppauge budget-ci seems to works well with szap/kaffeine/VDR but my
Geniatech DVB-S and my Hauppauge HVR-4000 seems to only works with
kaffeine.

>From kaffeine :
Tuning to: ZDFtheaterkanal / autocount: 0
DvbCam::probe(): /dev/dvb/adapter1/ca0: : No such file or directory
Using DVB device 1:0 "Conexant CX24116/CX24118"
tuning DVB-S to 11953000 h 27500000
inv:2 fecH:3
DiSEqC: switch pos 1, 18V, hiband (index 7)
DiSEqC: e0 10 38 f7 00 00
. LOCKED.
NOUT: 1
dvbEvents 1:0 started
Tuning delay: 5929 ms
pipe opened
xine pipe opened /home/greg/.kaxtv.ts

But ./szap -c /usr/src/CVS/dvb-apps/util/szap/channels-conf/dvb-s/Astra-19.=
2E -x -a1 -n19
reading channels from file '/usr/src/CVS/dvb-apps/util/szap/channels-conf/d=
vb-s/Astra-19.2E'
zapping to 19 'ZDF Theaterkanal':
sat 0, frequency =3D 11954 MHz H, symbolrate 27500000, vpid =3D 0x0456, api=
d =3D 0x0460 sid =3D 0x6d70
using '/dev/dvb/adapter1/frontend0' and '/dev/dvb/adapter1/demux0'
status 01 | signal d240 | snr 0000 | ber 00000000 | unc 00000000 | =

status 01 | signal d140 | snr 0000 | ber 00000000 | unc 00000000 | =

status 03 | signal d1c0 | snr 0000 | ber 00000000 | unc 00000000 | =

status 01 | signal d140 | snr 0000 | ber 00000000 | unc 00000000 | =

status 01 | signal d1c0 | snr 0000 | ber 00000000 | unc 00000000 | =

status 03 | signal d140 | snr 0000 | ber 00000000 | unc 00000000 | =

status 01 | signal d1c0 | snr 0000 | ber 00000000 | unc 00000000 | =

status 03 | signal d140 | snr 0000 | ber 00000000 | unc 00000000 | =

status 01 | signal d1c0 | snr 0000 | ber 00000000 | unc 00000000 | =

status 03 | signal d1c0 | snr 0000 | ber 00000000 | unc 00000000 | =


And after edit :
./szap -c /usr/src/CVS/dvb-apps/util/szap/channels-conf/dvb-s/Astra-19.2E -=
x -a1 -n19
reading channels from file '/usr/src/CVS/dvb-apps/util/szap/channels-conf/d=
vb-s/Astra-19.2E'
zapping to 19 'ZDF Theaterkanal':
sat 0, frequency =3D 11953 MHz H, symbolrate 27500000, vpid =3D 0x0456, api=
d =3D 0x0460 sid =3D 0x6d70
using '/dev/dvb/adapter1/frontend0' and '/dev/dvb/adapter1/demux0'
status 03 | signal d240 | snr 0000 | ber 00000000 | unc 00000000 | =

status 03 | signal d2c0 | snr 0000 | ber 00000000 | unc 00000000 | =

status 01 | signal d2c0 | snr 0000 | ber 00000000 | unc 00000000 | =

status 03 | signal d2c0 | snr 0000 | ber 00000000 | unc 00000000 | =

status 03 | signal d340 | snr 0000 | ber 00000000 | unc 00000000 | =

status 03 | signal d2c0 | snr 0000 | ber 00000000 | unc 00000000 | =

status 03 | signal d340 | snr 0000 | ber 00000000 | unc 00000000 | =

status 03 | signal d340 | snr 0000 | ber 00000000 | unc 00000000 | =

status 03 | signal d2c0 | snr 0000 | ber 00000000 | unc 00000000 | =

status 01 | signal d340 | snr 0000 | ber 00000000 | unc 00000000 | =


Also, VDR fails with those two cards ???

I am a bit lost here, does someone got an idea for me ?

I just recompiled the v4l-dvb's hg source, no change (except that I didn't
patch the source for DVB-S2 capability anymore).

Thanks.
-- =

Gr=E9goire FAVRE http://gregoire.favre.googlepages.com http://www.gnupg.org
               http://picasaweb.google.com/Gregoire.Favre

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
