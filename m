Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.153])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <albert.comerma@gmail.com>) id 1JRFRQ-00088S-Q5
	for linux-dvb@linuxtv.org; Tue, 19 Feb 2008 00:30:32 +0100
Received: by fg-out-1718.google.com with SMTP id 22so1457799fge.25
	for <linux-dvb@linuxtv.org>; Mon, 18 Feb 2008 15:30:29 -0800 (PST)
Message-ID: <ea4209750802181530p7bd2ec78j562e7fdf281890b5@mail.gmail.com>
Date: Tue, 19 Feb 2008 00:30:29 +0100
From: "Albert Comerma" <albert.comerma@gmail.com>
To: "Antti Palosaari" <crope@iki.fi>
In-Reply-To: <47BA0C4D.4070102@iki.fi>
MIME-Version: 1.0
References: <ea4209750801161224p6b75d7fanbdcd29e7d367802d@mail.gmail.com>
	<47B9D533.7050504@iki.fi>
	<ea4209750802181306tcc8c98clff330d4289523d96@mail.gmail.com>
	<47BA011D.9060003@iki.fi>
	<ea4209750802181424q4ac90c7ag33ad8b8d79e258fd@mail.gmail.com>
	<47BA0C4D.4070102@iki.fi>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Yuan EC372S (STK7700D based device)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1917980720=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1917980720==
Content-Type: multipart/alternative;
	boundary="----=_Part_854_25842819.1203377429501"

------=_Part_854_25842819.1203377429501
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

It seems ok. Could you test a scan with kaffeine instead of looking for a
specific location? And if you do so it reports signal strenght?
By the way, what does it mean moi and moikka? Hello in finish?

Albert

2008/2/18, Antti Palosaari <crope@iki.fi>:
>
> latest v4l-master + patch you give.
>
>
> regards
> Antti
>
> Albert Comerma wrote:
>
> > Uhm... that's strange, I don't have any of this cards to test, but other
> > people reported that this solution was working. Could you post the
> > dib0700_devices.c you're using to have a look?
> >
> > Albert
> >
>
> > 2008/2/18, Antti Palosaari <crope@iki.fi <mailto:crope@iki.fi>>:
>
> >
> >     moi
> >     It does not work for me. It says same PID-filter timeout as I have
> got
> >     earlier. I don't have amplified antenna now, but I can say that all
> >     other DVB-T sticks I have are working with this small antenna. It
> could
> >     be that sensitivity of this hardware is bad or there is something
> wrong
> >     with driver or firmware. Lets try to test it Windows to see if it is
> >     working or not.
> >     Logs attached.
> >
> >
> >     regards
> >     Antti
> >
> >     Albert Comerma wrote:
> >
> >      > Hey people, we already solved this problems. I submitted a patch
> >     a few
> >      > days ago, but I think it's not on the current sources. I send
> >     again the
> >      > patch. Basically it must use the same frontend description as
> >     asus cards.
> >      >
> >      > Albert
> >      >
> >
> >      > 2008/2/18, Antti Palosaari <crope@iki.fi <mailto:crope@iki.fi>
>
> >     <mailto:crope@iki.fi <mailto:crope@iki.fi>>>:
>
> >
> >      >
> >      >     moikka
> >      >     I have also this device (express card). I haven't looked
> >     inside yet, but
> >      >     I think there is DibCOM STK7700D (in my understanding dual
> >     demod chip)
> >      >     and only *one* MT2266 tuner. I tried various GPIO settings
> but no
> >      >     luck yet.
> >      >     GPIO6 is for MT2266.
> >      >     GPIO9 and GPIO10 are for frontend.
> >      >
> >      >     Looks like tuner goes to correct frequency because I got
> always
> >      >     PID-filter timeouts when tuning to correct freq. I will now
> >     try to take
> >      >     some usb-sniffs to see configuration used. Any help is
> welcome.
> >      >
> >      >     regards
> >      >     Antti
> >      >
> >      >     Albert Comerma wrote:
> >      >      > Hi!, with Michel (mm-sl@ibelgique.com
> >     <mailto:mm-sl@ibelgique.com>
> >
> >      >     <mailto:mm-sl@ibelgique.com <mailto:mm-sl@ibelgique.com>>
> >     <mailto:mm-sl@ibelgique.com <mailto:mm-sl@ibelgique.com>
> >
>
> >      >     <mailto:mm-sl@ibelgique.com <mailto:mm-sl@ibelgique.com>>>)
> who
>
> >      >
> >      >      > is a owner of this Yuan card we added the device to
> >      >     dib0700_devices, and
> >      >      > we got it recognized without problems. The only problem is
> >     that no
> >      >      > channel is detected on scan on kaffeine or other
> software... I
> >      >     post some
> >      >      > dmesg. We don't know where it may be the problem... or how
> to
> >      >     detect it...
> >      >      >
> >      >      > usb 4-2: new high speed USB device using ehci_hcd and
> >     address 6
> >      >      > usb 4-2: new device found, idVendor=1164, idProduct=1edc
> >      >      > usb 4-2: new device strings: Mfr=1, Product=2,
> SerialNumber=3
> >      >      > usb 4-2: Product: STK7700D
> >      >      > usb 4-2: Manufacturer: YUANRD
> >      >      > usb 4-2: SerialNumber: 0000000001
> >      >      > usb 4-2: configuration #1 chosen from 1 choice
> >      >      > dvb-usb: found a 'Yuan EC372S' in cold state, will try to
> >     load a
> >      >     firmware
> >      >      > dvb-usb: downloading firmware from file
> >     'dvb-usb-dib0700-1.10.fw'
> >      >      > dib0700: firmware started successfully.
> >      >      > dvb-usb: found a 'Yuan EC372S' in warm state.
> >      >      > dvb-usb: will pass the complete MPEG2 transport stream to
> the
> >      >     software
> >      >      > demuxer.
> >      >      > DVB: registering new adapter (Yuan EC372S)
> >      >      > dvb-usb: no frontend was attached by 'Yuan EC372S'
> >      >      > dvb-usb: will pass the complete MPEG2 transport stream to
> the
> >      >     software
> >      >      > demuxer.
> >      >      > DVB: registering new adapter (Yuan EC372S)
> >      >      > DVB: registering frontend 1 (DiBcom 7000PC)...
> >      >      > MT2266: successfully identified
> >      >      > input: IR-receiver inside an USB DVB receiver as
> >     /class/input/input10
> >      >      > dvb-usb: schedule remote query interval to 150 msecs.
> >      >      > dvb-usb: Yuan EC372S successfully initialized and
> connected.
> >      >      >
> >      >      >
> >      >
> >      >      >
> >      >
> >
> ------------------------------------------------------------------------
> >      >      >
> >      >      > _______________________________________________
> >      >      > linux-dvb mailing list
> >
> >      >      > linux-dvb@linuxtv.org <mailto:linux-dvb@linuxtv.org>
>
> >     <mailto:linux-dvb@linuxtv.org <mailto:linux-dvb@linuxtv.org>>
>
> >
> >      >      > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >      >
> >      >
> >      >
> >      >     --
> >      >     http://palosaari.fi/
> >      >
> >      >
> >      >
> >      >
> >
> ------------------------------------------------------------------------
> >      >
> >      > _______________________________________________
> >      > linux-dvb mailing list
> >      > linux-dvb@linuxtv.org <mailto:linux-dvb@linuxtv.org>
> >      > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >
> >
> >     --
> >     http://palosaari.fi/
> >
> >
>
> >     Bus 001 Device 005: ID 1164:1edc YUAN High-Tech Development Co., Ltd
> >     Device Descriptor:
> >       bLength                18
> >       bDescriptorType         1
> >       bcdUSB               2.00
> >       bDeviceClass            0 (Defined at Interface level)
> >       bDeviceSubClass         0
> >       bDeviceProtocol         0
> >       bMaxPacketSize0        64
> >       idVendor           0x1164 YUAN High-Tech Development Co., Ltd
> >       idProduct          0x1edc
> >       bcdDevice            1.00
> >       iManufacturer           1 YUANRD
> >       iProduct                2 STK7700D
> >       iSerial                 3 0000000001
> >       bNumConfigurations      1
> >       Configuration Descriptor:
> >         bLength                 9
> >         bDescriptorType         2
> >         wTotalLength           46
> >         bNumInterfaces          1
> >         bConfigurationValue     1
> >         iConfiguration          0
> >         bmAttributes         0xa0
> >           Remote Wakeup
> >         MaxPower              500mA
> >         Interface Descriptor:
> >           bLength                 9
> >           bDescriptorType         4
> >           bInterfaceNumber        0
> >           bAlternateSetting       0
> >           bNumEndpoints           4
> >           bInterfaceClass       255 Vendor Specific Class
> >           bInterfaceSubClass      0
> >           bInterfaceProtocol      0
> >           iInterface              0
> >           Endpoint Descriptor:
> >             bLength                 7
> >             bDescriptorType         5
> >             bEndpointAddress     0x01  EP 1 OUT
> >             bmAttributes            2
> >               Transfer Type            Bulk
> >               Synch Type               None
> >               Usage Type               Data
> >             wMaxPacketSize     0x0200  1x 512 bytes
> >             bInterval               1
> >           Endpoint Descriptor:
> >             bLength                 7
> >             bDescriptorType         5
> >             bEndpointAddress     0x81  EP 1 IN
> >             bmAttributes            2
> >               Transfer Type            Bulk
> >               Synch Type               None
> >               Usage Type               Data
> >             wMaxPacketSize     0x0200  1x 512 bytes
> >             bInterval               1
> >           Endpoint Descriptor:
> >             bLength                 7
> >             bDescriptorType         5
> >             bEndpointAddress     0x82  EP 2 IN
> >             bmAttributes            2
> >               Transfer Type            Bulk
> >               Synch Type               None
> >               Usage Type               Data
> >             wMaxPacketSize     0x0200  1x 512 bytes
> >             bInterval               1
> >           Endpoint Descriptor:
> >             bLength                 7
> >             bDescriptorType         5
> >             bEndpointAddress     0x83  EP 3 IN
> >             bmAttributes            2
> >               Transfer Type            Bulk
> >               Synch Type               None
> >               Usage Type               Data
> >             wMaxPacketSize     0x0200  1x 512 bytes
> >             bInterval               1
> >     Device Qualifier (for other device speed):
> >       bLength                10
> >       bDescriptorType         6
> >       bcdUSB               2.00
> >       bDeviceClass            0 (Defined at Interface level)
> >       bDeviceSubClass         0
> >       bDeviceProtocol         0
> >       bMaxPacketSize0        64
> >       bNumConfigurations      1
> >
> >     Feb 18 23:50:53 localhost kernel: usb 1-8: USB disconnect, address 5
> >     Feb 18 23:50:55 localhost kernel: usb 1-8: new high speed USB device
> >     using ehci_hcd and address 6
> >     Feb 18 23:50:55 localhost kernel: usb 1-8: configuration #1 chosen
> >     from 1 choice
> >     Feb 18 23:50:55 localhost kernel: dib0700: loaded with support for 6
> >     different device-types
> >     Feb 18 23:50:55 localhost kernel: dvb-usb: found a 'Yuan EC372S' in
> >     cold state, will try to load a firmware
> >     Feb 18 23:50:55 localhost kernel: dvb-usb: downloading firmware from
> >     file 'dvb-usb-dib0700-1.10.fw'
> >     Feb 18 23:50:55 localhost kernel: dib0700: firmware started
> >     successfully.
> >     Feb 18 23:50:56 localhost kernel: dvb-usb: found a 'Yuan EC372S' in
> >     warm state.
> >     Feb 18 23:50:56 localhost kernel: dvb-usb: will pass the complete
> >     MPEG2 transport stream to the software demuxer.
> >     Feb 18 23:50:56 localhost kernel: DVB: registering new adapter (Yuan
> >     EC372S)
> >     Feb 18 23:50:56 localhost kernel: DVB: registering frontend 0
> >     (DiBcom 7000PC)...
> >     Feb 18 23:50:56 localhost kernel: MT2266: successfully identified
> >     Feb 18 23:50:56 localhost kernel: dvb-usb: Yuan EC372S successfully
> >     initialized and connected.
> >     Feb 18 23:50:56 localhost kernel: usbcore: registered new interface
> >     driver dvb_usb_dib0700
> >
> >     [crope@localhost linuxtv]$ scandvb fi-Oulu
> >     scanning fi-Oulu
> >     using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> >     initial transponder 634000000 0 2 9 3 1 2 0
> >     initial transponder 714000000 0 2 9 3 1 2 0
> >     initial transponder 738000000 0 2 9 3 1 2 0
> >     initial transponder 602000000 0 2 9 3 1 2 0
> >      >>> tune to:
> >
> 634000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
> >     WARNING: filter timeout pid 0x0011
> >     WARNING: filter timeout pid 0x0000
> >     WARNING: filter timeout pid 0x0010
> >      >>> tune to:
> >
> 714000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
> >     WARNING: filter timeout pid 0x0011
> >     WARNING: filter timeout pid 0x0000
> >     WARNING: filter timeout pid 0x0010
> >      >>> tune to:
> >
> 738000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
> >     WARNING: filter timeout pid 0x0011
> >     WARNING: filter timeout pid 0x0000
> >     WARNING: filter timeout pid 0x0010
> >      >>> tune to:
> >
> 602000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
> >     WARNING: filter timeout pid 0x0011
> >     WARNING: filter timeout pid 0x0000
> >     WARNING: filter timeout pid 0x0010
> >     dumping lists (0 services)
> >     Done.
> >     [crope@localhost linuxtv]$
> >
> >
> >
> >
> > ------------------------------------------------------------------------
> >
> > _______________________________________________
> > linux-dvb mailing list
> > linux-dvb@linuxtv.org
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
>
> --
> http://palosaari.fi/
>
>

------=_Part_854_25842819.1203377429501
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

It seems ok. Could you test a scan with kaffeine instead of looking for a specific location? And if you do so it reports signal strenght? <br>By the way, what does it mean moi and moikka? Hello in finish?<br><br>Albert<br>
<br><div><span class="gmail_quote">2008/2/18, Antti Palosaari &lt;<a href="mailto:crope@iki.fi">crope@iki.fi</a>&gt;:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
latest v4l-master + patch you give.<br> <br><br> regards<br> Antti<br> <br> Albert Comerma wrote:<br> <br>&gt; Uhm... that&#39;s strange, I don&#39;t have any of this cards to test, but other<br> &gt; people reported that this solution was working. Could you post the<br>
 &gt; dib0700_devices.c you&#39;re using to have a look?<br> &gt;<br> &gt; Albert<br> &gt;<br> <br>&gt; 2008/2/18, Antti Palosaari &lt;<a href="mailto:crope@iki.fi">crope@iki.fi</a> &lt;mailto:<a href="mailto:crope@iki.fi">crope@iki.fi</a>&gt;&gt;:<br>
 <br>&gt;<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; moi<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; It does not work for me. It says same PID-filter timeout as I have got<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; earlier. I don&#39;t have amplified antenna now, but I can say that all<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; other DVB-T sticks I have are working with this small antenna. It could<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp; be that sensitivity of this hardware is bad or there is something wrong<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; with driver or firmware. Lets try to test it Windows to see if it is<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; working or not.<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; Logs attached.<br>
 &gt;<br> &gt;<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; regards<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; Antti<br> &gt;<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; Albert Comerma wrote:<br> &gt;<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt; Hey people, we already solved this problems. I submitted a patch<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; a few<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt; days ago, but I think it&#39;s not on the current sources. I send<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp; again the<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt; patch. Basically it must use the same frontend description as<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; asus cards.<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt; Albert<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;<br> &gt;<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt; 2008/2/18, Antti Palosaari &lt;<a href="mailto:crope@iki.fi">crope@iki.fi</a> &lt;mailto:<a href="mailto:crope@iki.fi">crope@iki.fi</a>&gt;<br>
 <br>&gt;&nbsp;&nbsp;&nbsp;&nbsp; &lt;mailto:<a href="mailto:crope@iki.fi">crope@iki.fi</a> &lt;mailto:<a href="mailto:crope@iki.fi">crope@iki.fi</a>&gt;&gt;&gt;:<br> <br>&gt;<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp; moikka<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp; I have also this device (express card). I haven&#39;t looked<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp; inside yet, but<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp; I think there is DibCOM STK7700D (in my understanding dual<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; demod chip)<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp; and only *one* MT2266 tuner. I tried various GPIO settings but no<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp; luck yet.<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp; GPIO6 is for MT2266.<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp; GPIO9 and GPIO10 are for frontend.<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp; Looks like tuner goes to correct frequency because I got always<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp; PID-filter timeouts when tuning to correct freq. I will now<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; try to take<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp; some usb-sniffs to see configuration used. Any help is welcome.<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp; regards<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp; Antti<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp; Albert Comerma wrote:<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt; Hi!, with Michel (<a href="mailto:mm-sl@ibelgique.com">mm-sl@ibelgique.com</a><br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; &lt;mailto:<a href="mailto:mm-sl@ibelgique.com">mm-sl@ibelgique.com</a>&gt;<br>
 &gt;<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp; &lt;mailto:<a href="mailto:mm-sl@ibelgique.com">mm-sl@ibelgique.com</a> &lt;mailto:<a href="mailto:mm-sl@ibelgique.com">mm-sl@ibelgique.com</a>&gt;&gt;<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; &lt;mailto:<a href="mailto:mm-sl@ibelgique.com">mm-sl@ibelgique.com</a> &lt;mailto:<a href="mailto:mm-sl@ibelgique.com">mm-sl@ibelgique.com</a>&gt;<br>
 &gt;<br> <br>&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp; &lt;mailto:<a href="mailto:mm-sl@ibelgique.com">mm-sl@ibelgique.com</a> &lt;mailto:<a href="mailto:mm-sl@ibelgique.com">mm-sl@ibelgique.com</a>&gt;&gt;&gt;) who<br> <br>&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt; is a owner of this Yuan card we added the device to<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp; dib0700_devices, and<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt; we got it recognized without problems. The only problem is<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; that no<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt; channel is detected on scan on kaffeine or other software... I<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp; post some<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt; dmesg. We don&#39;t know where it may be the problem... or how to<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp; detect it...<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt; usb 4-2: new high speed USB device using ehci_hcd and<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp; address 6<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt; usb 4-2: new device found, idVendor=1164, idProduct=1edc<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt; usb 4-2: new device strings: Mfr=1, Product=2, SerialNumber=3<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt; usb 4-2: Product: STK7700D<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt; usb 4-2: Manufacturer: YUANRD<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt; usb 4-2: SerialNumber: 0000000001<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt; usb 4-2: configuration #1 chosen from 1 choice<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt; dvb-usb: found a &#39;Yuan EC372S&#39; in cold state, will try to<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp; load a<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp; firmware<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt; dvb-usb: downloading firmware from file<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; &#39;dvb-usb-dib0700-1.10.fw&#39;<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt; dib0700: firmware started successfully.<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt; dvb-usb: found a &#39;Yuan EC372S&#39; in warm state.<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt; dvb-usb: will pass the complete MPEG2 transport stream to the<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp; software<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt; demuxer.<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt; DVB: registering new adapter (Yuan EC372S)<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt; dvb-usb: no frontend was attached by &#39;Yuan EC372S&#39;<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt; dvb-usb: will pass the complete MPEG2 transport stream to the<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp; software<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt; demuxer.<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt; DVB: registering new adapter (Yuan EC372S)<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt; DVB: registering frontend 1 (DiBcom 7000PC)...<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt; MT2266: successfully identified<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt; input: IR-receiver inside an USB DVB receiver as<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; /class/input/input10<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt; dvb-usb: schedule remote query interval to 150 msecs.<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt; dvb-usb: Yuan EC372S successfully initialized and connected.<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; ------------------------------------------------------------------------<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt; _______________________________________________<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt; linux-dvb mailing list<br> &gt;<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt; <a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a> &lt;mailto:<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a>&gt;<br>
 <br>&gt;&nbsp;&nbsp;&nbsp;&nbsp; &lt;mailto:<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a> &lt;mailto:<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a>&gt;&gt;<br> <br>&gt;<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt; <a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp; --<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp; <a href="http://palosaari.fi/">http://palosaari.fi/</a><br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp; ------------------------------------------------------------------------<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt; _______________________________________________<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt; linux-dvb mailing list<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt; <a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a> &lt;mailto:<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a>&gt;<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt; <a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br> &gt;<br> &gt;<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; --<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; <a href="http://palosaari.fi/">http://palosaari.fi/</a><br>
 &gt;<br> &gt;<br> <br>&gt;&nbsp;&nbsp;&nbsp;&nbsp; Bus 001 Device 005: ID 1164:1edc YUAN High-Tech Development Co., Ltd<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; Device Descriptor:<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bLength&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;18<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bDescriptorType&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bcdUSB&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2.00<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bDeviceClass&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0 (Defined at Interface level)<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bDeviceSubClass&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bDeviceProtocol&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bMaxPacketSize0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;64<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; idVendor&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0x1164 YUAN High-Tech Development Co., Ltd<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; idProduct&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0x1edc<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bcdDevice&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.00<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; iManufacturer&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 YUANRD<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; iProduct&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2 STK7700D<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; iSerial&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3 0000000001<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bNumConfigurations&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Configuration Descriptor:<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bLength&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 9<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bDescriptorType&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; wTotalLength&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 46<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bNumInterfaces&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bConfigurationValue&nbsp;&nbsp;&nbsp;&nbsp; 1<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; iConfiguration&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bmAttributes&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0xa0<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Remote Wakeup<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; MaxPower&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;500mA<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Interface Descriptor:<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bLength&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 9<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bDescriptorType&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bInterfaceNumber&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bAlternateSetting&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bNumEndpoints&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bInterfaceClass&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 255 Vendor Specific Class<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bInterfaceSubClass&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bInterfaceProtocol&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; iInterface&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Endpoint Descriptor:<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bLength&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bDescriptorType&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 5<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bEndpointAddress&nbsp;&nbsp;&nbsp;&nbsp; 0x01&nbsp;&nbsp;EP 1 OUT<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bmAttributes&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Transfer Type&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Bulk<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Synch Type&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; None<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Usage Type&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Data<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; wMaxPacketSize&nbsp;&nbsp;&nbsp;&nbsp; 0x0200&nbsp;&nbsp;1x 512 bytes<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bInterval&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Endpoint Descriptor:<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bLength&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bDescriptorType&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 5<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bEndpointAddress&nbsp;&nbsp;&nbsp;&nbsp; 0x81&nbsp;&nbsp;EP 1 IN<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bmAttributes&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Transfer Type&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Bulk<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Synch Type&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; None<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Usage Type&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Data<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; wMaxPacketSize&nbsp;&nbsp;&nbsp;&nbsp; 0x0200&nbsp;&nbsp;1x 512 bytes<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bInterval&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Endpoint Descriptor:<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bLength&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bDescriptorType&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 5<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bEndpointAddress&nbsp;&nbsp;&nbsp;&nbsp; 0x82&nbsp;&nbsp;EP 2 IN<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bmAttributes&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Transfer Type&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Bulk<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Synch Type&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; None<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Usage Type&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Data<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; wMaxPacketSize&nbsp;&nbsp;&nbsp;&nbsp; 0x0200&nbsp;&nbsp;1x 512 bytes<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bInterval&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Endpoint Descriptor:<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bLength&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bDescriptorType&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 5<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bEndpointAddress&nbsp;&nbsp;&nbsp;&nbsp; 0x83&nbsp;&nbsp;EP 3 IN<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bmAttributes&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Transfer Type&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Bulk<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Synch Type&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; None<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Usage Type&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Data<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; wMaxPacketSize&nbsp;&nbsp;&nbsp;&nbsp; 0x0200&nbsp;&nbsp;1x 512 bytes<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bInterval&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; Device Qualifier (for other device speed):<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bLength&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;10<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bDescriptorType&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 6<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bcdUSB&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2.00<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bDeviceClass&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0 (Defined at Interface level)<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bDeviceSubClass&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bDeviceProtocol&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bMaxPacketSize0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;64<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bNumConfigurations&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1<br> &gt;<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; Feb 18 23:50:53 localhost kernel: usb 1-8: USB disconnect, address 5<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; Feb 18 23:50:55 localhost kernel: usb 1-8: new high speed USB device<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp; using ehci_hcd and address 6<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; Feb 18 23:50:55 localhost kernel: usb 1-8: configuration #1 chosen<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; from 1 choice<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; Feb 18 23:50:55 localhost kernel: dib0700: loaded with support for 6<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp; different device-types<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; Feb 18 23:50:55 localhost kernel: dvb-usb: found a &#39;Yuan EC372S&#39; in<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; cold state, will try to load a firmware<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; Feb 18 23:50:55 localhost kernel: dvb-usb: downloading firmware from<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp; file &#39;dvb-usb-dib0700-1.10.fw&#39;<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; Feb 18 23:50:55 localhost kernel: dib0700: firmware started<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; successfully.<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; Feb 18 23:50:56 localhost kernel: dvb-usb: found a &#39;Yuan EC372S&#39; in<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp; warm state.<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; Feb 18 23:50:56 localhost kernel: dvb-usb: will pass the complete<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; MPEG2 transport stream to the software demuxer.<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; Feb 18 23:50:56 localhost kernel: DVB: registering new adapter (Yuan<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp; EC372S)<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; Feb 18 23:50:56 localhost kernel: DVB: registering frontend 0<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; (DiBcom 7000PC)...<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; Feb 18 23:50:56 localhost kernel: MT2266: successfully identified<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; Feb 18 23:50:56 localhost kernel: dvb-usb: Yuan EC372S successfully<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp; initialized and connected.<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; Feb 18 23:50:56 localhost kernel: usbcore: registered new interface<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; driver dvb_usb_dib0700<br> &gt;<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; [crope@localhost linuxtv]$ scandvb fi-Oulu<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp; scanning fi-Oulu<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; using &#39;/dev/dvb/adapter0/frontend0&#39; and &#39;/dev/dvb/adapter0/demux0&#39;<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; initial transponder 634000000 0 2 9 3 1 2 0<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; initial transponder 714000000 0 2 9 3 1 2 0<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp; initial transponder 738000000 0 2 9 3 1 2 0<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; initial transponder 602000000 0 2 9 3 1 2 0<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&gt;&gt; tune to:<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; 634000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp; WARNING: filter timeout pid 0x0011<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; WARNING: filter timeout pid 0x0000<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; WARNING: filter timeout pid 0x0010<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&gt;&gt; tune to:<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; 714000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp; WARNING: filter timeout pid 0x0011<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; WARNING: filter timeout pid 0x0000<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; WARNING: filter timeout pid 0x0010<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&gt;&gt; tune to:<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; 738000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp; WARNING: filter timeout pid 0x0011<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; WARNING: filter timeout pid 0x0000<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; WARNING: filter timeout pid 0x0010<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&gt;&gt;&gt; tune to:<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; 602000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp; WARNING: filter timeout pid 0x0011<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; WARNING: filter timeout pid 0x0000<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; WARNING: filter timeout pid 0x0010<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; dumping lists (0 services)<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; Done.<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; [crope@localhost linuxtv]$<br>
 &gt;<br> &gt;<br> &gt;<br> &gt;<br> &gt; ------------------------------------------------------------------------<br> &gt;<br> &gt; _______________________________________________<br> &gt; linux-dvb mailing list<br> &gt; <a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
 &gt; <a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br> <br> <br> --<br> <a href="http://palosaari.fi/">http://palosaari.fi/</a><br> <br>
</blockquote></div><br>

------=_Part_854_25842819.1203377429501--


--===============1917980720==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1917980720==--
