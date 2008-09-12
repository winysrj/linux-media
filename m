Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.170])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lucastim@gmail.com>) id 1Kdxok-000482-5o
	for linux-dvb@linuxtv.org; Fri, 12 Sep 2008 03:51:37 +0200
Received: by wf-out-1314.google.com with SMTP id 27so596380wfd.17
	for <linux-dvb@linuxtv.org>; Thu, 11 Sep 2008 18:51:20 -0700 (PDT)
Message-ID: <e32e0e5d0809111851n2e5cb896r821dc29f3a7b2a0d@mail.gmail.com>
Date: Thu, 11 Sep 2008 18:51:20 -0700
From: "Tim Lucas" <lucastim@gmail.com>
To: "linux dvb" <linux-dvb@linuxtv.org>, "Steven Toth" <stoth@linuxtv.org>
MIME-Version: 1.0
Subject: Re: [linux-dvb] [PATCH] cx23885 analog TV and audio support for
	HVR-1500 (Update on progress)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0700699760=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0700699760==
Content-Type: multipart/alternative;
	boundary="----=_Part_94675_15038715.1221184280667"

------=_Part_94675_15038715.1221184280667
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Brief summary:  Trying to get analog working on a DViCO FusionHDTV7 Dual
Express
It was suggested that I use the ~stoth/cx23885-audio branch and load the
card as a HVR1500.

Since nothing was working, I decided to update to the latest kernel (and
therefore mythbuntu 8.1)
Although the card still didn't work, I was getting better results.  dmesg
said

[   11.224568] cx23885[0]: i2c bus 0 registered
[   11.224609] cx23885[0]: i2c bus 1 registered
[   11.224632] cx23885[0]: i2c bus 2 registered
[   11.251024] tveeprom 2-0050: Encountered bad packet header [ff]. Corrupt
or not a Hauppauge eeprom.
[   11.251026] cx23885[0]: warning: unknown hauppauge model #0
[   11.251027] cx23885[0]: hauppauge eeprom: model=0
[   11.268639] cx25840' 4-0044: cx25  0-21 found @ 0x88 (cx23885[0])
[   11.283305] tuner' 2-0064: chip found @ 0xc8 (cx23885[0])
[   11.285887] tuner' 3-0064: chip found @ 0xc8 (cx23885[0])
[   11.288377] cx23885[0]/0: registered device video0 [v4l2]
[   11.288653] cx23885[0]/1: registered ALSA audio device
[   11.288658] tuner' 3-0064: tuner type not set
[   11.292131] firmware: requesting v4l-cx23885-avcore-01.fw
[   11.310299] cx25840' 4-0044: unable to open firmware
v4l-cx23885-avcore-01.fw
[   11.324551] cx23885[0]: cx23885 based dvb card
[   11.348947] cx23885[0]: frontend initialization failed
[   11.348949] cx23885_dvb_register() dvb_register failed err = -1
[   11.348951] cx23885_dev_setup() Failed to register dvb on VID_C
[   11.348955] cx23885_dev_checkrevision() Hardware revision = 0xb0
[   11.348960] cx23885[0]/0: found at 0000:08:00.0, rev: 2, irq: 16,
latency: 0, mmio: 0xfd800000
[   11.348966] cx23885 0000:08:00.0: setting latency timer to 64
[   11.349304] ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 22
[   11.349308] HDA Intel 0000:00:10.1: PCI INT B -> Link[AAZA] -> GSI 22
(level, low) -> IRQ 22
[   11.349322] HDA Intel 0000:00:10.1: setting latency timer to 64
[   11.382833] hda_codec: Unknown model for ALC883, trying auto-probe from
BIOS...
[   12.055790] lp0: using parport0 (interrupt-driven).
[   12.326401] Adding 6040400k swap on /dev/sda5.  Priority:-1 extents:1
across:6040400k
[   13.009799] EXT3 FS on sda1, internal journal
[   14.162071] type=1505 audit(1221183219.263:2): operation="profile_load"
name="/usr/sbin/mysqld" name2="default" pid=4549
[   14.370696] ip_tables: (C) 2000-2006 Netfilter Core Team
[   15.464191] ACPI: WMI: Mapper loaded
[   18.424988] warning: `avahi-daemon' uses 32-bit capabilities (legacy
support in use)
[   19.203038] NET: Registered protocol family 10
[   19.203387] lo: Disabled Privacy Extensions
[   29.299688] tuner' 3-0064: tuner type not set
[   29.307835] tuner' 3-0064: tuner type not set
[   32.729350] mtrr: base(0xf7000000) is not aligned on a size(0xe00000)
boundary
[   34.762892] NET: Registered protocol family 17
[   44.712012] eth0: no IPv6 routers present


This made me think that I should go out and find v4l-cx23885-avcore-01.fw.
I found it at http://www.steventoth.net/linux/hvr1800/

I loaded this firmware too.  New results:
[   11.087605] cx23885 driver version 0.0.1 loaded
[   11.088234] ACPI: PCI Interrupt Link [APC6] enabled at IRQ 16
[   11.088237] cx23885 0000:08:00.0: PCI INT A -> Link[APC6] -> GSI 16
(level, low) -> IRQ 16
[   11.088311] CORE cx23885[0]: subsystem: 18ac:d618, board: Hauppauge
WinTV-HVR1500 [card=6,insmod option]
[   11.196069] cx23885[0]: i2c bus 0 registered
[   11.196109] cx23885[0]: i2c bus 1 registered
[   11.196144] cx23885[0]: i2c bus 2 registered
[   11.222543] tveeprom 2-0050: Encountered bad packet header [ff]. Corrupt
or not a Hauppauge eeprom.
[   11.222545] cx23885[0]: warning: unknown hauppauge model #0
[   11.222546] cx23885[0]: hauppauge eeprom: model=0
[   11.232371] cx25840' 4-0044: cx25  0-21 found @ 0x88 (cx23885[0])
[   11.245763] tuner' 2-0064: chip found @ 0xc8 (cx23885[0])
[   11.248348] tuner' 3-0064: chip found @ 0xc8 (cx23885[0])
[   11.250432] cx23885[0]/0: registered device video0 [v4l2]
[   11.250696] cx23885[0]/1: registered ALSA audio device
[   11.250700] tuner' 3-0064: tuner type not set
[   11.254199] firmware: requesting v4l-cx23885-avcore-01.fw
[   11.876323] cx25840' 4-0044: loaded v4l-cx23885-avcore-01.fw firmware
(16382 bytes)
[   11.890444] cx23885[0]: cx23885 based dvb card
[   11.920769] cx23885[0]: frontend initialization failed
[   11.920771] cx23885_dvb_register() dvb_register failed err = -1
[   11.920773] cx23885_dev_setup() Failed to register dvb on VID_C
[   11.920777] cx23885_dev_checkrevision() Hardware revision = 0xb0
[   11.920783] cx23885[0]/0: found at 0000:08:00.0, rev: 2, irq: 16,
latency: 0, mmio: 0xfd800000
[   11.920788] cx23885 0000:08:00.0: setting latency timer to 64
[   11.921128] ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 22
[   11.921132] HDA Intel 0000:00:10.1: PCI INT B -> Link[AAZA] -> GSI 22
(level, low) -> IRQ 22
[   11.921147] HDA Intel 0000:00:10.1: setting latency timer to 64
[   11.954833] hda_codec: Unknown model for ALC883, trying auto-probe from
BIOS...
[   13.052435] lp0: using parport0 (interrupt-driven).
[   13.323879] Adding 6040400k swap on /dev/sda5.  Priority:-1 extents:1
across:6040400k
[   14.006491] EXT3 FS on sda1, internal journal
[   15.167174] type=1505 audit(1221184067.272:2): operation="profile_load"
name="/usr/sbin/mysqld" name2="default" pid=4590
[   15.334061] ip_tables: (C) 2000-2006 Netfilter Core Team
[   16.444201] ACPI: WMI: Mapper loaded
[   19.463314] warning: `avahi-daemon' uses 32-bit capabilities (legacy
support in use)
[   20.171391] NET: Registered protocol family 10
[   20.171801] lo: Disabled Privacy Extensions
[   29.432385] tuner' 3-0064: tuner type not set
[   29.440692] tuner' 3-0064: tuner type not set
[   34.560243] NET: Registered protocol family 17
[   44.123339] mtrr: base(0xf7000000) is not aligned on a size(0xe00000)
boundary
[   45.156509] eth0: no IPv6 routers present

I feel like I am getting closer, but I still cannot tune channels.  Any help
would be appreciated.


-- 
--Tim

------=_Part_94675_15038715.1221184280667
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr"><div>Brief summary: &nbsp;Trying to get analog working on a DViCO FusionHDTV7 Dual Express</div><div>It was suggested that I use the ~stoth/cx23885-audio branch and load the card as a HVR1500.</div><div><br></div>


<div>Since nothing was working, I decided to update to the latest kernel (and therefore mythbuntu 8.1)</div><div>Although the card still didn&#39;t work, I was getting better results. &nbsp;dmesg said</div><div><br></div><div>


[ &nbsp; 11.224568] cx23885[0]: i2c bus 0 registered</div><div>[ &nbsp; 11.224609] cx23885[0]: i2c bus 1 registered</div><div>[ &nbsp; 11.224632] cx23885[0]: i2c bus 2 registered</div><div>[ &nbsp; 11.251024] tveeprom 2-0050: Encountered bad packet header [ff]. Corrupt or not a Hauppauge eeprom.</div>


<div>[ &nbsp; 11.251026] cx23885[0]: warning: unknown hauppauge model #0</div><div>[ &nbsp; 11.251027] cx23885[0]: hauppauge eeprom: model=0</div><div>[ &nbsp; 11.268639] cx25840&#39; 4-0044: cx25 &nbsp;0-21 found @ 0x88 (cx23885[0])</div><div>


[ &nbsp; 11.283305] tuner&#39; 2-0064: chip found @ 0xc8 (cx23885[0])</div><div>[ &nbsp; 11.285887] tuner&#39; 3-0064: chip found @ 0xc8 (cx23885[0])</div><div>[ &nbsp; 11.288377] cx23885[0]/0: registered device video0 [v4l2]</div><div>


[ &nbsp; 11.288653] cx23885[0]/1: registered ALSA audio device</div><div>[ &nbsp; 11.288658] tuner&#39; 3-0064: tuner type not set</div><div>[ &nbsp; 11.292131] firmware: requesting v4l-cx23885-avcore-01.fw</div><div>[ &nbsp; 11.310299] cx25840&#39; 4-0044: unable to open firmware v4l-cx23885-avcore-01.fw</div>


<div>[ &nbsp; 11.324551] cx23885[0]: cx23885 based dvb card</div><div>[ &nbsp; 11.348947] cx23885[0]: frontend initialization failed</div><div>[ &nbsp; 11.348949] cx23885_dvb_register() dvb_register failed err = -1</div><div>[ &nbsp; 11.348951] cx23885_dev_setup() Failed to register dvb on VID_C</div>


<div>[ &nbsp; 11.348955] cx23885_dev_checkrevision() Hardware revision = 0xb0</div><div>[ &nbsp; 11.348960] cx23885[0]/0: found at 0000:08:00.0, rev: 2, irq: 16, latency: 0, mmio: 0xfd800000</div><div>[ &nbsp; 11.348966] cx23885 0000:08:00.0: setting latency timer to 64</div>


<div><div>[ &nbsp; 11.349304] ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 22</div><div>[ &nbsp; 11.349308] HDA Intel 0000:00:10.1: PCI INT B -&gt; Link[AAZA] -&gt; GSI 22 (level, low) -&gt; IRQ 22</div><div>[ &nbsp; 11.349322] HDA Intel 0000:00:10.1: setting latency timer to 64</div>


<div>[ &nbsp; 11.382833] hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...</div><div>[ &nbsp; 12.055790] lp0: using parport0 (interrupt-driven).</div><div>[ &nbsp; 12.326401] Adding 6040400k swap on /dev/sda5. &nbsp;Priority:-1 extents:1 across:6040400k</div>


<div>[ &nbsp; 13.009799] EXT3 FS on sda1, internal journal</div><div>[ &nbsp; 14.162071] type=1505 audit(1221183219.263:2): operation=&quot;profile_load&quot; name=&quot;/usr/sbin/mysqld&quot; name2=&quot;default&quot; pid=4549</div>


<div>[ &nbsp; 14.370696] ip_tables: (C) 2000-2006 Netfilter Core Team</div><div>[ &nbsp; 15.464191] ACPI: WMI: Mapper loaded</div><div>[ &nbsp; 18.424988] warning: `avahi-daemon&#39; uses 32-bit capabilities (legacy support in use)</div>


<div>[ &nbsp; 19.203038] NET: Registered protocol family 10</div><div>[ &nbsp; 19.203387] lo: Disabled Privacy Extensions</div><div>[ &nbsp; 29.299688] tuner&#39; 3-0064: tuner type not set</div><div>[ &nbsp; 29.307835] tuner&#39; 3-0064: tuner type not set</div>


<div>[ &nbsp; 32.729350] mtrr: base(0xf7000000) is not aligned on a size(0xe00000) boundary</div><div>[ &nbsp; 34.762892] NET: Registered protocol family 17</div><div>[ &nbsp; 44.712012] eth0: no IPv6 routers present</div><div><br></div>


</div><div><br></div><div>This made me think that I should go out and find&nbsp;v4l-cx23885-avcore-01.fw.</div><div>I found it at&nbsp;<a href="http://www.steventoth.net/linux/hvr1800/" target="_blank">http://www.steventoth.net/linux/hvr1800/</a></div>


<div><br></div><div>I loaded this firmware too. &nbsp;New results:</div><div><div>[ &nbsp; 11.087605] cx23885 driver version 0.0.1 loaded</div><div>[ &nbsp; 11.088234] ACPI: PCI Interrupt Link [APC6] enabled at IRQ 16</div><div>[ &nbsp; 11.088237] cx23885 0000:08:00.0: PCI INT A -&gt; Link[APC6] -&gt; GSI 16 (level, low) -&gt; IRQ 16</div>

<div>[ &nbsp; 11.088311] CORE cx23885[0]: subsystem: 18ac:d618, board: Hauppauge WinTV-HVR1500 [card=6,insmod option]</div><div>[ &nbsp; 11.196069] cx23885[0]: i2c bus 0 registered</div><div>[ &nbsp; 11.196109] cx23885[0]: i2c bus 1 registered</div>

<div>[ &nbsp; 11.196144] cx23885[0]: i2c bus 2 registered</div><div>[ &nbsp; 11.222543] tveeprom 2-0050: Encountered bad packet header [ff]. Corrupt or not a Hauppauge eeprom.</div><div>[ &nbsp; 11.222545] cx23885[0]: warning: unknown hauppauge model #0</div>

<div>[ &nbsp; 11.222546] cx23885[0]: hauppauge eeprom: model=0</div><div>[ &nbsp; 11.232371] cx25840&#39; 4-0044: cx25 &nbsp;0-21 found @ 0x88 (cx23885[0])</div><div>[ &nbsp; 11.245763] tuner&#39; 2-0064: chip found @ 0xc8 (cx23885[0])</div>

<div>[ &nbsp; 11.248348] tuner&#39; 3-0064: chip found @ 0xc8 (cx23885[0])</div><div>[ &nbsp; 11.250432] cx23885[0]/0: registered device video0 [v4l2]</div><div>[ &nbsp; 11.250696] cx23885[0]/1: registered ALSA audio device</div><div>[ &nbsp; 11.250700] tuner&#39; 3-0064: tuner type not set</div>

<div>[ &nbsp; 11.254199] firmware: requesting v4l-cx23885-avcore-01.fw</div><div>[ &nbsp; 11.876323] cx25840&#39; 4-0044: loaded v4l-cx23885-avcore-01.fw firmware (16382 bytes)</div><div>[ &nbsp; 11.890444] cx23885[0]: cx23885 based dvb card</div>

<div><div>[ &nbsp; 11.920769] cx23885[0]: frontend initialization failed</div><div>[ &nbsp; 11.920771] cx23885_dvb_register() dvb_register failed err = -1</div><div>[ &nbsp; 11.920773] cx23885_dev_setup() Failed to register dvb on VID_C</div>

<div>[ &nbsp; 11.920777] cx23885_dev_checkrevision() Hardware revision = 0xb0</div><div>[ &nbsp; 11.920783] cx23885[0]/0: found at 0000:08:00.0, rev: 2, irq: 16, latency: 0, mmio: 0xfd800000</div><div>[ &nbsp; 11.920788] cx23885 0000:08:00.0: setting latency timer to 64</div>

<div>[ &nbsp; 11.921128] ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 22</div><div>[ &nbsp; 11.921132] HDA Intel 0000:00:10.1: PCI INT B -&gt; Link[AAZA] -&gt; GSI 22 (level, low) -&gt; IRQ 22</div><div>[ &nbsp; 11.921147] HDA Intel 0000:00:10.1: setting latency timer to 64</div>

<div>[ &nbsp; 11.954833] hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...</div><div>[ &nbsp; 13.052435] lp0: using parport0 (interrupt-driven).</div><div>[ &nbsp; 13.323879] Adding 6040400k swap on /dev/sda5. &nbsp;Priority:-1 extents:1 across:6040400k</div>

<div>[ &nbsp; 14.006491] EXT3 FS on sda1, internal journal</div><div>[ &nbsp; 15.167174] type=1505 audit(1221184067.272:2): operation=&quot;profile_load&quot; name=&quot;/usr/sbin/mysqld&quot; name2=&quot;default&quot; pid=4590</div>

<div>[ &nbsp; 15.334061] ip_tables: (C) 2000-2006 Netfilter Core Team</div><div>[ &nbsp; 16.444201] ACPI: WMI: Mapper loaded</div><div>[ &nbsp; 19.463314] warning: `avahi-daemon&#39; uses 32-bit capabilities (legacy support in use)</div>

<div>[ &nbsp; 20.171391] NET: Registered protocol family 10</div><div>[ &nbsp; 20.171801] lo: Disabled Privacy Extensions</div><div>[ &nbsp; 29.432385] tuner&#39; 3-0064: tuner type not set</div><div>[ &nbsp; 29.440692] tuner&#39; 3-0064: tuner type not set</div>

<div>[ &nbsp; 34.560243] NET: Registered protocol family 17</div><div>[ &nbsp; 44.123339] mtrr: base(0xf7000000) is not aligned on a size(0xe00000) boundary</div><div>[ &nbsp; 45.156509] eth0: no IPv6 routers present</div><div><br></div>

<div>I feel like I am getting closer, but I still cannot tune channels. &nbsp;Any help would be appreciated.</div></div></div><div><br></div><div><br></div>-- <br> --Tim<br>
</div>

------=_Part_94675_15038715.1221184280667--


--===============0700699760==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0700699760==--
