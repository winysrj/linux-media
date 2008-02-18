Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hyatt.suomi.net ([82.128.152.22])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1JRE7z-0003Ug-JF
	for linux-dvb@linuxtv.org; Mon, 18 Feb 2008 23:06:23 +0100
Received: from tiku.suomi.net ([82.128.154.67])
	by hyatt.suomi.net (Sun Java System Messaging Server 6.2-3.04 (built
	Jul 15 2005)) with ESMTP id <0JWG007FAG1P0B40@hyatt.suomi.net> for
	linux-dvb@linuxtv.org; Tue, 19 Feb 2008 00:05:49 +0200 (EET)
Received: from spam2.suomi.net (spam2.suomi.net [212.50.131.166])
	by mailstore.suomi.net
	(Sun Java(tm) System Messaging Server 6.3-4.01 (built Aug  3 2007;
	32bit)) with ESMTP id <0JWG00FA4G1P8R10@mailstore.suomi.net> for
	linux-dvb@linuxtv.org; Tue, 19 Feb 2008 00:05:49 +0200 (EET)
Date: Tue, 19 Feb 2008 00:05:17 +0200
From: Antti Palosaari <crope@iki.fi>
In-reply-to: <ea4209750802181306tcc8c98clff330d4289523d96@mail.gmail.com>
To: Albert Comerma <albert.comerma@gmail.com>
Message-id: <47BA011D.9060003@iki.fi>
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_PG+JS7lLWWg1gSVt20nrJQ)"
References: <ea4209750801161224p6b75d7fanbdcd29e7d367802d@mail.gmail.com>
	<47B9D533.7050504@iki.fi>
	<ea4209750802181306tcc8c98clff330d4289523d96@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Yuan EC372S (STK7700D based device)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--Boundary_(ID_PG+JS7lLWWg1gSVt20nrJQ)
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT

moi
It does not work for me. It says same PID-filter timeout as I have got 
earlier. I don't have amplified antenna now, but I can say that all 
other DVB-T sticks I have are working with this small antenna. It could 
be that sensitivity of this hardware is bad or there is something wrong 
with driver or firmware. Lets try to test it Windows to see if it is 
working or not.
Logs attached.

regards
Antti

Albert Comerma wrote:
> Hey people, we already solved this problems. I submitted a patch a few 
> days ago, but I think it's not on the current sources. I send again the 
> patch. Basically it must use the same frontend description as asus cards.
> 
> Albert
> 
> 2008/2/18, Antti Palosaari <crope@iki.fi <mailto:crope@iki.fi>>:
> 
>     moikka
>     I have also this device (express card). I haven't looked inside yet, but
>     I think there is DibCOM STK7700D (in my understanding dual demod chip)
>     and only *one* MT2266 tuner. I tried various GPIO settings but no
>     luck yet.
>     GPIO6 is for MT2266.
>     GPIO9 and GPIO10 are for frontend.
> 
>     Looks like tuner goes to correct frequency because I got always
>     PID-filter timeouts when tuning to correct freq. I will now try to take
>     some usb-sniffs to see configuration used. Any help is welcome.
> 
>     regards
>     Antti
> 
>     Albert Comerma wrote:
>      > Hi!, with Michel (mm-sl@ibelgique.com
>     <mailto:mm-sl@ibelgique.com> <mailto:mm-sl@ibelgique.com
>     <mailto:mm-sl@ibelgique.com>>) who
> 
>      > is a owner of this Yuan card we added the device to
>     dib0700_devices, and
>      > we got it recognized without problems. The only problem is that no
>      > channel is detected on scan on kaffeine or other software... I
>     post some
>      > dmesg. We don't know where it may be the problem... or how to
>     detect it...
>      >
>      > usb 4-2: new high speed USB device using ehci_hcd and address 6
>      > usb 4-2: new device found, idVendor=1164, idProduct=1edc
>      > usb 4-2: new device strings: Mfr=1, Product=2, SerialNumber=3
>      > usb 4-2: Product: STK7700D
>      > usb 4-2: Manufacturer: YUANRD
>      > usb 4-2: SerialNumber: 0000000001
>      > usb 4-2: configuration #1 chosen from 1 choice
>      > dvb-usb: found a 'Yuan EC372S' in cold state, will try to load a
>     firmware
>      > dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.10.fw'
>      > dib0700: firmware started successfully.
>      > dvb-usb: found a 'Yuan EC372S' in warm state.
>      > dvb-usb: will pass the complete MPEG2 transport stream to the
>     software
>      > demuxer.
>      > DVB: registering new adapter (Yuan EC372S)
>      > dvb-usb: no frontend was attached by 'Yuan EC372S'
>      > dvb-usb: will pass the complete MPEG2 transport stream to the
>     software
>      > demuxer.
>      > DVB: registering new adapter (Yuan EC372S)
>      > DVB: registering frontend 1 (DiBcom 7000PC)...
>      > MT2266: successfully identified
>      > input: IR-receiver inside an USB DVB receiver as /class/input/input10
>      > dvb-usb: schedule remote query interval to 150 msecs.
>      > dvb-usb: Yuan EC372S successfully initialized and connected.
>      >
>      >
> 
>      >
>     ------------------------------------------------------------------------
>      >
>      > _______________________________________________
>      > linux-dvb mailing list
>      > linux-dvb@linuxtv.org <mailto:linux-dvb@linuxtv.org>
>      > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 
> 
> 
>     --
>     http://palosaari.fi/
> 
> 
> 
> ------------------------------------------------------------------------
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


-- 
http://palosaari.fi/

--Boundary_(ID_PG+JS7lLWWg1gSVt20nrJQ)
Content-type: text/plain; name=lsusb_Yuan_EC372S.txt
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=lsusb_Yuan_EC372S.txt


Bus 001 Device 005: ID 1164:1edc YUAN High-Tech Development Co., Ltd 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x1164 YUAN High-Tech Development Co., Ltd
  idProduct          0x1edc 
  bcdDevice            1.00
  iManufacturer           1 YUANRD
  iProduct                2 STK7700D
  iSerial                 3 0000000001
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           46
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xa0
      Remote Wakeup
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           4
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  bNumConfigurations      1

--Boundary_(ID_PG+JS7lLWWg1gSVt20nrJQ)
Content-type: text/plain; name=Yuan_EC372S.txt
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=Yuan_EC372S.txt

Feb 18 23:50:53 localhost kernel: usb 1-8: USB disconnect, address 5
Feb 18 23:50:55 localhost kernel: usb 1-8: new high speed USB device using ehci_hcd and address 6
Feb 18 23:50:55 localhost kernel: usb 1-8: configuration #1 chosen from 1 choice
Feb 18 23:50:55 localhost kernel: dib0700: loaded with support for 6 different device-types
Feb 18 23:50:55 localhost kernel: dvb-usb: found a 'Yuan EC372S' in cold state, will try to load a firmware
Feb 18 23:50:55 localhost kernel: dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.10.fw'
Feb 18 23:50:55 localhost kernel: dib0700: firmware started successfully.
Feb 18 23:50:56 localhost kernel: dvb-usb: found a 'Yuan EC372S' in warm state.
Feb 18 23:50:56 localhost kernel: dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
Feb 18 23:50:56 localhost kernel: DVB: registering new adapter (Yuan EC372S)
Feb 18 23:50:56 localhost kernel: DVB: registering frontend 0 (DiBcom 7000PC)...
Feb 18 23:50:56 localhost kernel: MT2266: successfully identified
Feb 18 23:50:56 localhost kernel: dvb-usb: Yuan EC372S successfully initialized and connected.
Feb 18 23:50:56 localhost kernel: usbcore: registered new interface driver dvb_usb_dib0700

[crope@localhost linuxtv]$ scandvb fi-Oulu 
scanning fi-Oulu
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 634000000 0 2 9 3 1 2 0
initial transponder 714000000 0 2 9 3 1 2 0
initial transponder 738000000 0 2 9 3 1 2 0
initial transponder 602000000 0 2 9 3 1 2 0
>>> tune to: 634000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
>>> tune to: 714000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
>>> tune to: 738000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
>>> tune to: 602000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
dumping lists (0 services)
Done.
[crope@localhost linuxtv]$ 


--Boundary_(ID_PG+JS7lLWWg1gSVt20nrJQ)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary_(ID_PG+JS7lLWWg1gSVt20nrJQ)--
