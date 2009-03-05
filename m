Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from m13-172.163.com ([220.181.13.172])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <wdy9927@163.com>) id 1LfBPe-00040c-9m
	for linux-dvb@linuxtv.org; Thu, 05 Mar 2009 12:06:53 +0100
Date: Thu, 5 Mar 2009 19:06:36 +0800 (CST)
From: wdy9927 <wdy9927@163.com>
To: linux-dvb@linuxtv.org
Message-ID: <12093750.396551236251196232.JavaMail.coremail@bj163app172.163.com>
MIME-Version: 1.0
Subject: [linux-dvb] ERROR: Module dvb_usb_aaa_dvbusb_demo is in use
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0519236642=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0519236642==
Content-Type: multipart/alternative;
	boundary="----=_Part_107126_33161849.1236251196230"

------=_Part_107126_33161849.1236251196230
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: quoted-printable


Hi,
I had make install a module for a dvb usb box which writen by my self. But =
this one didn't have real frontend ops and tuner ops.These functions did no=
thing but return 0.
Like this=20
static int demo_fe_init(struct dvb_frontend *fe)
{
    return 0;
}

After the usb box removed from linux, the DVB system called demo_fe_release=
 and demo_tu_release, sofar that seems very good=A3=A1 But, I can't rmmod t=
his module normally. It showed "ERROR: Module dvb_usb_dvbusb_demo is in use=
".This error is diffrent with "ERROR: Module dvb_usb is in use by dvb_usb_d=
vbusb_demo"

How can i rmmod this module with out reboot Linux.

thanks

$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$=
$$$$$$$$$$$$$$$
[   93.895305] dvb-usb: found a 'DVB USB2.0  Demo' in warm state.
[   93.897118] dvb-usb: will pass the complete MPEG2 transport stream to th=
e software demuxer.
[   93.897633] DVB: registering new adapter (DVB USB2.0  Demo)
[   93.899827] DVB_DEMO: demo_frontend_attach:
[   93.899829]
[   93.899842] DVB_DEMO: demo_fe_attach:
[   93.899844]
[   93.902815] DVB: registering adapter 0 frontend 0 ( Demo USB Driver)...
[   93.906273] DVB_DEMO: demo_tuner_attach:
[   93.906275]
[   93.906286] DVB_DEMO: demo_tu_attach:
[   93.906288]
[   93.909823] dvb-usb: will pass the complete MPEG2 transport stream to th=
e software demuxer.
[   93.912149] DVB: registering new adapter (DVB USB2.0  Demo)
[   93.914388] DVB_DEMO: demo_frontend_attach:
[   93.914390]
[   93.914401] DVB_DEMO: demo_fe_attach:
[   93.914403]
[   93.917737] DVB: registering adapter 1 frontend 0 ( Demo USB Driver)...
[   93.933098] DVB_DEMO: demo_tuner_attach:
[   93.933101]
[   93.933117] DVB_DEMO: demo_tu_attach:
[   93.933119]
[   93.936762] input: IR-receiver inside an USB DVB receiver as /devices/pc=
i0000:00/0000:00:02.1/usb2/2-6/input/input7
[   93.980756] dvb-usb: schedule remote query interval to 20000 msecs.
[   93.980773] dvb-usb: DVB USB2.0  Demo successfully initialized and conne=
cted.
[   93.984967] DVB_DEMO: demo_init: running
[   93.984970]
[   93.986705] usbcore: registered new interface driver dvb_usb_demo
[  119.219743] type=3D1503 audit(1236249152.266:5): operation=3D"inode_perm=
ission" requested_mask=3D"r::" denied_mask=3D"r::" fsuid=3D7 name=3D"/proc/=
5886/net/" pid=3D5886 profile=3D"/usr/sbin/cupsd"
[  120.405504] type=3D1503 audit(1236249153.454:6): operation=3D"inode_perm=
ission" requested_mask=3D"r::" denied_mask=3D"r::" fsuid=3D7 name=3D"/proc/=
5891/net/" pid=3D5891 profile=3D"/usr/sbin/cupsd"
[  120.405583] type=3D1503 audit(1236249153.454:7): operation=3D"socket_cre=
ate" family=3D"ax25" sock_type=3D"dgram" protocol=3D0 pid=3D5891 profile=3D=
"/usr/sbin/cupsd"
[  120.405598] type=3D1503 audit(1236249153.454:8): operation=3D"socket_cre=
ate" family=3D"netrom" sock_type=3D"seqpacket" protocol=3D0 pid=3D5891 prof=
ile=3D"/usr/sbin/cupsd"
[  120.405613] type=3D1503 audit(1236249153.454:9): operation=3D"socket_cre=
ate" family=3D"rose" sock_type=3D"dgram" protocol=3D0 pid=3D5891 profile=3D=
"/usr/sbin/cupsd"
[  120.405634] type=3D1503 audit(1236249153.454:10): operation=3D"socket_cr=
eate" family=3D"ipx" sock_type=3D"dgram" protocol=3D0 pid=3D5891 profile=3D=
"/usr/sbin/cupsd"
[  120.405648] type=3D1503 audit(1236249153.454:11): operation=3D"socket_cr=
eate" family=3D"appletalk" sock_type=3D"dgram" protocol=3D0 pid=3D5891 prof=
ile=3D"/usr/sbin/cupsd"
[  120.405662] type=3D1503 audit(1236249153.454:12): operation=3D"socket_cr=
eate" family=3D"econet" sock_type=3D"dgram" protocol=3D0 pid=3D5891 profile=
=3D"/usr/sbin/cupsd"
[  120.405684] type=3D1503 audit(1236249153.454:13): operation=3D"socket_cr=
eate" family=3D"ash" sock_type=3D"dgram" protocol=3D0 pid=3D5891 profile=3D=
"/usr/sbin/cupsd"
[  120.405697] type=3D1503 audit(1236249153.454:14): operation=3D"socket_cr=
eate" family=3D"x25" sock_type=3D"seqpacket" protocol=3D0 pid=3D5891 profil=
e=3D"/usr/sbin/cupsd"
[  121.103127] ppdev0: registered pardevice
[  121.152421] ppdev0: unregistered pardevice
[  121.224252] ppdev0: registered pardevice
[  121.272607] ppdev0: unregistered pardevice
[  121.333579] ppdev0: registered pardevice
[  121.384426] ppdev0: unregistered pardevice
[  170.980533] hub 2-0:1.0: port 6 disabled by hub (EMI?), re-enabling...
[  170.980552] usb 2-6: USB disconnect, address 4
[  171.009401] DVB_DEMO: demo_tu_release:
[  171.009403]
[  171.009416] DVB_DEMO: demo_fe_release:
[  171.009418]
[  171.010558] DVB_DEMO: demo_tu_release:
[  171.010560]
[  171.010571] DVB_DEMO: demo_fe_release:
[  171.010573]
[  171.013164] dvb-usb: DVB USB2.0  Demo successfully deinitialized and dis=
connected.
wdy@wdy:~$ sudo rmmod dvb-usb-dvbusb-demo
[sudo] password for wdy:
ERROR: Module dvb_usb_dvbusb_demo is in use







------=_Part_107126_33161849.1236251196230
Content-Type: text/html; charset=gbk
Content-Transfer-Encoding: quoted-printable

<br>Hi,<br>I had make install a module for a dvb usb box which writen by my=
 self. But this one didn't have real frontend ops and tuner ops.These funct=
ions did nothing but return 0.<br>Like this <br>static int demo_fe_init(str=
uct dvb_frontend *fe)<br>{<br>&nbsp;&nbsp;&nbsp; return 0;<br>}<br><br>Afte=
r the usb box removed from linux, the DVB system called demo_fe_release and=
 demo_tu_release, sofar that seems very good=A3=A1 But, I can't rmmod this =
module normally. It showed "ERROR: Module dvb_usb_dvbusb_demo is in use".Th=
is error is diffrent with "ERROR: Module dvb_usb is in use by dvb_usb_dvbus=
b_demo"<br><br>How can i rmmod this module with out reboot Linux.<br><br>th=
anks<br><br>$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$=
$$$$$$$$$$$$$$$$$$$$$$$$$$$<br>[&nbsp;&nbsp; 93.895305] dvb-usb: found a 'D=
VB USB2.0&nbsp; Demo' in warm state.<br>[&nbsp;&nbsp; 93.897118] dvb-usb: w=
ill pass the complete MPEG2 transport stream to the software demuxer.<br>[&=
nbsp;&nbsp; 93.897633] DVB: registering new adapter (DVB USB2.0&nbsp; Demo)=
<br>[&nbsp;&nbsp; 93.899827] DVB_DEMO: demo_frontend_attach:<br>[&nbsp;&nbs=
p; 93.899829]<br>[&nbsp;&nbsp; 93.899842] DVB_DEMO: demo_fe_attach:<br>[&nb=
sp;&nbsp; 93.899844]<br>[&nbsp;&nbsp; 93.902815] DVB: registering adapter 0=
 frontend 0 ( Demo USB Driver)...<br>[&nbsp;&nbsp; 93.906273] DVB_DEMO: dem=
o_tuner_attach:<br>[&nbsp;&nbsp; 93.906275]<br>[&nbsp;&nbsp; 93.906286] DVB=
_DEMO: demo_tu_attach:<br>[&nbsp;&nbsp; 93.906288]<br>[&nbsp;&nbsp; 93.9098=
23] dvb-usb: will pass the complete MPEG2 transport stream to the software =
demuxer.<br>[&nbsp;&nbsp; 93.912149] DVB: registering new adapter (DVB USB2=
.0&nbsp; Demo)<br>[&nbsp;&nbsp; 93.914388] DVB_DEMO: demo_frontend_attach:<=
br>[&nbsp;&nbsp; 93.914390]<br>[&nbsp;&nbsp; 93.914401] DVB_DEMO: demo_fe_a=
ttach:<br>[&nbsp;&nbsp; 93.914403]<br>[&nbsp;&nbsp; 93.917737] DVB: registe=
ring adapter 1 frontend 0 ( Demo USB Driver)...<br>[&nbsp;&nbsp; 93.933098]=
 DVB_DEMO: demo_tuner_attach:<br>[&nbsp;&nbsp; 93.933101]<br>[&nbsp;&nbsp; =
93.933117] DVB_DEMO: demo_tu_attach:<br>[&nbsp;&nbsp; 93.933119]<br>[&nbsp;=
&nbsp; 93.936762] input: IR-receiver inside an USB DVB receiver as /devices=
/pci0000:00/0000:00:02.1/usb2/2-6/input/input7<br>[&nbsp;&nbsp; 93.980756] =
dvb-usb: schedule remote query interval to 20000 msecs.<br>[&nbsp;&nbsp; 93=
.980773] dvb-usb: DVB USB2.0&nbsp; Demo successfully initialized and connec=
ted.<br>[&nbsp;&nbsp; 93.984967] DVB_DEMO: demo_init: running<br>[&nbsp;&nb=
sp; 93.984970]<br>[&nbsp;&nbsp; 93.986705] usbcore: registered new interfac=
e driver dvb_usb_demo<br>[&nbsp; 119.219743] type=3D1503 audit(1236249152.2=
66:5): operation=3D"inode_permission" requested_mask=3D"r::" denied_mask=3D=
"r::" fsuid=3D7 name=3D"/proc/5886/net/" pid=3D5886 profile=3D"/usr/sbin/cu=
psd"<br>[&nbsp; 120.405504] type=3D1503 audit(1236249153.454:6): operation=
=3D"inode_permission" requested_mask=3D"r::" denied_mask=3D"r::" fsuid=3D7 =
name=3D"/proc/5891/net/" pid=3D5891 profile=3D"/usr/sbin/cupsd"<br>[&nbsp; =
120.405583] type=3D1503 audit(1236249153.454:7): operation=3D"socket_create=
" family=3D"ax25" sock_type=3D"dgram" protocol=3D0 pid=3D5891 profile=3D"/u=
sr/sbin/cupsd"<br>[&nbsp; 120.405598] type=3D1503 audit(1236249153.454:8): =
operation=3D"socket_create" family=3D"netrom" sock_type=3D"seqpacket" proto=
col=3D0 pid=3D5891 profile=3D"/usr/sbin/cupsd"<br>[&nbsp; 120.405613] type=
=3D1503 audit(1236249153.454:9): operation=3D"socket_create" family=3D"rose=
" sock_type=3D"dgram" protocol=3D0 pid=3D5891 profile=3D"/usr/sbin/cupsd"<b=
r>[&nbsp; 120.405634] type=3D1503 audit(1236249153.454:10): operation=3D"so=
cket_create" family=3D"ipx" sock_type=3D"dgram" protocol=3D0 pid=3D5891 pro=
file=3D"/usr/sbin/cupsd"<br>[&nbsp; 120.405648] type=3D1503 audit(123624915=
3.454:11): operation=3D"socket_create" family=3D"appletalk" sock_type=3D"dg=
ram" protocol=3D0 pid=3D5891 profile=3D"/usr/sbin/cupsd"<br>[&nbsp; 120.405=
662] type=3D1503 audit(1236249153.454:12): operation=3D"socket_create" fami=
ly=3D"econet" sock_type=3D"dgram" protocol=3D0 pid=3D5891 profile=3D"/usr/s=
bin/cupsd"<br>[&nbsp; 120.405684] type=3D1503 audit(1236249153.454:13): ope=
ration=3D"socket_create" family=3D"ash" sock_type=3D"dgram" protocol=3D0 pi=
d=3D5891 profile=3D"/usr/sbin/cupsd"<br>[&nbsp; 120.405697] type=3D1503 aud=
it(1236249153.454:14): operation=3D"socket_create" family=3D"x25" sock_type=
=3D"seqpacket" protocol=3D0 pid=3D5891 profile=3D"/usr/sbin/cupsd"<br>[&nbs=
p; 121.103127] ppdev0: registered pardevice<br>[&nbsp; 121.152421] ppdev0: =
unregistered pardevice<br>[&nbsp; 121.224252] ppdev0: registered pardevice<=
br>[&nbsp; 121.272607] ppdev0: unregistered pardevice<br>[&nbsp; 121.333579=
] ppdev0: registered pardevice<br>[&nbsp; 121.384426] ppdev0: unregistered =
pardevice<br>[&nbsp; 170.980533] hub 2-0:1.0: port 6 disabled by hub (EMI?)=
, re-enabling...<br>[&nbsp; 170.980552] usb 2-6: USB disconnect, address 4<=
br>[&nbsp; 171.009401] DVB_DEMO: demo_tu_release:<br>[&nbsp; 171.009403]<br=
>[&nbsp; 171.009416] DVB_DEMO: demo_fe_release:<br>[&nbsp; 171.009418]<br>[=
&nbsp; 171.010558] DVB_DEMO: demo_tu_release:<br>[&nbsp; 171.010560]<br>[&n=
bsp; 171.010571] DVB_DEMO: demo_fe_release:<br>[&nbsp; 171.010573]<br>[&nbs=
p; 171.013164] dvb-usb: DVB USB2.0&nbsp; Demo successfully deinitialized an=
d disconnected.<br>wdy@wdy:~$ sudo rmmod dvb-usb-dvbusb-demo<br>[sudo] pass=
word for wdy:<br>ERROR: Module dvb_usb_dvbusb_demo is in use<br><br><br><br=
><br><br><br><br><!-- footer --><br><span title=3D"neteasefooter"/><hr/>
<a href=3D"http://www.yeah.net">=CD=F8=D2=D7=D3=CA=CF=E4=A3=AC=D6=D0=B9=FA=
=B5=DA=D2=BB=B4=F3=B5=E7=D7=D3=D3=CA=BC=FE=B7=FE=CE=F1=C9=CC</a>
</span>
------=_Part_107126_33161849.1236251196230--



--===============0519236642==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0519236642==--
