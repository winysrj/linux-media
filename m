Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <timf@iinet.net.au>) id 1Ja4YK-0001Re-IH
	for linux-dvb@linuxtv.org; Fri, 14 Mar 2008 08:42:14 +0100
From: timf <timf@iinet.net.au>
To: Hartmut Hackmann <hartmut.hackmann@t-online.de>,
	linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <47D1A65B.3080900@t-online.de>
References: <1204893775.10536.4.camel@ubuntu> <47D1A65B.3080900@t-online.de>
Date: Fri, 14 Mar 2008 16:41:57 +0900
Message-Id: <1205480517.5913.8.camel@ubuntu>
Mime-Version: 1.0
Subject: Re: [linux-dvb] Kworld DVB-T 210 - dvb tuning problem
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

On Fri, 2008-03-07 at 21:32 +0100, Hartmut Hackmann wrote:
> Hi, Tim
> 
> timf schrieb:
> > Hi Hartmut,
> > I noticed you had a bit to do with implementing this card.
> > 
> > With a fresh install of ubuntu 7.10 (kernel i386 2.6.22-14-generic),
> > the card is auto recognised as: Kworld DVB-T 210 (card=114)
> > 
> > However, tda1004 firmware does not load.
> > Used download-firmware, placed dvb-fe-tda10046.fw
> > into /lib/firmware/2.6.22-14-generic
> > 
> > Rebooted.
> > 
> > Now, again card is recognised, firmware recognised as version 20.
> > Here is the strange part:
> > - using dvb-utils scan, each time I run that I get a different result in
> > channels.
> > - I try to scan with Kaffeine - nothing
> > - I try to scan with Me-tv - nothing
> > - I try to scan with tvtime - all channels obtained ( no audio).
> > 
> > Now, after reboot, if I first start tvtime (analog tv), view a channel,
> > turn tvtime off, and then :
> > - if I place a previously good channels.dvb in Kaffeine - it plays all
> > channels.
> > - if I place a previously good channels.conf in Me-tv - it plays all
> > channels. 
> > 
> > Would it be correct to say that the "switch" is not working for DVB
> > after boot?
> > 
> > I have studied the code, but I need your help to point me in the right
> > direction.
> > 
> > Thanks,
> > Tim
> > 
> Hermann reported something similar. I have an idea what the reason could
> be. Please let me check.
> Best regards
>   Hartmut

Hi Hartmut,

Further to this, is the Remote Control meant to work for this card?

lsmod
<snip>
videobuf_core          19460  3 videobuf_dvb,saa7134,videobuf_dma_sg
snd_seq_midi_event      8448  2 snd_seq_oss,snd_seq_midi
ir_kbd_i2c             11280  1 saa7134
ir_common              38404  2 saa7134,ir_kbd_i2c
nvidia               6221648  24 
snd_seq                53232  6
snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event
snd_timer              24324  2 snd_pcm,snd_seq
snd_seq_device          9228  5
snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq
tveeprom               13572  1 saa7134
sky2                   46852  0 
parport_pc             37412  1 
parport                37448  3 ppdev,lp,parport_pc
i2c_core               26112  18
tda1004x,saa7134_dvb,tuner,tea5767,tda8290,tda18271,tda827x,tuner_xc2028,xc5000,tda9887,tuner_simple,mt20xx,tea5761,saa7134,v4l2_common,ir_kbd_i2c,nvidia,tveeprom
psmouse                39952  0 
pcspkr                  4224  0 
<snip>

timf@ubuntu:~$ sudo cat /proc/bus/input/devices
[sudo] password for timf:
I: Bus=0017 Vendor=0001 Product=0001 Version=0100
N: Name="Macintosh mouse button emulation"
P: Phys=
S: Sysfs=/class/input/input0
U: Uniq=
H: Handlers=mouse0 event0 
B: EV=7
B: KEY=70000 0 0 0 0 0 0 0 0
B: REL=3

I: Bus=0011 Vendor=0001 Product=0001 Version=ab41
N: Name="AT Translated Set 2 keyboard"
P: Phys=isa0060/serio0/input0
S: Sysfs=/class/input/input1
U: Uniq=
H: Handlers=kbd event1 
B: EV=120013
B: KEY=4 2000000 3802078 f840d001 feffffdf ffefffff ffffffff fffffffe
B: MSC=10
B: LED=7

I: Bus=0003 Vendor=045e Product=0040 Version=0110
N: Name="Microsoft Microsoft 3-Button Mouse with IntelliEye(TM)"
P: Phys=usb-0000:00:1a.2-2/input0
S: Sysfs=/class/input/input2
U: Uniq=
H: Handlers=mouse1 event2 
B: EV=7
B: KEY=70000 0 0 0 0 0 0 0 0
B: REL=103

I: Bus=0010 Vendor=001f Product=0001 Version=0100
N: Name="PC Speaker"
P: Phys=isa0061/input0
S: Sysfs=/class/input/input3
U: Uniq=
H: Handlers=kbd event3 
B: EV=40001
B: SND=6

I: Bus=0019 Vendor=0000 Product=0002 Version=0000
N: Name="Power Button (FF)"
P: Phys=button_power/button/input0
S: Sysfs=/class/input/input4
U: Uniq=
H: Handlers=kbd event4 
B: EV=3
B: KEY=100000 0 0 0

I: Bus=0019 Vendor=0000 Product=0001 Version=0000
N: Name="Power Button (CM)"
P: Phys=PNP0C0C/button/input0
S: Sysfs=/class/input/input5
U: Uniq=
H: Handlers=kbd event5 
B: EV=3
B: KEY=100000 0 0 0

Regards,
Tim

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
