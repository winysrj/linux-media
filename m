Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.174])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tutuyu@usc.edu>) id 1Luy6s-0003x0-H9
	for linux-dvb@linuxtv.org; Sat, 18 Apr 2009 02:08:43 +0200
Received: by wf-out-1314.google.com with SMTP id 28so1010965wff.17
	for <linux-dvb@linuxtv.org>; Fri, 17 Apr 2009 17:08:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <cae4ceb0904161659q50808ff8p965b3b1b46f14ab1@mail.gmail.com>
References: <cae4ceb0904161659q50808ff8p965b3b1b46f14ab1@mail.gmail.com>
Date: Fri, 17 Apr 2009 17:08:35 -0700
Message-ID: <cae4ceb0904171708o7aa83fe9g2df0181fc72874a7@mail.gmail.com>
From: Tu-Tu Yu <tutuyu@usc.edu>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Fwd: About HVR1250 cant load the driver
Reply-To: linux-media@vger.kernel.org
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

Hi there:
Can anyone tell me is that because my driver is not loaded or the
signal I got is not in the right frequency?


so when i do "dmesg | grep -i dvb"
it shows

     tveeprom 1-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L')
PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
     cx23885_dvb_register() allocating 1 frontend(s)
     cx23885[0]: cx23885 based dvb card
     DVB: registering new adapter (cx23885[0])
     DVB: registering adapter 0 frontend 0 (NXP TDA10048HN DVB-T)...
     tda10048_firmware_upload: waiting for firmware upload
(dvb-fe-tda10048-1.0.fw)...
     firmware: requesting dvb-fe-tda10048-1.0.fw
     DVB: adapter 0 frontend 0 frequency 134513322 out of range
(177000000..858000000)

Thank you so much !!!!!!!
Audrey



---------- Forwarded message ----------
From: Tu-Tu Yu <tutuyu@usc.edu>
Date: Thu, Apr 16, 2009 at 4:59 PM
Subject: About HVR1250 cant load the driver
To: linux-dvb@linuxtv.org


Dear Sirs:
I have tried to install HVR 1200 in my machine...
I follow the step on the website. But it seems like i didn't load the
driver. Could somebody tell me which step i did wrong?
Thank you so much!!!!
Audrey


=A0 1. Change into the v4l-dvb directory:

=A0 =A0 =A0cd v4l-dvb

=A0 2. Build the modules:

=A0 =A0 =A0make

=A0 3. Install the modules:

=A0 =A0 =A0make install

=A0 4. Download the files from http://steventoth.net/linux/hvr1200/ and
follow the instructions in the readme.txt
=A0 (on this step i do sh extract.sh on one machine and then copy those
3 files to both /lib/firmware and /lib/firmware/2.6.26, because the
machine i am using now doesn't support unzip)

=A0 5. add this line to /etc/modules.d/dvb:
=A0 (on this step because there is no modules.d/dvb file in my machine
so i create it by mkdir)

after i reboot, and scan, it shows:

=A0 =A0 scanning /usr/share/dvb/dvb-t/uk-Oxford
=A0 =A0 using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
=A0 =A0 initial transponder 578000000 0 3 9 1 0 0 0
=A0 =A0 initial transponder 850000000 0 2 9 3 0 0 0
=A0 =A0 initial transponder 713833000 0 2 9 3 0 0 0
=A0 =A0 initial transponder 721833000 0 3 9 1 0 0 0
=A0 =A0 initial transponder 690000000 0 3 9 1 0 0 0
=A0 =A0 initial transponder 538000000 0 3 9 1 0 0 0
=A0 =A0 =A0>>> tune to:
578000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSI=
ON_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
=A0 =A0 WARNING: >>> tuning failed!!!
=A0 =A0 >>> tune to:
578000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSI=
ON_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
(tuning failed)
=A0 =A0 WARNING: >>> tuning failed!!!

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
