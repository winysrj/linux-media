Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.24])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1Kqtgp-00054t-EA
	for linux-dvb@linuxtv.org; Fri, 17 Oct 2008 20:04:45 +0200
Received: by ey-out-2122.google.com with SMTP id 25so248906eya.17
	for <linux-dvb@linuxtv.org>; Fri, 17 Oct 2008 11:04:30 -0700 (PDT)
Message-ID: <412bdbff0810171104ob627994me2876504b43c18d8@mail.gmail.com>
Date: Fri, 17 Oct 2008 14:04:30 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: Linux-dvb <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] [RFC] SNR units in tuners
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

Hello,

In response to Steven Toth's suggestion regarding figuring out what
the various units are across demodulators, I took a quick inventory
and came up with the following list.  Note that this is just a first
pass by taking a quick look at the source for each demodulator (I
haven't looked for the datasheets for any of them yet or done sample
captures to see what the reported ranges are).

Could everybody who is responsible for a demod please take a look at
the list and see if you can fill in the holes?

Having a definitive list of the current state is important to being
able to provide unified reporting of SNR.

Thank you,

Devin

===
af9013.c        dB
at76c651.c      unknown
au8522.c        0.1 dB
bcm3510.c       unknown (vals > 1000)
cx22700.c       unknown
cx22702.c       unknown
cx24110.c       ESN0
cx24116.c       percent scaled to 0-0xffff, support for ESN0
cx24123.c       Inverted ESN0
dib3000mb.c     unknown
dib3000mc.c     always zero
dib7000m.c      always zero
dib7000p.c      always zero
drx397xD.c      always zero
dvb_dummy_fe.c  always zero
l64781.c        unknown
lgdt330x.c      dB scaled to 0-0xffff
lgs8gl5.c       unknown
mt312.c         unknown
mt352.c         unknown
nxt200x.c       dB
nxt6000.c       unknown
or51132.c       dB
or51211.c       dB
s5h1409.c       0.1 dB
s5h1411.c       0.1 dB
s5h1420.c       unsupported
si21xx.c        unknown (scaled to 0-0xffff)
sp8870.c        unsupported
sp887x.c        unknown
stv0288.c       unknown
stv0297.c       unknown
stv0299.c       unknown
tda10021.c      unknown
tda10023.c      unknown
tda10048.c      unknown (looks like 0.1dB)
tda1004x.c      unknown
tda10086.c      unknown
tda8083.c       unknown
tda80xx.c       unknown
ves1820.c       unknown
ves1x93.c       unknown
zl10353.c       unknown


-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
