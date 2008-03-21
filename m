Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.159])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <albert.comerma@gmail.com>) id 1Jclhu-0000CE-Ua
	for linux-dvb@linuxtv.org; Fri, 21 Mar 2008 19:11:13 +0100
Received: by fg-out-1718.google.com with SMTP id 22so1160674fge.25
	for <linux-dvb@linuxtv.org>; Fri, 21 Mar 2008 11:11:07 -0700 (PDT)
Message-ID: <ea4209750803211111m2b1bd83dyc4ce3b38b7b3ee66@mail.gmail.com>
Date: Fri, 21 Mar 2008 19:11:07 +0100
From: "Albert Comerma" <albert.comerma@gmail.com>
To: "Antti Palosaari" <crope@iki.fi>
In-Reply-To: <47E3CB84.3060208@iki.fi>
MIME-Version: 1.0
References: <47E3CB84.3060208@iki.fi>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] How to disable RC-polling from driver
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0842271383=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0842271383==
Content-Type: multipart/alternative;
	boundary="----=_Part_14297_11297094.1206123067034"

------=_Part_14297_11297094.1206123067034
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Moi,
I found this that perhaps is useful for you;
to disable rc_polling on /etc/modprobe.d/options add;

options dvb_usb disable_rc_polling=1

Albert

2008/3/21, Antti Palosaari <crope@iki.fi>:
>
> moi
> Is there any designed way (for example callback) to disable RC-polling
> (disable_rc_polling) from dvb-usb-driver module in runtime? There is
> information regarding remote controller usage stored in eeprom and
> therefore it is not possible use dvb_usb_device_properties structure
> (structure is populated earlier).
>
> regards
> Antti
>
> --
> http://palosaari.fi/
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_14297_11297094.1206123067034
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Moi, <br>I found this that perhaps is useful for you;<br>to disable rc_polling on /etc/modprobe.d/options add;<br><br>options dvb_usb disable_rc_polling=1<br><br>Albert<br><br><tt></tt>

<div><span class="gmail_quote">2008/3/21, Antti Palosaari &lt;<a href="mailto:crope@iki.fi">crope@iki.fi</a>&gt;:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
moi<br> Is there any designed way (for example callback) to disable RC-polling<br> (disable_rc_polling) from dvb-usb-driver module in runtime? There is<br> information regarding remote controller usage stored in eeprom and<br>
 therefore it is not possible use dvb_usb_device_properties structure<br> (structure is populated earlier).<br> <br> regards<br> Antti<br> <br>--<br> <a href="http://palosaari.fi/">http://palosaari.fi/</a><br> <br> _______________________________________________<br>
 linux-dvb mailing list<br> <a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br> <a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
 </blockquote></div><br>

------=_Part_14297_11297094.1206123067034--


--===============0842271383==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0842271383==--
