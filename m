Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:54831 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753804Ab1A3NDd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Jan 2011 08:03:33 -0500
Message-ID: <4D45619F.80306@gmx.de>
Date: Sun, 30 Jan 2011 14:03:27 +0100
From: David Ondracek <david.ondracek@gmx.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: AF9015 Problem
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi there,

I have a problem using my DIGITRADE DVB-T stick, which is marked as 
fully supported in the wiki. It works fine for a while, but after some 
time it crashes and I have to reboot and disconnect the stick to make it 
work again (for a while)

dmesg | grep af9015 says:

[   12.832866] dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick' in 
cold state, will try to load a firmware
[   13.059483] dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
[   13.133595] dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick' in 
warm state.
[   13.134316] DVB: registering new adapter (Afatech AF9015 DVB-T USB2.0 
stick)
[   13.837011] dvb-usb: Afatech AF9015 DVB-T USB2.0 stick successfully 
initialized and connected.
[   13.842692] usbcore: registered new interface driver dvb_usb_af9015
[  854.135480] af9015: bulk message failed:-22 (8/-1)
[  854.135488] af9015: bulk message failed:-22 (8/0)
[  854.135493] af9015: bulk message failed:-22 (9/0)
[  854.135498] af9015: bulk message failed:-22 (8/-30720)
[  854.135503] af9015: bulk message failed:-22 (8/-30720)
[  854.135508] af9015: bulk message failed:-22 (8/-1)
[ 1080.430165]  [<ffffffffa0416051>] af9015_usb_device_exit+0x41/0x60 
[dvb_usb_af9015]
[ 1200.431386]  [<ffffffffa0416051>] af9015_usb_device_exit+0x41/0x60 
[dvb_usb_af9015]
[ 1320.431408]  [<ffffffffa0416051>] af9015_usb_device_exit+0x41/0x60 
[dvb_usb_af9015]
[ 1440.430306]  [<ffffffffa0416051>] af9015_usb_device_exit+0x41/0x60 
[dvb_usb_af9015]
[ 1560.431363]  [<ffffffffa0416051>] af9015_usb_device_exit+0x41/0x60 
[dvb_usb_af9015]
[ 1680.430227]  [<ffffffffa0416051>] af9015_usb_device_exit+0x41/0x60 
[dvb_usb_af9015]
[ 1800.430167]  [<ffffffffa0416051>] af9015_usb_device_exit+0x41/0x60 
[dvb_usb_af9015]
[ 1920.430438]  [<ffffffffa0416051>] af9015_usb_device_exit+0x41/0x60 
[dvb_usb_af9015]
[ 2040.431407]  [<ffffffffa0416051>] af9015_usb_device_exit+0x41/0x60 
[dvb_usb_af9015]
[ 2160.430155]  [<ffffffffa0416051>] af9015_usb_device_exit+0x41/0x60 
[dvb_usb_af9015]
[ 6541.809955] af9015: bulk message failed:-22 (8/-30720)
[ 6573.722578] dvb-usb: Afatech AF9015 DVB-T USB2.0 stick successfully 
deinitialized and disconnected.
[ 6573.808899] usbcore: deregistering interface driver dvb_usb_af9015
[ 6574.452270] dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick' in 
warm state.
[ 6574.452777] DVB: registering new adapter (Afatech AF9015 DVB-T USB2.0 
stick)
[ 6575.033328] dvb-usb: Afatech AF9015 DVB-T USB2.0 stick successfully 
initialized and connected.
[ 6575.043645] usbcore: registered new interface driver dvb_usb_af9015
[73982.427778] af9015: bulk message failed:-22 (8/-1)
[73982.427785] af9015: bulk message failed:-22 (8/0)
[73982.427790] af9015: bulk message failed:-22 (9/0)
[73982.427795] af9015: bulk message failed:-22 (8/-30720)
[73982.427800] af9015: bulk message failed:-22 (8/-30720)
[73982.427805] af9015: bulk message failed:-22 (8/-1)

by looking at the dmesg, I found out a strange thing: an af9013 (yes, 
THREE at the end) device is recognized and registred also. dmesg | grep 
9013:

[   13.187955] af9013: firmware version:4.95.0
[   13.190955] DVB: registering adapter 0 frontend 0 (Afatech AF9013 
DVB-T)...
[  854.135485] af9013: I2C read failed reg:d417
[  854.135490] af9013: I2C read failed reg:d417
[  854.135500] af9013: I2C read failed reg:d417
[  854.135505] af9013: I2C read failed reg:d417
[  854.135510] af9013: I2C read failed reg:d730
[ 6574.458711] af9013: firmware version:4.95.0
[ 6574.463654] DVB: registering adapter 0 frontend 0 (Afatech AF9013 
DVB-T)...
[73982.427782] af9013: I2C read failed reg:d417
[73982.427787] af9013: I2C read failed reg:d417
[73982.427797] af9013: I2C read failed reg:d417
[73982.427802] af9013: I2C read failed reg:d417
[73982.427807] af9013: I2C read failed reg:d730

is anyone running this device stable and/or have an idea what i could do 
to get rid of the problem?

thanks,
David

