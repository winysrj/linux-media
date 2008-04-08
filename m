Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ik-out-1112.google.com ([66.249.90.183])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <albert.comerma@gmail.com>) id 1JjIv7-00029v-8A
	for linux-dvb@linuxtv.org; Tue, 08 Apr 2008 20:51:52 +0200
Received: by ik-out-1112.google.com with SMTP id b32so406899ika.1
	for <linux-dvb@linuxtv.org>; Tue, 08 Apr 2008 11:51:43 -0700 (PDT)
Message-ID: <ea4209750804081151t628c4d0egbbfae00d32526c68@mail.gmail.com>
Date: Tue, 8 Apr 2008 20:51:43 +0200
From: "Albert Comerma" <albert.comerma@gmail.com>
To: "Paolo Pettinato" <p.pettinato@gmail.com>
In-Reply-To: <79f9d6350804081125h5a480222gd33c5b44a6630204@mail.gmail.com>
MIME-Version: 1.0
References: <79f9d6350804081125h5a480222gd33c5b44a6630204@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Help with unsupported DVB-T usb stick (CE6230)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1935100814=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1935100814==
Content-Type: multipart/alternative;
	boundary="----=_Part_16867_8542338.1207680703153"

------=_Part_16867_8542338.1207680703153
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Paolo, buonasera,
 the first thing you need to know for adding a device is which hardware it's
using, and often the better is to just remove all the plastic of your device
and have a look at the chips... Once this has been done if you're lucky the
specifications of the chips would be public or already programmed and you
just would need to manage to get your card working. And if you're unlucky
you will have no information from the manufacturer and no information at all
and you will have to do reverse engineering...
It seems that this devices are based on two chips; CE 6230 usb bridge and
MXL5005 tuner. None of them are supported or in development currently, and
to get the specifications you need to get in touch with the manufacturers
(intel and  maxlinear).
Anyway, you can have a look at the code downloading it from mercurial (see
linuxtv.org), the usb dvb part is mostly inside
linux/drivers/media/dvb/dvb-usb/

Albert

2008/4/8 Paolo Pettinato <p.pettinato@gmail.com>:

> Hi all,
> I'm new to this mailing list so please excuse me if I do some mistakes
> :) also I feel sorry for my English :)
> I've recently bought a cheap DVB-T dongle on ebay. Works like a charm
> on windows XP, but it seems that there's no support on linux (I've
> done some searching).
> The vendorid:productid codes are 8086:9500. On "Device Manager" it is
> listed as "CE6230 Standalone Driver (BDA)". On its properties, it says
> that it's manufactured by Realfine Ltd and is on Location 0
> (CE9500B1).
> Since I can't stand the fact that I can't use some hardware on linux,
> I'm asking two questions:
> 1. Has any work be done to support this device (or similar ones, like
> - I think - the "AVerMedia USB2.0 DVB-T A310")?
> 2. If so, how can I help further developing?
>
> I'm a student in computer engineering, so I won't mind spending some
> time on driver developing (though I have never done till now).
> Paolo
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_16867_8542338.1207680703153
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Paolo, buonasera,<br>&nbsp;the first thing you need to know for adding a device is which hardware it&#39;s using, and often the better is to just remove all the plastic of your device and have a look at the chips... Once this has been done if you&#39;re lucky the specifications of the chips would be public or already programmed and you just would need to manage to get your card working. And if you&#39;re unlucky you will have no information from the manufacturer and no information at all and you will have to do reverse engineering...<br>
It seems that this devices are based on two chips; CE 6230 usb bridge and MXL5005 tuner. None of them are supported or in development currently, and to get the specifications you need to get in touch with the manufacturers (intel and&nbsp; maxlinear). <br>
Anyway, you can have a look at the code downloading it from mercurial (see <a href="http://linuxtv.org">linuxtv.org</a>), the usb dvb part is mostly inside linux/drivers/media/dvb/dvb-usb/<br><br>Albert<br><br><div class="gmail_quote">
2008/4/8 Paolo Pettinato &lt;<a href="mailto:p.pettinato@gmail.com">p.pettinato@gmail.com</a>&gt;:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Hi all,<br>
I&#39;m new to this mailing list so please excuse me if I do some mistakes<br>
:) also I feel sorry for my English :)<br>
I&#39;ve recently bought a cheap DVB-T dongle on ebay. Works like a charm<br>
on windows XP, but it seems that there&#39;s no support on linux (I&#39;ve<br>
done some searching).<br>
The vendorid:productid codes are 8086:9500. On &quot;Device Manager&quot; it is<br>
listed as &quot;CE6230 Standalone Driver (BDA)&quot;. On its properties, it says<br>
that it&#39;s manufactured by Realfine Ltd and is on Location 0<br>
(CE9500B1).<br>
Since I can&#39;t stand the fact that I can&#39;t use some hardware on linux,<br>
I&#39;m asking two questions:<br>
1. Has any work be done to support this device (or similar ones, like<br>
- I think - the &quot;AVerMedia USB2.0 DVB-T A310&quot;)?<br>
2. If so, how can I help further developing?<br>
<br>
I&#39;m a student in computer engineering, so I won&#39;t mind spending some<br>
time on driver developing (though I have never done till now).<br>
Paolo<br>
<br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
</blockquote></div><br>

------=_Part_16867_8542338.1207680703153--


--===============1935100814==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1935100814==--
