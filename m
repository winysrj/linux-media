Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from an-out-0708.google.com ([209.85.132.251])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <albert.comerma@gmail.com>) id 1LJU9F-0004od-V3
	for linux-dvb@linuxtv.org; Sun, 04 Jan 2009 15:40:14 +0100
Received: by an-out-0708.google.com with SMTP id b38so1925073ana.41
	for <linux-dvb@linuxtv.org>; Sun, 04 Jan 2009 06:40:06 -0800 (PST)
Message-ID: <ea4209750901040640k532f2dc0rf918fb4967a4a19d@mail.gmail.com>
Date: Sun, 4 Jan 2009 15:40:06 +0100
From: "Albert Comerma" <albert.comerma@gmail.com>
To: "Yusuf Altin" <yusuf.altin@t-online.de>
In-Reply-To: <1231015340.2963.7.camel@yusuf.laptop>
MIME-Version: 1.0
References: <1231015340.2963.7.camel@yusuf.laptop>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TerraTec Cinergy T Express
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1839551743=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1839551743==
Content-Type: multipart/alternative;
	boundary="----=_Part_111810_17775525.1231080006172"

------=_Part_111810_17775525.1231080006172
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Yusuf, if you're sure about the type of the device you should try to
modify the v4l source code, probably just adding your new device it should
work.

To do so you will need; mercurial, gcc, make and linux-headers matching your
kernel. Once installed you can get the current source code runing;  hg clone
http://linuxtv.org/hg/v4l-dvb
You will also need the card's firmware, you can get it from
http://www.wi-bw.tfh-wildau.de/~pboettch/home/linux-dvb-firmware/dvb-usb-dib0700-1.10.fwand
copy it to /lib/firmware/
Then go to v4l-dvb/linux/drivers/media/dvb/dvb-usb and modify the files
dib-usb-ids.h adding the new id with a descriptor, and dib0700_devices.c
Once modified just run make and make install (as root, this can potentialy
screw other v4l drivers), and test it (if you have the modules loaded you
will need to reload them).

If you want to try it and don't know how to modify the files just tell me
and I can make your version, but only ask for it when you have everything
installed and ready.

Albert

2009/1/3 Yusuf Altin <yusuf.altin@t-online.de>

> Hello,
>
> I own a TerraTec Cinergy T Express DVB-T Card and it doesn't work with
> Fedora 10.
>
> My kernel is 2.6.27.10-167.fc10.i686.
>
> lsusb:
> Bus 001 Device 008: ID 0ccd:0062 TerraTec Electronic GmbH
>
> dmesg:
> usb 1-6: new high speed USB device using ehci_hcd and address 8
> usb 1-6: configuration #1 chosen from 1 choice
> usb 1-6: New USB device found, idVendor=0ccd, idProduct=0062
> usb 1-6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> usb 1-6: Product: STK7700D
> usb 1-6: Manufacturer: YUANRD
> usb 1-6: SerialNumber: 0000000001
>
> The card has afaik a dib7700PC chip.
>
> Is it possible to get the card working?
>
> Greeting
>
> Yusuf Altin
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_111810_17775525.1231080006172
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Yusuf, if you&#39;re sure about the type of the device you should try to modify the v4l source code, probably just adding your new device it should work.<br><br>To do so you will need; mercurial, gcc, make and linux-headers matching your kernel. Once installed you can get the current source code runing;&nbsp; hg clone <a href="http://linuxtv.org/hg/v4l-dvb">http://linuxtv.org/hg/v4l-dvb</a><br>
You will also need the card&#39;s firmware, you can get it from <a href="http://www.wi-bw.tfh-wildau.de/~pboettch/home/linux-dvb-firmware/dvb-usb-dib0700-1.10.fw">http://www.wi-bw.tfh-wildau.de/~pboettch/home/linux-dvb-firmware/dvb-usb-dib0700-1.10.fw</a> and copy it to /lib/firmware/<br>
Then go to v4l-dvb/linux/drivers/media/dvb/dvb-usb and modify the files dib-usb-ids.h adding the new id with a descriptor, and dib0700_devices.c<br>Once modified just run make and make install (as root, this can potentialy screw other v4l drivers), and test it (if you have the modules loaded you will need to reload them).<br>
<br>If you want to try it and don&#39;t know how to modify the files just tell me and I can make your version, but only ask for it when you have everything installed and ready.<br><br>Albert<br><br><div class="gmail_quote">
2009/1/3 Yusuf Altin <span dir="ltr">&lt;<a href="mailto:yusuf.altin@t-online.de">yusuf.altin@t-online.de</a>&gt;</span><br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Hello,<br>
<br>
I own a TerraTec Cinergy T Express DVB-T Card and it doesn&#39;t work with<br>
Fedora 10.<br>
<br>
My kernel is 2.6.27.10-167.fc10.i686.<br>
<br>
lsusb:<br>
Bus 001 Device 008: ID 0ccd:0062 TerraTec Electronic GmbH<br>
<br>
dmesg:<br>
usb 1-6: new high speed USB device using ehci_hcd and address 8<br>
usb 1-6: configuration #1 chosen from 1 choice<br>
usb 1-6: New USB device found, idVendor=0ccd, idProduct=0062<br>
usb 1-6: New USB device strings: Mfr=1, Product=2, SerialNumber=3<br>
usb 1-6: Product: STK7700D<br>
usb 1-6: Manufacturer: YUANRD<br>
usb 1-6: SerialNumber: 0000000001<br>
<br>
The card has afaik a dib7700PC chip.<br>
<br>
Is it possible to get the card working?<br>
<br>
Greeting<br>
<br>
Yusuf Altin<br>
<br>
<br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
</blockquote></div><br>

------=_Part_111810_17775525.1231080006172--


--===============1839551743==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1839551743==--
