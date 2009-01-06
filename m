Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.224])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <albert.comerma@gmail.com>) id 1LKAWu-0001TO-LW
	for linux-dvb@linuxtv.org; Tue, 06 Jan 2009 12:55:31 +0100
Received: by rv-out-0506.google.com with SMTP id b25so7858479rvf.41
	for <linux-dvb@linuxtv.org>; Tue, 06 Jan 2009 03:55:24 -0800 (PST)
Message-ID: <ea4209750901060355j3387d019waba507a38aad6c0d@mail.gmail.com>
Date: Tue, 6 Jan 2009 12:55:24 +0100
From: "Albert Comerma" <albert.comerma@gmail.com>
To: "Yusuf Altin" <yusuf.altin@t-online.de>
In-Reply-To: <1231240910.3778.9.camel@yusuf.laptop>
MIME-Version: 1.0
References: <1231015340.2963.7.camel@yusuf.laptop>
	<ea4209750901040640k532f2dc0rf918fb4967a4a19d@mail.gmail.com>
	<1231145794.2968.15.camel@yusuf.laptop>
	<ea4209750901050252i76e0e6cdvd4ae7ea142facc25@mail.gmail.com>
	<1231208271.27507.18.camel@yusuf.laptop>
	<ea4209750901060317m2035e6d6k556327f1170ec0f@mail.gmail.com>
	<1231240910.3778.9.camel@yusuf.laptop>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TerraTec Cinergy T Express
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0240603332=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0240603332==
Content-Type: multipart/alternative;
	boundary="----=_Part_120328_26082677.1231242924122"

------=_Part_120328_26082677.1231242924122
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Sorry, no idea about the polarisation...
For the patch, just send a mail to the mailing list with the subject [PATCH]
and a description (add such device to dibcom driver), containing the patch
(you can create it running hg diff -p -U 8  v4l-dvb > somname.patch) and a
line saying signed-off by: yourname yourmail. You can also add me to the
signed-off by if you want :).  And probably somebody will update the source.

Albert

2009/1/6 Yusuf Altin <yusuf.altin@t-online.de>

> Hi Albert,
>
> just in time I find out, if I keep my flagpol antenna horizontal, every
> channel works fine and without artefacts.
>
> Is it possible to change the polarisation in the source code?
>
> Which list do you mean, i've never done similar before.
>
> Greetings Yusuf
>
> Am Dienstag, den 06.01.2009, 12:17 +0100 schrieb Albert Comerma:
> > I don't know if somebody improved the dibcom driver, but for my
> > experience the signal strength numbers are not useful, they only go
> > from a small number or jump to maximum, so don't trust them. I think
> > there where also some issues with signal strength on some hardware...
> > but I'm not sure about that.
> > Apart from that signal issues your device seems to work perfectly,
> > could you submit the patch to the list to add it to current version?
> >
> > Albert
> >
> > 2009/1/6 Yusuf Altin <yusuf.altin@t-online.de>
> >         ok, now I'm a step ahead, i moved my device to the section
> >         around line
> >         1562. By using w_scan every occupied frequencys were found,
> >         but scanning
> >         for services (pids) isn't successful at all. The card finds
> >         only a few
> >         channels and the signal strength is very poor -> a lot of
> >         artefacts. My
> >         Antenna is good justified and with Windows and the Original
> >         Software it
> >         works well.
> >         Is there any way to optimize the reception?
> >
> >         PS: My Card gots a led, it turns always on when i connect it
> >         with my
> >         notebook.
> >
> >         Am Montag, den 05.01.2009, 11:52 +0100 schrieb Albert Comerma:
> >
> >         > The patch looks good and now dmesg looks much better, and I
> >         guess
> >         > there must be a /dev/dvb/ something created when you plug
> >         your card.
> >         > First could you try to move your device to the STK7700D
> >         section? I
> >         > mean around line 1539... reverting changes on the other
> >         section...
> >         > If that doesn't work you can also try next section which has
> >         some
> >         > small changes on attaching the tunner... around line 1569 or
> >         on
> >         > another section around line 1715.
> >         > If there's some led on the card it goes on after connecting?
> >         > If nothing works probably there's some GPIO wrong with that
> >         card...
> >         > and that's not easy to solve, just change and try... when
> >         you try to
> >         > scan channels what you see on dmesg?
> >         >
> >         > Albert
> >         >
> >         > 2009/1/5 Yusuf Altin <yusuf.altin@t-online.de>
> >         >         Hi Albert,
> >         >
> >         >         thanks for you helping.
> >         >
> >         >         I downloaded and modified the sourcecode like this:
> >         >
> >         >         dvb-usb-ids.h:
> >         >                #define USB_PID_TERRATEC_CINERGY_HT_USB_XE
> >         >          0x0058
> >         >                #define USB_PID_TERRATEC_CINERGY_HT_EXPRESS
> >         >         0x0060
> >         >         +       #define USB_PID_TERRATEC_CINERGY_T_EXPRESS
> >         >            0x0062
> >         >                #define USB_PID_TERRATEC_CINERGY_T_XXS
> >         >          0x0078
> >         >                #define USB_PID_PINNACLE_EXPRESSCARD_320CX
> >         >          0x022e
> >         >
> >         >         dib0700_devices.c:
> >         >
> >         >         LL 1393
> >         >                { USB_DEVICE(USB_VID_ASUS,
> >          USB_PID_ASUS_U3000H) },
> >         >         /* 40 */{ USB_DEVICE(USB_VID_PINNACLE,
> >         >          USB_PID_PINNACLE_PCTV801E) },
> >         >                { USB_DEVICE(USB_VID_PINNACLE,
> >         >          USB_PID_PINNACLE_PCTV801E_SE) },
> >         >         + { USB_DEVICE(USB_VID_TERRATEC,
> >         >          USB_PID_TERRATEC_CINERGY_T_EXPRESS) },
> >         >                { 0 }           /* Terminating entry */
> >         >
> >         >
> >         >         LL 1438
> >         >         -               .num_device_descs = 8,
> >         >         +               .num_device_descs = 9,
> >         >                        .devices = {
> >         >                                {   "DiBcom STK7700P
> >         reference design",
> >         >
> >          { &dib0700_usb_id_table[0],
> >         >         &dib0700_usb_id_table[1] },
> >         >                                        { NULL },
> >         >                                },
> >         >                                {   "Hauppauge Nova-T Stick",
> >         >
> >          { &dib0700_usb_id_table[4],
> >         >         &dib0700_usb_id_table[9], NULL },
> >         >                                        { NULL },
> >         >                                },
> >         >                                {   "AVerMedia AVerTV DVB-T
> >         Volar",
> >         >
> >          { &dib0700_usb_id_table[5],
> >         >         &dib0700_usb_id_table[10] },
> >         >                                        { NULL },
> >         >                                },
> >         >                                {   "Compro Videomate U500",
> >         >
> >          { &dib0700_usb_id_table[6],
> >         >         &dib0700_usb_id_table[19] },
> >         >                                        { NULL },
> >         >                                },
> >         >                                {   "Uniwill STK7700P based
> >         (Hama and
> >         >         others)",
> >         >
> >          { &dib0700_usb_id_table[7],
> >         >         NULL },
> >         >                                        { NULL },
> >         >                                },
> >         >                                {   "Leadtek Winfast DTV
> >         Dongle
> >         >         (STK7700P based)",
> >         >
> >          { &dib0700_usb_id_table[8],
> >         >         &dib0700_usb_id_table[34] },
> >         >                                        { NULL },
> >         >                                },
> >         >                                {   "AVerMedia AVerTV DVB-T
> >         Express",
> >         >
> >          { &dib0700_usb_id_table[20] },
> >         >                                        { NULL },
> >         >                                },
> >         >                                {   "Gigabyte U7000",
> >         >
> >          { &dib0700_usb_id_table[21],
> >         >         NULL },
> >         >                                        { NULL },
> >         >         -                       }
> >         >         +                       },
> >         >         +                       {   "Terratec Cinergy T
> >         Express",
> >         >         +
> >         { &dib0700_usb_id_table[42],
> >         >         NULL },
> >         >         +                               { NULL },
> >         >         +                       }
> >         >                        },
> >         >
> >         >
> >         >         make and make install was no problem.
> >         >
> >         >
> >         >         Now dmesg says
> >         >
> >         >         usb 1-6: new high speed USB device using ehci_hcd
> >         and address
> >         >         9
> >         >         usb 1-6: configuration #1 chosen from 1 choice
> >         >
> >         >         dvb-usb: found a 'Terratec Cinergy T Express' in
> >         cold state,
> >         >         will try to
> >         >         load a firmware
> >         >         firmware: requesting dvb-usb-dib0700-1.20.fw
> >         >         dvb-usb: downloading firmware from file
> >         >         'dvb-usb-dib0700-1.20.fw'
> >         >         dib0700: firmware started successfully.
> >         >         dvb-usb: found a 'Terratec Cinergy T Express' in
> >         warm state.
> >         >         dvb-usb: will pass the complete MPEG2 transport
> >         stream to the
> >         >         software
> >         >         demuxer.
> >         >         DVB: registering new adapter (Terratec Cinergy T
> >         Express)
> >         >         DVB: registering adapter 0 frontend 0 (DiBcom
> >         7000PC)...
> >         >         input: IR-receiver inside an USB DVB receiver
> >         >
> >         as /devices/pci0000:00/0000:00:1d.7/usb1/1-6/input/input17
> >         >         dvb-usb: schedule remote query interval to 50 msecs.
> >         >         dvb-usb: Terratec Cinergy T Express successfully
> >         initialized
> >         >         and
> >         >         connected.
> >         >         usb 1-6: New USB device found, idVendor=0ccd,
> >         idProduct=0062
> >         >         usb 1-6: New USB device strings: Mfr=1, Product=2,
> >         >         SerialNumber=3
> >         >         usb 1-6: Product: STK7700D
> >         >         usb 1-6: Manufacturer: YUANRD
> >         >         usb 1-6: SerialNumber: 0000000001
> >         >
> >         >
> >         >         I mean it looks better
> >         >
> >         >         Now I am able to select the card in Totem but the
> >         picture
> >         >         stays black
> >         >         (dvb-channels.conf is ok), same problem in vlc.
> >         >
> >         >         What went wrong?
> >         >
> >         >         Yusuf
> >         >
> >         >         Am Sonntag, den 04.01.2009, 15:40 +0100 schrieb
> >         Albert
> >         >         Comerma:
> >         >
> >         >         > Hi Yusuf, if you're sure about the type of the
> >         device you
> >         >         should try
> >         >         > to modify the v4l source code, probably just
> >         adding your new
> >         >         device it
> >         >         > should work.
> >         >         >
> >         >         > To do so you will need; mercurial, gcc, make and
> >         >         linux-headers
> >         >         > matching your kernel. Once installed you can get
> >         the current
> >         >         source
> >         >         > code runing;  hg clone
> >         http://linuxtv.org/hg/v4l-dvb
> >         >         > You will also need the card's firmware, you can
> >         get it from
> >         >         >
> >         >
> >
> http://www.wi-bw.tfh-wildau.de/~pboettch/home/linux-dvb-firmware/dvb-usb-dib0700-1.10.fw<http://www.wi-bw.tfh-wildau.de/%7Epboettch/home/linux-dvb-firmware/dvb-usb-dib0700-1.10.fw>and copy it to /lib/firmware/
> >         >         > Then go to v4l-dvb/linux/drivers/media/dvb/dvb-usb
> >         and
> >         >         modify the
> >         >         > files dib-usb-ids.h adding the new id with a
> >         descriptor, and
> >         >         > dib0700_devices.c
> >         >         > Once modified just run make and make install (as
> >         root, this
> >         >         can
> >         >         > potentialy screw other v4l drivers), and test it
> >         (if you
> >         >         have the
> >         >         > modules loaded you will need to reload them).
> >         >         >
> >         >         > If you want to try it and don't know how to modify
> >         the files
> >         >         just tell
> >         >         > me and I can make your version, but only ask for
> >         it when you
> >         >         have
> >         >         > everything installed and ready.
> >         >         >
> >         >         > Albert
> >         >         >
> >         >         > 2009/1/3 Yusuf Altin <yusuf.altin@t-online.de>
> >         >         >         Hello,
> >         >         >
> >         >         >         I own a TerraTec Cinergy T Express DVB-T
> >         Card and it
> >         >         doesn't
> >         >         >         work with
> >         >         >         Fedora 10.
> >         >         >
> >         >         >         My kernel is 2.6.27.10-167.fc10.i686.
> >         >         >
> >         >         >         lsusb:
> >         >         >         Bus 001 Device 008: ID 0ccd:0062 TerraTec
> >         Electronic
> >         >         GmbH
> >         >         >
> >         >         >         dmesg:
> >         >         >         usb 1-6: new high speed USB device using
> >         ehci_hcd
> >         >         and address
> >         >         >         8
> >         >         >         usb 1-6: configuration #1 chosen from 1
> >         choice
> >         >         >         usb 1-6: New USB device found,
> >         idVendor=0ccd,
> >         >         idProduct=0062
> >         >         >         usb 1-6: New USB device strings: Mfr=1,
> >         Product=2,
> >         >         >         SerialNumber=3
> >         >         >         usb 1-6: Product: STK7700D
> >         >         >         usb 1-6: Manufacturer: YUANRD
> >         >         >         usb 1-6: SerialNumber: 0000000001
> >         >         >
> >         >         >         The card has afaik a dib7700PC chip.
> >         >         >
> >         >         >         Is it possible to get the card working?
> >         >         >
> >         >         >         Greeting
> >         >         >
> >         >         >         Yusuf Altin
> >         >         >
> >         >         >
> >         >         >
> >         _______________________________________________
> >         >         >         linux-dvb mailing list
> >         >         >         linux-dvb@linuxtv.org
> >         >         >
> >         >
> >         http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >         >         >
> >         >
> >         >
> >         >
> >
> >
> >
>
>

------=_Part_120328_26082677.1231242924122
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Sorry, no idea about the polarisation...<br>For the patch, just send a mail to the mailing list with the subject [PATCH] and a description (add such device to dibcom driver), containing the patch (you can create it running hg diff -p -U 8&nbsp; v4l-dvb &gt; somname.patch) and a line saying signed-off by: yourname yourmail. You can also add me to the signed-off by if you want :).&nbsp; And probably somebody will update the source.<br>
<br>Albert<br><br><div class="gmail_quote">2009/1/6 Yusuf Altin <span dir="ltr">&lt;<a href="mailto:yusuf.altin@t-online.de">yusuf.altin@t-online.de</a>&gt;</span><br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Hi Albert,<br>
<br>
just in time I find out, if I keep my flagpol antenna horizontal, every<br>
channel works fine and without artefacts.<br>
<br>
Is it possible to change the polarisation in the source code?<br>
<br>
Which list do you mean, i&#39;ve never done similar before.<br>
<br>
Greetings Yusuf<br>
<br>
Am Dienstag, den 06.01.2009, 12:17 +0100 schrieb Albert Comerma:<br>
<div><div></div><div class="Wj3C7c">&gt; I don&#39;t know if somebody improved the dibcom driver, but for my<br>
&gt; experience the signal strength numbers are not useful, they only go<br>
&gt; from a small number or jump to maximum, so don&#39;t trust them. I think<br>
&gt; there where also some issues with signal strength on some hardware...<br>
&gt; but I&#39;m not sure about that.<br>
&gt; Apart from that signal issues your device seems to work perfectly,<br>
&gt; could you submit the patch to the list to add it to current version?<br>
&gt;<br>
&gt; Albert<br>
&gt;<br>
&gt; 2009/1/6 Yusuf Altin &lt;<a href="mailto:yusuf.altin@t-online.de">yusuf.altin@t-online.de</a>&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; ok, now I&#39;m a step ahead, i moved my device to the section<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; around line<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; 1562. By using w_scan every occupied frequencys were found,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; but scanning<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; for services (pids) isn&#39;t successful at all. The card finds<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; only a few<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; channels and the signal strength is very poor -&gt; a lot of<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; artefacts. My<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Antenna is good justified and with Windows and the Original<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Software it<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; works well.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Is there any way to optimize the reception?<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; PS: My Card gots a led, it turns always on when i connect it<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; with my<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; notebook.<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Am Montag, den 05.01.2009, 11:52 +0100 schrieb Albert Comerma:<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; The patch looks good and now dmesg looks much better, and I<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; guess<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; there must be a /dev/dvb/ something created when you plug<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; your card.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; First could you try to move your device to the STK7700D<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; section? I<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; mean around line 1539... reverting changes on the other<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; section...<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; If that doesn&#39;t work you can also try next section which has<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; some<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; small changes on attaching the tunner... around line 1569 or<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; on<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; another section around line 1715.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; If there&#39;s some led on the card it goes on after connecting?<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; If nothing works probably there&#39;s some GPIO wrong with that<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; card...<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; and that&#39;s not easy to solve, just change and try... when<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; you try to<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; scan channels what you see on dmesg?<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; Albert<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; 2009/1/5 Yusuf Altin &lt;<a href="mailto:yusuf.altin@t-online.de">yusuf.altin@t-online.de</a>&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Hi Albert,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; thanks for you helping.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; I downloaded and modified the sourcecode like this:<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; dvb-usb-ids.h:<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;#define USB_PID_TERRATEC_CINERGY_HT_USB_XE<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;0x0058<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;#define USB_PID_TERRATEC_CINERGY_HT_EXPRESS<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; 0x0060<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; #define USB_PID_TERRATEC_CINERGY_T_EXPRESS<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;0x0062<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;#define USB_PID_TERRATEC_CINERGY_T_XXS<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;0x0078<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;#define USB_PID_PINNACLE_EXPRESSCARD_320CX<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;0x022e<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; dib0700_devices.c:<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; LL 1393<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ USB_DEVICE(USB_VID_ASUS,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;USB_PID_ASUS_U3000H) },<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; /* 40 */{ USB_DEVICE(USB_VID_PINNACLE,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;USB_PID_PINNACLE_PCTV801E) },<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ USB_DEVICE(USB_VID_PINNACLE,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;USB_PID_PINNACLE_PCTV801E_SE) },<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; + { USB_DEVICE(USB_VID_TERRATEC,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;USB_PID_TERRATEC_CINERGY_T_EXPRESS) },<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ 0 } &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; /* Terminating entry */<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; LL 1438<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; - &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; .num_device_descs = 8,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; .num_device_descs = 9,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.devices = {<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ &nbsp; &quot;DiBcom STK7700P<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; reference design&quot;,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ &amp;dib0700_usb_id_table[0],<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &amp;dib0700_usb_id_table[1] },<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ NULL },<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;},<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ &nbsp; &quot;Hauppauge Nova-T Stick&quot;,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ &amp;dib0700_usb_id_table[4],<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &amp;dib0700_usb_id_table[9], NULL },<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ NULL },<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;},<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ &nbsp; &quot;AVerMedia AVerTV DVB-T<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Volar&quot;,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ &amp;dib0700_usb_id_table[5],<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &amp;dib0700_usb_id_table[10] },<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ NULL },<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;},<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ &nbsp; &quot;Compro Videomate U500&quot;,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ &amp;dib0700_usb_id_table[6],<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &amp;dib0700_usb_id_table[19] },<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ NULL },<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;},<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ &nbsp; &quot;Uniwill STK7700P based<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; (Hama and<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; others)&quot;,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ &amp;dib0700_usb_id_table[7],<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; NULL },<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ NULL },<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;},<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ &nbsp; &quot;Leadtek Winfast DTV<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Dongle<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; (STK7700P based)&quot;,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ &amp;dib0700_usb_id_table[8],<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &amp;dib0700_usb_id_table[34] },<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ NULL },<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;},<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ &nbsp; &quot;AVerMedia AVerTV DVB-T<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Express&quot;,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ &amp;dib0700_usb_id_table[20] },<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ NULL },<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;},<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ &nbsp; &quot;Gigabyte U7000&quot;,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ &amp;dib0700_usb_id_table[21],<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; NULL },<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ NULL },<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; - &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; },<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; { &nbsp; &quot;Terratec Cinergy T<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Express&quot;,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; +<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; { &amp;dib0700_usb_id_table[42],<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; NULL },<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; { NULL },<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;},<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; make and make install was no problem.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Now dmesg says<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; usb 1-6: new high speed USB device using ehci_hcd<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; and address<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; 9<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; usb 1-6: configuration #1 chosen from 1 choice<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; dvb-usb: found a &#39;Terratec Cinergy T Express&#39; in<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; cold state,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; will try to<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; load a firmware<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; firmware: requesting dvb-usb-dib0700-1.20.fw<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; dvb-usb: downloading firmware from file<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &#39;dvb-usb-dib0700-1.20.fw&#39;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; dib0700: firmware started successfully.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; dvb-usb: found a &#39;Terratec Cinergy T Express&#39; in<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; warm state.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; dvb-usb: will pass the complete MPEG2 transport<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; stream to the<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; software<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; demuxer.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; DVB: registering new adapter (Terratec Cinergy T<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Express)<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; DVB: registering adapter 0 frontend 0 (DiBcom<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; 7000PC)...<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; input: IR-receiver inside an USB DVB receiver<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; as /devices/pci0000:00/0000:00:1d.7/usb1/1-6/input/input17<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; dvb-usb: schedule remote query interval to 50 msecs.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; dvb-usb: Terratec Cinergy T Express successfully<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; initialized<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; and<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; connected.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; usb 1-6: New USB device found, idVendor=0ccd,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; idProduct=0062<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; usb 1-6: New USB device strings: Mfr=1, Product=2,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; SerialNumber=3<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; usb 1-6: Product: STK7700D<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; usb 1-6: Manufacturer: YUANRD<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; usb 1-6: SerialNumber: 0000000001<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; I mean it looks better<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Now I am able to select the card in Totem but the<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; picture<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; stays black<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; (dvb-channels.conf is ok), same problem in vlc.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; What went wrong?<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Yusuf<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Am Sonntag, den 04.01.2009, 15:40 +0100 schrieb<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Albert<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Comerma:<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; Hi Yusuf, if you&#39;re sure about the type of the<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; device you<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; should try<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; to modify the v4l source code, probably just<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; adding your new<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; device it<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; should work.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; To do so you will need; mercurial, gcc, make and<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; linux-headers<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; matching your kernel. Once installed you can get<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; the current<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; source<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; code runing; &nbsp;hg clone<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; <a href="http://linuxtv.org/hg/v4l-dvb" target="_blank">http://linuxtv.org/hg/v4l-dvb</a><br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; You will also need the card&#39;s firmware, you can<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; get it from<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; <a href="http://www.wi-bw.tfh-wildau.de/%7Epboettch/home/linux-dvb-firmware/dvb-usb-dib0700-1.10.fw" target="_blank">http://www.wi-bw.tfh-wildau.de/~pboettch/home/linux-dvb-firmware/dvb-usb-dib0700-1.10.fw</a> and copy it to /lib/firmware/<br>

&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; Then go to v4l-dvb/linux/drivers/media/dvb/dvb-usb<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; and<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; modify the<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; files dib-usb-ids.h adding the new id with a<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; descriptor, and<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; dib0700_devices.c<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; Once modified just run make and make install (as<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; root, this<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; can<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; potentialy screw other v4l drivers), and test it<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; (if you<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; have the<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; modules loaded you will need to reload them).<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; If you want to try it and don&#39;t know how to modify<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; the files<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; just tell<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; me and I can make your version, but only ask for<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; it when you<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; have<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; everything installed and ready.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; Albert<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; 2009/1/3 Yusuf Altin &lt;<a href="mailto:yusuf.altin@t-online.de">yusuf.altin@t-online.de</a>&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Hello,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; I own a TerraTec Cinergy T Express DVB-T<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Card and it<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; doesn&#39;t<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; work with<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Fedora 10.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; My kernel is 2.6.27.10-167.fc10.i686.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; lsusb:<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Bus 001 Device 008: ID 0ccd:0062 TerraTec<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Electronic<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; GmbH<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; dmesg:<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; usb 1-6: new high speed USB device using<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; ehci_hcd<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; and address<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; 8<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; usb 1-6: configuration #1 chosen from 1<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; choice<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; usb 1-6: New USB device found,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; idVendor=0ccd,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; idProduct=0062<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; usb 1-6: New USB device strings: Mfr=1,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Product=2,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; SerialNumber=3<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; usb 1-6: Product: STK7700D<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; usb 1-6: Manufacturer: YUANRD<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; usb 1-6: SerialNumber: 0000000001<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; The card has afaik a dib7700PC chip.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Is it possible to get the card working?<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Greeting<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Yusuf Altin<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; _______________________________________________<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; linux-dvb mailing list<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; <a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; <a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
<br>
</div></div></blockquote></div><br>

------=_Part_120328_26082677.1231242924122--


--===============0240603332==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0240603332==--
