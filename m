Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from an-out-0708.google.com ([209.85.132.246])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <albert.comerma@gmail.com>) id 1KcGWf-0001X5-KS
	for linux-dvb@linuxtv.org; Sun, 07 Sep 2008 11:25:46 +0200
Received: by an-out-0708.google.com with SMTP id c18so173344anc.125
	for <linux-dvb@linuxtv.org>; Sun, 07 Sep 2008 02:25:41 -0700 (PDT)
Message-ID: <ea4209750809070225t7990e924l63c2a5f718d4dcf3@mail.gmail.com>
Date: Sun, 7 Sep 2008 11:25:41 +0200
From: "Albert Comerma" <albert.comerma@gmail.com>
To: "Daniel Oliveira Nascimento" <don@syst.com.br>
In-Reply-To: <a86be8e70809062055v6157e476nfbff0cba13dbd444@mail.gmail.com>
MIME-Version: 1.0
References: <a86be8e70809062055v6157e476nfbff0cba13dbd444@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] support YUAN High-Tech STK7700D (1164:1f08)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1305810481=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1305810481==
Content-Type: multipart/alternative;
	boundary="----=_Part_262_14901601.1220779541364"

------=_Part_262_14901601.1220779541364
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Daniel, it would be great if somebody could test it, just to be sure,
before adding it to the current driver. On the analogue there are some
efforts on porting the needed api to dvb-usb, but still with no results.
Let's hope in a few months...

Albert

2008/9/7 Daniel Oliveira Nascimento <don@syst.com.br>

> Hi List,
>
> attached is a patch that extends the dib0700 driver to support the DVB-part of the Asus notebook M51Sn tv-tunner (USB-ID 1164:1f08).
>
> Following this thread:
> http://thread.gmane.org/gmane.linux.drivers.dvb/39269/focus=39298
>
> I reproduced the same behavior that Albert Comerma had with his card. So I think that the same code will work with this card.
> I can't test if the card work properly with the patch because a live in Brazil and the digital tv standard is different.
>
> But I think that this information will be useful for someone trying to make this card work.
>
> Did someone make the analog part of any of these cards "Terratec Cinergy HT USB XE", "Pinnacle Expresscard 320cx" or "Terratec Cinergy HT Express" work ?
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_262_14901601.1220779541364
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">Hi Daniel, it would be great if somebody could test it, just to be sure, before adding it to the current driver. On the analogue there are some efforts on porting the needed api to dvb-usb, but still with no results. Let&#39;s hope in a few months...<br>
<br>Albert<br><br><div class="gmail_quote">2008/9/7 Daniel Oliveira Nascimento <span dir="ltr">&lt;<a href="mailto:don@syst.com.br">don@syst.com.br</a>&gt;</span><br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div dir="ltr"><pre>Hi List,<br><br>attached is a patch that extends the dib0700 driver to support the DVB-part of the Asus notebook M51Sn tv-tunner (USB-ID 1164:1f08).<br><br>Following this thread:<br><a href="http://thread.gmane.org/gmane.linux.drivers.dvb/39269/focus=39298" target="_blank">http://thread.gmane.org/gmane.linux.drivers.dvb/39269/focus=39298</a><br>

<br>I reproduced the same behavior that Albert Comerma had with his card. So I think that the same code will work with this card.<br>I can&#39;t test if the card work properly with the patch because a live in Brazil and the digital tv standard is different. <br>

But I think that this information will be useful for someone trying to make this card work.<br><br>Did someone make the analog part of any of these cards &quot;Terratec Cinergy HT USB XE&quot;, &quot;Pinnacle Expresscard 320cx&quot; or &quot;Terratec Cinergy HT Express&quot; work ?<br>

<br></pre></div>
<br>_______________________________________________<br>
linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br></blockquote></div><br></div>

------=_Part_262_14901601.1220779541364--


--===============1305810481==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1305810481==--
