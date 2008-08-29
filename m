Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 203.161.84.42.static.amnet.net.au ([203.161.84.42]
	helo=goeng.com.au) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tom@goeng.com.au>) id 1KYrTz-0002zo-Ma
	for linux-dvb@linuxtv.org; Fri, 29 Aug 2008 02:04:57 +0200
From: "Thomas Goerke" <tom@goeng.com.au>
To: "'Devin Heitmueller'" <devin.heitmueller@gmail.com>
References: <004f01c90921$248fe2b0$6dafa810$@com.au>	
	<412bdbff0808280824s288de72el297dda0556d6ca4d@mail.gmail.com>	
	<007f01c90965$344da360$9ce8ea20$@com.au>
	<412bdbff0808281638h7e911b37n4d5043bf40b42d65@mail.gmail.com>
In-Reply-To: <412bdbff0808281638h7e911b37n4d5043bf40b42d65@mail.gmail.com>
Date: Fri, 29 Aug 2008 08:05:25 +0800
Message-ID: <008001c9096a$f315df10$d9419d30$@com.au>
MIME-Version: 1.0
Content-Language: en-au
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Hauppauge WinTV-NOVA-T-500 New Firmware
	(dvb-usb-dib0700-1.20.fw) causes problems
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

> 
> Hmmm...  You're the second person to see that behavior.  Weird.
> 
> Did you apply the patch I sent out for the driver as well, or did you
> just replace the firmware file?
> 
> Devin
> 
> 
> --
> Devin J. Heitmueller
> http://www.devinheitmueller.com
> AIM: devinheitmueller

Devin,

I did a little more debugging and it seems that the I still have a problem
with the .20 version.  However, you only see it after a cold reset ie when
you need to load the firmware.  See below for the first dmesg which is with
the .20 firmware.  As you can see the card is found but only in a cold
state.  The second dmesg is with the .10 firmware and the card is found
firstly in a cold state and then in a warm state.  Each of these dmesg
outputs have been after a power off from the power supply for 10 seconds ie
no power to backplane.

.20 Firmware - Not working:
[   33.016231] dib0700: loaded with support for 7 different device-types
[   33.016463] dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in cold
state, will try to load a firmware
--
[   33.071378] dvb-usb: downloading firmware from file
'dvb-usb-dib0700-1.10.fw'
[   33.080751] input,hiddev96,hidraw1: USB HID v1.11 Mouse [Logitech
Logitech BT Mini-Receiver] on usb-0000:00:1a.2-2.3
[   33.080763] usbcore: registered new interface driver usbhid
[   33.080771] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   33.277932] usbcore: registered new interface driver dvb_usb_dib0700
[   33.611862] lp: driver loaded but no devices found
[   33.656757] w83627ehf: Found W83627DHG chip at 0x290
[   33.679680] coretemp coretemp.0: Using undocumented features, absolute
temperature might be wrong!
[   33.679707] coretemp coretemp.1: Using undocumented features, absolute
temperature might be wrong!
[   33.889981] Adding 9847804k swap on /dev/sda5.  Priority:-1 extents:1
across:9847804k
[   34.561845] EXT3 FS on sda1, internal journal 


.10 Firmware Working:
[   32.242798] dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in cold
state, will try to load a firmware
[   32.275449] Linux video capture interface: v2.00
--
[   32.316276] dvb-usb: downloading firmware from file
'dvb-usb-dib0700-1.10.fw'
--
[   32.659286] dib0700: firmware started successfully.
--
[   33.159764] dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in warm
state.
[   33.159793] dvb-usb: will pass the complete MPEG2 transport stream to the
software demuxer.
[   33.159925] DVB: registering new adapter (Hauppauge Nova-T 500 Dual
DVB-T)
[   33.273283] DVB: registering frontend 1 (DiBcom 3000MC/P)...
[   33.312133] MT2060: successfully identified (IF1 = 1258)
[   33.786468] dvb-usb: will pass the complete MPEG2 transport stream to the
software demuxer.
[   33.786660] DVB: registering new adapter (Hauppauge Nova-T 500 Dual
DVB-T)
[   33.792214] DVB: registering frontend 2 (DiBcom 3000MC/P)...
[   33.796959] MT2060: successfully identified (IF1 = 1255)
[   34.352045] input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:1e.0/0000:05:00.2/usb9/9-1/input/input6
[   34.378748] dvb-usb: schedule remote query interval to 150 msecs.
[   34.378750] dvb-usb: Hauppauge Nova-T 500 Dual DVB-T successfully
initialized and connected.

Files:
ls -al /lib/firmware
-rw-r--r--  1 root root  34306 2008-08-29 07:38 dvb-usb-dib0700-1.10.fw
-rw-r--r--  1 root root  34306 2008-08-28 09:11
dvb-usb-dib0700-1.10.fw.original
-rw-r--r--  1 root root  33768 2008-08-28 09:10 dvb-usb-dib0700-1.20.fw

I have not applied the patch as I followed instructions on
http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-NOVA-T-500 which doesnt
mention this.  I am using the latest v4l-dvb source. 

I can apply the patch to test if required.  Can you please let me know where
this is and I will try it.

Tom


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
