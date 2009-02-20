Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-bw0-f176.google.com ([209.85.218.176])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <threnard@gmail.com>) id 1LadMc-0001eV-5x
	for linux-dvb@linuxtv.org; Fri, 20 Feb 2009 22:56:56 +0100
Received: by bwz24 with SMTP id 24so2943446bwz.17
	for <linux-dvb@linuxtv.org>; Fri, 20 Feb 2009 13:56:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <499DBDCD.20408@iki.fi>
References: <499DB335.50807@laposte.net> <499DBDCD.20408@iki.fi>
Date: Fri, 20 Feb 2009 22:56:20 +0100
Message-ID: <7a3c9e3d0902201356v5ef498c9x9dfd3fd02b0547e5@mail.gmail.com>
From: Thomas RENARD <threnard@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Can I use AVerTV Volar Black HD (A850) with Linux ?
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1582620913=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1582620913==
Content-Type: multipart/alternative; boundary=001636c5bfb51d0131046360b939

--001636c5bfb51d0131046360b939
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello,

What I tried :

sudo apt-get install dvb-utils

Get
http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/4.95.0/dvb-usb-af9015.fw
sudo mv dvb-usb-af9015.fw  /lib/firmware/

Get http://linuxtv.org/hg/~anttip/af9015_aver_a850/archive/tip.tar.gz
In the directory :
sudo make
sudo make install

Add dvb-usb-af9015 to /etc/modules

Reboot

Plug the card



Some results :

thomas@trubuntu:~$ lsmod | grep dvb
dvb_usb_af9015         32672  0
dvb_usb                27660  1 dvb_usb_af9015
dvb_core               94336  1 dvb_usb
i2c_core               31892  6
dvb_usb_af9015,dvb_usb,eeprom,asb100,nvidia,i2c_nforce2
usbcore               149360  5 dvb_usb_af9015,dvb_usb,ohci_hcd,ehci_hcd

thomas@trubuntu:~$ dmesg | grep dvb
[   24.923217] usbcore: registered new interface driver dvb_usb_af9015

thomas@trubuntu:~$ less /var/log/messages
Feb 20 22:38:25 trubuntu kernel: [  327.984028] usb 3-6: new high speed USB
device using ehci_hcd and address 3
Feb 20 22:38:25 trubuntu kernel: [  328.150333] usb 3-6: configuration #1
chosen from 1 choice

thomas@trubuntu:~$ modprobe -l | grep dvb
/lib/modules/2.6.27-11-generic/kernel/drivers/media/video/videobuf-dvb.ko
/lib/modules/2.6.27-11-generic/kernel/drivers/media/video/saa7134/saa7134-dvb.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/video/em28xx/em28xx-dvb.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/video/cx88/cx88-dvb.ko
/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/ttusb-dec/ttusb_dec.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/ttusb-dec/ttusbdecfe.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dm1105/dm1105.ko
/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/ttpci/ttpci-eeprom.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/ttpci/budget.ko
/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/ttpci/budget-patch.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/ttpci/budget-core.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/ttpci/budget-ci.ko
/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/ttpci/budget-av.ko
/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/ttpci/dvb-ttpci.ko
/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/siano/sms1xxx.ko
/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/pluto2/pluto2.ko
/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/af9013.ko
/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/cx24113.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/stb0899.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/tda8261.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/cx24116.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/lgdt3304.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/stb6000.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/dvb_dummy_fe.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/stb6100.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/lgs8gl5.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/s921.ko
/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/stv0288.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/zl10353.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/ves1x93.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/ves1820.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/tua6100.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/tda826x.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/tda8083.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/tda10086.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/tda1004x.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/tda10048.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/tda10023.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/tda10021.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/stv0299.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/stv0297.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/sp887x.ko
/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/sp8870.ko
/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/s5h1420.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/si21xx.ko
/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/s5h1409.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/or51211.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/or51132.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/s5h1411.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/nxt200x.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/mt352.ko
/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/mt312.ko
/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/lnbp21.ko
/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/lgdt330x.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/l64781.ko
/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/itd1000.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/isl6421.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/isl6405.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/dvb-pll.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/drx397xD.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/nxt6000.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/dib7000p.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/dib7000m.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/dib3000mc.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/dibx000_common.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/dib0070.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/cx24123.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/cx24110.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/cx22702.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/cx22700.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/bcm3510.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/au8522.ko
/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/dib3000mb.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb-cinergyT2.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb-af9015.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb.ko
/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb-vp7045.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb-vp702x.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb-umt-010.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb-ttusb2.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb-opera.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb-nova-t-usb2.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb-m920x.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb-gp8psk.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb-gl861.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb-dw2102.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb-dtt200u.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb-digitv.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb-dibusb-mc.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb-dibusb-mb.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb-dtv5100.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb-dib0700.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb-cxusb.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb-au6610.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb-anysee.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb-af9005.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb-dibusb-common.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb-a800.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb-af9005-remote.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-core/dvb-core.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/bt8xx/dst_ca.ko
/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/bt8xx/dst.ko
/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/bt8xx/bt878.ko
/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/bt8xx/dvb-bt8xx.ko
/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/b2c2/b2c2-flexcop-usb.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/b2c2/b2c2-flexcop.ko

/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/b2c2/b2c2-flexcop-pci.ko


The card doesn't work ? Can you help me ? What is the next step ?
Thanks,
Regards,

Thomas


2009/2/19 Antti Palosaari <crope@iki.fi>

> Thomas RENARD wrote:
>
>> I bought this USB card : AVerTV Volar Black HD (A850) -
>> http://www.avermedia.com/avertv/Product/ProductDetail.aspx?Id=460&tab=APDriver
>> .
>> I don't find anything relevant about using this card on linux.
>>
>> Can I use this card on Linux ? How ?
>>
>> Here is some information :
>>
>
> Looks like AF9015 or AF9035. Could you test whether this driver will tell
> more?
> http://linuxtv.org/hg/~anttip/af9015_aver_a850/<http://linuxtv.org/hg/%7Eanttip/af9015_aver_a850/>
>
> http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/4.95.0/<http://www.otit.fi/%7Ecrope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/4.95.0/>
>
> regards
> Antti
> --
> http://palosaari.fi/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--001636c5bfb51d0131046360b939
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div class=3D"gmail_quote">Hello,<br><br>What I tried :<br><br>sudo apt-get=
 install dvb-utils<br><br>Get <a href=3D"http://www.otit.fi/~crope/v4l-dvb/=
af9015/af9015_firmware_cutter/firmware_files/4.95.0/dvb-usb-af9015.fw">http=
://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/=
4.95.0/dvb-usb-af9015.fw</a><br>
sudo mv dvb-usb-af9015.fw&nbsp; /lib/firmware/<br><br>Get <a href=3D"http:/=
/linuxtv.org/hg/~anttip/af9015_aver_a850/archive/tip.tar.gz">http://linuxtv=
.org/hg/~anttip/af9015_aver_a850/archive/tip.tar.gz</a><br>In the directory=
 :<br>
sudo make<br>sudo make install<br><br>Add dvb-usb-af9015 to /etc/modules<br=
><br>Reboot<br><br>Plug the card<br><br><br><br>Some results :<br><br>thoma=
s@trubuntu:~$ lsmod | grep dvb
<br>dvb_usb_af9015&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 32672&nb=
sp; 0&nbsp;
<br>dvb_usb&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp; 27660&nbsp; 1 dvb_usb_af9015
<br>dvb_core&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp; 94336&nbsp; 1 dvb_usb
<br>i2c_core&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp; 31892&nbsp; 6 dvb_usb_af9015,dvb_usb,eeprom,asb100,nv=
idia,i2c_nforce2
<br>usbcore&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; 149360&nbsp; 5 dvb_usb_af9015,dvb_usb,ohci_hcd,ehci_hc=
d
<br><br>thomas@trubuntu:~$ dmesg | grep dvb
<br>[&nbsp;&nbsp; 24.923217] usbcore: registered new interface driver dvb_u=
sb_af9015
<br><br>thomas@trubuntu:~$ less /var/log/messages<br>Feb 20 22:38:25 trubun=
tu kernel: [&nbsp; 327.984028] usb 3-6: new high speed USB device using ehc=
i_hcd and address 3
<br>Feb 20 22:38:25 trubuntu kernel: [&nbsp; 328.150333] usb 3-6: configura=
tion #1 chosen from 1 choice
<br><br>thomas@trubuntu:~$ modprobe -l | grep dvb
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/video/videobuf-dvb.=
ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/video/saa7134/saa71=
34-dvb.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/video/em28xx/em28xx=
-dvb.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/video/cx88/cx88-dvb=
.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/ttusb-dec/ttusb=
_dec.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/ttusb-dec/ttusb=
decfe.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dm1105/dm1105.k=
o
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/ttpci/ttpci-eep=
rom.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/ttpci/budget.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/ttpci/budget-pa=
tch.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/ttpci/budget-co=
re.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/ttpci/budget-ci=
.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/ttpci/budget-av=
.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/ttpci/dvb-ttpci=
.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/siano/sms1xxx.k=
o
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/pluto2/pluto2.k=
o
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/af901=
3.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/cx241=
13.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/stb08=
99.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/tda82=
61.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/cx241=
16.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/lgdt3=
304.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/stb60=
00.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/dvb_d=
ummy_fe.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/stb61=
00.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/lgs8g=
l5.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/s921.=
ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/stv02=
88.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/zl103=
53.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/ves1x=
93.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/ves18=
20.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/tua61=
00.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/tda82=
6x.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/tda80=
83.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/tda10=
086.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/tda10=
04x.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/tda10=
048.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/tda10=
023.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/tda10=
021.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/stv02=
99.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/stv02=
97.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/sp887=
x.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/sp887=
0.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/s5h14=
20.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/si21x=
x.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/s5h14=
09.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/or512=
11.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/or511=
32.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/s5h14=
11.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/nxt20=
0x.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/mt352=
.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/mt312=
.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/lnbp2=
1.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/lgdt3=
30x.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/l6478=
1.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/itd10=
00.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/isl64=
21.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/isl64=
05.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/dvb-p=
ll.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/drx39=
7xD.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/nxt60=
00.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/dib70=
00p.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/dib70=
00m.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/dib30=
00mc.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/dibx0=
00_common.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/dib00=
70.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/cx241=
23.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/cx241=
10.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/cx227=
02.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/cx227=
00.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/bcm35=
10.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/au852=
2.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/frontends/dib30=
00mb.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb=
-cinergyT2.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb=
-af9015.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb=
.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb=
-vp7045.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb=
-vp702x.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb=
-umt-010.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb=
-ttusb2.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb=
-opera.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb=
-nova-t-usb2.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb=
-m920x.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb=
-gp8psk.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb=
-gl861.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb=
-dw2102.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb=
-dtt200u.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb=
-digitv.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb=
-dibusb-mc.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb=
-dibusb-mb.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb=
-dtv5100.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb=
-dib0700.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb=
-cxusb.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb=
-au6610.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb=
-anysee.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb=
-af9005.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb=
-dibusb-common.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb=
-a800.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb=
-af9005-remote.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/dvb-core/dvb-co=
re.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/ttusb-budget/dv=
b-ttusb-budget.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/bt8xx/dst_ca.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/bt8xx/dst.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/bt8xx/bt878.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/bt8xx/dvb-bt8xx=
.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/b2c2/b2c2-flexc=
op-usb.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/b2c2/b2c2-flexc=
op.ko
<br>/lib/modules/2.6.27-11-generic/kernel/drivers/media/dvb/b2c2/b2c2-flexc=
op-pci.ko<br><br><br>The card doesn&#39;t work ? Can you help me ? What is =
the next step ?<br>Thanks,<br>Regards,<br><br>Thomas<br><br><br>2009/2/19 A=
ntti Palosaari <span dir=3D"ltr">&lt;<a href=3D"mailto:crope@iki.fi" target=
=3D"_blank">crope@iki.fi</a>&gt;</span><br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div>Thomas RENARD wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
I bought this USB card : AVerTV Volar Black HD (A850) - <a href=3D"http://w=
ww.avermedia.com/avertv/Product/ProductDetail.aspx?Id=3D460&amp;tab=3DAPDri=
ver" target=3D"_blank">http://www.avermedia.com/avertv/Product/ProductDetai=
l.aspx?Id=3D460&amp;tab=3DAPDriver</a>.<br>


I don&#39;t find anything relevant about using this card on linux.<br>
<br>
Can I use this card on Linux ? How ?<br>
<br>
Here is some information :<br>
</blockquote>
<br></div>
Looks like AF9015 or AF9035. Could you test whether this driver will tell m=
ore?<br>
<a href=3D"http://linuxtv.org/hg/%7Eanttip/af9015_aver_a850/" target=3D"_bl=
ank">http://linuxtv.org/hg/~anttip/af9015_aver_a850/</a><br>
<a href=3D"http://www.otit.fi/%7Ecrope/v4l-dvb/af9015/af9015_firmware_cutte=
r/firmware_files/4.95.0/" target=3D"_blank">http://www.otit.fi/~crope/v4l-d=
vb/af9015/af9015_firmware_cutter/firmware_files/4.95.0/</a><br>
<br>
regards<br>
Antti<br>
-- <br>
<a href=3D"http://palosaari.fi/" target=3D"_blank">http://palosaari.fi/</a>=
<br><font color=3D"#888888">
--<br>
To unsubscribe from this list: send the line &quot;unsubscribe linux-media&=
quot; in<br>
the body of a message to <a href=3D"mailto:majordomo@vger.kernel.org" targe=
t=3D"_blank">majordomo@vger.kernel.org</a><br>
More majordomo info at &nbsp;<a href=3D"http://vger.kernel.org/majordomo-in=
fo.html" target=3D"_blank">http://vger.kernel.org/majordomo-info.html</a><b=
r>
</font></blockquote></div><br><br>

--001636c5bfb51d0131046360b939--


--===============1582620913==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1582620913==--
