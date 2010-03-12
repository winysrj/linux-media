Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <ton.machielsen@gmail.com>) id 1Nq77N-0000qu-TU
	for linux-dvb@linuxtv.org; Fri, 12 Mar 2010 16:49:42 +0100
Received: from mail-ww0-f54.google.com ([74.125.82.54])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-a) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1Nq77N-0001Nn-4T; Fri, 12 Mar 2010 16:49:41 +0100
Received: by wwb24 with SMTP id 24so268887wwb.41
	for <linux-dvb@linuxtv.org>; Fri, 12 Mar 2010 07:49:40 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 12 Mar 2010 16:49:40 +0100
Message-ID: <e77013311003120749q5c37f89at5e224f557fde0442@mail.gmail.com>
From: Ton Machielsen <ton@machielsen.net>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] USB1.1 vs. USB2.0
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1008546982=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1008546982==
Content-Type: multipart/alternative; boundary=0016e656b598afa58e04819c7a67

--0016e656b598afa58e04819c7a67
Content-Type: text/plain; charset=ISO-8859-1

Hi all!

When i insert a USB 2.0 device i get the following errors:

[   93.680054] usb 2-1: new full speed USB device using uhci_hcd and address
3
[   93.843342] usb 2-1: configuration #1 chosen from 1 choice
[   93.855095] input: HID 18b4:1001 as
/devices/pci0000:00/0000:00:1d.1/usb2/2-1/2-1:1.0/input/input12
[   93.855916] generic-usb 0003:18B4:1001.0002: input,hidraw0: USB HID v1.11
Keyboard [HID 18b4:1001] on usb-0000:00:1d.1-1/input0
[   93.866130] dvb-usb: found a 'E3C EC168 DVB-T USB2.0 reference design' in
cold state, will try to load a firmware
[   93.866151] usb 2-1: firmware: requesting dvb-usb-ec168.fw
[   94.212405] dvb-usb: downloading firmware from file 'dvb-usb-ec168.fw'
[   94.317243] dvb-usb: found a 'E3C EC168 DVB-T USB2.0 reference design' in
warm state.
[   94.317401] dvb-usb: This USB2.0 device cannot be run on a USB1.1 port.
(it lacks a hardware PID filter)
[   94.317471] dvb-usb: E3C EC168 DVB-T USB2.0 reference design error while
loading driver (-19)
I've seen this message many times when searching the internet for a
solution, but i haven't found the solution yet.

Does anybody know how to solve this?

This is Ubuntu 2.6.32.8-1 on an EeePC 701. And yes, this machine does have
USB 2.0 ports.

Thanks,

Ton.

--0016e656b598afa58e04819c7a67
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Hi all!</div>
<div>=A0</div>
<div>When i insert a USB 2.0 device i get the following errors:<br><br>[=A0=
 =A093.680054] usb 2-1: new full speed USB device using uhci_hcd and addres=
s 3<br>[=A0 =A093.843342] usb 2-1: configuration #1 chosen from 1 choice<br=
>[=A0 =A093.855095] input: HID 18b4:1001 as /devices/pci0000:00/0000:00:1d.=
1/usb2/2-1/2-1:1.0/input/input12<br>
[=A0 =A093.855916] generic-usb 0003:18B4:1001.0002: input,hidraw0: USB HID =
v1.11 Keyboard [HID 18b4:1001] on usb-0000:00:1d.1-1/input0<br>[=A0 =A093.8=
66130] dvb-usb: found a &#39;E3C EC168 DVB-T USB2.0 reference design&#39; i=
n cold state, will try to load a firmware<br>
[=A0 =A093.866151] usb 2-1: firmware: requesting dvb-usb-ec168.fw<br>[=A0 =
=A094.212405] dvb-usb: downloading firmware from file &#39;dvb-usb-ec168.fw=
&#39;<br>[=A0 =A094.317243] dvb-usb: found a &#39;E3C EC168 DVB-T USB2.0 re=
ference design&#39; in warm state.<br>
[=A0 =A094.317401] dvb-usb: This USB2.0 device cannot be run on a USB1.1 po=
rt. (it lacks a hardware PID filter)<br>[=A0 =A094.317471] dvb-usb: E3C EC1=
68 DVB-T USB2.0 reference design error while loading driver (-19)<br></div>
<div>I&#39;ve seen this message many times when searching the internet for =
a solution, but i haven&#39;t found the solution yet.</div>
<div>=A0</div>
<div>Does anybody know how to solve this?</div>
<div>=A0</div>
<div>This is Ubuntu 2.6.32.8-1 on an EeePC 701. And yes, this machine does =
have USB 2.0 ports.</div>
<div>=A0</div>
<div>Thanks,</div>
<div>=A0</div>
<div>Ton.</div>
<div>=A0</div>

--0016e656b598afa58e04819c7a67--


--===============1008546982==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1008546982==--
