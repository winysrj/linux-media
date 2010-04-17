Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <waichai@gmail.com>) id 1O3CG2-0001dn-5h
	for linux-dvb@linuxtv.org; Sat, 17 Apr 2010 19:56:42 +0200
Received: from mail-gx0-f225.google.com ([209.85.217.225])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-a) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1O3CG0-0000dS-Cr; Sat, 17 Apr 2010 19:56:41 +0200
Received: by gxk25 with SMTP id 25so2003940gxk.11
	for <linux-dvb@linuxtv.org>; Sat, 17 Apr 2010 10:56:38 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 18 Apr 2010 01:56:38 +0800
Message-ID: <u2wc58d1d9d1004171056t879761f9n5acb957d5bfa9a4@mail.gmail.com>
From: Halu Wong <waichai@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Problem in USB DVB devices: dvb-usb: recv bulk message
	failed: -110
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0718594807=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0718594807==
Content-Type: multipart/alternative; boundary=001636c925861142af048472736e

--001636c925861142af048472736e
Content-Type: text/plain; charset=UTF-8

Hi all,

I got a Mygica D689 which already have driver in v4l-dvb.

But i can only get it work in VM (VMware player) but not in a real machine.

Both using the same distribution/kernel/v4l-dvb etc.

- Fedora 11 (32 bits)
- Standard installation with the default kernel: 2.6.29.4-167.fc11.i686.PAE
- with development tools/libraries installed

download the latest v4l-dvb
#hg clone http://www.linuxtv.org/hg/v4l-dvb
#cd v4l-dvb
#make
- remove all the things in
"/lib/modules/2.6.29.4-167.fc11.i686.PAE/kernel/drivers/media"
# make install

plug the Mygica D689,
message in real machine:
Apr 18 09:23:06 localhost kernel: usb 1-7: new high speed USB device using
ehci_hcd and address 3
Apr 18 09:23:06 localhost kernel: usb 1-7: New USB device found,
idVendor=0572, idProduct=d811
Apr 18 09:23:06 localhost kernel: usb 1-7: New USB device strings: Mfr=1,
Product=2, SerialNumber=3
Apr 18 09:23:06 localhost kernel: usb 1-7: Product: USB Stick
Apr 18 09:23:06 localhost kernel: usb 1-7: Manufacturer: Geniatech
Apr 18 09:23:06 localhost kernel: usb 1-7: SerialNumber: 080116
Apr 18 09:23:06 localhost kernel: usb 1-7: configuration #1 chosen from 1
choice
Apr 18 09:23:06 localhost kernel: dvb-usb: found a 'Mygica D689 DMB-TH' in
warm state.
Apr 18 09:23:06 localhost kernel: dvb-usb: will pass the complete MPEG2
transport stream to the software demuxer.
Apr 18 09:23:06 localhost kernel: DVB: registering new adapter (Mygica D689
DMB-TH)
Apr 18 09:23:07 localhost kernel: DVB: registering adapter 0 frontend 0
(AltoBeam ATBM8830/8831 DMB-TH)...
Apr 18 09:23:07 localhost kernel: input: IR-receiver inside an USB DVB
receiver as /devices/pci0000:00/0000:00:1d.7/usb1/1-7/input/input6
Apr 18 09:23:07 localhost kernel: dvb-usb: schedule remote query interval to
100 msecs.
Apr 18 09:23:07 localhost kernel: dvb-usb: Mygica D689 DMB-TH successfully
initialized and connected.
Apr 18 09:23:07 localhost kernel: usbcore: registered new interface driver
dvb_usb_cxusb
Apr 18 09:23:09 localhost kernel: dvb-usb: recv bulk message failed: -110

message in VM:
Apr 18 09:51:51 f11vm kernel: usb 1-1: new high speed USB device using
ehci_hcd and address 2
Apr 18 09:51:51 f11vm kernel: usb 1-1: New USB device found, idVendor=0572,
idProduct=d811
Apr 18 09:51:51 f11vm kernel: usb 1-1: New USB device strings: Mfr=1,
Product=2, SerialNumber=3
Apr 18 09:51:51 f11vm kernel: usb 1-1: Product: USB Stick
Apr 18 09:51:51 f11vm kernel: usb 1-1: Manufacturer: Geniatech
Apr 18 09:51:51 f11vm kernel: usb 1-1: SerialNumber: 080116
Apr 18 09:51:52 f11vm kernel: usb 1-1: configuration #1 chosen from 1 choice
Apr 18 09:51:52 f11vm kernel: dvb-usb: found a 'Mygica D689 DMB-TH' in warm
state.
Apr 18 09:51:52 f11vm kernel: dvb-usb: will pass the complete MPEG2
transport stream to the software demuxer.
Apr 18 09:51:52 f11vm kernel: DVB: registering new adapter (Mygica D689
DMB-TH)
Apr 18 09:51:53 f11vm kernel: DVB: registering adapter 0 frontend 0
(AltoBeam ATBM8830/8831 DMB-TH)...
Apr 18 09:51:54 f11vm kernel: input: IR-receiver inside an USB DVB receiver
as /devices/pci0000:00/0000:00:11.0/0000:02:03.0/usb1/1-1/input/input5
Apr 18 09:51:54 f11vm kernel: dvb-usb: schedule remote query interval to 100
msecs.
Apr 18 09:51:54 f11vm kernel: dvb-usb: Mygica D689 DMB-TH successfully
initialized and connected.
Apr 18 09:51:54 f11vm kernel: usbcore: registered new interface driver
dvb_usb_cxusb

i can do w_scan with 11 services in VM but not ZERO in real machine!!

Did the following log message imply sth!?!?
Apr 18 09:23:09 localhost kernel: dvb-usb: recv bulk message failed: -110

I have tried to install in another real machine but also with the same
result!

Can anyone give me a hint on how to check/solve this issue!!

Thanks,
Halu Wong

--001636c925861142af048472736e
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi all,<div><br></div><div>I got a Mygica D689 which already have driver in=
 v4l-dvb.=C2=A0</div><div><br></div><div>But i can only get it work in VM (=
VMware player) but not in a real machine.</div><div><br></div><div>Both usi=
ng the same distribution/kernel/v4l-dvb etc.</div>
<div><br></div><div>- Fedora 11 (32 bits)</div><div>- Standard installation=
 with the default kernel:=C2=A02.6.29.4-167.fc11.i686.PAE</div><div>- with =
development tools/libraries installed</div><div><br></div><div>download the=
 latest v4l-dvb</div>
<div>#hg clone <a href=3D"http://www.linuxtv.org/hg/v4l-dvb">http://www.lin=
uxtv.org/hg/v4l-dvb</a></div><div>#cd=C2=A0v4l-dvb</div><div>#make</div><di=
v>- remove all the things in &quot;/lib/modules/2.6.29.4-167.fc11.i686.PAE/=
kernel/drivers/media&quot;</div>
<div># make install</div><div><br></div><div>plug the Mygica D689,</div><di=
v>message in real machine:</div><div><div>Apr 18 09:23:06 localhost kernel:=
 usb 1-7: new high speed USB device using ehci_hcd and address 3</div><div>
Apr 18 09:23:06 localhost kernel: usb 1-7: New USB device found, idVendor=
=3D0572, idProduct=3Dd811</div><div>Apr 18 09:23:06 localhost kernel: usb 1=
-7: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D3</div><di=
v>Apr 18 09:23:06 localhost kernel: usb 1-7: Product: USB Stick</div>
<div>Apr 18 09:23:06 localhost kernel: usb 1-7: Manufacturer: Geniatech</di=
v><div>Apr 18 09:23:06 localhost kernel: usb 1-7: SerialNumber: 080116</div=
><div>Apr 18 09:23:06 localhost kernel: usb 1-7: configuration #1 chosen fr=
om 1 choice</div>
<div>Apr 18 09:23:06 localhost kernel: dvb-usb: found a &#39;Mygica D689 DM=
B-TH&#39; in warm state.</div><div>Apr 18 09:23:06 localhost kernel: dvb-us=
b: will pass the complete MPEG2 transport stream to the software demuxer.</=
div>
<div>Apr 18 09:23:06 localhost kernel: DVB: registering new adapter (Mygica=
 D689 DMB-TH)</div><div>Apr 18 09:23:07 localhost kernel: DVB: registering =
adapter 0 frontend 0 (AltoBeam ATBM8830/8831 DMB-TH)...</div><div>Apr 18 09=
:23:07 localhost kernel: input: IR-receiver inside an USB DVB receiver as /=
devices/pci0000:00/0000:00:1d.7/usb1/1-7/input/input6</div>
<div>Apr 18 09:23:07 localhost kernel: dvb-usb: schedule remote query inter=
val to 100 msecs.</div><div>Apr 18 09:23:07 localhost kernel: dvb-usb: Mygi=
ca D689 DMB-TH successfully initialized and connected.</div><div>Apr 18 09:=
23:07 localhost kernel: usbcore: registered new interface driver dvb_usb_cx=
usb</div>
<div>Apr 18 09:23:09 localhost kernel: dvb-usb: recv bulk message failed: -=
110</div></div><div><br></div><div>message in VM:</div><div><div>Apr 18 09:=
51:51 f11vm kernel: usb 1-1: new high speed USB device using ehci_hcd and a=
ddress 2</div>
<div>Apr 18 09:51:51 f11vm kernel: usb 1-1: New USB device found, idVendor=
=3D0572, idProduct=3Dd811</div><div>Apr 18 09:51:51 f11vm kernel: usb 1-1: =
New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D3</div><div>Ap=
r 18 09:51:51 f11vm kernel: usb 1-1: Product: USB Stick</div>
<div>Apr 18 09:51:51 f11vm kernel: usb 1-1: Manufacturer: Geniatech</div><d=
iv>Apr 18 09:51:51 f11vm kernel: usb 1-1: SerialNumber: 080116</div><div>Ap=
r 18 09:51:52 f11vm kernel: usb 1-1: configuration #1 chosen from 1 choice<=
/div>
<div>Apr 18 09:51:52 f11vm kernel: dvb-usb: found a &#39;Mygica D689 DMB-TH=
&#39; in warm state.</div><div>Apr 18 09:51:52 f11vm kernel: dvb-usb: will =
pass the complete MPEG2 transport stream to the software demuxer.</div>
<div>Apr 18 09:51:52 f11vm kernel: DVB: registering new adapter (Mygica D68=
9 DMB-TH)</div><div>Apr 18 09:51:53 f11vm kernel: DVB: registering adapter =
0 frontend 0 (AltoBeam ATBM8830/8831 DMB-TH)...</div><div>Apr 18 09:51:54 f=
11vm kernel: input: IR-receiver inside an USB DVB receiver as /devices/pci0=
000:00/0000:00:11.0/0000:02:03.0/usb1/1-1/input/input5</div>
<div>Apr 18 09:51:54 f11vm kernel: dvb-usb: schedule remote query interval =
to 100 msecs.</div><div>Apr 18 09:51:54 f11vm kernel: dvb-usb: Mygica D689 =
DMB-TH successfully initialized and connected.</div><div>Apr 18 09:51:54 f1=
1vm kernel: usbcore: registered new interface driver dvb_usb_cxusb</div>
</div><div><br></div><div>i can do w_scan with 11 services in VM but not ZE=
RO in real machine!!</div><div><br></div><div>Did the following log message=
 imply sth!?!?</div><div>Apr 18 09:23:09 localhost kernel: dvb-usb: recv bu=
lk message failed: -110</div>
<div><br></div><div>I have tried to install in another real machine but als=
o with the same result!</div><div><br></div><div>Can anyone give me a hint =
on how to check/solve this issue!!</div><div><br></div><div>Thanks,</div>
<div>Halu Wong</div><div><br></div><div><br></div>

--001636c925861142af048472736e--


--===============0718594807==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0718594807==--
