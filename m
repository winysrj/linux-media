Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.152])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <albert.comerma@gmail.com>) id 1JbOTU-0003HP-6B
	for linux-dvb@linuxtv.org; Tue, 18 Mar 2008 00:10:43 +0100
Received: by fg-out-1718.google.com with SMTP id 22so4420161fge.25
	for <linux-dvb@linuxtv.org>; Mon, 17 Mar 2008 16:10:32 -0700 (PDT)
Message-ID: <ea4209750803171610u22e948fcl4812f5c873801b64@mail.gmail.com>
Date: Tue, 18 Mar 2008 00:10:29 +0100
From: "Albert Comerma" <albert.comerma@gmail.com>
To: "Felix Apitzsch" <f.apitzsch@soz.uni-frankfurt.de>
In-Reply-To: <47DEF7DE.9080709@soz.uni-frankfurt.de>
MIME-Version: 1.0
References: <47DEF7DE.9080709@soz.uni-frankfurt.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Terratec Cinergy HT Express
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1753109446=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1753109446==
Content-Type: multipart/alternative;
	boundary="----=_Part_17307_21073893.1205795429882"

------=_Part_17307_21073893.1205795429882
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

To make dvb-t working (not analog), please have a look at my page;
http://www.comerma.net/pinnacle320cx_en.html
It should work for you just adding your device descriptor to
dvb-usb-ids.hand your card at dib0700_devices.c, I would try first to
use the same
frontend attach as other cinergy usb cards. If you think it's to complicated
I can try to add it for you, tomorrow. Please let me know.

Albert

2008/3/17, Felix Apitzsch <f.apitzsch@soz.uni-frankfurt.de>:
>
> Im am trying to get my Terratec Cinergy HT Express to work with v4l-dvb.
>
> It's a DVB-T/analog hybrid (+radio) ExpressCard 34, but it connects
> via the usb interface, not the pci-e interface. To confirm what I
> reckoned, I openend the device to find the following:
>
> DiBcom 7700C1-ACXXa-G QH0T8 D2PRJ.1 0646-1100-C
>
> XCEIVE XC3028 AK47465,2 0620TWE3
>
> CONEXANT CX25843-24Z 61024448 0625 KOREA
>
> (I took some photos if someone is interested)
>
> The usd-id is 0ccd:0060 .
>
> For now, I would be happy to live with just DVB-T support.
> As far as I understand the status quo, it should be possible to get
> the card running, isn't it?
>
> I would need some help to get the xc3028 part compiled and running and
> add it to dib0700_devices.c and dvb-usb-ids.h with the right config
> for the DIB770C1+XC3028. Additionally, I would need some assistance
> with the firmware xc3028. The dib0700 firmeware should be ok.
>
> Also, I had some trouble when I tried to get the xc3028 frontend code
> compiled. It is not in v4l_experimental anymore, is it? Where did it
> go and how do I include it?
>
> Could anyone do a patch for me and pack me a .bz2, so I can do some
> testing?
>
> I am running a kernel 2.6.24 on a x86_64 (~amd64) gentoo system with
> current v4l-dvb-hg from portage.
>
> Felix
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_17307_21073893.1205795429882
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

To make dvb-t working (not analog), please have a look at my page; <a href="http://www.comerma.net/pinnacle320cx_en.html">http://www.comerma.net/pinnacle320cx_en.html</a><br>It should work for you just adding your device descriptor to dvb-usb-ids.h and your card at dib0700_devices.c, I would try first to use the same frontend attach as other cinergy usb cards. If you think it&#39;s to complicated I can try to add it for you, tomorrow. Please let me know.<br>
<br>Albert<br><br><div><span class="gmail_quote">2008/3/17, Felix Apitzsch &lt;<a href="mailto:f.apitzsch@soz.uni-frankfurt.de">f.apitzsch@soz.uni-frankfurt.de</a>&gt;:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Im am trying to get my Terratec Cinergy HT Express to work with v4l-dvb.<br> <br> It&#39;s a DVB-T/analog hybrid (+radio) ExpressCard 34, but it connects<br> via the usb interface, not the pci-e interface. To confirm what I<br>
 reckoned, I openend the device to find the following:<br> <br> DiBcom 7700C1-ACXXa-G QH0T8 D2PRJ.1 0646-1100-C<br> <br> XCEIVE XC3028 AK47465,2 0620TWE3<br> <br> CONEXANT CX25843-24Z 61024448 0625 KOREA<br> <br> (I took some photos if someone is interested)<br>
 <br> The usd-id is 0ccd:0060 .<br> <br> For now, I would be happy to live with just DVB-T support.<br> As far as I understand the status quo, it should be possible to get<br> the card running, isn&#39;t it?<br> <br> I would need some help to get the xc3028 part compiled and running and<br>
 add it to dib0700_devices.c and dvb-usb-ids.h with the right config<br> for the DIB770C1+XC3028. Additionally, I would need some assistance<br> with the firmware xc3028. The dib0700 firmeware should be ok.<br> <br> Also, I had some trouble when I tried to get the xc3028 frontend code<br>
 compiled. It is not in v4l_experimental anymore, is it? Where did it<br> go and how do I include it?<br> <br> Could anyone do a patch for me and pack me a .bz2, so I can do some testing?<br> <br> I am running a kernel 2.6.24 on a x86_64 (~amd64) gentoo system with<br>
 current v4l-dvb-hg from portage.<br> <br> Felix<br> <br> _______________________________________________<br> linux-dvb mailing list<br> <a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br> <a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
 </blockquote></div><br>

------=_Part_17307_21073893.1205795429882--


--===============1753109446==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1753109446==--
