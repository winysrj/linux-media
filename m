Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail.icp-qv1-irony-out1.iinet.net.au ([203.59.1.146])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sonofzev@iinet.net.au>) id 1Kdyqe-0007eq-5G
	for linux-dvb@linuxtv.org; Fri, 12 Sep 2008 04:57:29 +0200
MIME-Version: 1.0
From: "sonofzev@iinet.net.au" <sonofzev@iinet.net.au>
To: 'linux dvb' <linux-dvb@linuxtv.org>, 'Steven Toth' <stoth@linuxtv.org>,
	'Tim Lucas' <lucastim@gmail.com>
Date: Fri, 12 Sep 2008 10:57:18 +0800
Message-Id: <62806.1221188238@iinet.net.au>
Subject: Re: [linux-dvb] [PATCH] cx23885 analog TV and audio support for
	HVR-1500 (Update on progress)
Reply-To: sonofzev@iinet.net.au
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0107666090=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0107666090==
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="us-ascii"

<HTML>
<BR>
I'm keeping close track of this. I've got the Australian/European version o=
f the card. <BR>
<BR>
Does this mean once analog is working the composite input may work as well?=
<BR>
 <BR>
<BR>
<span style=3D"font-weight: bold;">On Fri Sep 12 11:51 , "Tim Lucas" <lucas=
tim@gmail.com> sent:<BR>
<BR>
</lucastim@gmail.com></span><blockquote style=3D"border-left: 2px solid rgb=
(245, 245, 245); margin-left: 5px; margin-right: 0px; padding-left: 5px; pa=
dding-right: 0px;"><div dir=3D"ltr"><div>Brief summary: &nbsp;Trying to get=
 analog working on a DViCO FusionHDTV7 Dual Express</div><div>It was sugges=
ted that I use the ~stoth/cx23885-audio branch and load the card as a HVR15=
00.</div><div><BR>
</div>


<div>Since nothing was working, I decided to update to the latest kernel (a=
nd therefore mythbuntu 8.1)</div><div>Although the card still didn't work, =
I was getting better results. &nbsp;dmesg said</div><div><BR>
</div><div>


[ &nbsp; 11.224568] cx23885[0]: i2c bus 0 registered</div><div>[ &nbsp; 11.=
224609] cx23885[0]: i2c bus 1 registered</div><div>[ &nbsp; 11.224632] cx23=
885[0]: i2c bus 2 registered</div><div>[ &nbsp; 11.251024] tveeprom 2-0050:=
 Encountered bad packet header [ff]. Corrupt or not a Hauppauge eeprom.</di=
v>


<div>[ &nbsp; 11.251026] cx23885[0]: warning: unknown hauppauge model #0</d=
iv><div>[ &nbsp; 11.251027] cx23885[0]: hauppauge eeprom: model=3D0</div><d=
iv>[ &nbsp; 11.268639] cx25840' 4-0044: cx25 &nbsp;0-21 found @ 0x88 (cx238=
85[0])</div><div>


[ &nbsp; 11.283305] tuner' 2-0064: chip found @ 0xc8 (cx23885[0])</div><div=
>[ &nbsp; 11.285887] tuner' 3-0064: chip found @ 0xc8 (cx23885[0])</div><di=
v>[ &nbsp; 11.288377] cx23885[0]/0: registered device video0 [v4l2]</div><d=
iv>


[ &nbsp; 11.288653] cx23885[0]/1: registered ALSA audio device</div><div>[ =
&nbsp; 11.288658] tuner' 3-0064: tuner type not set</div><div>[ &nbsp; 11.2=
92131] firmware: requesting v4l-cx23885-avcore-01.fw</div><div>[ &nbsp; 11.=
310299] cx25840' 4-0044: unable to open firmware v4l-cx23885-avcore-01.fw</=
div>


<div>[ &nbsp; 11.324551] cx23885[0]: cx23885 based dvb card</div><div>[ &nb=
sp; 11.348947] cx23885[0]: frontend initialization failed</div><div>[ &nbsp=
; 11.348949] cx23885_dvb_register() dvb_register failed err =3D -1</div><di=
v>[ &nbsp; 11.348951] cx23885_dev_setup() Failed to register dvb on VID_C</=
div>


<div>[ &nbsp; 11.348955] cx23885_dev_checkrevision() Hardware revision =3D =
0xb0</div><div>[ &nbsp; 11.348960] cx23885[0]/0: found at 0000:08:00.0, rev=
: 2, irq: 16, latency: 0, mmio: 0xfd800000</div><div>[ &nbsp; 11.348966] cx=
23885 0000:08:00.0: setting latency timer to 64</div>


<div><div>[ &nbsp; 11.349304] ACPI: PCI Interrupt Link [AAZA] enabled at IR=
Q 22</div><div>[ &nbsp; 11.349308] HDA Intel 0000:00:10.1: PCI INT B -&gt; =
Link[AAZA] -&gt; GSI 22 (level, low) -&gt; IRQ 22</div><div>[ &nbsp; 11.349=
322] HDA Intel 0000:00:10.1: setting latency timer to 64</div>


<div>[ &nbsp; 11.382833] hda_codec: Unknown model for ALC883, trying auto-p=
robe from BIOS...</div><div>[ &nbsp; 12.055790] lp0: using parport0 (interr=
upt-driven).</div><div>[ &nbsp; 12.326401] Adding 6040400k swap on /dev/sda=
5. &nbsp;Priority:-1 extents:1 across:6040400k</div>


<div>[ &nbsp; 13.009799] EXT3 FS on sda1, internal journal</div><div>[ &nbs=
p; 14.162071] type=3D1505 audit(1221183219.263:2): operation=3D"profile_loa=
d" name=3D"/usr/sbin/mysqld" name2=3D"default" pid=3D4549</div>


<div>[ &nbsp; 14.370696] ip_tables: (C) 2000-2006 Netfilter Core Team</div>=
<div>[ &nbsp; 15.464191] ACPI: WMI: Mapper loaded</div><div>[ &nbsp; 18.424=
988] warning: `avahi-daemon' uses 32-bit capabilities (legacy support in us=
e)</div>


<div>[ &nbsp; 19.203038] NET: Registered protocol family 10</div><div>[ &nb=
sp; 19.203387] lo: Disabled Privacy Extensions</div><div>[ &nbsp; 29.299688=
] tuner' 3-0064: tuner type not set</div><div>[ &nbsp; 29.307835] tuner' 3-=
0064: tuner type not set</div>


<div>[ &nbsp; 32.729350] mtrr: base(0xf7000000) is not aligned on a size(0x=
e00000) boundary</div><div>[ &nbsp; 34.762892] NET: Registered protocol fam=
ily 17</div><div>[ &nbsp; 44.712012] eth0: no IPv6 routers present</div><di=
v><BR>
</div>


</div><div><BR>
</div><div>This made me think that I should go out and find&nbsp;v4l-cx2388=
5-avcore-01.fw.</div><div>I found it at&nbsp;<a href=3D"http://www.stevento=
th.net/linux/hvr1800/" target=3D"_blank">http://www.steventoth.net/linux/hv=
r1800/</a></div>


<div><BR>
</div><div>I loaded this firmware too. &nbsp;New results:</div><div><div>[ =
&nbsp; 11.087605] cx23885 driver version 0.0.1 loaded</div><div>[ &nbsp; 11=
.088234] ACPI: PCI Interrupt Link [APC6] enabled at IRQ 16</div><div>[ &nbs=
p; 11.088237] cx23885 0000:08:00.0: PCI INT A -&gt; Link[APC6] -&gt; GSI 16=
 (level, low) -&gt; IRQ 16</div>

<div>[ &nbsp; 11.088311] CORE cx23885[0]: subsystem: 18ac:d618, board: Haup=
pauge WinTV-HVR1500 [card=3D6,insmod option]</div><div>[ &nbsp; 11.196069] =
cx23885[0]: i2c bus 0 registered</div><div>[ &nbsp; 11.196109] cx23885[0]: =
i2c bus 1 registered</div>

<div>[ &nbsp; 11.196144] cx23885[0]: i2c bus 2 registered</div><div>[ &nbsp=
; 11.222543] tveeprom 2-0050: Encountered bad packet header [ff]. Corrupt o=
r not a Hauppauge eeprom.</div><div>[ &nbsp; 11.222545] cx23885[0]: warning=
: unknown hauppauge model #0</div>

<div>[ &nbsp; 11.222546] cx23885[0]: hauppauge eeprom: model=3D0</div><div>=
[ &nbsp; 11.232371] cx25840' 4-0044: cx25 &nbsp;0-21 found @ 0x88 (cx23885[=
0])</div><div>[ &nbsp; 11.245763] tuner' 2-0064: chip found @ 0xc8 (cx23885=
[0])</div>

<div>[ &nbsp; 11.248348] tuner' 3-0064: chip found @ 0xc8 (cx23885[0])</div=
><div>[ &nbsp; 11.250432] cx23885[0]/0: registered device video0 [v4l2]</di=
v><div>[ &nbsp; 11.250696] cx23885[0]/1: registered ALSA audio device</div>=
<div>[ &nbsp; 11.250700] tuner' 3-0064: tuner type not set</div>

<div>[ &nbsp; 11.254199] firmware: requesting v4l-cx23885-avcore-01.fw</div=
><div>[ &nbsp; 11.876323] cx25840' 4-0044: loaded v4l-cx23885-avcore-01.fw =
firmware (16382 bytes)</div><div>[ &nbsp; 11.890444] cx23885[0]: cx23885 ba=
sed dvb card</div>

<div><div>[ &nbsp; 11.920769] cx23885[0]: frontend initialization failed</d=
iv><div>[ &nbsp; 11.920771] cx23885_dvb_register() dvb_register failed err =
=3D -1</div><div>[ &nbsp; 11.920773] cx23885_dev_setup() Failed to register=
 dvb on VID_C</div>

<div>[ &nbsp; 11.920777] cx23885_dev_checkrevision() Hardware revision =3D =
0xb0</div><div>[ &nbsp; 11.920783] cx23885[0]/0: found at 0000:08:00.0, rev=
: 2, irq: 16, latency: 0, mmio: 0xfd800000</div><div>[ &nbsp; 11.920788] cx=
23885 0000:08:00.0: setting latency timer to 64</div>

<div>[ &nbsp; 11.921128] ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 22<=
/div><div>[ &nbsp; 11.921132] HDA Intel 0000:00:10.1: PCI INT B -&gt; Link[=
AAZA] -&gt; GSI 22 (level, low) -&gt; IRQ 22</div><div>[ &nbsp; 11.921147] =
HDA Intel 0000:00:10.1: setting latency timer to 64</div>

<div>[ &nbsp; 11.954833] hda_codec: Unknown model for ALC883, trying auto-p=
robe from BIOS...</div><div>[ &nbsp; 13.052435] lp0: using parport0 (interr=
upt-driven).</div><div>[ &nbsp; 13.323879] Adding 6040400k swap on /dev/sda=
5. &nbsp;Priority:-1 extents:1 across:6040400k</div>

<div>[ &nbsp; 14.006491] EXT3 FS on sda1, internal journal</div><div>[ &nbs=
p; 15.167174] type=3D1505 audit(1221184067.272:2): operation=3D"profile_loa=
d" name=3D"/usr/sbin/mysqld" name2=3D"default" pid=3D4590</div>

<div>[ &nbsp; 15.334061] ip_tables: (C) 2000-2006 Netfilter Core Team</div>=
<div>[ &nbsp; 16.444201] ACPI: WMI: Mapper loaded</div><div>[ &nbsp; 19.463=
314] warning: `avahi-daemon' uses 32-bit capabilities (legacy support in us=
e)</div>

<div>[ &nbsp; 20.171391] NET: Registered protocol family 10</div><div>[ &nb=
sp; 20.171801] lo: Disabled Privacy Extensions</div><div>[ &nbsp; 29.432385=
] tuner' 3-0064: tuner type not set</div><div>[ &nbsp; 29.440692] tuner' 3-=
0064: tuner type not set</div>

<div>[ &nbsp; 34.560243] NET: Registered protocol family 17</div><div>[ &nb=
sp; 44.123339] mtrr: base(0xf7000000) is not aligned on a size(0xe00000) bo=
undary</div><div>[ &nbsp; 45.156509] eth0: no IPv6 routers present</div><di=
v><BR>
</div>

<div>I feel like I am getting closer, but I still cannot tune channels. &nb=
sp;Any help would be appreciated.</div></div></div><div><BR>
</div><div><BR>
</div>-- <BR>
 --Tim<BR>

</div>
</blockquote></HTML>
<BR>=


--===============0107666090==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0107666090==--
