Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <dejan.rodiger@gmail.com>) id 1Oxxso-0007mE-Ra
	for linux-dvb@linuxtv.org; Tue, 21 Sep 2010 10:07:23 +0200
Received: from mail-vw0-f54.google.com ([209.85.212.54])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-b) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1Oxxso-0004Ik-7Q; Tue, 21 Sep 2010 10:07:22 +0200
Received: by vws2 with SMTP id 2so3739545vws.41
	for <linux-dvb@linuxtv.org>; Tue, 21 Sep 2010 01:07:20 -0700 (PDT)
MIME-Version: 1.0
From: Dejan Rodiger <dejan.rodiger@gmail.com>
Date: Tue, 21 Sep 2010 10:07:00 +0200
Message-ID: <AANLkTikf0hp8nXzovvdn0j_80Dcirr1a-EMH9sDDGEoX@mail.gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Asus MyCinema P7131 Dual support
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2045163188=="
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

--===============2045163188==
Content-Type: multipart/alternative; boundary=0016e68ee000a505300490c084ae

--0016e68ee000a505300490c084ae
Content-Type: text/plain; charset=UTF-8

Hi,

I am using Ubuntu linux 10.10 with the latest kernel 2.6.35-22-generic on
x86_64. I have installed nonfree firmware which should support this card,
but to be sure, can somebody confirm that my TV card is supported in Analog
or DVB mode?

sudo lspci -vnn
01:06.0 Multimedia controller [0480]: Philips Semiconductors
SAA7131/SAA7133/SAA7135 Video Broadcast Decoder [1131:7133] (rev d1)
        Subsystem: ASUSTeK Computer Inc. My Cinema-P7131 *Hybrid*[1043:4876]
        Flags: bus master, medium devsel, latency 32, IRQ 18
        Memory at fdeff000 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [40] Power Management version 2
        Kernel driver in use: saa7134
        Kernel modules: saa7134

It says Hybrid, but I put the following in the /etc/modprobe.d/saa7134.conf
options saa7134 card=78 tuner=54


Thanks
-- 
Dejan Rodiger
S: callto://drodiger

--0016e68ee000a505300490c084ae
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,<br><br>I am using Ubuntu linux 10.10 with the latest kernel 2.6.35-22-g=
eneric on x86_64. I have installed nonfree firmware which should support th=
is card, but to be sure, can somebody confirm that my TV card is supported =
in Analog or DVB mode?<br>

<br>sudo lspci -vnn<br>01:06.0 Multimedia controller [0480]: Philips Semico=
nductors SAA7131/SAA7133/SAA7135 Video Broadcast Decoder [1131:7133] (rev d=
1)<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Subsystem: ASUSTeK Compute=
r Inc. My Cinema-P7131 <b><u>Hybrid</u></b> [1043:4876]<br>

=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Flags: bus master, medium devsel=
, latency 32, IRQ 18<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Memory a=
t fdeff000 (32-bit, non-prefetchable) [size=3D2K]<br>=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 Capabilities: [40] Power Management version 2<br>=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Kernel driver in use: saa7134<br>

=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Kernel modules: saa7134<br><br>I=
t says Hybrid, but I put the following in the /etc/modprobe.d/saa7134.conf<=
br>options saa7134 card=3D78 tuner=3D54<br><br><br>Thanks<br clear=3D"all">=
-- <br>Dejan Rodiger<br>S: callto://drodiger<br>



--0016e68ee000a505300490c084ae--


--===============2045163188==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2045163188==--
