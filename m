Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailout09.t-online.de ([194.25.134.84])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <yusuf.altin@t-online.de>) id 1LKA0o-0007GL-FC
	for linux-dvb@linuxtv.org; Tue, 06 Jan 2009 12:22:19 +0100
From: Yusuf Altin <yusuf.altin@t-online.de>
To: Albert Comerma <albert.comerma@gmail.com>
In-Reply-To: <ea4209750901060317m2035e6d6k556327f1170ec0f@mail.gmail.com>
References: <1231015340.2963.7.camel@yusuf.laptop>
	<ea4209750901040640k532f2dc0rf918fb4967a4a19d@mail.gmail.com>
	<1231145794.2968.15.camel@yusuf.laptop>
	<ea4209750901050252i76e0e6cdvd4ae7ea142facc25@mail.gmail.com>
	<1231208271.27507.18.camel@yusuf.laptop>
	<ea4209750901060317m2035e6d6k556327f1170ec0f@mail.gmail.com>
Date: Tue, 06 Jan 2009 12:21:50 +0100
Message-Id: <1231240910.3778.9.camel@yusuf.laptop>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TerraTec Cinergy T Express
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

Hi Albert,

just in time I find out, if I keep my flagpol antenna horizontal, every
channel works fine and without artefacts.

Is it possible to change the polarisation in the source code?

Which list do you mean, i've never done similar before.

Greetings Yusuf

Am Dienstag, den 06.01.2009, 12:17 +0100 schrieb Albert Comerma:
> I don't know if somebody improved the dibcom driver, but for my
> experience the signal strength numbers are not useful, they only go
> from a small number or jump to maximum, so don't trust them. I think
> there where also some issues with signal strength on some hardware...
> but I'm not sure about that.
> Apart from that signal issues your device seems to work perfectly,
> could you submit the patch to the list to add it to current version?
> 
> Albert
> 
> 2009/1/6 Yusuf Altin <yusuf.altin@t-online.de>
>         ok, now I'm a step ahead, i moved my device to the section
>         around line
>         1562. By using w_scan every occupied frequencys were found,
>         but scanning
>         for services (pids) isn't successful at all. The card finds
>         only a few
>         channels and the signal strength is very poor -> a lot of
>         artefacts. My
>         Antenna is good justified and with Windows and the Original
>         Software it
>         works well.
>         Is there any way to optimize the reception?
>         
>         PS: My Card gots a led, it turns always on when i connect it
>         with my
>         notebook.
>         
>         Am Montag, den 05.01.2009, 11:52 +0100 schrieb Albert Comerma:
>         
>         > The patch looks good and now dmesg looks much better, and I
>         guess
>         > there must be a /dev/dvb/ something created when you plug
>         your card.
>         > First could you try to move your device to the STK7700D
>         section? I
>         > mean around line 1539... reverting changes on the other
>         section...
>         > If that doesn't work you can also try next section which has
>         some
>         > small changes on attaching the tunner... around line 1569 or
>         on
>         > another section around line 1715.
>         > If there's some led on the card it goes on after connecting?
>         > If nothing works probably there's some GPIO wrong with that
>         card...
>         > and that's not easy to solve, just change and try... when
>         you try to
>         > scan channels what you see on dmesg?
>         >
>         > Albert
>         >
>         > 2009/1/5 Yusuf Altin <yusuf.altin@t-online.de>
>         >         Hi Albert,
>         >
>         >         thanks for you helping.
>         >
>         >         I downloaded and modified the sourcecode like this:
>         >
>         >         dvb-usb-ids.h:
>         >                #define USB_PID_TERRATEC_CINERGY_HT_USB_XE
>         >          0x0058
>         >                #define USB_PID_TERRATEC_CINERGY_HT_EXPRESS
>         >         0x0060
>         >         +       #define USB_PID_TERRATEC_CINERGY_T_EXPRESS
>         >            0x0062
>         >                #define USB_PID_TERRATEC_CINERGY_T_XXS
>         >          0x0078
>         >                #define USB_PID_PINNACLE_EXPRESSCARD_320CX
>         >          0x022e
>         >
>         >         dib0700_devices.c:
>         >
>         >         LL 1393
>         >                { USB_DEVICE(USB_VID_ASUS,
>          USB_PID_ASUS_U3000H) },
>         >         /* 40 */{ USB_DEVICE(USB_VID_PINNACLE,
>         >          USB_PID_PINNACLE_PCTV801E) },
>         >                { USB_DEVICE(USB_VID_PINNACLE,
>         >          USB_PID_PINNACLE_PCTV801E_SE) },
>         >         + { USB_DEVICE(USB_VID_TERRATEC,
>         >          USB_PID_TERRATEC_CINERGY_T_EXPRESS) },
>         >                { 0 }           /* Terminating entry */
>         >
>         >
>         >         LL 1438
>         >         -               .num_device_descs = 8,
>         >         +               .num_device_descs = 9,
>         >                        .devices = {
>         >                                {   "DiBcom STK7700P
>         reference design",
>         >
>          { &dib0700_usb_id_table[0],
>         >         &dib0700_usb_id_table[1] },
>         >                                        { NULL },
>         >                                },
>         >                                {   "Hauppauge Nova-T Stick",
>         >
>          { &dib0700_usb_id_table[4],
>         >         &dib0700_usb_id_table[9], NULL },
>         >                                        { NULL },
>         >                                },
>         >                                {   "AVerMedia AVerTV DVB-T
>         Volar",
>         >
>          { &dib0700_usb_id_table[5],
>         >         &dib0700_usb_id_table[10] },
>         >                                        { NULL },
>         >                                },
>         >                                {   "Compro Videomate U500",
>         >
>          { &dib0700_usb_id_table[6],
>         >         &dib0700_usb_id_table[19] },
>         >                                        { NULL },
>         >                                },
>         >                                {   "Uniwill STK7700P based
>         (Hama and
>         >         others)",
>         >
>          { &dib0700_usb_id_table[7],
>         >         NULL },
>         >                                        { NULL },
>         >                                },
>         >                                {   "Leadtek Winfast DTV
>         Dongle
>         >         (STK7700P based)",
>         >
>          { &dib0700_usb_id_table[8],
>         >         &dib0700_usb_id_table[34] },
>         >                                        { NULL },
>         >                                },
>         >                                {   "AVerMedia AVerTV DVB-T
>         Express",
>         >
>          { &dib0700_usb_id_table[20] },
>         >                                        { NULL },
>         >                                },
>         >                                {   "Gigabyte U7000",
>         >
>          { &dib0700_usb_id_table[21],
>         >         NULL },
>         >                                        { NULL },
>         >         -                       }
>         >         +                       },
>         >         +                       {   "Terratec Cinergy T
>         Express",
>         >         +
>         { &dib0700_usb_id_table[42],
>         >         NULL },
>         >         +                               { NULL },
>         >         +                       }
>         >                        },
>         >
>         >
>         >         make and make install was no problem.
>         >
>         >
>         >         Now dmesg says
>         >
>         >         usb 1-6: new high speed USB device using ehci_hcd
>         and address
>         >         9
>         >         usb 1-6: configuration #1 chosen from 1 choice
>         >
>         >         dvb-usb: found a 'Terratec Cinergy T Express' in
>         cold state,
>         >         will try to
>         >         load a firmware
>         >         firmware: requesting dvb-usb-dib0700-1.20.fw
>         >         dvb-usb: downloading firmware from file
>         >         'dvb-usb-dib0700-1.20.fw'
>         >         dib0700: firmware started successfully.
>         >         dvb-usb: found a 'Terratec Cinergy T Express' in
>         warm state.
>         >         dvb-usb: will pass the complete MPEG2 transport
>         stream to the
>         >         software
>         >         demuxer.
>         >         DVB: registering new adapter (Terratec Cinergy T
>         Express)
>         >         DVB: registering adapter 0 frontend 0 (DiBcom
>         7000PC)...
>         >         input: IR-receiver inside an USB DVB receiver
>         >
>         as /devices/pci0000:00/0000:00:1d.7/usb1/1-6/input/input17
>         >         dvb-usb: schedule remote query interval to 50 msecs.
>         >         dvb-usb: Terratec Cinergy T Express successfully
>         initialized
>         >         and
>         >         connected.
>         >         usb 1-6: New USB device found, idVendor=0ccd,
>         idProduct=0062
>         >         usb 1-6: New USB device strings: Mfr=1, Product=2,
>         >         SerialNumber=3
>         >         usb 1-6: Product: STK7700D
>         >         usb 1-6: Manufacturer: YUANRD
>         >         usb 1-6: SerialNumber: 0000000001
>         >
>         >
>         >         I mean it looks better
>         >
>         >         Now I am able to select the card in Totem but the
>         picture
>         >         stays black
>         >         (dvb-channels.conf is ok), same problem in vlc.
>         >
>         >         What went wrong?
>         >
>         >         Yusuf
>         >
>         >         Am Sonntag, den 04.01.2009, 15:40 +0100 schrieb
>         Albert
>         >         Comerma:
>         >
>         >         > Hi Yusuf, if you're sure about the type of the
>         device you
>         >         should try
>         >         > to modify the v4l source code, probably just
>         adding your new
>         >         device it
>         >         > should work.
>         >         >
>         >         > To do so you will need; mercurial, gcc, make and
>         >         linux-headers
>         >         > matching your kernel. Once installed you can get
>         the current
>         >         source
>         >         > code runing;  hg clone
>         http://linuxtv.org/hg/v4l-dvb
>         >         > You will also need the card's firmware, you can
>         get it from
>         >         >
>         >
>         http://www.wi-bw.tfh-wildau.de/~pboettch/home/linux-dvb-firmware/dvb-usb-dib0700-1.10.fw and copy it to /lib/firmware/
>         >         > Then go to v4l-dvb/linux/drivers/media/dvb/dvb-usb
>         and
>         >         modify the
>         >         > files dib-usb-ids.h adding the new id with a
>         descriptor, and
>         >         > dib0700_devices.c
>         >         > Once modified just run make and make install (as
>         root, this
>         >         can
>         >         > potentialy screw other v4l drivers), and test it
>         (if you
>         >         have the
>         >         > modules loaded you will need to reload them).
>         >         >
>         >         > If you want to try it and don't know how to modify
>         the files
>         >         just tell
>         >         > me and I can make your version, but only ask for
>         it when you
>         >         have
>         >         > everything installed and ready.
>         >         >
>         >         > Albert
>         >         >
>         >         > 2009/1/3 Yusuf Altin <yusuf.altin@t-online.de>
>         >         >         Hello,
>         >         >
>         >         >         I own a TerraTec Cinergy T Express DVB-T
>         Card and it
>         >         doesn't
>         >         >         work with
>         >         >         Fedora 10.
>         >         >
>         >         >         My kernel is 2.6.27.10-167.fc10.i686.
>         >         >
>         >         >         lsusb:
>         >         >         Bus 001 Device 008: ID 0ccd:0062 TerraTec
>         Electronic
>         >         GmbH
>         >         >
>         >         >         dmesg:
>         >         >         usb 1-6: new high speed USB device using
>         ehci_hcd
>         >         and address
>         >         >         8
>         >         >         usb 1-6: configuration #1 chosen from 1
>         choice
>         >         >         usb 1-6: New USB device found,
>         idVendor=0ccd,
>         >         idProduct=0062
>         >         >         usb 1-6: New USB device strings: Mfr=1,
>         Product=2,
>         >         >         SerialNumber=3
>         >         >         usb 1-6: Product: STK7700D
>         >         >         usb 1-6: Manufacturer: YUANRD
>         >         >         usb 1-6: SerialNumber: 0000000001
>         >         >
>         >         >         The card has afaik a dib7700PC chip.
>         >         >
>         >         >         Is it possible to get the card working?
>         >         >
>         >         >         Greeting
>         >         >
>         >         >         Yusuf Altin
>         >         >
>         >         >
>         >         >
>         _______________________________________________
>         >         >         linux-dvb mailing list
>         >         >         linux-dvb@linuxtv.org
>         >         >
>         >
>         http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>         >         >
>         >
>         >
>         >
>         
>         
> 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
