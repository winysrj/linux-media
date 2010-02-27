Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [130.149.205.37] (helo=mail.tu-berlin.de)
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <prjackson68@gmail.com>) id 1NlIKo-0002xE-RR
	for linux-dvb@linuxtv.org; Sat, 27 Feb 2010 09:47:40 +0100
Received: from mail-ew0-f220.google.com ([209.85.219.220])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-d) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1NlIKo-0001jI-3f; Sat, 27 Feb 2010 09:47:38 +0100
Received: by ewy20 with SMTP id 20so453688ewy.1
	for <linux-dvb@linuxtv.org>; Sat, 27 Feb 2010 00:47:36 -0800 (PST)
From: peter <prjackson68@gmail.com>
To: linux-dvb@linuxtv.org
Date: Sat, 27 Feb 2010 08:47:24 +0000
Message-ID: <1267260444.4176.31.camel@lisa>
Mime-Version: 1.0
Subject: [linux-dvb] Compro U80 Nearly there???
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

I'm running Ubuntu Karmic, and have a Compro U80 Device USB ID
185b:0150.

To get this close to working I have:

1) Added 50-udev.rules which seem to allow the device to be recognised.

2) Compiled the ~jhoogenraad/rtl2831-r2 version of the driver.

This gets me to the point where:
- /dev/dvb exists.
- my applications recognise the device

- In the log I see:

[   14.311735] dvb-usb: found a 'VideoMate U90' in warm state.
[   14.311743] dvb-usb: will pass the complete MPEG2 transport stream to
the software demuxer.
[   14.312131] DVB: registering new adapter (VideoMate U90)
[   14.312420] DVB: registering adapter 0 frontend 0 (Realtek RTL2831
DVB-T)...
[   14.312521] input: IR-receiver inside an USB DVB receiver
as /devices/pci0000:00/0000:00:02.1/usb1/1-1/input/input5
[   14.312552] dvb-usb: schedule remote query interval to 300 msecs.
[   14.312558] dvb-usb: VideoMate U90 successfully initialized and
connected.
[   14.312589] usbcore: registered new interface driver dvb_usb_rtd2831u

So looking good so far.


However, if i used scan, or an application like Kaffeine tuning fails. I
know that the device works as I can get it to work on windows.

So I have been looking at the RTL2831U data sheets which I know from the
windows driver that this is based on. (I don't know much about this
hardware I am trying to figure it out ). So this chip is just doing the
demodulating and the USB interface. It must therefore be paired with
tuner.  It seems logical to me (but is possibly wrong ) that if the
demodulator is working and I cant tune, then the issue is with the tuner
part of the driver. The windows drivers refer to both the MT2060 and the
QT1010, but I don't know which one is being used. (I have not had the
guts to rip the thing apart yet). Docu in the code of for the driver
implies that it can support the MT2060 but not the QT1010 so I guess
with my luck it is the quantec one. 

Has any one got any advice as to where I should look next? Has anyone
got this to work? It seems to be quite close. I any suggestions would be
appreciated.
Thanks
Peter


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
