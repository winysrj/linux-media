Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from srv6.sysproserver.de ([78.47.47.66])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <m740@wagner-budenheim.de>) id 1KXLTL-0008F5-Lm
	for linux-dvb@linuxtv.org; Sun, 24 Aug 2008 21:42:01 +0200
Received: from [192.168.254.4] (dslb-084-059-168-001.pools.arcor-ip.net
	[84.59.168.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by srv6.sysproserver.de (Postfix) with ESMTP id 4C781403289
	for <linux-dvb@linuxtv.org>; Sun, 24 Aug 2008 21:41:55 +0200 (CEST)
Message-ID: <48B1B979.7060205@wagner-budenheim.de>
Date: Sun, 24 Aug 2008 21:41:45 +0200
From: "Dirk E. Wagner" <m740@wagner-budenheim.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <mailman.705.1219358478.3928.linux-dvb@linuxtv.org>
In-Reply-To: <mailman.705.1219358478.3928.linux-dvb@linuxtv.org>
Subject: [linux-dvb] Still USB diasconnect and i2c reead errors with
	dvb-usb-dib0700-1.20.fw
Reply-To: m740@wagner-budenheim.de
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

Hello,

the new firmware dvb-usb-dib0700-1.20.fw does not solve the usb =

disconnect und i2c read/write errors.
With 1.10 I had 1-2 i2c rw-errors per month. Now I have 1-2 rw-errors =

per day.

I'm using kernel 2.6.26.1 with dvb-usb-dib0700-1.20.fw.
Hardware is Hauppauge Nova-TD Stick, Mobo MSI KT4-V (Via KT400)

Aug 24 08:29:39 etch-server kernel: dib0700: loaded with support for 7 =

different device-types
Aug 24 08:29:39 etch-server kernel: dvb-usb: found a 'Hauppauge Nova-TD =

Stick/Elgato Eye-TV Diversity' in cold state, will try to load a firmware
Aug 24 08:29:39 etch-server kernel: firmware: requesting =

dvb-usb-dib0700-1.20.fw
Aug 24 08:29:39 etch-server kernel: dvb-usb: downloading firmware from =

file 'dvb-usb-dib0700-1.20.fw'
Aug 24 08:29:39 etch-server kernel: dib0700: firmware started successfully.
Aug 24 08:29:39 etch-server kernel: dvb-usb: found a 'Hauppauge Nova-TD =

Stick/Elgato Eye-TV Diversity' in warm state.
Aug 24 08:29:39 etch-server kernel: dvb-usb: will pass the complete =

MPEG2 transport stream to the software demuxer.
Aug 24 08:29:39 etch-server kernel: DVB: registering new adapter =

(Hauppauge Nova-TD Stick/Elgato Eye-TV Diversity)
Aug 24 08:29:39 etch-server kernel: DVB: registering frontend 0 (DiBcom =

7000PC)...
Aug 24 08:29:39 etch-server kernel: MT2266: successfully identified
Aug 24 08:29:39 etch-server kernel: dvb-usb: will pass the complete =

MPEG2 transport stream to the software demuxer.
Aug 24 08:29:39 etch-server kernel: DVB: registering new adapter =

(Hauppauge Nova-TD Stick/Elgato Eye-TV Diversity)
Aug 24 08:29:39 etch-server kernel: DVB: registering frontend 1 (DiBcom =

7000PC)...
Aug 24 08:29:39 etch-server kernel: MT2266: successfully identified
Aug 24 08:29:39 etch-server kernel: dvb-usb: Hauppauge Nova-TD =

Stick/Elgato Eye-TV Diversity successfully initialized and connected.
Aug 24 08:29:39 etch-server kernel: usbcore: registered new interface =

driver dvb_usb_dib0700
[...]
Aug 24 10:33:48 etch-server kernel: usb 1-6: USB disconnect, address 3
Aug 24 10:33:48 etch-server kernel: MT2266 I2C write failed
Aug 24 10:33:48 etch-server kernel: MT2266 I2C write failed
Aug 24 10:34:08 etch-server vdr: [3160] ERROR: frontend 0: Kein =

passendes Ger=C3=A4t gefunden
Aug 24 10:34:08 etch-server kernel: MT2266 I2C write failed (len=3D9)
Aug 24 10:34:08 etch-server kernel: MT2266 I2C write failed (len=3D4)
Aug 24 10:34:08 etch-server kernel: MT2266 I2C write failed (len=3D3)
Aug 24 10:34:08 etch-server kernel: MT2266 I2C read failed
Aug 24 10:34:08 etch-server last message repeated 8 times
Aug 24 10:34:08 etch-server kernel: dvb-usb: error while stopping stream.
Aug 24 10:34:08 etch-server kernel: MT2266 I2C read failed
Aug 24 10:34:09 etch-server kernel: dvb-usb: error while stopping stream.
Aug 24 10:34:10 etch-server vdr: [3181] ERROR: can't set filter (pid=3D18, =

tid=3D4E, mask=3DFE): Kein passendes Ger=C3=A4t gefunden
Aug 24 10:34:10 etch-server kernel: dvb-usb: could not submit URB no. 0 =

- get them all back
Aug 24 10:34:10 etch-server kernel: dvb-usb: error while enabling fifo.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
