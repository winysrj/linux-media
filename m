Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rn-out-0910.google.com ([64.233.170.185])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <albert.comerma@gmail.com>) id 1LJn4D-0002VO-Sh
	for linux-dvb@linuxtv.org; Mon, 05 Jan 2009 11:52:18 +0100
Received: by rn-out-0910.google.com with SMTP id j43so4511391rne.2
	for <linux-dvb@linuxtv.org>; Mon, 05 Jan 2009 02:52:13 -0800 (PST)
Message-ID: <ea4209750901050252i76e0e6cdvd4ae7ea142facc25@mail.gmail.com>
Date: Mon, 5 Jan 2009 11:52:13 +0100
From: "Albert Comerma" <albert.comerma@gmail.com>
To: "Yusuf Altin" <yusuf.altin@t-online.de>
In-Reply-To: <1231145794.2968.15.camel@yusuf.laptop>
MIME-Version: 1.0
References: <1231015340.2963.7.camel@yusuf.laptop>
	<ea4209750901040640k532f2dc0rf918fb4967a4a19d@mail.gmail.com>
	<1231145794.2968.15.camel@yusuf.laptop>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TerraTec Cinergy T Express
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1345133484=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1345133484==
Content-Type: multipart/alternative;
	boundary="----=_Part_117006_22248573.1231152733176"

------=_Part_117006_22248573.1231152733176
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

The patch looks good and now dmesg looks much better, and I guess there must
be a /dev/dvb/ something created when you plug your card.
First could you try to move your device to the STK7700D section? I mean
around line 1539... reverting changes on the other section...
If that doesn't work you can also try next section which has some small
changes on attaching the tunner... around line 1569 or on another section
around line 1715.
If there's some led on the card it goes on after connecting?
If nothing works probably there's some GPIO wrong with that card... and
that's not easy to solve, just change and try... when you try to scan
channels what you see on dmesg?

Albert

2009/1/5 Yusuf Altin <yusuf.altin@t-online.de>

> Hi Albert,
>
> thanks for you helping.
>
> I downloaded and modified the sourcecode like this:
>
> dvb-usb-ids.h:
>        #define USB_PID_TERRATEC_CINERGY_HT_USB_XE              0x0058
>        #define USB_PID_TERRATEC_CINERGY_HT_EXPRESS             0x0060
> +       #define USB_PID_TERRATEC_CINERGY_T_EXPRESS              0x0062
>        #define USB_PID_TERRATEC_CINERGY_T_XXS                  0x0078
>        #define USB_PID_PINNACLE_EXPRESSCARD_320CX              0x022e
>
> dib0700_devices.c:
>
> LL 1393
>        { USB_DEVICE(USB_VID_ASUS,      USB_PID_ASUS_U3000H) },
> /* 40 */{ USB_DEVICE(USB_VID_PINNACLE,  USB_PID_PINNACLE_PCTV801E) },
>        { USB_DEVICE(USB_VID_PINNACLE,  USB_PID_PINNACLE_PCTV801E_SE) },
> + { USB_DEVICE(USB_VID_TERRATEC,        USB_PID_TERRATEC_CINERGY_T_EXPRESS)
> },
>        { 0 }           /* Terminating entry */
>
>
> LL 1438
> -               .num_device_descs = 8,
> +               .num_device_descs = 9,
>                .devices = {
>                        {   "DiBcom STK7700P reference design",
>                                { &dib0700_usb_id_table[0],
> &dib0700_usb_id_table[1] },
>                                { NULL },
>                        },
>                        {   "Hauppauge Nova-T Stick",
>                                { &dib0700_usb_id_table[4],
> &dib0700_usb_id_table[9], NULL },
>                                { NULL },
>                        },
>                        {   "AVerMedia AVerTV DVB-T Volar",
>                                { &dib0700_usb_id_table[5],
> &dib0700_usb_id_table[10] },
>                                { NULL },
>                        },
>                        {   "Compro Videomate U500",
>                                { &dib0700_usb_id_table[6],
> &dib0700_usb_id_table[19] },
>                                { NULL },
>                        },
>                        {   "Uniwill STK7700P based (Hama and others)",
>                                { &dib0700_usb_id_table[7], NULL },
>                                { NULL },
>                        },
>                        {   "Leadtek Winfast DTV Dongle (STK7700P based)",
>                                { &dib0700_usb_id_table[8],
> &dib0700_usb_id_table[34] },
>                                { NULL },
>                        },
>                        {   "AVerMedia AVerTV DVB-T Express",
>                                { &dib0700_usb_id_table[20] },
>                                { NULL },
>                        },
>                        {   "Gigabyte U7000",
>                                { &dib0700_usb_id_table[21], NULL },
>                                { NULL },
> -                       }
> +                       },
> +                       {   "Terratec Cinergy T Express",
> +                               { &dib0700_usb_id_table[42], NULL },
> +                               { NULL },
> +                       }
>                },
>
>
> make and make install was no problem.
>
>
> Now dmesg says
>
> usb 1-6: new high speed USB device using ehci_hcd and address 9
> usb 1-6: configuration #1 chosen from 1 choice
> dvb-usb: found a 'Terratec Cinergy T Express' in cold state, will try to
> load a firmware
> firmware: requesting dvb-usb-dib0700-1.20.fw
> dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
> dib0700: firmware started successfully.
> dvb-usb: found a 'Terratec Cinergy T Express' in warm state.
> dvb-usb: will pass the complete MPEG2 transport stream to the software
> demuxer.
> DVB: registering new adapter (Terratec Cinergy T Express)
> DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
> input: IR-receiver inside an USB DVB receiver
> as /devices/pci0000:00/0000:00:1d.7/usb1/1-6/input/input17
> dvb-usb: schedule remote query interval to 50 msecs.
> dvb-usb: Terratec Cinergy T Express successfully initialized and
> connected.
> usb 1-6: New USB device found, idVendor=0ccd, idProduct=0062
> usb 1-6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> usb 1-6: Product: STK7700D
> usb 1-6: Manufacturer: YUANRD
> usb 1-6: SerialNumber: 0000000001
>
> I mean it looks better
>
> Now I am able to select the card in Totem but the picture stays black
> (dvb-channels.conf is ok), same problem in vlc.
>
> What went wrong?
>
> Yusuf
>
> Am Sonntag, den 04.01.2009, 15:40 +0100 schrieb Albert Comerma:
> > Hi Yusuf, if you're sure about the type of the device you should try
> > to modify the v4l source code, probably just adding your new device it
> > should work.
> >
> > To do so you will need; mercurial, gcc, make and linux-headers
> > matching your kernel. Once installed you can get the current source
> > code runing;  hg clone http://linuxtv.org/hg/v4l-dvb
> > You will also need the card's firmware, you can get it from
> >
> http://www.wi-bw.tfh-wildau.de/~pboettch/home/linux-dvb-firmware/dvb-usb-dib0700-1.10.fw<http://www.wi-bw.tfh-wildau.de/%7Epboettch/home/linux-dvb-firmware/dvb-usb-dib0700-1.10.fw>and copy it to /lib/firmware/
> > Then go to v4l-dvb/linux/drivers/media/dvb/dvb-usb and modify the
> > files dib-usb-ids.h adding the new id with a descriptor, and
> > dib0700_devices.c
> > Once modified just run make and make install (as root, this can
> > potentialy screw other v4l drivers), and test it (if you have the
> > modules loaded you will need to reload them).
> >
> > If you want to try it and don't know how to modify the files just tell
> > me and I can make your version, but only ask for it when you have
> > everything installed and ready.
> >
> > Albert
> >
> > 2009/1/3 Yusuf Altin <yusuf.altin@t-online.de>
> >         Hello,
> >
> >         I own a TerraTec Cinergy T Express DVB-T Card and it doesn't
> >         work with
> >         Fedora 10.
> >
> >         My kernel is 2.6.27.10-167.fc10.i686.
> >
> >         lsusb:
> >         Bus 001 Device 008: ID 0ccd:0062 TerraTec Electronic GmbH
> >
> >         dmesg:
> >         usb 1-6: new high speed USB device using ehci_hcd and address
> >         8
> >         usb 1-6: configuration #1 chosen from 1 choice
> >         usb 1-6: New USB device found, idVendor=0ccd, idProduct=0062
> >         usb 1-6: New USB device strings: Mfr=1, Product=2,
> >         SerialNumber=3
> >         usb 1-6: Product: STK7700D
> >         usb 1-6: Manufacturer: YUANRD
> >         usb 1-6: SerialNumber: 0000000001
> >
> >         The card has afaik a dib7700PC chip.
> >
> >         Is it possible to get the card working?
> >
> >         Greeting
> >
> >         Yusuf Altin
> >
> >
> >         _______________________________________________
> >         linux-dvb mailing list
> >         linux-dvb@linuxtv.org
> >         http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >
>
>

------=_Part_117006_22248573.1231152733176
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

The patch looks good and now dmesg looks much better, and I guess there must be a /dev/dvb/ something created when you plug your card. <br>First could you try to move your device to the STK7700D section? I mean around line 1539... reverting changes on the other section...<br>
If that doesn&#39;t work you can also try next section which has some small changes on attaching the tunner... around line 1569 or on another section around line 1715.<br>If there&#39;s some led on the card it goes on after connecting?<br>
If nothing works probably there&#39;s some GPIO wrong with that card... and that&#39;s not easy to solve, just change and try... when you try to scan channels what you see on dmesg?<br><br>Albert<br><br><div class="gmail_quote">
2009/1/5 Yusuf Altin <span dir="ltr">&lt;<a href="mailto:yusuf.altin@t-online.de">yusuf.altin@t-online.de</a>&gt;</span><br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Hi Albert,<br>
<br>
thanks for you helping.<br>
<br>
I downloaded and modified the sourcecode like this:<br>
<br>
dvb-usb-ids.h:<br>
 &nbsp; &nbsp; &nbsp; &nbsp;#define USB_PID_TERRATEC_CINERGY_HT_USB_XE &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;0x0058<br>
 &nbsp; &nbsp; &nbsp; &nbsp;#define USB_PID_TERRATEC_CINERGY_HT_EXPRESS &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 0x0060<br>
+ &nbsp; &nbsp; &nbsp; #define USB_PID_TERRATEC_CINERGY_T_EXPRESS &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;0x0062<br>
 &nbsp; &nbsp; &nbsp; &nbsp;#define USB_PID_TERRATEC_CINERGY_T_XXS &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;0x0078<br>
 &nbsp; &nbsp; &nbsp; &nbsp;#define USB_PID_PINNACLE_EXPRESSCARD_320CX &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;0x022e<br>
<br>
dib0700_devices.c:<br>
<br>
LL 1393<br>
 &nbsp; &nbsp; &nbsp; &nbsp;{ USB_DEVICE(USB_VID_ASUS, &nbsp; &nbsp; &nbsp;USB_PID_ASUS_U3000H) },<br>
/* 40 */{ USB_DEVICE(USB_VID_PINNACLE, &nbsp;USB_PID_PINNACLE_PCTV801E) },<br>
 &nbsp; &nbsp; &nbsp; &nbsp;{ USB_DEVICE(USB_VID_PINNACLE, &nbsp;USB_PID_PINNACLE_PCTV801E_SE) },<br>
+ { USB_DEVICE(USB_VID_TERRATEC, &nbsp; &nbsp; &nbsp; &nbsp;USB_PID_TERRATEC_CINERGY_T_EXPRESS) },<br>
 &nbsp; &nbsp; &nbsp; &nbsp;{ 0 } &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; /* Terminating entry */<br>
<br>
<br>
LL 1438<br>
- &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; .num_device_descs = 8,<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; .num_device_descs = 9,<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.devices = {<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ &nbsp; &quot;DiBcom STK7700P reference design&quot;,<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ &amp;dib0700_usb_id_table[0], &amp;dib0700_usb_id_table[1] },<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ NULL },<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;},<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ &nbsp; &quot;Hauppauge Nova-T Stick&quot;,<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ &amp;dib0700_usb_id_table[4], &amp;dib0700_usb_id_table[9], NULL },<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ NULL },<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;},<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ &nbsp; &quot;AVerMedia AVerTV DVB-T Volar&quot;,<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ &amp;dib0700_usb_id_table[5], &amp;dib0700_usb_id_table[10] },<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ NULL },<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;},<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ &nbsp; &quot;Compro Videomate U500&quot;,<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ &amp;dib0700_usb_id_table[6], &amp;dib0700_usb_id_table[19] },<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ NULL },<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;},<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ &nbsp; &quot;Uniwill STK7700P based (Hama and others)&quot;,<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ &amp;dib0700_usb_id_table[7], NULL },<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ NULL },<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;},<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ &nbsp; &quot;Leadtek Winfast DTV Dongle (STK7700P based)&quot;,<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ &amp;dib0700_usb_id_table[8], &amp;dib0700_usb_id_table[34] },<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ NULL },<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;},<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ &nbsp; &quot;AVerMedia AVerTV DVB-T Express&quot;,<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ &amp;dib0700_usb_id_table[20] },<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ NULL },<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;},<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ &nbsp; &quot;Gigabyte U7000&quot;,<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ &amp;dib0700_usb_id_table[21], NULL },<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ NULL },<br>
- &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; },<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; { &nbsp; &quot;Terratec Cinergy T Express&quot;,<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; { &amp;dib0700_usb_id_table[42], NULL },<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; { NULL },<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;},<br>
<br>
<br>
make and make install was no problem.<br>
<br>
<br>
Now dmesg says<br>
<div class="Ih2E3d"><br>
usb 1-6: new high speed USB device using ehci_hcd and address 9<br>
usb 1-6: configuration #1 chosen from 1 choice<br>
</div>dvb-usb: found a &#39;Terratec Cinergy T Express&#39; in cold state, will try to<br>
load a firmware<br>
firmware: requesting dvb-usb-dib0700-1.20.fw<br>
dvb-usb: downloading firmware from file &#39;dvb-usb-dib0700-1.20.fw&#39;<br>
dib0700: firmware started successfully.<br>
dvb-usb: found a &#39;Terratec Cinergy T Express&#39; in warm state.<br>
dvb-usb: will pass the complete MPEG2 transport stream to the software<br>
demuxer.<br>
DVB: registering new adapter (Terratec Cinergy T Express)<br>
DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...<br>
input: IR-receiver inside an USB DVB receiver<br>
as /devices/pci0000:00/0000:00:1d.7/usb1/1-6/input/input17<br>
dvb-usb: schedule remote query interval to 50 msecs.<br>
dvb-usb: Terratec Cinergy T Express successfully initialized and<br>
connected.<br>
<div class="Ih2E3d">usb 1-6: New USB device found, idVendor=0ccd, idProduct=0062<br>
usb 1-6: New USB device strings: Mfr=1, Product=2, SerialNumber=3<br>
usb 1-6: Product: STK7700D<br>
usb 1-6: Manufacturer: YUANRD<br>
usb 1-6: SerialNumber: 0000000001<br>
<br>
</div>I mean it looks better<br>
<br>
Now I am able to select the card in Totem but the picture stays black<br>
(dvb-channels.conf is ok), same problem in vlc.<br>
<br>
What went wrong?<br>
<br>
Yusuf<br>
<br>
Am Sonntag, den 04.01.2009, 15:40 +0100 schrieb Albert Comerma:<br>
<div><div></div><div class="Wj3C7c">&gt; Hi Yusuf, if you&#39;re sure about the type of the device you should try<br>
&gt; to modify the v4l source code, probably just adding your new device it<br>
&gt; should work.<br>
&gt;<br>
&gt; To do so you will need; mercurial, gcc, make and linux-headers<br>
&gt; matching your kernel. Once installed you can get the current source<br>
&gt; code runing; &nbsp;hg clone <a href="http://linuxtv.org/hg/v4l-dvb" target="_blank">http://linuxtv.org/hg/v4l-dvb</a><br>
&gt; You will also need the card&#39;s firmware, you can get it from<br>
&gt; <a href="http://www.wi-bw.tfh-wildau.de/%7Epboettch/home/linux-dvb-firmware/dvb-usb-dib0700-1.10.fw" target="_blank">http://www.wi-bw.tfh-wildau.de/~pboettch/home/linux-dvb-firmware/dvb-usb-dib0700-1.10.fw</a> and copy it to /lib/firmware/<br>

&gt; Then go to v4l-dvb/linux/drivers/media/dvb/dvb-usb and modify the<br>
&gt; files dib-usb-ids.h adding the new id with a descriptor, and<br>
&gt; dib0700_devices.c<br>
&gt; Once modified just run make and make install (as root, this can<br>
&gt; potentialy screw other v4l drivers), and test it (if you have the<br>
&gt; modules loaded you will need to reload them).<br>
&gt;<br>
&gt; If you want to try it and don&#39;t know how to modify the files just tell<br>
&gt; me and I can make your version, but only ask for it when you have<br>
&gt; everything installed and ready.<br>
&gt;<br>
&gt; Albert<br>
&gt;<br>
&gt; 2009/1/3 Yusuf Altin &lt;<a href="mailto:yusuf.altin@t-online.de">yusuf.altin@t-online.de</a>&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Hello,<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; I own a TerraTec Cinergy T Express DVB-T Card and it doesn&#39;t<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; work with<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Fedora 10.<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; My kernel is 2.6.27.10-167.fc10.i686.<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; lsusb:<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Bus 001 Device 008: ID 0ccd:0062 TerraTec Electronic GmbH<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; dmesg:<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; usb 1-6: new high speed USB device using ehci_hcd and address<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; 8<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; usb 1-6: configuration #1 chosen from 1 choice<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; usb 1-6: New USB device found, idVendor=0ccd, idProduct=0062<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; usb 1-6: New USB device strings: Mfr=1, Product=2,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; SerialNumber=3<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; usb 1-6: Product: STK7700D<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; usb 1-6: Manufacturer: YUANRD<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; usb 1-6: SerialNumber: 0000000001<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; The card has afaik a dib7700PC chip.<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Is it possible to get the card working?<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Greeting<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Yusuf Altin<br>
&gt;<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; _______________________________________________<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; linux-dvb mailing list<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; <a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; <a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
&gt;<br>
<br>
</div></div></blockquote></div><br>

------=_Part_117006_22248573.1231152733176--


--===============1345133484==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1345133484==--
