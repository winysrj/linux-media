Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from snt0-omc3-s15.snt0.hotmail.com ([65.55.90.154])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <n1gp@hotmail.com>) id 1MsIHq-0003UQ-Pc
	for linux-dvb@linuxtv.org; Mon, 28 Sep 2009 17:37:17 +0200
Message-ID: <SNT112-W2305BCEE9A08C59B9071F487D60@phx.gbl>
From: Richard Koch <n1gp@hotmail.com>
To: <linux-dvb@linuxtv.org>
Date: Mon, 28 Sep 2009 11:36:37 -0400
MIME-Version: 1.0
Subject: [linux-dvb] Need help w/ USB TV (TM6000) kernel Ooops
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1572034930=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1572034930==
Content-Type: multipart/alternative;
	boundary="_f09b2c69-8e8f-4570-990c-9492d59381e3_"

--_f09b2c69-8e8f-4570-990c-9492d59381e3_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


Hello=2C

I'm trying to bring up a USB TV Tuner I got from Geeks.com:

http://www.geeks.com/largePic_All.asp?InvtId=3DPCTV-PENDRIVETVTUNER&Pic=3DP=
CTV-PENDRIVETVTUNER-box.jpg

It's USB ID is  6000:0001

I grabbed the latest v4l-dvb as of 9/28/09=2C built=2C and tested getting a=
 kernel Ooops.
1st thing I see go wrong is the "Error -32 while retrieving board version" =
and then
reading all 00's from the eeprom.

Appreciate any input/suggestions

Below is the dmesg output:


tm6000 v4l2 driver version 0.0.1 loaded
tm6000: alt 0=2C interface 0=2C class 255
tm6000: alt 0=2C interface 0=2C class 255
tm6000: Bulk IN endpoint: 0x82 (max size=3D512 bytes)
tm6000: alt 1=2C interface 0=2C class 255
tm6000: ISOC IN endpoint: 0x81 (max size=3D3072 bytes)
tm6000: alt 1=2C interface 0=2C class 255
tm6000: alt 2=2C interface 0=2C class 255
tm6000: alt 2=2C interface 0=2C class 255
tm6000: New video device @ 480 Mbps (6000:0001=2C ifnum 0)
tm6000: Found 10Moons UT 821
Error -32 while retrieving board version
tm6000 #0: i2c eeprom 00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  =
................
tm6000 #0: i2c eeprom 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  =
................
tm6000 #0: i2c eeprom 20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  =
................
tm6000 #0: i2c eeprom 30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  =
................
tm6000 #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  =
................
tm6000 #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  =
................
tm6000 #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  =
................
tm6000 #0: i2c eeprom 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  =
................
tm6000 #0: i2c eeprom 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  =
................
tm6000 #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  =
................
tm6000 #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  =
................
tm6000 #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  =
................
tm6000 #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  =
................
tm6000 #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  =
................
tm6000 #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  =
................
tm6000 #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  =
................
  ................
Trident TVMaster TM5600/TM6000 USB2 board (Load status: 0)
tuner 4-0061: chip found @ 0xc2 (tm6000 #0)
Setting firmware parameters for xc2028
BUG: unable to handle kernel paging request at 253e343c
IP: [<253e343c>] 0x253e343c
*pde =3D 00000000
Oops: 0000 [#1]
last sysfs file: /sys/module/tuner/initstate
Modules linked in: tm6000(+) videobuf_vmalloc videobuf_core lgdt330x dvb_co=
re tuner_xc2028 tuner tvp5150 v4l2_common videodev v4l1_compat fuse hwmon_v=
id hwmon ipv6 cpufreq_ondemand acpi_cpufreq freq_table dm_mirror dm_region_=
hash dm_log dm_mod snd_intel8x0 snd_ac97_codec ac97_bus i915 snd_pcm snd_ti=
mer serio_raw iTCO_wdt snd iTCO_vendor_support ohci1394 i2c_i801 soundcore =
snd_page_alloc drm i2c_algo_bit i2c_core video output [last unloaded: tveep=
rom]

Pid: 31777=2C comm: modprobe Not tainted (2.6.31 #1)
EIP: 0060:[<253e343c>] EFLAGS: 00210206 CPU: 0
EIP is at 0x253e343c
EAX: eb89fa80 EBX: ce2dd800 ECX: 253e343c EDX: ccaf3e88
ESI: ccaf3e88 EDI: eb89fa80 EBP: ccaf3e9c ESP: ccaf3dd8
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process modprobe (pid: 31777=2C ti=3Dccaf2000 task=3Dce2e7230 task.ti=3Dcca=
f2000)
Stack:
 fbad7786 f71a8100 00000038 ce2ddad8 ce2ddae8 ce2ddadc ce2ddaec ce2ddae0
<0> ce2ddaf0 ce2ddae4 ce2ddaf4 cc990400 00000003 00000000 00000000 fbadb986
<0> 00000002 ce2dd858 ce2dda84 ce2dda80 ce2ddac8 ccaf3e3c da386a48 cca0d570
Call Trace:
 [<fbad7786>] ? tm6000_usb_probe+0x54e/0x6b8 [tm6000]
 [<c10b04f6>] ? iput+0x29/0x53
 [<c10df895>] ? sysfs_addrm_finish+0x51/0x176
 [<fbad70f3>] ? tm6000_tuner_callback+0x0/0x145 [tm6000]
 [<c1210944>] ? usb_probe_interface+0x100/0x149
 [<c11df72b>] ? driver_sysfs_add+0x38/0x53
 [<c11df826>] ? driver_probe_device+0x7d/0x108
 [<c11df8f9>] ? __driver_attach+0x48/0x64
 [<c11df259>] ? bus_for_each_dev+0x42/0x6c
 [<c11df6f1>] ? driver_attach+0x19/0x1b
 [<c11df8b1>] ? __driver_attach+0x0/0x64
 [<c11deca6>] ? bus_add_driver+0xa7/0x1ce
 [<c11dfb63>] ? driver_register+0x90/0xf0
 [<c121072a>] ? usb_register_driver+0x64/0xbe
 [<f87f1000>] ? tm6000_module_init+0x0/0x45 [tm6000]
 [<f87f1028>] ? tm6000_module_init+0x28/0x45 [tm6000]
 [<c1001138>] ? _stext+0x50/0x13a
 [<c104a56a>] ? sys_init_module+0xac/0x1bc
 [<c10029c8>] ? sysenter_do_call+0x12/0x27
Code:  Bad EIP value.
EIP: [<253e343c>] 0x253e343c SS:ESP 0068:ccaf3dd8
CR2: 00000000253e343c
---[ end trace aaed81f943beb724 ]---
tm6000: open called (minor=3D0)

 		 	   		  =

--_f09b2c69-8e8f-4570-990c-9492d59381e3_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<style><!--
.hmmessage P
{
margin:0px=3B
padding:0px
}
body.hmmessage
{
font-size: 10pt=3B
font-family:Verdana
}
--></style>
</head>
<body class=3D'hmmessage'>
Hello=2C<br><br>I'm trying to bring up a USB TV Tuner I got from Geeks.com:=
<br><br><a href=3D"http://www.geeks.com/largePic_All.asp?InvtId=3DPCTV-PEND=
RIVETVTUNER&amp=3BPic=3DPCTV-PENDRIVETVTUNER-box.jpg">http://www.geeks.com/=
largePic_All.asp?InvtId=3DPCTV-PENDRIVETVTUNER&amp=3BPic=3DPCTV-PENDRIVETVT=
UNER-box.jpg</a><br><br>It's USB ID is&nbsp=3B 6000:0001<br><br>I grabbed t=
he latest v4l-dvb as of 9/28/09=2C built=2C and tested getting a kernel Ooo=
ps.<br>1st thing I see go wrong is the "Error -32 while retrieving board ve=
rsion" and then<br>reading all 00's from the eeprom.<br><br>Appreciate any =
input/suggestions<br><br>Below is the dmesg output:<br><br><br>tm6000 v4l2 =
driver version 0.0.1 loaded<br>tm6000: alt 0=2C interface 0=2C class 255<br=
>tm6000: alt 0=2C interface 0=2C class 255<br>tm6000: Bulk IN endpoint: 0x8=
2 (max size=3D512 bytes)<br>tm6000: alt 1=2C interface 0=2C class 255<br>tm=
6000: ISOC IN endpoint: 0x81 (max size=3D3072 bytes)<br>tm6000: alt 1=2C in=
terface 0=2C class 255<br>tm6000: alt 2=2C interface 0=2C class 255<br>tm60=
00: alt 2=2C interface 0=2C class 255<br>tm6000: New video device @ 480 Mbp=
s (6000:0001=2C ifnum 0)<br>tm6000: Found 10Moons UT 821<br>Error -32 while=
 retrieving board version<br>tm6000 #0: i2c eeprom 00: 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00 00 00&nbsp=3B ................<br>tm6000 #0: i2c eepr=
om 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00&nbsp=3B ............=
....<br>tm6000 #0: i2c eeprom 20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00=
 00 00&nbsp=3B ................<br>tm6000 #0: i2c eeprom 30: 00 00 00 00 00=
 00 00 00 00 00 00 00 00 00 00 00&nbsp=3B ................<br>tm6000 #0: i2=
c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00&nbsp=3B ......=
..........<br>tm6000 #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00=
 00 00 00 00&nbsp=3B ................<br>tm6000 #0: i2c eeprom 60: 00 00 00=
 00 00 00 00 00 00 00 00 00 00 00 00 00&nbsp=3B ................<br>tm6000 =
#0: i2c eeprom 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00&nbsp=3B =
................<br>tm6000 #0: i2c eeprom 80: 00 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00&nbsp=3B ................<br>tm6000 #0: i2c eeprom 90: 00=
 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00&nbsp=3B ................<br>t=
m6000 #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00&nb=
sp=3B ................<br>tm6000 #0: i2c eeprom b0: 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00 00&nbsp=3B ................<br>tm6000 #0: i2c eeprom =
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00&nbsp=3B ...............=
.<br>tm6000 #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=
 00&nbsp=3B ................<br>tm6000 #0: i2c eeprom e0: 00 00 00 00 00 00=
 00 00 00 00 00 00 00 00 00 00&nbsp=3B ................<br>tm6000 #0: i2c e=
eprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00&nbsp=3B .........=
.......<br>&nbsp=3B ................<br>Trident TVMaster TM5600/TM6000 USB2=
 board (Load status: 0)<br>tuner 4-0061: chip found @ 0xc2 (tm6000 #0)<br>S=
etting firmware parameters for xc2028<br>BUG: unable to handle kernel pagin=
g request at 253e343c<br>IP: [&lt=3B253e343c&gt=3B] 0x253e343c<br>*pde =3D =
00000000<br>Oops: 0000 [#1]<br>last sysfs file: /sys/module/tuner/initstate=
<br>Modules linked in: tm6000(+) videobuf_vmalloc videobuf_core lgdt330x dv=
b_core tuner_xc2028 tuner tvp5150 v4l2_common videodev v4l1_compat fuse hwm=
on_vid hwmon ipv6 cpufreq_ondemand acpi_cpufreq freq_table dm_mirror dm_reg=
ion_hash dm_log dm_mod snd_intel8x0 snd_ac97_codec ac97_bus i915 snd_pcm sn=
d_timer serio_raw iTCO_wdt snd iTCO_vendor_support ohci1394 i2c_i801 soundc=
ore snd_page_alloc drm i2c_algo_bit i2c_core video output [last unloaded: t=
veeprom]<br><br>Pid: 31777=2C comm: modprobe Not tainted (2.6.31 #1)<br>EIP=
: 0060:[&lt=3B253e343c&gt=3B] EFLAGS: 00210206 CPU: 0<br>EIP is at 0x253e34=
3c<br>EAX: eb89fa80 EBX: ce2dd800 ECX: 253e343c EDX: ccaf3e88<br>ESI: ccaf3=
e88 EDI: eb89fa80 EBP: ccaf3e9c ESP: ccaf3dd8<br>&nbsp=3BDS: 007b ES: 007b =
FS: 0000 GS: 0033 SS: 0068<br>Process modprobe (pid: 31777=2C ti=3Dccaf2000=
 task=3Dce2e7230 task.ti=3Dccaf2000)<br>Stack:<br>&nbsp=3Bfbad7786 f71a8100=
 00000038 ce2ddad8 ce2ddae8 ce2ddadc ce2ddaec ce2ddae0<br>&lt=3B0&gt=3B ce2=
ddaf0 ce2ddae4 ce2ddaf4 cc990400 00000003 00000000 00000000 fbadb986<br>&lt=
=3B0&gt=3B 00000002 ce2dd858 ce2dda84 ce2dda80 ce2ddac8 ccaf3e3c da386a48 c=
ca0d570<br>Call Trace:<br>&nbsp=3B[&lt=3Bfbad7786&gt=3B] ? tm6000_usb_probe=
+0x54e/0x6b8 [tm6000]<br>&nbsp=3B[&lt=3Bc10b04f6&gt=3B] ? iput+0x29/0x53<br=
>&nbsp=3B[&lt=3Bc10df895&gt=3B] ? sysfs_addrm_finish+0x51/0x176<br>&nbsp=3B=
[&lt=3Bfbad70f3&gt=3B] ? tm6000_tuner_callback+0x0/0x145 [tm6000]<br>&nbsp=
=3B[&lt=3Bc1210944&gt=3B] ? usb_probe_interface+0x100/0x149<br>&nbsp=3B[&lt=
=3Bc11df72b&gt=3B] ? driver_sysfs_add+0x38/0x53<br>&nbsp=3B[&lt=3Bc11df826&=
gt=3B] ? driver_probe_device+0x7d/0x108<br>&nbsp=3B[&lt=3Bc11df8f9&gt=3B] ?=
 __driver_attach+0x48/0x64<br>&nbsp=3B[&lt=3Bc11df259&gt=3B] ? bus_for_each=
_dev+0x42/0x6c<br>&nbsp=3B[&lt=3Bc11df6f1&gt=3B] ? driver_attach+0x19/0x1b<=
br>&nbsp=3B[&lt=3Bc11df8b1&gt=3B] ? __driver_attach+0x0/0x64<br>&nbsp=3B[&l=
t=3Bc11deca6&gt=3B] ? bus_add_driver+0xa7/0x1ce<br>&nbsp=3B[&lt=3Bc11dfb63&=
gt=3B] ? driver_register+0x90/0xf0<br>&nbsp=3B[&lt=3Bc121072a&gt=3B] ? usb_=
register_driver+0x64/0xbe<br>&nbsp=3B[&lt=3Bf87f1000&gt=3B] ? tm6000_module=
_init+0x0/0x45 [tm6000]<br>&nbsp=3B[&lt=3Bf87f1028&gt=3B] ? tm6000_module_i=
nit+0x28/0x45 [tm6000]<br>&nbsp=3B[&lt=3Bc1001138&gt=3B] ? _stext+0x50/0x13=
a<br>&nbsp=3B[&lt=3Bc104a56a&gt=3B] ? sys_init_module+0xac/0x1bc<br>&nbsp=
=3B[&lt=3Bc10029c8&gt=3B] ? sysenter_do_call+0x12/0x27<br>Code:&nbsp=3B Bad=
 EIP value.<br>EIP: [&lt=3B253e343c&gt=3B] 0x253e343c SS:ESP 0068:ccaf3dd8<=
br>CR2: 00000000253e343c<br>---[ end trace aaed81f943beb724 ]---<br>tm6000:=
 open called (minor=3D0)<br><br> 		 	   		  </body>
</html>=

--_f09b2c69-8e8f-4570-990c-9492d59381e3_--


--===============1572034930==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1572034930==--
