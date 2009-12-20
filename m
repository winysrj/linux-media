Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from blu0-omc3-s30.blu0.hotmail.com ([65.55.116.105])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <oholler@live.com>) id 1NMQUw-0005Ft-Te
	for linux-dvb@linuxtv.org; Sun, 20 Dec 2009 19:27:19 +0100
Message-ID: <BLU141-W328C060CAFF6A5A445B0A5DC830@phx.gbl>
From: Oliver Holler <oholler@live.com>
To: <linux-dvb@linuxtv.org>
Date: Sun, 20 Dec 2009 19:26:43 +0100
MIME-Version: 1.0
Subject: [linux-dvb] Kernel oops with Technotrend S2-3200
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0874052161=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0874052161==
Content-Type: multipart/alternative;
	boundary="_d30640e6-3048-4dd1-86a4-4b01936b8a7f_"

--_d30640e6-3048-4dd1-86a4-4b01936b8a7f_
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable


Hello=2C

I am trying to get a new Technotrend S2-3200 to run.
I am using changeset 13992:77a5248e92b5 of s2-liplianin and kernel 2.6.31.8=
 and 2.6.32.1.

When I try to load the module with modprobe budget_ci
I am getting a kernel: Oops: 0000 [#1] PREEMPT.

I appreciate any help.

Here is the syslog:
Dec 20 15:27:37 fs1 kernel: saa7146: register extension 'budget_ci dvb'.
Dec 20 15:27:37 fs1 kernel: budget_ci dvb 0000:01:01.0: PCI INT A -> GSI 20=
 (level=2C low) -> IRQ 20
Dec 20 15:27:37 fs1 kernel: IRQ 20/: IRQF_DISABLED is not guaranteed on sha=
red IRQs
Dec 20 15:27:37 fs1 kernel: saa7146: found saa7146 @ mem f8210c00 (revision=
 1=2C irq 20) (0x13c2=2C0x1019).
Dec 20 15:27:37 fs1 kernel: saa7146 (0): dma buffer size 192512
Dec 20 15:27:37 fs1 kernel: DVB: registering new adapter (TT-Budget S2-3200=
 PCI)
Dec 20 15:27:37 fs1 kernel: adapter has MAC addr =3D 00:d0:5c:64:99:e6
Dec 20 15:27:37 fs1 kernel: input: Budget-CI dvb ir receiver saa7146 (0) as=
 /class/input/input2
Dec 20 15:27:37 fs1 kernel: Creating IR device irrcv0
Dec 20 15:27:37 fs1 kernel: BUG: unable to handle kernel paging request at =
72727563
Dec 20 15:27:37 fs1 kernel: IP: [<c1111f36>] strcmp+0x7/0x19
Dec 20 15:27:37 fs1 kernel: *pde =3D 00000000=20
Dec 20 15:27:37 fs1 kernel: Oops: 0000 [#1] PREEMPT=20
Dec 20 15:27:37 fs1 kernel: last sysfs file: /sys/class/net/lo/operstate
Dec 20 15:27:37 fs1 kernel: Modules linked in: budget_ci(+) ir_common budge=
t_core dvb_core saa7146 ttpci_eeprom ir_core fuse evdev atl1 iTCO_wdt iTCO_=
vendor_support i2c_i801 ehci_hcd uhci_hcd thermal processor button thermal_=
sys usbcore
Dec 20 15:27:37 fs1 kernel:=20
Dec 20 15:27:37 fs1 kernel: Pid: 10958=2C comm: modprobe Not tainted (2.6.3=
1.8 #1) System Product Name
Dec 20 15:27:37 fs1 kernel: EIP: 0060:[<c1111f36>] EFLAGS: 00010282 CPU: 0
Dec 20 15:27:37 fs1 kernel: EIP is at strcmp+0x7/0x19
Dec 20 15:27:37 fs1 kernel: EAX: c12b2475 EBX: f662e534 ECX: 00000001 EDX: =
72727563
Dec 20 15:27:37 fs1 kernel: ESI: c12b24bb EDI: 72727563 EBP: f662e560 ESP: =
f6bffdcc
Dec 20 15:27:37 fs1 kernel:  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Dec 20 15:27:37 fs1 kernel: Process modprobe (pid: 10958=2C ti=3Df6bfe000 t=
ask=3Df70eb1b0 task.ti=3Df6bfe000)
Dec 20 15:27:37 fs1 kernel: Stack:
Dec 20 15:27:37 fs1 kernel:  72727563 f6bffe08 c1092f33 f814fcb0 f662e458 c=
1093018 f814fcb0 f662e458
Dec 20 15:27:37 fs1 kernel: <0> f6bffe08 c10930c2 f814fcb0 f662e458 fffffff=
4 f662e560 c1092c0a f662e560
Dec 20 15:27:37 fs1 kernel: <0> 00000000 00000000 00000000 00000001 0000000=
0 f81507f4 f684d488 c109460e
Dec 20 15:27:37 fs1 kernel: Call Trace:
Dec 20 15:27:37 fs1 kernel:  [<c1092f33>] ? sysfs_find_dirent+0x13/0x23
Dec 20 15:27:37 fs1 kernel:  [<c1093018>] ? __sysfs_add_one+0x11/0x81
Dec 20 15:27:37 fs1 kernel:  [<c10930c2>] ? sysfs_add_one+0xd/0x70
Dec 20 15:27:37 fs1 kernel:  [<c1092c0a>] ? sysfs_add_file_mode+0x3f/0x66
Dec 20 15:27:37 fs1 kernel:  [<c109460e>] ? internal_create_group+0xd0/0x14=
0
Dec 20 15:27:37 fs1 kernel:  [<f814f7b4>] ? ir_register_class+0x64/0x92 [ir=
_core]
Dec 20 15:27:37 fs1 kernel:  [<f814f32b>] ? ir_input_register+0x133/0x176 [=
ir_core]
Dec 20 15:27:37 fs1 kernel:  [<f8206d08>] ? budget_ci_attach+0x1fa/0xb0c [b=
udget_ci]
Dec 20 15:27:37 fs1 kernel:  [<f81642ea>] ? saa7146_init_one+0x4ea/0x6cb [s=
aa7146]
Dec 20 15:27:37 fs1 kernel:  [<c10930c2>] ? sysfs_add_one+0xd/0x70
Dec 20 15:27:37 fs1 kernel:  [<c111a55d>] ? local_pci_probe+0xb/0xc
Dec 20 15:27:37 fs1 kernel:  [<c111aba1>] ? pci_device_probe+0x41/0x63
Dec 20 15:27:37 fs1 kernel:  [<c115f5d2>] ? driver_probe_device+0x75/0xfc
Dec 20 15:27:37 fs1 kernel:  [<c115f699>] ? __driver_attach+0x40/0x5b
Dec 20 15:27:37 fs1 kernel:  [<c115f055>] ? bus_for_each_dev+0x37/0x5f
Dec 20 15:27:37 fs1 kernel:  [<c115f4ba>] ? driver_attach+0x11/0x13
Dec 20 15:27:37 fs1 kernel:  [<c115f659>] ? __driver_attach+0x0/0x5b
Dec 20 15:27:37 fs1 kernel:  [<c115eaea>] ? bus_add_driver+0x99/0x1bc
Dec 20 15:27:37 fs1 kernel:  [<c115f8b3>] ? driver_register+0x87/0xe0
Dec 20 15:27:37 fs1 kernel:  [<c111aeea>] ? __pci_register_driver+0x2c/0x82
Dec 20 15:27:37 fs1 kernel:  [<f820d000>] ? budget_ci_init+0x0/0xa [budget_=
ci]
Dec 20 15:27:37 fs1 kernel:  [<c100112b>] ? do_one_initcall+0x43/0x11f
Dec 20 15:27:37 fs1 kernel:  [<c1036773>] ? sys_init_module+0xa7/0x1b4
Dec 20 15:27:37 fs1 kernel:  [<c10028f4>] ? sysenter_do_call+0x12/0x26
Dec 20 15:27:37 fs1 kernel: Code: 04 31 db 89 0c 24 89 d8 89 d1 f2 ae 4f 8b=
 0c 24 49 78 06 ac aa 84 c0 75 f7 31 c0 aa 5b 89 e8 5b 5e 5f 5d c3 57 89 d7=
 56 89 c6 ac <ae> 75 08 84 c0 75 f8 31 c0 eb 04 19 c0 0c 01 5e 5f c3 57 89 =
d7=20
Dec 20 15:27:37 fs1 kernel: EIP: [<c1111f36>] strcmp+0x7/0x19 SS:ESP 0068:f=
6bffdcc
Dec 20 15:27:37 fs1 kernel: CR2: 0000000072727563
Dec 20 15:27:37 fs1 kernel: ---[ end trace 858b357512ea7e44 ]--- =20
 		 	   		 =20
_________________________________________________________________
Windows Live: Make it easier for your friends to see what you=92re up to on=
 Facebook.
http://www.microsoft.com/middleeast/windows/windowslive/see-it-in-action/so=
cial-network-basics.aspx?ocid=3DPID23461::T:WLMTAGL:ON:WL:en-xm:SI_SB_2:092=
009=

--_d30640e6-3048-4dd1-86a4-4b01936b8a7f_
Content-Type: text/html; charset="Windows-1252"
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
Hello=2C<br><br>I am trying to get a new Technotrend S2-3200 to run.<br>I a=
m using changeset 13992:77a5248e92b5 of s2-liplianin and kernel 2.6.31.8 an=
d 2.6.32.1.<br>
When I try to load the module with modprobe budget_ci<br>I am getting a ker=
nel: Oops: 0000 [#1] PREEMPT.<br><br>I appreciate any help.<br><br>Here is =
the syslog:<br>Dec 20 15:27:37 fs1 kernel: saa7146: register extension 'bud=
get_ci dvb'.<br>Dec 20 15:27:37 fs1 kernel: budget_ci dvb 0000:01:01.0: PCI=
 INT A -&gt=3B GSI 20 (level=2C low) -&gt=3B IRQ 20<br>Dec 20 15:27:37 fs1 =
kernel: IRQ 20/: IRQF_DISABLED is not guaranteed on shared IRQs<br>Dec 20 1=
5:27:37 fs1 kernel: saa7146: found saa7146 @ mem f8210c00 (revision 1=2C ir=
q 20) (0x13c2=2C0x1019).<br>Dec 20 15:27:37 fs1 kernel: saa7146 (0): dma bu=
ffer size 192512<br>Dec 20 15:27:37 fs1 kernel: DVB: registering new adapte=
r (TT-Budget S2-3200 PCI)<br>Dec 20 15:27:37 fs1 kernel: adapter has MAC ad=
dr =3D 00:d0:5c:64:99:e6<br>Dec 20 15:27:37 fs1 kernel: input: Budget-CI dv=
b ir receiver saa7146 (0) as /class/input/input2<br>Dec 20 15:27:37 fs1 ker=
nel: Creating IR device irrcv0<br>Dec 20 15:27:37 fs1 kernel: BUG: unable t=
o handle kernel paging request at 72727563<br>Dec 20 15:27:37 fs1 kernel: I=
P: [&lt=3Bc1111f36&gt=3B] strcmp+0x7/0x19<br>Dec 20 15:27:37 fs1 kernel: *p=
de =3D 00000000 <br>Dec 20 15:27:37 fs1 kernel: Oops: 0000 [#1] PREEMPT <br=
>Dec 20 15:27:37 fs1 kernel: last sysfs file: /sys/class/net/lo/operstate<b=
r>Dec 20 15:27:37 fs1 kernel: Modules linked in: budget_ci(+) ir_common bud=
get_core dvb_core saa7146 ttpci_eeprom ir_core fuse evdev atl1 iTCO_wdt iTC=
O_vendor_support i2c_i801 ehci_hcd uhci_hcd thermal processor button therma=
l_sys usbcore<br>Dec 20 15:27:37 fs1 kernel: <br>Dec 20 15:27:37 fs1 kernel=
: Pid: 10958=2C comm: modprobe Not tainted (2.6.31.8 #1) System Product Nam=
e<br>Dec 20 15:27:37 fs1 kernel: EIP: 0060:[&lt=3Bc1111f36&gt=3B] EFLAGS: 0=
0010282 CPU: 0<br>Dec 20 15:27:37 fs1 kernel: EIP is at strcmp+0x7/0x19<br>=
Dec 20 15:27:37 fs1 kernel: EAX: c12b2475 EBX: f662e534 ECX: 00000001 EDX: =
72727563<br>Dec 20 15:27:37 fs1 kernel: ESI: c12b24bb EDI: 72727563 EBP: f6=
62e560 ESP: f6bffdcc<br>Dec 20 15:27:37 fs1 kernel:&nbsp=3B DS: 007b ES: 00=
7b FS: 0000 GS: 0033 SS: 0068<br>Dec 20 15:27:37 fs1 kernel: Process modpro=
be (pid: 10958=2C ti=3Df6bfe000 task=3Df70eb1b0 task.ti=3Df6bfe000)<br>Dec =
20 15:27:37 fs1 kernel: Stack:<br>Dec 20 15:27:37 fs1 kernel:&nbsp=3B 72727=
563 f6bffe08 c1092f33 f814fcb0 f662e458 c1093018 f814fcb0 f662e458<br>Dec 2=
0 15:27:37 fs1 kernel: &lt=3B0&gt=3B f6bffe08 c10930c2 f814fcb0 f662e458 ff=
fffff4 f662e560 c1092c0a f662e560<br>Dec 20 15:27:37 fs1 kernel: &lt=3B0&gt=
=3B 00000000 00000000 00000000 00000001 00000000 f81507f4 f684d488 c109460e=
<br>Dec 20 15:27:37 fs1 kernel: Call Trace:<br>Dec 20 15:27:37 fs1 kernel:&=
nbsp=3B [&lt=3Bc1092f33&gt=3B] ? sysfs_find_dirent+0x13/0x23<br>Dec 20 15:2=
7:37 fs1 kernel:&nbsp=3B [&lt=3Bc1093018&gt=3B] ? __sysfs_add_one+0x11/0x81=
<br>Dec 20 15:27:37 fs1 kernel:&nbsp=3B [&lt=3Bc10930c2&gt=3B] ? sysfs_add_=
one+0xd/0x70<br>Dec 20 15:27:37 fs1 kernel:&nbsp=3B [&lt=3Bc1092c0a&gt=3B] =
? sysfs_add_file_mode+0x3f/0x66<br>Dec 20 15:27:37 fs1 kernel:&nbsp=3B [&lt=
=3Bc109460e&gt=3B] ? internal_create_group+0xd0/0x140<br>Dec 20 15:27:37 fs=
1 kernel:&nbsp=3B [&lt=3Bf814f7b4&gt=3B] ? ir_register_class+0x64/0x92 [ir_=
core]<br>Dec 20 15:27:37 fs1 kernel:&nbsp=3B [&lt=3Bf814f32b&gt=3B] ? ir_in=
put_register+0x133/0x176 [ir_core]<br>Dec 20 15:27:37 fs1 kernel:&nbsp=3B [=
&lt=3Bf8206d08&gt=3B] ? budget_ci_attach+0x1fa/0xb0c [budget_ci]<br>Dec 20 =
15:27:37 fs1 kernel:&nbsp=3B [&lt=3Bf81642ea&gt=3B] ? saa7146_init_one+0x4e=
a/0x6cb [saa7146]<br>Dec 20 15:27:37 fs1 kernel:&nbsp=3B [&lt=3Bc10930c2&gt=
=3B] ? sysfs_add_one+0xd/0x70<br>Dec 20 15:27:37 fs1 kernel:&nbsp=3B [&lt=
=3Bc111a55d&gt=3B] ? local_pci_probe+0xb/0xc<br>Dec 20 15:27:37 fs1 kernel:=
&nbsp=3B [&lt=3Bc111aba1&gt=3B] ? pci_device_probe+0x41/0x63<br>Dec 20 15:2=
7:37 fs1 kernel:&nbsp=3B [&lt=3Bc115f5d2&gt=3B] ? driver_probe_device+0x75/=
0xfc<br>Dec 20 15:27:37 fs1 kernel:&nbsp=3B [&lt=3Bc115f699&gt=3B] ? __driv=
er_attach+0x40/0x5b<br>Dec 20 15:27:37 fs1 kernel:&nbsp=3B [&lt=3Bc115f055&=
gt=3B] ? bus_for_each_dev+0x37/0x5f<br>Dec 20 15:27:37 fs1 kernel:&nbsp=3B =
[&lt=3Bc115f4ba&gt=3B] ? driver_attach+0x11/0x13<br>Dec 20 15:27:37 fs1 ker=
nel:&nbsp=3B [&lt=3Bc115f659&gt=3B] ? __driver_attach+0x0/0x5b<br>Dec 20 15=
:27:37 fs1 kernel:&nbsp=3B [&lt=3Bc115eaea&gt=3B] ? bus_add_driver+0x99/0x1=
bc<br>Dec 20 15:27:37 fs1 kernel:&nbsp=3B [&lt=3Bc115f8b3&gt=3B] ? driver_r=
egister+0x87/0xe0<br>Dec 20 15:27:37 fs1 kernel:&nbsp=3B [&lt=3Bc111aeea&gt=
=3B] ? __pci_register_driver+0x2c/0x82<br>Dec 20 15:27:37 fs1 kernel:&nbsp=
=3B [&lt=3Bf820d000&gt=3B] ? budget_ci_init+0x0/0xa [budget_ci]<br>Dec 20 1=
5:27:37 fs1 kernel:&nbsp=3B [&lt=3Bc100112b&gt=3B] ? do_one_initcall+0x43/0=
x11f<br>Dec 20 15:27:37 fs1 kernel:&nbsp=3B [&lt=3Bc1036773&gt=3B] ? sys_in=
it_module+0xa7/0x1b4<br>Dec 20 15:27:37 fs1 kernel:&nbsp=3B [&lt=3Bc10028f4=
&gt=3B] ? sysenter_do_call+0x12/0x26<br>Dec 20 15:27:37 fs1 kernel: Code: 0=
4 31 db 89 0c 24 89 d8 89 d1 f2 ae 4f 8b 0c 24 49 78 06 ac aa 84 c0 75 f7 3=
1 c0 aa 5b 89 e8 5b 5e 5f 5d c3 57 89 d7 56 89 c6 ac &lt=3Bae&gt=3B 75 08 8=
4 c0 75 f8 31 c0 eb 04 19 c0 0c 01 5e 5f c3 57 89 d7 <br>Dec 20 15:27:37 fs=
1 kernel: EIP: [&lt=3Bc1111f36&gt=3B] strcmp+0x7/0x19 SS:ESP 0068:f6bffdcc<=
br>Dec 20 15:27:37 fs1 kernel: CR2: 0000000072727563<br>Dec 20 15:27:37 fs1=
 kernel: ---[ end trace 858b357512ea7e44 ]---&nbsp=3B <br> 		 	   		  <br /=
><hr />Windows Live: Make it easier for your friends to see  <a href=3D'htt=
p://www.microsoft.com/middleeast/windows/windowslive/see-it-in-action/socia=
l-network-basics.aspx?ocid=3DPID23461::T:WLMTAGL:ON:WL:en-xm:SI_SB_2:092009=
' target=3D'_new'>what you=92re up to on Facebook.</a></body>
</html>=

--_d30640e6-3048-4dd1-86a4-4b01936b8a7f_--


--===============0874052161==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0874052161==--
