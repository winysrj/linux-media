Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from core.devicen.de ([62.159.186.206])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <l.lacher@abian.de>) id 1KADxU-0004lT-C9
	for linux-dvb@linuxtv.org; Sun, 22 Jun 2008 03:01:33 +0200
Received: from [10.71.67.13] ([10.71.67.13])
	by core.devicen.de (8.13.1/8.13.1/DEVICE/N GmbH 20070903) with ESMTP id
	m5M10th5027525
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-dvb@linuxtv.org>; Sun, 22 Jun 2008 03:00:56 +0200
From: Lutz Lacher <l.lacher@abian.de>
To: linux-dvb@linuxtv.org
Date: Sun, 22 Jun 2008 03:00:51 +0200
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806220300.51879.l.lacher@abian.de>
Subject: [linux-dvb] dvb_usb_dib0700 and Remote Control DSR-0112
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello everybody,

i have a problem with a Hauppauge WinTV-NOVA-T-Stick which i bought in late =

May in a german "Media Markt".
Watching TV works fine after compiling the modules as suggested on =

http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-NOVA-T-Stick
but i can't get the remote control working.

The remote control has 35 buttons, a white top and a black back. On the bac=
k =

is printed:
Remote Control
Model No. DSR-0112
Made in China

lsusb returns:
Bus 002 Device 006: ID 2040:7070 Hauppauge

Loading the module gives in /var/log/messages
dvb-usb: found a 'Hauppauge Nova-T Stick' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software =

demuxmer.
DVB: registering new adapter (Hauppauge Nova-T Stick)
DVB: registering frontend 0 (DiBcom 7000PC)...
DiB0070: successfully identified
input: IR-receiver inside an USB DVB receiver as /class/input/input21
dvb-usb: schedule remote query interval to 150 msecs.
dvb-usb: Hauppauge Nova-T Stick successfully initialized and connected.
usbcore: registered new interface driver dvb_usb_dib0700

Neither irw nor irrecord returns any output except for irrecord:
irrecord: gap not found, can't continue
irrecord: closing '/dev/input/event9'

Presing keys on the remote control produces in /var/log/messages e.g.:
kernel: dib0700: Unknown remote controller key: 1D =A07 =A01 =A00

I tried it on Mandriva 2008.1 and SUSE 10.3 with no success on both systems.

Am i missing something obvious?

Thanks for your help,
Lutz

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
