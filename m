Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-fx0-f228.google.com ([209.85.220.228])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <alexander.saers@gmail.com>) id 1MeU4L-0000rl-4Q
	for linux-dvb@linuxtv.org; Fri, 21 Aug 2009 15:22:14 +0200
Received: by fxm28 with SMTP id 28so455185fxm.17
	for <linux-dvb@linuxtv.org>; Fri, 21 Aug 2009 06:21:40 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 21 Aug 2009 15:21:39 +0200
Message-ID: <7606f7c10908210621r77acf304g1c921396a566399a@mail.gmail.com>
From: Alexander Saers <alex@saers.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Anysee E30 Combo Plus startup mode
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1673908694=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1673908694==
Content-Type: multipart/alternative; boundary=0003255596869a111f0471a6bfad

--0003255596869a111f0471a6bfad
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello

I have a Anysee E30 Combo Plus USB device. It's capable of both DVB-C and
DVB-T. I currently use the device with ubuntu 9.04 64bit with mythtv. I have
problem with selction of mode for the device

The following way i can get DVB-T
1. Power up computer with E30 Combo Plus connected.
2. run dmesg
<dmesg shows>
...
[   12.254209] dvb-usb: found a 'Anysee DVB USB2.0' in warm state.
[   12.254356] dvb-usb: will pass the complete MPEG2 transport stream to the
software demuxer.
[   12.255832] DVB: registering new adapter (Anysee DVB USB2.0)
[   12.259593] anysee: firmware version:0.1.2 hardware id:15
[   12.276531] generic-usb 0003:046D:C505.0002: input,hidraw1: USB HID v1.10
Mouse [Logitech USB Receiver] on usb-0000:00:04.0-3/input1
[   12.276610] usbcore: registered new interface driver usbhid
[   12.276690] usbhid: v2.6:USB HID core driver
[   12.392415] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353
DVB-T)...
[   12.428278] input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00: 04.1/usb1/1-2/input/input6
[   12.460271] dvb-usb: schedule remote query interval to 200 msecs.
[   12.460284] dvb-usb: Anysee DVB USB2.0 successfully initialized and
connected.
[   12.463685] usbcore: registered new interface driver dvb_usb_anysee
...
</dmesg shows>
3. rmod dvb_usb_anysee
4. modprobe dvb_usb_anysee delsys=0
5. run dmesg -> stil dvb-t :(


The following way i can get DVB-C. But its kind of anoying to remove the
device during every boot.
1. Power up computer with E30 Combo Plus disconnected.
2. Wait until everything has loaded and gdm is seen on the monitor
3. Connect the E30 Combo Plus.
4. Device is detected as a DVB-C device
5. dmesg
<dmesg shows>
[   64.464258] dvb-usb: found a 'Anysee DVB USB2.0' in warm state.
[   64.464356] dvb-usb: will pass the complete MPEG2 transport stream to the
software demuxer.
[   64.464601] DVB: registering new adapter (Anysee DVB USB2.0)
[   64.469473] anysee: firmware version:0.1.2 hardware id:15
[   64.564746] DVB: registering adapter 0 frontend 0 (Philips TDA10023
DVB-C)...
[   64.597789] input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:04.1/usb1/1-2/input/input6
[   64.628139] dvb-usb: schedule remote query interval to 200 msecs.
[   64.628149] dvb-usb: Anysee DVB USB2.0 successfully initialized and
connected.
[   64.634715] usbcore: registered new interface driver dvb_usb_anysee

</dmesg shows>

Anyone experienced this problem? It would be nice to run DVB-C without
having to disconnect and connect hardware.

Br
Alexander

--0003255596869a111f0471a6bfad
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello<br><br>I have a Anysee E30 Combo Plus USB device. It&#39;s capable of
both DVB-C and DVB-T. I currently use the device with ubuntu 9.04 64bit
with mythtv. I have problem with selction of mode for the device<br><br>The=
 following way i can get DVB-T<br>
1. Power up computer with E30 Combo Plus connected.<br>2. run dmesg<br>&lt;=
dmesg shows&gt;<br>...<br>[=A0=A0 12.254209] dvb-usb: found a &#39;Anysee D=
VB USB2.0&#39; in warm state.<br>[=A0=A0 12.254356] dvb-usb: will pass the =
complete MPEG2 transport stream to the software demuxer.<br>


[=A0=A0 12.255832] DVB: registering new adapter (Anysee DVB USB2.0)<br>[=A0=
=A0 12.259593] anysee: firmware version:0.1.2 hardware id:15<br>[=A0=A0
12.276531] generic-usb 0003:046D:C505.0002: input,hidraw1: USB HID
v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:04.0-3/input1<br>
[=A0=A0 12.276610] usbcore: registered new interface driver usbhid<br>[=A0=
=A0 12.276690] usbhid: v2.6:USB HID core driver<br>[=A0=A0 12.392415] DVB: =
registering adapter 0 frontend 0 (Zarlink ZL10353 DVB-T)...<br>[=A0=A0 12.4=
28278] input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00=
/0000:00:
04.1/usb1/1-2/input/input6<br>
[=A0=A0 12.460271] dvb-usb: schedule remote query interval to 200 msecs.<br=
>[=A0=A0 12.460284] dvb-usb: Anysee DVB USB2.0 successfully initialized and=
 connected.<br>[=A0=A0 12.463685] usbcore: registered new interface driver =
dvb_usb_anysee<br>


...<br>&lt;/dmesg shows&gt;<br>3. rmod dvb_usb_anysee<br>4. modprobe dvb_us=
b_anysee delsys=3D0<br>5. run dmesg -&gt; stil dvb-t :(<br><br><br>The foll=
owing way i can get DVB-C. But its kind of anoying to remove the device dur=
ing every boot.<br>


1. Power up computer with E30 Combo Plus disconnected.<br>2. Wait until eve=
rything has loaded and gdm is seen on the monitor<br>3. Connect the E30 Com=
bo Plus.<br>4. Device is detected as a DVB-C device<br>5. dmesg<br>&lt;dmes=
g shows&gt;<br>


[=A0=A0 64.464258] dvb-usb: found a &#39;Anysee DVB USB2.0&#39; in warm sta=
te.<br>[=A0=A0 64.464356] dvb-usb: will pass the complete MPEG2 transport s=
tream to the software demuxer.<br>[=A0=A0 64.464601] DVB: registering new a=
dapter (Anysee DVB USB2.0)<br>


[=A0=A0 64.469473] anysee: firmware version:0.1.2 hardware id:15<br>[=A0=A0=
 64.564746] DVB: registering adapter 0 frontend 0 (Philips TDA10023 DVB-C).=
..<br>[=A0=A0 64.597789] input: IR-receiver inside an USB DVB receiver as /=
devices/pci0000:00/0000:00:<div>
04.1/usb1/1-2/input/input6<br>

[=A0=A0 64.628139] dvb-usb: schedule remote query interval to 200 msecs.<br=
>[=A0=A0 64.628149] dvb-usb: Anysee DVB USB2.0 successfully initialized and=
 connected.<br>[=A0=A0 64.634715] usbcore: registered new interface driver =
dvb_usb_anysee<br>


<br>&lt;/dmesg shows&gt;<br><br>Anyone experienced this problem? It would b=
e nice to run DVB-C without having to disconnect and connect hardware.<br><=
br>Br<br>Alexander</div>

--0003255596869a111f0471a6bfad--


--===============1673908694==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1673908694==--
