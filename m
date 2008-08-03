Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from an-out-0708.google.com ([209.85.132.240])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <albert.comerma@gmail.com>) id 1KPewz-0007xj-US
	for linux-dvb@linuxtv.org; Sun, 03 Aug 2008 16:52:57 +0200
Received: by an-out-0708.google.com with SMTP id c18so446447anc.125
	for <linux-dvb@linuxtv.org>; Sun, 03 Aug 2008 07:52:42 -0700 (PDT)
Message-ID: <ea4209750808030752j355b1359gc2ec76f37759a8a9@mail.gmail.com>
Date: Sun, 3 Aug 2008 16:52:40 +0200
From: "Albert Comerma" <albert.comerma@gmail.com>
To: mailgk@xs4all.nl
In-Reply-To: <1217763477.3847.14.camel@gk-sem3.gkall.nl>
MIME-Version: 1.0
References: <1217763477.3847.14.camel@gk-sem3.gkall.nl>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Pinnacle pctv hybrid pro stick 340e support
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0781177090=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0781177090==
Content-Type: multipart/alternative;
	boundary="----=_Part_14679_31465386.1217775160173"

------=_Part_14679_31465386.1217775160173
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Gerard, to try if it's a dibcom7700 based device you can try adding your
device descriptor to the v4l drivers. I think that would be the fastest. You
need the firmware and recompile with the modifications. If you don't know
how I can send you the modified files, but it's easy, basically add your
descriptor at v4l-dvb/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h and add
your device on v4l-dvb/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c ,
you can try on Pinnacle 320cx section.

Albert

2008/8/3 Gerard <mailgk@xs4all.nl>:

> Hello,
>
> Just bought and searched for support for the Pinnacle pctv hybrid pro
> stick 340e, not found.
>
> I have placed the lsusb -v output on
> http://www.gkall.nl/pinnacle-pctv-hybrid-pro-stick-340e.html
>
> information is in pinnacle-pctv-hybrid-pro-stick-340e.txt
>
>
> output from kernel.log
>
> Aug  2 16:48:25 gk-sem3 kernel: [26398.325169] usb 2-3: new high speed
> USB device using ehci_hcd and address 7
> Aug  2 16:48:25 gk-sem3 kernel: [26398.482055] usb 2-3: configuration #1
> chosen from 1 choice
> Aug  2 16:48:25 gk-sem3 kernel: [26398.482055] usb 2-3: New USB device
> found, idVendor=2304, idProduct=023d
> Aug  2 16:48:25 gk-sem3 kernel: [26398.482055] usb 2-3: New USB device
> strings: Mfr=1, Product=2, SerialNumber=3
> Aug  2 16:48:25 gk-sem3 kernel: [26398.482055] usb 2-3: Product: PCTV
> 340e
> Aug  2 16:48:25 gk-sem3 kernel: [26398.482055] usb 2-3: Manufacturer:
> YUANRD
> Aug  2 16:48:25 gk-sem3 kernel: [26398.482055] usb 2-3: SerialNumber:
> 060096D0F0
>
> I can do some test, intention is to get it working on a acer aspire one
> netbook.
>
> According to an other lsusb -v output it could be a dibcom chip??
>
> Question is if there is already some driver information?
>
> --
> --------
> m.vr.gr.
> Gerard Klaver
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_14679_31465386.1217775160173
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">Hi Gerard, to try if it&#39;s a dibcom7700 based device you can try adding your device descriptor to the v4l drivers. I think that would be the fastest. You need the firmware and recompile with the modifications. If you don&#39;t know how I can send you the modified files, but it&#39;s easy, basically add your descriptor at v4l-dvb/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h and add your device on v4l-dvb/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c , you can try on Pinnacle 320cx section.<br>
<br>Albert<br><br><div class="gmail_quote">2008/8/3 Gerard &lt;<a href="mailto:mailgk@xs4all.nl">mailgk@xs4all.nl</a>&gt;:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Hello,<br>
<br>
Just bought and searched for support for the Pinnacle pctv hybrid pro<br>
stick 340e, not found.<br>
<br>
I have placed the lsusb -v output on<br>
<a href="http://www.gkall.nl/pinnacle-pctv-hybrid-pro-stick-340e.html" target="_blank">http://www.gkall.nl/pinnacle-pctv-hybrid-pro-stick-340e.html</a><br>
<br>
information is in pinnacle-pctv-hybrid-pro-stick-340e.txt<br>
<br>
<br>
output from kernel.log<br>
<br>
Aug &nbsp;2 16:48:25 gk-sem3 kernel: [26398.325169] usb 2-3: new high speed<br>
USB device using ehci_hcd and address 7<br>
Aug &nbsp;2 16:48:25 gk-sem3 kernel: [26398.482055] usb 2-3: configuration #1<br>
chosen from 1 choice<br>
Aug &nbsp;2 16:48:25 gk-sem3 kernel: [26398.482055] usb 2-3: New USB device<br>
found, idVendor=2304, idProduct=023d<br>
Aug &nbsp;2 16:48:25 gk-sem3 kernel: [26398.482055] usb 2-3: New USB device<br>
strings: Mfr=1, Product=2, SerialNumber=3<br>
Aug &nbsp;2 16:48:25 gk-sem3 kernel: [26398.482055] usb 2-3: Product: PCTV<br>
340e<br>
Aug &nbsp;2 16:48:25 gk-sem3 kernel: [26398.482055] usb 2-3: Manufacturer:<br>
YUANRD<br>
Aug &nbsp;2 16:48:25 gk-sem3 kernel: [26398.482055] usb 2-3: SerialNumber:<br>
060096D0F0<br>
<br>
I can do some test, intention is to get it working on a acer aspire one<br>
netbook.<br>
<br>
According to an other lsusb -v output it could be a dibcom chip??<br>
<br>
Question is if there is already some driver information?<br>
<br>
--<br>
--------<br>
<a href="http://m.vr.gr" target="_blank">m.vr.gr</a>.<br>
Gerard Klaver<br>
<br>
<br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
</blockquote></div><br></div>

------=_Part_14679_31465386.1217775160173--


--===============0781177090==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0781177090==--
