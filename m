Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wr-out-0506.google.com ([64.233.184.227])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eduardhc@gmail.com>) id 1JjFHV-00022o-Oa
	for linux-dvb@linuxtv.org; Tue, 08 Apr 2008 16:58:45 +0200
Received: by wr-out-0506.google.com with SMTP id c30so1761691wra.14
	for <linux-dvb@linuxtv.org>; Tue, 08 Apr 2008 07:58:36 -0700 (PDT)
Message-ID: <617be8890804080758o20a29e3dvd6e00dda7101b9f1@mail.gmail.com>
Date: Tue, 8 Apr 2008 16:58:35 +0200
From: "Eduard Huguet" <eduardhc@gmail.com>
To: "mehmet canser" <mehmetcanser@hotmail.com>, linux-dvb@linuxtv.org
In-Reply-To: <BAY114-W531B3EFEA7CE4CAEC133AEDBF20@phx.gbl>
MIME-Version: 1.0
References: <617be8890804080606y23bc62b7j7495a37c039bd3d6@mail.gmail.com>
	<BAY114-W531B3EFEA7CE4CAEC133AEDBF20@phx.gbl>
Subject: Re: [linux-dvb] Any progress on the AverMedia A700 (DVB-S Pro)?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1841223197=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1841223197==
Content-Type: multipart/alternative;
	boundary="----=_Part_17182_31085142.1207666715278"

------=_Part_17182_31085142.1207666715278
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Thanks for your feedback. It seems that the patch works for some people and
doesn't for others (which is my case, unfortunately :D).

I'll try again this afternoon and see if I can't get a lock on any
satellite. I've tested all the patches published and none of them has worke=
d
for me, but I really don't know the reason.

I'll compare the contents of your EEPROM, etc... which mine, to see if ther=
e
is any difference. =BFAre you using any special options for the saa7134,
etc...modules? I mean if you have added any options file in
/etc/modules.d/... or similar.

The card works perfectly under Windows, so it's not an antenna problem. The
only thing that it's maybe related is the fact that I don't "own" the dish.
It's a common equipment for the whole house and it's sitted on the top of
the building (a 15-floor apartment building) roof, and I get the signal
through the common TV cable. The TV wire carries analog TV, DVB-T and DVB-S
signals all together, and DVB-S is then splitted once at home using a
diplexor. Windows works just fine with this setup but I'm wondering if Linu=
x
driver has any problem with it due to the fact that it can't control the
dish through LNB signals or whatever.
(note: I'm a complete noob regarding DVB-S, so if the above paragraph is
just silly please ignore it...)

Regards,
  Eduard



2008/4/8, mehmet canser <mehmetcanser@hotmail.com>:
>
>  I m using this card and it is working.
> My configuration:
>   Avermedia A700 DVB-S Pro A700 - ubuntu hardy development 64 bit - kerne=
l
> 2.6.24-14
>   Patch : http://dev.gentoo.org/~zzam/dvb/a700_full_20080313.diff<http://=
dev.gentoo.org/%7Ezzam/dvb/a700_full_20080313.diff>
>  Two satellite dishes: Turksat 42E and Hotbird 13E. Both working.
>
> Digital TV and audio  work correctly, only signals weak.
> Analog video (composite input) works, but i can't get sound from analog
> input.
> For digital tv, I m using kaffeine and it works without problems. For
> analog part, I use xawtv and tvtime, both shows video, but no sound.
>
> lspci  -vnn
> 04:09.0 Multimedia controller [0480]: Philips Semiconductors
> SAA7133/SAA7135 Video Broadcast Decoder [1131:7133] (rev d1)
>     Subsystem: Avermedia Technologies Inc Unknown device [1461:a7a1]
>     Flags: bus master, medium devsel, latency 32, IRQ 17
>     Memory at fdcff000 (32-bit, non-prefetchable) [size=3D2K]
>     Capabilities: <access denied>
>
> dmesg | grep DVB
> [   36.655632] saa7133[0]: subsystem: 1461:a7a1, board: Avermedia DVB-S
> Pro A700 [card=3D140,autodetected]
> [   38.590558] DVB: registering new adapter (saa7133[0])
> [   38.590561] DVB: registering frontend 0 (Zarlink ZL10313 DVB-S)...
>
> dmesg | grep saa
> [   36.655100] saa7130/34: v4l2 driver version 0.2.14 loaded
> [   36.655626] saa7133[0]: found at 0000:04:09.0, rev: 209, irq: 17,
> latency: 32, mmio: 0xfdcff000
> [   36.655632] saa7133[0]: subsystem: 1461:a7a1, board: Avermedia DVB-S
> Pro A700 [card=3D140,autodetected]
> [   36.655643] saa7133[0]: board init: gpio is 23200
> [   37.011708] saa7133[0]: i2c eeprom 00: 61 14 a1 a7 ff ff ff ff ff ff f=
f
> ff ff ff ff ff
> [   37.011716] saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff f=
f
> ff ff ff ff ff
> [   37.011721] saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff f=
f
> ff ff ff ff ff
> [   37.011726] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff f=
f
> ff ff ff ff ff
> [   37.011730] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff f=
f
> ff ff ff ff ff
> [   37.011735] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff f=
f
> ff ff ff ff ff
> [   37.011740] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff f=
f
> ff ff ff ff ff
> [   37.011745] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff f=
f
> ff ff ff ff ff
> [   37.011749] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff f=
f
> ff ff ff ff ff
> [   37.011754] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff f=
f
> ff ff ff ff ff
> [   37.011759] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff f=
f
> ff ff ff ff ff
> [   37.011764] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff f=
f
> ff ff ff ff ff
> [   37.011768] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff f=
f
> ff ff ff ff ff
> [   37.011773] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff f=
f
> ff ff ff ff ff
> [   37.011778] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff f=
f
> ff ff ff ff ff
> [   37.011783] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff f=
f
> ff ff ff ff ff
> [   37.019673] saa7133[0]: i2c scan: found device @ 0x1c  [???]
> [   37.035662] saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
> [   37.054218] saa7133[0]: registered device video0 [v4l2]
> [   37.054249] saa7133[0]: registered device vbi0
> [   38.590558] DVB: registering new adapter (saa7133[0])
>
> Best regards,
> Mehmet Canser
>
>
> ------------------------------
> Date: Tue, 8 Apr 2008 15:06:12 +0200
> From: eduardhc@gmail.com
> To: linux-dvb@linuxtv.org
> Subject: [linux-dvb] Any progress on the AverMedia A700 (DVB-S Pro)?
>
> Hi,
>     Things are very quiet lately regarding this card. Is there any
> possibility that the card gets supported in any near future? I know
> Matthias  Schwarzot had been working on it, but there's no messages from =
him
> lately on the list.
>
> Best regards,
>   Eduard
>
>
> ------------------------------
> Use video conversation to talk face-to-face with Windows Live Messenger. =
Get
> started!<http://www.windowslive.com/messenger/connect_your_way.html?ocid=
=3DTXT_TAGLM_WL_Refresh_messenger_video_042008>
>

------=_Part_17182_31085142.1207666715278
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Thanks for your feedback. It seems that the patch works for some people and=
 doesn&#39;t for others (which is my case, unfortunately :D).<br><br>I&#39;=
ll try again this afternoon and see if I can&#39;t get a lock on any satell=
ite. I&#39;ve tested all the patches published and none of them has worked =
for me, but I really don&#39;t know the reason. <br>
<br>I&#39;ll compare the contents of your EEPROM, etc... which mine, to see=
 if there is any difference. =BFAre you using any special options for the s=
aa7134, etc...modules? I mean if you have added any options file in /etc/mo=
dules.d/... or similar.<br>
<br>The card works perfectly under Windows, so it&#39;s not an antenna prob=
lem. The only thing that it&#39;s maybe related is the fact that I don&#39;=
t &quot;own&quot; the dish. It&#39;s a common equipment for the whole house=
 and it&#39;s sitted on the top of the building (a 15-floor apartment build=
ing) roof, and I get the signal through the common TV cable. The TV wire ca=
rries analog TV, DVB-T and DVB-S signals all together, and DVB-S is then sp=
litted once at home using a diplexor. Windows works just fine with this set=
up but I&#39;m wondering if Linux driver has any problem with it due to the=
 fact that it can&#39;t control the dish through LNB signals or whatever.<b=
r>
(note: I&#39;m a complete noob regarding DVB-S, so if the above paragraph i=
s just silly please ignore it...)<br><br>Regards, <br>&nbsp; Eduard<br><br>=
<br><br><div><span class=3D"gmail_quote">2008/4/8, mehmet canser &lt;<a hre=
f=3D"mailto:mehmetcanser@hotmail.com">mehmetcanser@hotmail.com</a>&gt;:</sp=
an><blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(20=
4, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">




<div>
I m using this card and it is working.<br>My configuration:&nbsp; <br>&nbsp=
; Avermedia A700 DVB-S Pro A700 - ubuntu hardy development 64 bit - kernel =
2.6.24-14<br>&nbsp; Patch : <a href=3D"http://dev.gentoo.org/%7Ezzam/dvb/a7=
00_full_20080313.diff" target=3D"_blank" onclick=3D"return top.js.OpenExtLi=
nk(window,event,this)">http://dev.gentoo.org/~zzam/dvb/a700_full_20080313.d=
iff</a><br>
&nbsp;Two satellite dishes: Turksat 42E and Hotbird 13E. Both working.<br><=
br>Digital TV and audio&nbsp; work correctly, only signals weak.<br>Analog =
video (composite input) works, but i can&#39;t get sound from analog input.=
 <br>For digital tv, I m using kaffeine and it works without problems. For =
analog part, I use xawtv and tvtime, both shows video, but no sound.<br>
&nbsp;<br>lspci&nbsp; -vnn<br>04:09.0 Multimedia controller [0480]: Philips=
 Semiconductors SAA7133/SAA7135 Video Broadcast Decoder [1131:7133] (rev d1=
)<br>&nbsp;&nbsp;&nbsp; Subsystem: Avermedia Technologies Inc Unknown devic=
e [1461:a7a1]<br>&nbsp;&nbsp;&nbsp; Flags: bus master, medium devsel, laten=
cy 32, IRQ 17<br>
&nbsp;&nbsp;&nbsp; Memory at fdcff000 (32-bit, non-prefetchable) [size=3D2K=
]<br>&nbsp;&nbsp;&nbsp; Capabilities: &lt;access denied&gt;<br><br>dmesg | =
grep DVB<br>[&nbsp;&nbsp; 36.655632] saa7133[0]: subsystem: 1461:a7a1, boar=
d: Avermedia DVB-S Pro A700 [card=3D140,autodetected]<br>
[&nbsp;&nbsp; 38.590558] DVB: registering new adapter (saa7133[0])<br>[&nbs=
p;&nbsp; 38.590561] DVB: registering frontend 0 (Zarlink ZL10313 DVB-S)...<=
br><br>dmesg | grep saa<br>[&nbsp;&nbsp; 36.655100] saa7130/34: v4l2 driver=
 version 0.2.14 loaded<br>
[&nbsp;&nbsp; 36.655626] saa7133[0]: found at 0000:04:09.0, rev: 209, irq: =
17, latency: 32, mmio: 0xfdcff000<br>[&nbsp;&nbsp; 36.655632] saa7133[0]: s=
ubsystem: 1461:a7a1, board: Avermedia DVB-S Pro A700 [card=3D140,autodetect=
ed]<br>[&nbsp;&nbsp; 36.655643] saa7133[0]: board init: gpio is 23200<br>
[&nbsp;&nbsp; 37.011708] saa7133[0]: i2c eeprom 00: 61 14 a1 a7 ff ff ff ff=
 ff ff ff ff ff ff ff ff<br>[&nbsp;&nbsp; 37.011716] saa7133[0]: i2c eeprom=
 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>[&nbsp;&nbsp; 37.01=
1721] saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff =
ff ff<br>
[&nbsp;&nbsp; 37.011726] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff=
 ff ff ff ff ff ff ff ff<br>[&nbsp;&nbsp; 37.011730] saa7133[0]: i2c eeprom=
 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>[&nbsp;&nbsp; 37.01=
1735] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff =
ff ff<br>
[&nbsp;&nbsp; 37.011740] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff=
 ff ff ff ff ff ff ff ff<br>[&nbsp;&nbsp; 37.011745] saa7133[0]: i2c eeprom=
 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>[&nbsp;&nbsp; 37.01=
1749] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff =
ff ff<br>
[&nbsp;&nbsp; 37.011754] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff=
 ff ff ff ff ff ff ff ff<br>[&nbsp;&nbsp; 37.011759] saa7133[0]: i2c eeprom=
 a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>[&nbsp;&nbsp; 37.01=
1764] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff =
ff ff<br>
[&nbsp;&nbsp; 37.011768] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff=
 ff ff ff ff ff ff ff ff<br>[&nbsp;&nbsp; 37.011773] saa7133[0]: i2c eeprom=
 d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>[&nbsp;&nbsp; 37.01=
1778] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff =
ff ff<br>
[&nbsp;&nbsp; 37.011783] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff=
 ff ff ff ff ff ff ff ff<br>[&nbsp;&nbsp; 37.019673] saa7133[0]: i2c scan: =
found device @ 0x1c&nbsp; [???]<br>[&nbsp;&nbsp; 37.035662] saa7133[0]: i2c=
 scan: found device @ 0xa0&nbsp; [eeprom]<br>
[&nbsp;&nbsp; 37.054218] saa7133[0]: registered device video0 [v4l2]<br>[&n=
bsp;&nbsp; 37.054249] saa7133[0]: registered device vbi0<br>[&nbsp;&nbsp; 3=
8.590558] DVB: registering new adapter (saa7133[0])<br><br>Best regards,<br=
>Mehmet Canser<br><br><br>
<blockquote><hr>Date: Tue, 8 Apr 2008 15:06:12 +0200<br>From: <a href=3D"ma=
ilto:eduardhc@gmail.com" target=3D"_blank" onclick=3D"return top.js.OpenExt=
Link(window,event,this)">eduardhc@gmail.com</a><br>To: <a href=3D"mailto:li=
nux-dvb@linuxtv.org" target=3D"_blank" onclick=3D"return top.js.OpenExtLink=
(window,event,this)">linux-dvb@linuxtv.org</a><br>
Subject: [linux-dvb] Any progress on the AverMedia A700 (DVB-S Pro)?<div><s=
pan class=3D"e" id=3D"q_1192e7bde9d3a180_1"><br><br>Hi, <br>&nbsp;&nbsp;&nb=
sp; Things are very quiet lately regarding this card. Is there any possibil=
ity that the card gets supported in any near future? I know Matthias&nbsp; =
Schwarzot had been working on it, but there&#39;s no messages from him late=
ly on the list.<br>

<br>Best regards, <br>&nbsp; Eduard<br><br>
</span></div></blockquote><br><hr>Use video conversation to talk face-to-fa=
ce with Windows Live Messenger. <a href=3D"http://www.windowslive.com/messe=
nger/connect_your_way.html?ocid=3DTXT_TAGLM_WL_Refresh_messenger_video_0420=
08" target=3D"_blank" onclick=3D"return top.js.OpenExtLink(window,event,thi=
s)">Get started!</a></div>

</blockquote></div><br>

------=_Part_17182_31085142.1207666715278--


--===============1841223197==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1841223197==--
