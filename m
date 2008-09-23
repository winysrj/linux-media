Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web52908.mail.re2.yahoo.com ([206.190.49.18])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <rankincj@yahoo.com>) id 1KiEIm-0003r0-4N
	for linux-dvb@linuxtv.org; Tue, 23 Sep 2008 22:16:05 +0200
Date: Tue, 23 Sep 2008 13:15:29 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <902525.49080.qm@web52908.mail.re2.yahoo.com>
Subject: [linux-dvb] Hauppauge DVB USB2 Nova-TD stick - report.
Reply-To: rankincj@yahoo.com
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
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

Hi,

I have just bought a Hauppauge Nova-TD "Diversity" USB2 stick; here is my initial report with the 2.6.26.4 kernel.

The device is based on the dib0700:

dvb_usb_dib0700        27784  0 
dib7000p               14472  3 dvb_usb_dib0700
dib7000m               13700  1 dvb_usb_dib0700
dvb_usb                14988  1 dvb_usb_dib0700
dib3000mc              11400  1 dvb_usb_dib0700
dibx000_common          3972  3 dib7000p,dib7000m,dib3000mc
dib0070                 7044  3 dvb_usb_dib0700

and gives me two DVB adapter device nodes. Here is the USB device descriptor:

T:  Bus=01 Lev=01 Prnt=01 Port=04 Cnt=02 Dev#=  9 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=2040 ProdID=5200 Rev= 0.01
S:  Manufacturer=Hauppauge
S:  Product=NovaT 500Stick
S:  SerialNumber=4031576243
C:* #Ifs= 1 Cfg#= 1 Atr=a0 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 4 Cls=ff(vend.) Sub=00 Prot=00 Driver=dvb_usb_dib0700
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=125us
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=83(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms

I was surprised to see it reported as product 0x5200 because I bought a Nova-T device several years ago which was product 0x9301. My Nova-TD device comes with a remote control, but no event node was created for it until I hacked the following lines into dib0700_devices.c:

                .rc_interval      = DEFAULT_RC_INTERVAL,
                .rc_key_map       = dib0700_rc_keys,
                .rc_key_map_size  = ARRAY_SIZE(dib0700_rc_keys),
                .rc_query         = dib0700_rc_query

With these lines added, I now see the following messages in my dmesg log:

usb 1-5: new high speed USB device using ehci_hcd and address 9
usb 1-5: configuration #1 chosen from 1 choice
dib0700: loaded with support for 7 different device-types
dvb-usb: found a 'Hauppauge Nova-TD Stick (52009)' in cold state, will try to load a firmware
firmware: requesting dvb-usb-dib0700-1.10.fw
dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.10.fw'
dib0700: firmware started successfully.
dvb-usb: found a 'Hauppauge Nova-TD Stick (52009)' in warm state.
i2c-adapter i2c-1: SMBus Quick command not supported, can't probe for chips
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (Hauppauge Nova-TD Stick (52009))
i2c-adapter i2c-2: SMBus Quick command not supported, can't probe for chips
DVB: registering frontend 1 (DiBcom 7000PC)...
DiB0070: successfully identified
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (Hauppauge Nova-TD Stick (52009))
i2c-adapter i2c-3: SMBus Quick command not supported, can't probe for chips
DVB: registering frontend 2 (DiBcom 7000PC)...
DiB0070: successfully identified
input: IR-receiver inside an USB DVB receiver as /class/input/input7
dvb-usb: schedule remote query interval to 150 msecs.
dvb-usb: Hauppauge Nova-TD Stick (52009) successfully initialized and connected.
usbcore: registered new interface driver dvb_usb_dib0700

I have successfully created a channels.conf file using scandvb with each of these adapters, and I understand that "diversity" mode is not (yet?) supported.  Also, the remote control that comes with my Nova-T (0x9301) is successfully controlling my VDR application, despite the fact that the VDR is actually talking to the 0x5200 device instead.

The firmware file that I am using has the following MD5 sum:
$ md5sum /lib/firmware/dvb-usb-dib0700-1.10.fw 
5878ebfcba2d8deb90b9120eb89b02da  /lib/firmware/dvb-usb-dib0700-1.10.fw

Hopefully, this should help future kernels support this stick slightly better :-).
Cheers,
Chris



      

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
