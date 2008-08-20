Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.232])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bhavinpshah@gmail.com>) id 1KVm4k-0003tN-M7
	for linux-dvb@linuxtv.org; Wed, 20 Aug 2008 13:42:09 +0200
Received: by rv-out-0506.google.com with SMTP id b25so456844rvf.41
	for <linux-dvb@linuxtv.org>; Wed, 20 Aug 2008 04:42:01 -0700 (PDT)
Message-ID: <43bd633d0808200442g3f9e1bdet7bed8b8b34daacd4@mail.gmail.com>
Date: Wed, 20 Aug 2008 17:12:01 +0530
From: "Bhavin Shah" <bhavinpshah@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] Please help with Twinhan VP 1025 DVB-S PCI
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0678606307=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0678606307==
Content-Type: multipart/alternative;
	boundary="----=_Part_15801_13620645.1219232521206"

------=_Part_15801_13620645.1219232521206
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi list,
I've been struggling hard with getting Twinhan VP 1025 DVB-S PCI card
with uBuntu 8.04 - Hardy and latest v4l-dvb source in India. I'm in
need of some insight.

The problem seems to be that the front end is unable to tune to or
monitor a signal.  Here is some background info:

Card:
Twinhan 1025 VisionPlus PCI DVB-S
Kernel/Dist:
2.6.24-19-generic

I just used hg to download the latest v4l-dvb and dvb-apps from
Mercurial and everything compiled and installed fine.  My card is auto
detected and loaded by BTTV module.

dmesg says:

###############dmesg#####################

Linux video capture interface: v2.00

bttv: driver version 0.9.17 loaded

bttv: using 8 buffers with 2080k (520 pages) each for capture

bttv: Bt8xx card found (0).

ACPI: PCI Interrupt 0000:03:03.0[A] -> GSI 21 (level, low) -> IRQ 21

bttv0: Bt878 (rev 17) at 0000:03:03.0, irq: 21, latency: 64, mmio: 0xfafff0=
00

bttv0: detected: Twinhan VisionPlus DVB [card=3D113], PCI subsystem ID
is 1822:0001

bttv0: using: Twinhan DST + clones [card=3D113,insmod option]

bttv0: risc main @ 1eafb000

bttv0: gpio: en=3D00000000, out=3D00000000 in=3D00d500ff [init]

bttv0: tuner type=3D16

bttv0: add subdevice "dvb0"

bt878: AUDIO driver version 0.0.0 loaded

bt878: Bt878 AUDIO function found (0).

ACPI: PCI Interrupt 0000:03:03.1[A] -> GSI 21 (level, low) -> IRQ 21

bt878_probe: card id=3D[0x11822],[ Twinhan VisionPlus DVB ] has DVB functio=
ns.

bt878(0): Bt878 (rev 17) at 03:03.1, irq: 21, latency: 64, memory: 0xfaffe0=
00

DVB: registering new adapter (bttv0)

ACPI: PCI Interrupt 0000:00:14.2[A] -> GSI 16 (level, low) -> IRQ 18

NET: Registered protocol family 10

lo: Disabled Privacy Extensions

hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...

dst(0) dst_get_device_id: Recognise [DST-03T]

dst(0) dst_get_device_id: Unsupported

dst(0) dst_check_mb86a15: Found a MB86A15 NIM

dst(0) dst_get_device_id: [DST-03T] has a [MB 86A15]

dst(0) dst_get_device_id: [DST-03T] has a [MB 86A15]

DST type flags : 0x2 ts204 0x4 symdiv 0x10 firmware version =3D 2

dst(0) dst_get_mac: MAC Address=3D[00:08:ca:16:67:00]

DVB: registering frontend 0 (DST DVB-S)...

###########################################

this seems fine to me. Now the problems...

I try to dvbtune to the inset4b, I'm in India but it gives following issues=
:

# dvbtune -f 10990000 -p V -s 27500 -v 501 -a 601 -m

Using DVB card "DST DVB-S"

tuning DVB-S to L-Band:0, Pol:V Srate=3D27500000, 22kHz=3Doff

polling....

Getting frontend event

FE_STATUS:

polling....

Getting frontend event

FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI FE_HAS_S=
YNC

Event:  Frequency: 1240000

        SymbolRate: 27500000

        FEC_inner:  9

Bit error rate: 0

Signal strength: 16384

SNR: 6400

FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI FE_HAS_S=
YNC

A/V/TT Filters set

FE READ_BER: : Operation not supported

FE READ UNCORRECTED BLOCKS: : Operation not supported

Signal=3D16384, Verror=3D0, SNR=3D6400dB, BlockErrors=3D0, (S|L|C|V|SY|)

FE READ_BER: : Operation not supported

FE READ UNCORRECTED BLOCKS: : Operation not supported

Signal=3D16640, Verror=3D0, SNR=3D6400dB, BlockErrors=3D0, (S|L|C|V|SY|)

FE READ_BER: : Operation not supported=85=85=85=85=85=85=85=85..





Then I look a dvbsnoop frontend info:
# dvbsnoop -s feinfo

dvbsnoop V1.4.50 -- http://dvbsnoop.sourceforge.net/



---------------------------------------------------------

FrontEnd Info...

---------------------------------------------------------



Device: /dev/dvb/adapter0/frontend0



Basic capabilities:

    Name: "DST DVB-S"

    Frontend-type:       QPSK (DVB-S)

    Frequency (min):     950.000 MHz

    Frequency (max):     2150.000 MHz

    Frequency stepsiz:   1.000 MHz

    Frequency tolerance: 29.500 MHz

    Symbol rate (min):     1.000000 MSym/s

    Symbol rate (max):     45.000000 MSym/s

    Symbol rate tolerance: 0 ppm

    Notifier delay: 0 ms

    Frontend capabilities:

        auto inversion

        FEC AUTO

        QPSK



Current parameters:

    Frequency:  1240.000 MHz

    Inversion:  OFF

    Symbol rate:  27.500000 MSym/s

    FEC:  FEC AUTO





user@machine:~$ dvbsnoop -s signal

dvbsnoop V1.4.50 -- http://dvbsnoop.sourceforge.net/



---------------------------------------------------------

Transponder/Frequency signal strength statistics...

---------------------------------------------------------

Error(95): frontend ioctl: Operation not supported

cycle: 1  d_time: 0.001 s



You can see that the freq is not set.  An interesting note is that up
in the basic capabilities section is lists frequency (max) as 2150.00
MHz.  Interestingly, when I change my cable to Windows with all the
same settings, I am able to tune and lock channels with TwinHan
provided SW.

Am I missing something here? Is the Linux DVB providing support of
TwinHan? I would REALLY appreciate any help or insight you might have
on this.  Thanks ton for your consideration.

------=_Part_15801_13620645.1219232521206
Content-Type: text/html; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

<div dir=3D"ltr"><meta http-equiv=3D"Content-Type" content=3D"text/html; ch=
arset=3Dutf-8"><meta name=3D"ProgId" content=3D"Word.Document"><meta name=
=3D"Generator" content=3D"Microsoft Word 11"><meta name=3D"Originator" cont=
ent=3D"Microsoft Word 11"><link rel=3D"File-List" href=3D"file:///D:%5CDOCU=
ME%7E1%5CBhavin%5CLOCALS%7E1%5CTemp%5Cmsohtml1%5C01%5Cclip_filelist.xml"><s=
tyle>
&lt;!--
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
=09{mso-style-parent:&quot;&quot;;
=09margin:0in;
=09margin-bottom:.0001pt;
=09mso-pagination:widow-orphan;
=09font-size:12.0pt;
=09font-family:&quot;Times New Roman&quot;;
=09mso-fareast-font-family:&quot;Times New Roman&quot;;}
pre
=09{margin:0in;
=09margin-bottom:.0001pt;
=09mso-pagination:widow-orphan;
=09font-size:10.0pt;
=09font-family:&quot;Courier New&quot;;
=09mso-fareast-font-family:&quot;Times New Roman&quot;;}
@page Section1
=09{size:8.5in 11.0in;
=09margin:1.0in 1.25in 1.0in 1.25in;
=09mso-header-margin:.5in;
=09mso-footer-margin:.5in;
=09mso-paper-source:0;}
div.Section1
=09{page:Section1;}
--&gt;
</style><pre>Hi list,
I&#39;ve been struggling hard with getting Twinhan VP 1025 DVB-S PCI card w=
ith uBuntu 8.04 - Hardy and latest v4l-dvb source in India. I&#39;m in need=
 of some insight.<span style=3D"">&nbsp; </span><br>
The problem seems to be that the front end is unable to tune to or monitor =
a signal.<span style=3D"">&nbsp; </span>Here is some background info:<br>
Card:
Twinhan 1025 VisionPlus PCI DVB-S
Kernel/Dist:
2.6.24-19-generic<br>
I just used hg to download the latest v4l-dvb and dvb-apps from Mercurial a=
nd everything compiled and installed fine.<span style=3D"">&nbsp; </span>My=
 card is auto detected and loaded by BTTV module.=20
<br>
dmesg says:<br>
###############dmesg#####################<br>
Linux video capture interface: v2.00</pre><pre>bttv: driver version 0.9.17 =
loaded</pre><pre>bttv: using 8 buffers with 2080k (520 pages) each for capt=
ure</pre><pre>bttv: Bt8xx card found (0).</pre><pre>ACPI: PCI Interrupt 000=
0:03:03.0[A] -&gt; GSI 21 (level, low) -&gt; IRQ 21</pre>
<pre>bttv0: Bt878 (rev 17) at 0000:03:03.0, irq: 21, latency: 64, mmio: 0xf=
afff000</pre><pre>bttv0: detected: Twinhan VisionPlus DVB [card=3D113], PCI=
 subsystem ID is 1822:0001</pre><pre>bttv0: using: Twinhan DST + clones [ca=
rd=3D113,insmod option]</pre>
<pre>bttv0: risc main @ 1eafb000</pre><pre>bttv0: gpio: en=3D00000000, out=
=3D00000000 in=3D00d500ff [init]</pre><pre>bttv0: tuner type=3D16</pre><pre=
>bttv0: add subdevice &quot;dvb0&quot;</pre><pre>bt878: AUDIO driver versio=
n 0.0.0 loaded</pre>
<pre>bt878: Bt878 AUDIO function found (0).</pre><pre>ACPI: PCI Interrupt 0=
000:03:03.1[A] -&gt; GSI 21 (level, low) -&gt; IRQ 21</pre><pre>bt878_probe=
: card id=3D[0x11822],[ Twinhan VisionPlus DVB ] has DVB functions.</pre>
<pre>bt878(0): Bt878 (rev 17) at 03:03.1, irq: 21, latency: 64, memory: 0xf=
affe000</pre><pre>DVB: registering new adapter (bttv0)</pre><pre>ACPI: PCI =
Interrupt 0000:00:14.2[A] -&gt; GSI 16 (level, low) -&gt; IRQ 18</pre><pre>
NET: Registered protocol family 10</pre><pre>lo: Disabled Privacy Extension=
s</pre><pre>hda_codec: Unknown model for ALC883, trying auto-probe from BIO=
S...</pre><pre>dst(0) dst_get_device_id: Recognise [DST-03T]</pre><pre>
dst(0) dst_get_device_id: Unsupported</pre><pre>dst(0) dst_check_mb86a15: F=
ound a MB86A15 NIM</pre><pre>dst(0) dst_get_device_id: [DST-03T] has a [MB =
86A15]</pre><pre>dst(0) dst_get_device_id: [DST-03T] has a [MB 86A15]</pre>
<pre>DST type flags : 0x2 ts204 0x4 symdiv 0x10 firmware version =3D 2</pre=
><pre>dst(0) dst_get_mac: MAC Address=3D[00:08:ca:16:67:00]</pre><pre>DVB: =
registering frontend 0 (DST DVB-S)...</pre><pre>###########################=
################<br>

this seems fine to me. Now the problems...<br style=3D"">
</pre><pre>I try to dvbtune to the inset4b, I&#39;m in India but it gives f=
ollowing issues:<br>
# dvbtune -f 10990000 -p V -s 27500 -v 501 -a 601 -m</pre><pre>Using DVB ca=
rd &quot;DST DVB-S&quot;</pre><pre>tuning DVB-S to L-Band:0, Pol:V Srate=3D=
27500000, 22kHz=3Doff</pre><pre>polling....</pre><pre>Getting frontend even=
t</pre>
<pre>FE_STATUS:</pre><pre>polling....</pre><pre>Getting frontend event</pre=
><pre>FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI FE=
_HAS_SYNC</pre><pre>Event:<span style=3D"">&nbsp; </span>Frequency: 1240000=
</pre>
<pre><span style=3D"">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>Sym=
bolRate: 27500000</pre><pre><span style=3D"">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; </span>FEC_inner:<span style=3D"">&nbsp; </span>9</pre><pre>Bi=
t error rate: 0</pre><pre>Signal strength: 16384</pre><pre>SNR: 6400</pre><=
pre>
FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI FE_HAS_S=
YNC</pre><pre>A/V/TT Filters set</pre><pre>FE READ_BER: : Operation not sup=
ported</pre><pre>FE READ UNCORRECTED BLOCKS: : Operation not supported</pre=
>
<pre>Signal=3D16384, Verror=3D0, SNR=3D6400dB, BlockErrors=3D0, (S|L|C|V|SY=
|)</pre><pre>FE READ_BER: : Operation not supported</pre><pre>FE READ UNCOR=
RECTED BLOCKS: : Operation not supported</pre><pre>Signal=3D16640, Verror=
=3D0, SNR=3D6400dB, BlockErrors=3D0, (S|L|C|V|SY|)</pre>
<pre>FE READ_BER: : Operation not supported=85=85=85=85=85=85=85=85..</pre>=
<pre>&nbsp;</pre><pre>&nbsp;</pre><pre>Then I look a dvbsnoop frontend info=
:
# dvbsnoop -s feinfo<br>
dvbsnoop V1.4.50 -- <a href=3D"http://dvbsnoop.sourceforge.net/">http://dvb=
snoop.sourceforge.net/</a> </pre><pre>&nbsp;</pre><pre>--------------------=
-------------------------------------</pre><pre>FrontEnd Info...</pre><pre>=
---------------------------------------------------------</pre>
<pre>&nbsp;</pre><pre>Device: /dev/dvb/adapter0/frontend0</pre><pre>&nbsp;<=
/pre><pre>Basic capabilities:</pre><pre><span style=3D"">&nbsp;&nbsp;&nbsp;=
 </span>Name: &quot;DST DVB-S&quot;</pre><pre><span style=3D"">&nbsp;&nbsp;=
&nbsp; </span>Frontend-type:<span style=3D"">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp; </span>QPSK (DVB-S)</pre>
<pre><span style=3D"">&nbsp;&nbsp;&nbsp; </span>Frequency (min):<span style=
=3D"">&nbsp;&nbsp;&nbsp;&nbsp; </span>950.000 MHz</pre><pre><span style=3D"=
">&nbsp;&nbsp;&nbsp; </span>Frequency (max):<span style=3D"">&nbsp;&nbsp;&n=
bsp;&nbsp; </span>2150.000 MHz</pre><pre><span style=3D"">&nbsp;&nbsp;&nbsp=
; </span>Frequency stepsiz:<span style=3D"">&nbsp;&nbsp; </span>1.000 MHz</=
pre>
<pre><span style=3D"">&nbsp;&nbsp;&nbsp; </span>Frequency tolerance: 29.500=
 MHz</pre><pre><span style=3D"">&nbsp;&nbsp;&nbsp; </span>Symbol rate (min)=
:<span style=3D"">&nbsp;&nbsp;&nbsp;&nbsp; </span>1.000000 MSym/s</pre><pre=
><span style=3D"">&nbsp;&nbsp;&nbsp; </span>Symbol rate (max):<span style=
=3D"">&nbsp;&nbsp;&nbsp;&nbsp; </span>45.000000 MSym/s</pre>
<pre><span style=3D"">&nbsp;&nbsp;&nbsp; </span>Symbol rate tolerance: 0 pp=
m</pre><pre><span style=3D"">&nbsp;&nbsp;&nbsp; </span>Notifier delay: 0 ms=
</pre><pre><span style=3D"">&nbsp;&nbsp;&nbsp; </span>Frontend capabilities=
:</pre><pre><span style=3D"">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </s=
pan>auto inversion</pre>
<pre><span style=3D"">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>FEC=
 AUTO</pre><pre><span style=3D"">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 </span>QPSK</pre><pre>&nbsp;</pre><pre>Current parameters:</pre><pre><span=
 style=3D"">&nbsp;&nbsp;&nbsp; </span>Frequency:<span style=3D"">&nbsp; </s=
pan>1240.000 MHz</pre><pre>
<span style=3D"">&nbsp;&nbsp;&nbsp; </span>Inversion:<span style=3D"">&nbsp=
; </span>OFF</pre><pre><span style=3D"">&nbsp;&nbsp;&nbsp; </span>Symbol ra=
te:<span style=3D"">&nbsp; </span>27.500000 MSym/s</pre><pre><span style=3D=
"">&nbsp;&nbsp;&nbsp; </span>FEC:<span style=3D"">&nbsp; </span>FEC AUTO</p=
re>
<pre>&nbsp;</pre><pre>&nbsp;</pre><pre>user@machine:~$ dvbsnoop -s signal</=
pre><pre>dvbsnoop V1.4.50 -- <a href=3D"http://dvbsnoop.sourceforge.net/">h=
ttp://dvbsnoop.sourceforge.net/</a> </pre><pre>&nbsp;</pre><pre>-----------=
----------------------------------------------</pre>
<pre>Transponder/Frequency signal strength statistics...</pre><pre>--------=
-------------------------------------------------</pre><pre>Error(95): fron=
tend ioctl: Operation not supported</pre><pre>cycle: 1<span style=3D"">&nbs=
p; </span>d_time: 0.001 s<span style=3D""> </span>&nbsp;<br>
</pre><pre>&nbsp;</pre><pre>You can see that the freq is not set.<span styl=
e=3D"">&nbsp; </span>An interesting note is that up in the basic capabiliti=
es section is lists frequency (max) as 2150.00 MHz.<span style=3D"">&nbsp; =
</span>Interestingly, when I change my cable to Windows with all the same s=
ettings, I am able to tune and lock channels with TwinHan provided SW. <br>
</pre><pre>Am I missing something here? Is the Linux DVB providing support =
of TwinHan? I would REALLY appreciate any help or insight you might have on=
 this.<span style=3D"">&nbsp; </span>Thanks ton for your consideration.</pr=
e>

<p class=3D"MsoNormal">&nbsp;</p>

</div>

------=_Part_15801_13620645.1219232521206--


--===============0678606307==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0678606307==--
