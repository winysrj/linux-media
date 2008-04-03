Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web25404.mail.ukl.yahoo.com ([217.12.10.138])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <dirk_vornheder@yahoo.de>) id 1JhLhZ-0005hW-Ei
	for linux-dvb@linuxtv.org; Thu, 03 Apr 2008 11:25:46 +0200
Date: Thu, 3 Apr 2008 09:25:11 +0000 (GMT)
From: Dirk Vornheder <dirk_vornheder@yahoo.de>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <921202.4036.qm@web25404.mail.ukl.yahoo.com>
Subject: Re: [linux-dvb] Terratec Cinery HT Express: It works !
Reply-To: dirk_vornheder@yahoo.de
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2121893183=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============2121893183==
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: quoted-printable

<table cellspacing=3D'0' cellpadding=3D'0' border=3D'0' ><tr><td style=3D'f=
ont: inherit;'>Hi !<BR><BR>The card doesn't work here:<BR><BR>Apr&nbsp; 2 1=
0:31:46 pclap kernel: usb 5-7: new high speed USB device using <BR>ehci_hcd=
 and address 7<BR>Apr&nbsp; 2 10:31:46 pclap kernel: usb 5-7: configuration=
 #1 chosen from 1 choice<BR>Apr&nbsp; 2 10:31:46 pclap kernel: dib0700: loa=
ded with support for 7 different <BR>device-types<BR>Apr&nbsp; 2 10:31:46 p=
clap kernel: dvb-usb: found a 'Terratec Cinergy HT Express' <BR>in cold sta=
te, will try to load a firmware<BR>Apr&nbsp; 2 10:31:46 pclap kernel: dvb-u=
sb: downloading firmware from <BR>file 'dvb-usb-dib0700-1.10.fw'<BR>Apr&nbs=
p; 2 10:31:47 pclap kernel: dib0700: firmware started successfully.<BR>Apr&=
nbsp; 2 10:31:47 pclap kernel: dvb-usb: found a 'Terratec Cinergy HT Expres=
s' <BR>in warm state.<BR>Apr&nbsp; 2 10:31:47 pclap kernel: i2c-adapter i2c=
-1: SMBus Quick command not <BR>supported, can't probe for
 chips<BR>Apr&nbsp; 2 10:31:47 pclap kernel: dvb-usb: will pass the complet=
e MPEG2 transport <BR>stream to the software demuxer.<BR>Apr&nbsp; 2 10:31:=
47 pclap kernel: DVB: registering new adapter (Terratec Cinergy <BR>HT Expr=
ess)<BR>Apr&nbsp; 2 10:31:47 pclap kernel: i2c-adapter i2c-2: SMBus Quick c=
ommand not <BR>supported, can't probe for chips<BR>Apr&nbsp; 2 10:31:47 pcl=
ap kernel: DVB: registering frontend 0 (DiBcom 7000PC)...<BR>Apr&nbsp; 2 10=
:31:47 pclap udevd-event[5177]: run_program: '/sbin/modprobe' <BR>abnormal =
exit<BR><BR>If the card is inserted during reboot of the laptop i get the f=
ollowing<BR><BR>messages:<BR><BR>Apr&nbsp; 2 12:35:18 (none) kernel: Blueto=
oth: Core ver 2.11<BR>Apr&nbsp; 2 12:35:18 (none) kernel: NET: Registered p=
rotocol family 31<BR>Apr&nbsp; 2 12:35:18 (none) kernel: Bluetooth: HCI dev=
ice and connection manager <BR>initialized<BR>Apr&nbsp; 2 12:35:18 (none) k=
ernel: Bluetooth: HCI socket layer initialized<BR>Apr&nbsp; 2
 12:35:18 (none) kernel: Bluetooth: BlueFRITZ! USB driver ver 1.1<BR>Apr&nb=
sp; 2 12:35:18 (none) kernel: usb 5-3: new high speed USB device using <BR>=
ehci_hcd and address 3<BR>Apr&nbsp; 2 12:35:18 (none) kernel: usb 5-3: conf=
iguration #1 chosen from 1 choice<BR>Apr&nbsp; 2 12:35:18 (none) kernel: hu=
b 5-3:1.0: USB hub found<BR>Apr&nbsp; 2 12:35:18 (none) kernel: hub 5-3:1.0=
: 4 ports detected<BR>Apr&nbsp; 2 12:35:18 (none) kernel: usb 5-7: new high=
 speed USB device using <BR>ehci_hcd and address 4<BR>Apr&nbsp; 2 12:35:18 =
(none) kernel: usb 5-7: configuration #1 chosen from 1 choice<BR>Apr&nbsp; =
2 12:35:18 (none) kernel: usbcore: registered new interface driver bfusb<BR=
>Apr&nbsp; 2 12:35:18 (none) kernel: usb 1-2: new full speed USB device usi=
ng <BR>uhci_hcd and address 4<BR>Apr&nbsp; 2 12:35:18 (none) kernel: dib070=
0: loaded with support for 7 different <BR>device-types<BR>Apr&nbsp; 2 12:3=
5:18 (none) kernel: usb 1-2: configuration #1 chosen from 1
 choice<BR>Apr&nbsp; 2 12:35:18 (none) kernel: usb 5-3.1: new high speed US=
B device using <BR>ehci_hcd and address 5<BR>Apr&nbsp; 2 12:35:18 (none) ke=
rnel: EXT3 FS on sda6, internal journal<BR>Apr&nbsp; 2 12:35:18 (none) kern=
el: usb 5-3.1: configuration #1 chosen from 1 <BR>choice<BR>Apr&nbsp; 2 12:=
35:18 (none) kernel: device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) <BR>in=
itialised: <A href=3D"http://de.mc254.mail.yahoo.com/mc/compose?to=3Ddm-dev=
el@redhat.com" ymailto=3D"mailto:dm-devel@redhat.com"><FONT color=3D#003399=
>dm-devel@redhat.com</FONT></A><BR>Apr&nbsp; 2 12:35:18 (none) kernel: Init=
ializing USB Mass Storage driver...<BR>Apr&nbsp; 2 12:35:18 (none) kernel: =
usb 5-3.2: new low speed USB device using <BR>ehci_hcd and address 6<BR>Apr=
&nbsp; 2 12:35:18 (none) kernel: usb 5-3.2: configuration #1 chosen from 1 =
<BR>choice<BR>Apr&nbsp; 2 12:35:18 (none) kernel: dvb-usb: found a 'Terrate=
c Cinergy HT Express' <BR>in cold state, will try to load a
 firmware<BR>Apr&nbsp; 2 12:35:18 (none) kernel: dvb-usb: downloading firmw=
are from <BR>file 'dvb-usb-dib0700-1.10.fw'<BR>Apr&nbsp; 2 12:35:18 (none) =
kernel: dib0700: firmware started successfully.<BR>Apr&nbsp; 2 12:35:18 (no=
ne) kernel: dvb-usb: found a 'Terratec Cinergy HT Express' <BR>in warm stat=
e.<BR>Apr&nbsp; 2 12:35:18 (none) kernel: dvb-usb: will pass the complete M=
PEG2 transport <BR>stream to the software demuxer.<BR>Apr&nbsp; 2 12:35:18 =
(none) kernel: DVB: registering new adapter (Terratec Cinergy <BR>HT Expres=
s)<BR>Apr&nbsp; 2 12:35:18 (none) kernel: DVB: registering frontend 0 (DiBc=
om 7000PC)...<BR>Apr&nbsp; 2 12:35:18 (none) kernel: BUG: unable to handle =
kernel NULL pointer <BR>dereference at virtual address 00000388<BR>Apr&nbsp=
; 2 12:35:18 (none) kernel: printing eip: f8993925 *pde =3D 00000000 <BR>Ap=
r&nbsp; 2 12:35:18 (none) kernel: Oops: 0000 [#1] SMP <BR>Apr&nbsp; 2 12:35=
:18 (none) kernel: Modules linked in: tuner_xc2028 usbmouse
 <BR>usb_storage dm_mod md_mod dvb_usb_dib0700 dib7000p dib7000m dvb_usb dv=
b_core <BR>dib3000mc dibx000_common dib0070 bfusb bluetooth serial_cs snd_h=
da_intel <BR>snd_pcm snd_timer snd_page_alloc snd_hwdep pcmcia ehci_hcd nvi=
dia(P) uhci_hcd <BR>ohci1394 snd yenta_socket ieee1394 backlight rsrc_nonst=
atic usbcore thermal <BR>pcmcia_core i2c_i801 container output soundcore i2=
c_core rng_core battery ac <BR>processor button pcspkr joydev evdev<BR>Apr&=
nbsp; 2 12:35:18 (none) kernel: <BR>Apr&nbsp; 2 12:35:18 (none) kernel: Pid=
: 2082, comm: modprobe Tainted: P&nbsp; &nbsp; &nbsp; &nbsp; <BR>(2.6.24.4 =
#1)<BR>Apr&nbsp; 2 12:35:18 (none) kernel: EIP: 0060:[&lt;f8993925&gt;] EFL=
AGS: 00010206 CPU: 0<BR>Apr&nbsp; 2 12:35:18 (none) kernel: EIP is at xc202=
8_attach+0x177/0x1ca <BR>[tuner_xc2028]<BR>Apr&nbsp; 2 12:35:18 (none) kern=
el: EAX: 00000880 EBX: f899750c ECX: ffffffff EDX: <BR>00000200<BR>Apr&nbsp=
; 2 12:35:18 (none) kernel: ESI: f8995bf0 EDI: f76071d8 EBP:
 f74f9d28 ESP: <BR>f74f9d00<BR>Apr&nbsp; 2 12:35:18 (none) kernel:&nbsp; DS=
: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068<BR>Apr&nbsp; 2 12:35:18 (none) k=
ernel: Process modprobe (pid: 2082, ti=3Df74f8000 <BR>task=3Df709a000 task.=
ti=3Df74f8000)<BR>Apr&nbsp; 2 12:35:18 (none) kernel: Stack: f74f9d20 f70ab=
754 f70ab754 f70ab790 <BR>f74f9d28 f8a24238 f7607000 f70ab754 <BR>Apr&nbsp;=
 2 12:35:18 (none) kernel:&nbsp; &nbsp; &nbsp; &nbsp; f70ab754 f70ab790 f74=
f9d38 f8a1ea16 <BR>f8a1fea4 f70ab754 f74f9d50 f892de29 <BR>Apr&nbsp; 2 12:3=
5:18 (none) kernel:&nbsp; &nbsp; &nbsp; &nbsp; f70ab7a0 f70ab000 f70ab754 f=
70ab000 <BR>f74f9d98 f892d8d1 f892f2bd f8a203f0 <BR>Apr&nbsp; 2 12:35:18 (n=
one) kernel: Call Trace:<BR>Apr&nbsp; 2 12:35:18 (none) kernel:&nbsp; [&lt;=
c0104ed7&gt;] show_trace_log_lvl+0x1a/0x2f<BR>Apr&nbsp; 2 12:35:18 (none) k=
ernel:&nbsp; [&lt;c0104f87&gt;] show_stack_log_lvl+0x9b/0xa3<BR>Apr&nbsp; 2=
 12:35:18 (none) kernel:&nbsp; [&lt;c0105036&gt;]
 show_registers+0xa7/0x179<BR>Apr&nbsp; 2 12:35:18 (none) kernel:&nbsp; [&l=
t;c010521e&gt;] die+0x116/0x1e1<BR>Apr&nbsp; 2 12:35:18 (none) kernel:&nbsp=
; [&lt;c011a09d&gt;] do_page_fault+0x425/0x500<BR>Apr&nbsp; 2 12:35:18 (non=
e) kernel:&nbsp; [&lt;c02fa37a&gt;] error_code+0x72/0x78<BR>Apr&nbsp; 2 12:=
35:18 (none) kernel:&nbsp; [&lt;f8a1ea16&gt;] stk7700ph_tuner_attach+0x5f/0=
x88 <BR>[dvb_usb_dib0700]<BR>Apr&nbsp; 2 12:35:18 (none) kernel:&nbsp; [&lt=
;f892de29&gt;] <BR>dvb_usb_adapter_frontend_init+0xc4/0xe8 [dvb_usb]<BR>Apr=
&nbsp; 2 12:35:18 (none) kernel:&nbsp; [&lt;f892d8d1&gt;] dvb_usb_device_in=
it+0x467/0x54a <BR>[dvb_usb]<BR>Apr&nbsp; 2 12:35:18 (none) kernel:&nbsp; [=
&lt;f8a1e415&gt;] dib0700_probe+0x28/0x53 <BR>[dvb_usb_dib0700]<BR>Apr&nbsp=
; 2 12:35:18 (none) kernel:&nbsp; [&lt;f88d3715&gt;] usb_probe_interface+0x=
b4/0xe6 <BR>[usbcore]<BR>Apr&nbsp; 2 12:35:18 (none) kernel:&nbsp; [&lt;c02=
21cb5&gt;] driver_probe_device+0xc8/0x14c<BR>Apr&nbsp; 2 12:35:18
 (none) kernel:&nbsp; [&lt;c0221e50&gt;] __driver_attach+0x69/0x9f<BR>Apr&n=
bsp; 2 12:35:18 (none) kernel:&nbsp; [&lt;c022123a&gt;] bus_for_each_dev+0x=
3b/0x5d<BR>Apr&nbsp; 2 12:35:18 (none) kernel:&nbsp; [&lt;c0221b2d&gt;] dri=
ver_attach+0x19/0x1b<BR>Apr&nbsp; 2 12:35:18 (none) kernel:&nbsp; [&lt;c022=
1541&gt;] bus_add_driver+0x76/0x191<BR>Apr&nbsp; 2 12:35:18 (none) kernel:&=
nbsp; [&lt;c022202d&gt;] driver_register+0x5e/0x63<BR>Apr&nbsp; 2 12:35:18 =
(none) kernel:&nbsp; [&lt;f88d32fe&gt;] usb_register_driver+0x73/0xda <BR>[=
usbcore]<BR>Apr&nbsp; 2 12:35:18 (none) kernel:&nbsp; [&lt;f8888030&gt;] di=
b0700_module_init+0x30/0x4d <BR>[dvb_usb_dib0700]<BR>Apr&nbsp; 2 12:35:18 (=
none) kernel:&nbsp; [&lt;c0140d7d&gt;] sys_init_module+0x1420/0x14ea<BR>Apr=
&nbsp; 2 12:35:18 (none) kernel:&nbsp; [&lt;c0103f06&gt;] sysenter_past_esp=
+0x5f/0x85<BR>Apr&nbsp; 2 12:35:18 (none) kernel:&nbsp; =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<BR>Apr&nbsp; 2 12:35:18=
 (none) kernel: Code: e9 5f 99 f8 e8 dd
 10 79 c7 8b 7d f0 be 24 <BR>5b 99 f8 b9 33 00 00 00 81 c7 0c 01 00 00 f3 a=
5 8b 53 0c 83 c9 ff 8a 43 08 85 <BR>d2 74 06 &lt;8b&gt; 8a 88 01 00 00 0f b=
6 c0 c7 44 24 10 07 60 99 f8 89 44 24 0c <BR>Apr&nbsp; 2 12:35:18 (none) ke=
rnel: EIP: [&lt;f8993925&gt;] xc2028_attach+0x177/0x1ca <BR>[tuner_xc2028] =
SS:ESP 0068:f74f9d00<BR>Apr&nbsp; 2 12:35:18 (none) kernel: ---[ end trace =
d804f6c9dc20afd5 ]---<BR><BR>I use openSUSE 10.3 and Kernel 2.6.24.4 !<BR><=
BR>Dirk<BR></td></tr></table><br>=0A      <hr size=3D1>=0AGesendet von <a  =
=0Ahref=3D"http://us.rd.yahoo.com/mailuk/taglines/isp/control/*http://us.rd=
.yahoo.com/evt=3D52427/*http://de.overview.mail.yahoo.com" target=3D_blank>=
Yahoo! Mail</a>.=0A<br>=0ADem pfiffigeren Posteingang.


--===============2121893183==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2121893183==--
