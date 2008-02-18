Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.158])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eduardhc@gmail.com>) id 1JR4Ff-00032I-9T
	for linux-dvb@linuxtv.org; Mon, 18 Feb 2008 12:33:39 +0100
Received: by fg-out-1718.google.com with SMTP id 22so1302646fge.25
	for <linux-dvb@linuxtv.org>; Mon, 18 Feb 2008 03:33:35 -0800 (PST)
Message-ID: <47B96BF2.3070401@gmail.com>
Date: Mon, 18 Feb 2008 12:28:50 +0100
From: Eduard Huguet <eduardhc@gmail.com>
MIME-Version: 1.0
To: Matthias Schwarzott <zzam@gentoo.org>
References: <47ADC81B.4050203@gmail.com> <200802131651.17260.zzam@gentoo.org>	
	<47B314B8.7060403@gmail.com> <200802172040.57892.zzam@gentoo.org>
In-Reply-To: <200802172040.57892.zzam@gentoo.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Some tests on Avermedia A700
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1620276332=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============1620276332==
Content-Type: multipart/alternative;
 boundary="------------080802090904040108090306"

This is a multi-part message in MIME format.
--------------080802090904040108090306
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



2008/2/17, Matthias Schwarzott <zzam@gentoo.org <mailto:zzam@gentoo.org>>:

    On Mittwoch, 13. Februar 2008, Eduard Huguet wrote:
     >
     > OK, I don't know exactly what you mean, but I'll try to measure the
     > output voltage of the input connector. I think you mean this,
    don't you?
     >
     > BTW, ¿where is the set_voltage app? I have media-tv/linuxtv-dvb-apps
     > package installed and there is nothing with that name...
     >

    Another thing you can try is:
    Boot windows and look at the GPIO values. (See v4l wiki for how to
    do this
    using regspy).

    Use my latest diff, and try loading saa7134 with use_frontend=1 to
    use the
    alternative zl10313 driver.

    Regards
    Matthias

    --
    Matthias Schwarzott (zzam)




Hi,
    I've tried regspy (and regmon from sysinternals), but I really 
haven't found anything relevant. ¿What exactly should I look for? The 
V4L wiki is not very clear about it...

Anyway, I also tried the use_frontend=1 option for saa7134-dvb and I got 
more or less the same results:

$ dvbscan /usr/share/dvb/dvb-s/Astra-19.2E
scanning /usr/share/dvb/dvb-s/Astra-19.2E
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 12551500 V 22000000 5
> >> tune to: 12551:v:0:22000
DVB-S IF freq is 1951500
WARNING: >>> tuning failed!!!
> >> tune to: 12551:v:0:22000 (tuning failed)
DVB-S IF freq is 1951500
WARNING: >>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)
Done.

The only difference with this frontend is that in Kaffeine I'm getting 
now a 0% signal level and a 99% SNR level. No idea why...

BTW, I've checked again the dmesg output of modprobe saa7134 after a 
cold boot (full power cycle: powering off, unplugged power cord and 
pressed power button to ensure the capacitors are emptied, so there is 
absolutely no remanent voltage in the motherboard...), and this is what 
I get:

[  116.429358] saa7130/34: v4l2 driver version 0.2.14 loaded
[  116.431261] ACPI: PCI Interrupt 0000:00:09.0[A] -> GSI 17 (level, 
low) -> IRQ 23
[  116.431369] saa7133[0]: found at 0000:00:09.0, rev: 209, irq: 23, 
latency: 64, mmio: 0xf7ffa800
[  116.431435] saa7133[0]: subsystem: 1461:a7a1, board: Avermedia DVB-S 
Pro A700 [card=133,autodetected]
[  116.431519] saa7133[0]: board init: gpio is *202f600*
[  116.696295] saa7133[0]: i2c eeprom 00: 61 14 a1 a7 ff ff ff ff ff ff 
ff ff ff ff ff ff
[  116.696321] saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  116.696358] saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  116.696372] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  116.696386] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  116.696400] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  116.696415] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  116.696429] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  116.696443] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  116.696456] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  116.696469] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  116.696482] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  116.696498] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  116.696513] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  116.696535] saa7133[0]: i2c eeprom e0: *00 01 81 af ea b5* ff ff ff 
ff ff ff ff ff ff ff
[  116.696557] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  116.700280] saa7133[0]: i2c scan: found device @ 0x1c  [???]
[  116.713245] saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
[  116.723550] saa7133[0]: registered device video0 [v4l2]
[  116.725685] saa7133[0]: registered device vbi0
[  117.256803] demodulator: zl10313: Demodulator attached @ i2c address 0x0e
[  117.284726] zl1003x: zl1003x: Power-On-Reset bit enabled - may need 
to reinitialize tuner
[  117.284743] zl1003x: zl10036_init_regs
[  117.302667] zl1003x_attach: tuner initialization (Zarlink ZL10036 
addr=0x60) ok
[  117.302687] DVB: registering new adapter (saa7133[0])
[  117.302719] DVB: registering frontend 0 (Zarlink ZL10313 DVB-S)...
[  117.335612] zl1003x: zl1003x_sleep


As you can see, the initial gpio value is different from what is listed 
in the wiki for my card (2f200). Also the contents of the eeprom are 
also different, and surprisingly matches the ones listed for the hybrid 
version. I suppose that this is mistake in the wiki entry, as I can 
assure you that my card is the standard DVB-S Pro...

Best regards,
  Eduard






--------------080802090904040108090306
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
</head>
<body bgcolor="#ffffff" text="#000000">
<br>
<br>
<div><span class="gmail_quote">2008/2/17, Matthias Schwarzott &lt;<a
 href="mailto:zzam@gentoo.org">zzam@gentoo.org</a>&gt;:</span>
<blockquote class="gmail_quote"
 style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">On
Mittwoch, 13. Februar 2008, Eduard Huguet wrote:<br>
&gt;<br>
&gt; OK, I don't know exactly what you mean, but I'll try to measure the<br>
&gt; output voltage of the input connector. I think you mean this,
don't you?<br>
&gt;<br>
&gt; BTW, ¿where is the set_voltage app? I have
media-tv/linuxtv-dvb-apps<br>
&gt; package installed and there is nothing with that name...<br>
&gt;<br>
  <br>
Another thing you can try is:<br>
Boot windows and look at the GPIO values. (See v4l wiki for how to do
this<br>
using regspy).<br>
  <br>
Use my latest diff, and try loading saa7134 with use_frontend=1 to use
the<br>
alternative zl10313 driver.<br>
  <br>
Regards<br>
Matthias<br>
  <br>
--<br>
Matthias Schwarzott (zzam)<br>
</blockquote>
</div>
<br>
<br>
<br>
Hi, <br>
    I've tried regspy (and regmon from sysinternals), but I really
haven't found anything relevant. ¿What exactly should I look for? The
V4L wiki is not very clear about it...<br>
<br>
Anyway, I also tried the use_frontend=1 option for saa7134-dvb and I
got more or less the same results:<br>
<br>
<tt><span style="font-family: courier new,monospace;">$ dvbscan
/usr/share/dvb/dvb-s/Astra-19.2E</span><br
 style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">scanning
/usr/share/dvb/dvb-s/Astra-19.2E</span><br
 style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">using
'/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'</span><br
 style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">initial transponder
12551500 V 22000000 5</span><br
 style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">&gt;&gt;&gt; tune to:
12551:v:0:22000</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">DVB-S IF freq is
1951500</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">WARNING: &gt;&gt;&gt;
tuning failed!!!</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">&gt;&gt;&gt; tune to:
12551:v:0:22000 (tuning failed)</span><br
 style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">DVB-S IF freq is
1951500</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">WARNING: &gt;&gt;&gt;
tuning failed!!!</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">ERROR: initial tuning
failed</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">dumping lists (0
services)</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">Done.</span><br
 style="font-family: courier new,monospace;">
</tt>
<br>
The only difference with this frontend is that in Kaffeine I'm getting
now a 0% signal level and a 99% SNR level. No idea why...<br>
<br>
BTW, I've checked again the dmesg output of modprobe saa7134 after a
cold boot (full power cycle: powering off, unplugged power cord and
pressed power button to ensure the capacitors are emptied, so there is
absolutely no remanent voltage in the motherboard...), and this is what
I get:<br>
<br>
<tt>[  116.429358] saa7130/34: v4l2 driver version 0.2.14 loaded<br>
[  116.431261] ACPI: PCI Interrupt 0000:00:09.0[A] -&gt; GSI 17 (level,
low) -&gt; IRQ 23<br>
[  116.431369] saa7133[0]: found at 0000:00:09.0, rev: 209, irq: 23,
latency: 64, mmio: 0xf7ffa800<br>
[  116.431435] saa7133[0]: subsystem: 1461:a7a1, board: Avermedia DVB-S
Pro A700 [card=133,autodetected]<br>
[  116.431519] saa7133[0]: board init: gpio is <b>202f600</b><br>
[  116.696295] saa7133[0]: i2c eeprom 00: 61 14 a1 a7 ff ff ff ff ff ff
ff ff ff ff ff ff<br>
[  116.696321] saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff<br>
[  116.696358] saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff<br>
[  116.696372] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff<br>
[  116.696386] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff<br>
[  116.696400] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff<br>
[  116.696415] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff<br>
[  116.696429] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff<br>
[  116.696443] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff<br>
[  116.696456] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff<br>
[  116.696469] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff<br>
[  116.696482] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff<br>
[  116.696498] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff<br>
[  116.696513] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff<br>
[  116.696535] saa7133[0]: i2c eeprom e0: <b>00 01 81 af ea b5</b> ff
ff ff ff ff ff ff ff ff ff<br>
[  116.696557] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff<br>
[  116.700280] saa7133[0]: i2c scan: found device @ 0x1c  [???]<br>
[  116.713245] saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]<br>
[  116.723550] saa7133[0]: registered device video0 [v4l2]<br>
[  116.725685] saa7133[0]: registered device vbi0<br>
[  117.256803] demodulator: zl10313: Demodulator attached @ i2c address
0x0e<br>
[  117.284726] zl1003x: zl1003x: Power-On-Reset bit enabled - may need
to reinitialize tuner<br>
[  117.284743] zl1003x: zl10036_init_regs<br>
[  117.302667] zl1003x_attach: tuner initialization (Zarlink ZL10036
addr=0x60) ok<br>
[  117.302687] DVB: registering new adapter (saa7133[0])<br>
[  117.302719] DVB: registering frontend 0 (Zarlink ZL10313 DVB-S)...<br>
[  117.335612] zl1003x: zl1003x_sleep<br>
</tt><br>
<br>
As you can see, the initial gpio value is different from what is listed
in the wiki for my card (2f200). Also the contents of the eeprom are
also different, and surprisingly matches the ones listed for the hybrid
version. I suppose that this is mistake in the wiki entry, as I can
assure you that my card is the standard DVB-S Pro...<br>
<br>
Best regards, <br>
  Eduard<br>
<br>
<br>
<br>
<br>
<br>
</body>
</html>

--------------080802090904040108090306--


--===============1620276332==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1620276332==--
