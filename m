Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from py-out-1112.google.com ([64.233.166.183])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mikerussellnz@gmail.com>) id 1JgFQM-0002dO-O4
	for linux-dvb@linuxtv.org; Mon, 31 Mar 2008 10:31:28 +0200
Received: by py-out-1112.google.com with SMTP id a29so1748098pyi.0
	for <linux-dvb@linuxtv.org>; Mon, 31 Mar 2008 01:31:21 -0700 (PDT)
Message-ID: <c112e7e90803310131v3d72ddefv91543b51b816ed73@mail.gmail.com>
Date: Mon, 31 Mar 2008 21:31:21 +1300
From: "Mike Russell" <mikerussellnz@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <47EF5855.1060202@uli-eckhardt.de>
MIME-Version: 1.0
References: <c112e7e90803280226h49820354r6520ca723e3a3584@mail.gmail.com>
	<47EF5855.1060202@uli-eckhardt.de>
Subject: Re: [linux-dvb] HVR-3000 - cx22702 DVB-T Problem cx22702_readreg: /
	cx22702_writereg:
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0737474130=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0737474130==
Content-Type: multipart/alternative;
	boundary="----=_Part_24177_27945580.1206952281347"

------=_Part_24177_27945580.1206952281347
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi

Thanks for the help, I am getting further but still am not getting any
video.  Running scan produces a channels.conf, here is the line generated
for what I am trying to watch. (DVB-T).  Mplayer doesnt appear to be able t=
o
read from the device,  someone said to cat /dev/dvb/adapter0/dvr0 >
test.tsand the file should get larger.  Tried that but the file stayed
empty.

Does anyone know how I can find out what is going wrong.

Thanks

Mike

TV3:698000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_1_2:QAM_64:TRANSMI=
SSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:0:0:1300

dvb_streaming_start(PROG: TV3, CARD: 1, VID: 0, AID: 0, TYPE: , FILE:
(null))
PROGRAM NUMBER 0: name=3DTV3, freq=3D698000000
DVB_OPEN_DEVICES(3)
OPEN(0), file /dev/dvb/adapter0/demux0: FD=3D4, CNT=3D0
OPEN(1), file /dev/dvb/adapter0/demux0: FD=3D5, CNT=3D1
OPEN(2), file /dev/dvb/adapter0/demux0: FD=3D6, CNT=3D2
DVB_SET_CHANNEL: new channel name=3DTV3, card: 0, channel 0
dvb_tune Freq: 698000000
TUNE_IT, fd_frontend 3, fd_sec 0
freq 698000000, srate 0, pol H, tone 0, specInv, diseqc 17909558,
fe_modulation_t modulation,fe_code_rate_t HP_CodeRate, fe_transmit_mode_t
TransmissionMode,fe_guard_interval_t guardInterval, fe_bandwidth_t bandwidt=
h
Using DVB card "Conexant CX22702 DVB-T"
tuning DVB-T to 698000000 Hz, bandwidth: 0
Getting frontend status
Bit error rate: 193
Signal strength: 15163
SNR: 65342
UNC: 0
FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI
FE_HAS_SYNC
SET PES FILTER ON PID 450 to fd 4, RESULT: 0, ERRNO: 0
SET PES FILTER ON PID 400 to fd 5, RESULT: 0, ERRNO: 0
SET PES FILTER ON PID 0 to fd 6, RESULT: 0, ERRNO: 0
SUCCESSFUL EXIT from dvb_streaming_start
STREAM: [dvbin] dvb://0@TV3
STREAM: Description: Dvb Input
STREAM: Author: Nico
STREAM: Comment: based on the code from ??? (probably Arpi)
Checking for MPEG-TS...
dvb_streaming_read, attempt N. 6 failed with errno 0 when reading 2048 byte=
s
dvb_streaming_read, attempt N. 5 failed with errno 0 when reading 2048 byte=
s
dvb_streaming_read, attempt N. 4 failed with errno 0 when reading 2048 byte=
s
dvb_streaming_read, attempt N. 3 failed with errno 0 when reading 2048 byte=
s
dvb_streaming_read, attempt N. 2 failed with errno 0 when reading 2048 byte=
s
dvb_streaming_read, attempt N. 1 failed with errno 0 when reading 2048 byte=
s
dvb_streaming_read, return 0 bytes
THIS DOESN'T LOOK LIKE AN MPEG-TS FILE!
TRIED UP TO POSITION 0, FOUND ffffff00, packet_size=3D 0, SEEMS A TS? 0

DVBIN_CLOSE, close(2), fd=3D6, COUNT=3D2
DVBIN_CLOSE, close(1), fd=3D5, COUNT=3D1
DVBIN_CLOSE, close(0), fd=3D4, COUNT=3D0
vo: x11 uninit called but X11 not inited..

Exiting... (End of file)


On Sun, Mar 30, 2008 at 10:07 PM, Ulrich Eckhardt <uli-dvb@uli-eckhardt.de>
wrote:

> Mike Russell wrote:
> > Hi
> >
> > I am currently having problems getting this card working under 2.6.24
> > for DVB-T.  The driver appears to load ok, but produces errors in dmesg
> > when attempting to scan for channels.
>
> Hi,
>
> it seems to me, that you use the original drivers from the linux kernel.
> Installing the drivers as described in
> http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-3000
> workes for kernel 2.6.24-4.
>
> Uli
> --
> Ulrich Eckhardt                  http://www.uli-eckhardt.de
>
> Ein Blitzableiter auf dem Kirchturm ist das denkbar st=E4rkste
> Misstrauensvotum gegen den lieben Gott. (Karl Krauss)
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_24177_27945580.1206952281347
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi <br><br>Thanks for the help, I am getting further but still am not getti=
ng any video.&nbsp; Running scan produces a channels.conf, here is the line=
 generated for what I am trying to watch. (DVB-T).&nbsp; Mplayer doesnt app=
ear to be able to read from the device,&nbsp; someone said to cat /dev/dvb/=
adapter0/dvr0 &gt; test.ts and the file should get larger.&nbsp; Tried that=
 but the file stayed empty.<br>
<br>Does anyone know how I can find out what is going wrong. <br><br>Thanks=
<br><br>Mike<br><br>TV3:698000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FE=
C_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:0:0:13=
00<br>
<br>dvb_streaming_start(PROG: TV3, CARD: 1, VID: 0, AID: 0, TYPE: , FILE: (=
null))<br>PROGRAM NUMBER 0: name=3DTV3, freq=3D698000000<br>DVB_OPEN_DEVICE=
S(3)<br>OPEN(0), file /dev/dvb/adapter0/demux0: FD=3D4, CNT=3D0<br>OPEN(1),=
 file /dev/dvb/adapter0/demux0: FD=3D5, CNT=3D1<br>
OPEN(2), file /dev/dvb/adapter0/demux0: FD=3D6, CNT=3D2<br>DVB_SET_CHANNEL:=
 new channel name=3DTV3, card: 0, channel 0<br>dvb_tune Freq: 698000000<br>=
TUNE_IT, fd_frontend 3, fd_sec 0<br>freq 698000000, srate 0, pol H, tone 0,=
 specInv, diseqc 17909558, fe_modulation_t modulation,fe_code_rate_t HP_Cod=
eRate, fe_transmit_mode_t TransmissionMode,fe_guard_interval_t guardInterva=
l, fe_bandwidth_t bandwidth<br>
Using DVB card &quot;Conexant CX22702 DVB-T&quot;<br>tuning DVB-T to 698000=
000 Hz, bandwidth: 0<br>Getting frontend status<br>Bit error rate: 193<br>S=
ignal strength: 15163<br>SNR: 65342<br>UNC: 0<br>FE_STATUS: FE_HAS_SIGNAL F=
E_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI FE_HAS_SYNC<br>
SET PES FILTER ON PID 450 to fd 4, RESULT: 0, ERRNO: 0<br>SET PES FILTER ON=
 PID 400 to fd 5, RESULT: 0, ERRNO: 0<br>SET PES FILTER ON PID 0 to fd 6, R=
ESULT: 0, ERRNO: 0<br>SUCCESSFUL EXIT from dvb_streaming_start<br>STREAM: [=
dvbin] dvb://0@TV3<br>
STREAM: Description: Dvb Input<br>STREAM: Author: Nico<br>STREAM: Comment: =
based on the code from ??? (probably Arpi)<br>Checking for MPEG-TS...<br>dv=
b_streaming_read, attempt N. 6 failed with errno 0 when reading 2048 bytes<=
br>
dvb_streaming_read, attempt N. 5 failed with errno 0 when reading 2048 byte=
s<br>dvb_streaming_read, attempt N. 4 failed with errno 0 when reading 2048=
 bytes<br>dvb_streaming_read, attempt N. 3 failed with errno 0 when reading=
 2048 bytes<br>
dvb_streaming_read, attempt N. 2 failed with errno 0 when reading 2048 byte=
s<br>dvb_streaming_read, attempt N. 1 failed with errno 0 when reading 2048=
 bytes<br>dvb_streaming_read, return 0 bytes<br>THIS DOESN&#39;T LOOK LIKE =
AN MPEG-TS FILE!<br>
TRIED UP TO POSITION 0, FOUND ffffff00, packet_size=3D 0, SEEMS A TS? 0<br>=
<br>DVBIN_CLOSE, close(2), fd=3D6, COUNT=3D2<br>DVBIN_CLOSE, close(1), fd=
=3D5, COUNT=3D1<br>DVBIN_CLOSE, close(0), fd=3D4, COUNT=3D0<br>vo: x11 unin=
it called but X11 not inited..<br>
<br>Exiting... (End of file)<br><br><br><div class=3D"gmail_quote">On Sun, =
Mar 30, 2008 at 10:07 PM, Ulrich Eckhardt &lt;<a href=3D"mailto:uli-dvb@uli=
-eckhardt.de">uli-dvb@uli-eckhardt.de</a>&gt; wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, 204, 204); margin=
: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div class=3D"Ih2E3d">Mike Russell wrote:<br>
&gt; Hi<br>
&gt;<br>
&gt; I am currently having problems getting this card working under 2.6.24<=
br>
&gt; for DVB-T. &nbsp;The driver appears to load ok, but produces errors in=
 dmesg<br>
&gt; when attempting to scan for channels.<br>
<br>
</div>Hi,<br>
<br>
it seems to me, that you use the original drivers from the linux kernel.<br=
>
Installing the drivers as described in<br>
<a href=3D"http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-3000" =
target=3D"_blank">http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR=
-3000</a><br>
workes for kernel 2.6.24-4.<br>
<br>
Uli<br>
--<br>
Ulrich Eckhardt &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp;<a href=3D"http://www.uli-eckhardt.de" target=3D"_blank">http://www.uli-=
eckhardt.de</a><br>
<br>
Ein Blitzableiter auf dem Kirchturm ist das denkbar st=E4rkste<br>
Misstrauensvotum gegen den lieben Gott. (Karl Krauss)<br>
<br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" targe=
t=3D"_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><=
br>
</blockquote></div><br>

------=_Part_24177_27945580.1206952281347--


--===============0737474130==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0737474130==--
