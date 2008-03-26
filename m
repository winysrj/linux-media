Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.154])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <albert.comerma@gmail.com>) id 1JeT1V-0002bG-Vb
	for linux-dvb@linuxtv.org; Wed, 26 Mar 2008 11:38:28 +0100
Received: by fg-out-1718.google.com with SMTP id 22so2972100fge.25
	for <linux-dvb@linuxtv.org>; Wed, 26 Mar 2008 03:38:22 -0700 (PDT)
Message-ID: <ea4209750803260338k48f25e8mf95c5734481d2da7@mail.gmail.com>
Date: Wed, 26 Mar 2008 11:38:22 +0100
From: "Albert Comerma" <albert.comerma@gmail.com>
To: elupus <elupus@ecce.se>
In-Reply-To: <a7d0idxnqmsq.1kxbekc9wr0n1.dlg@40tude.net>
MIME-Version: 1.0
References: <timjkg4t68k0.u9vss0x6vh17$.dlg@40tude.net>
	<19apj9y5ari7e$.iq8vatom4e8q.dlg@40tude.net>
	<a7d0idxnqmsq.1kxbekc9wr0n1.dlg@40tude.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] STK7700-PH ( dib7700 + ConexantCX25842 + Xceive
	XC3028 )
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1235556602=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1235556602==
Content-Type: multipart/alternative;
	boundary="----=_Part_16095_30345613.1206527902485"

------=_Part_16095_30345613.1206527902485
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

So, to sum up. Using the "standard" configuration of dibcom 7700+xc3028 you
managed to get dvb-t working.
Perhaps you have some problem with your computer power management and it
keeps power on usb while it's off.

Albert

2008/3/26, elupus <elupus@ecce.se>:
>
> On Tue, 25 Mar 2008 23:18:02 +0100, elupus wrote:
>
> > Okey, I finally got this up and running.
> >
>
>
> An update on this. I might have been wrong in the requirement of the other
> firmware. What I instead found out is that if the card is in warmstate
> when
> kernel boots, things doesn't work. (fails in the way posted first in this
> thread).
> If i poweroff machine and pull the plug. It boots and then device is in
> cold state. Then everything works properly.
>
> What gives???
>
>
> Regards
> Joakim
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_16095_30345613.1206527902485
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

So, to sum up. Using the &quot;standard&quot; configuration of dibcom 7700+xc3028 you managed to get dvb-t working. <br>Perhaps you have some problem with your computer power management and it keeps power on usb while it&#39;s off.<br>
<br>Albert<br><br><div><span class="gmail_quote">2008/3/26, elupus &lt;<a href="mailto:elupus@ecce.se">elupus@ecce.se</a>&gt;:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
On Tue, 25 Mar 2008 23:18:02 +0100, elupus wrote:<br> <br> &gt; Okey, I finally got this up and running.<br> &gt;<br> <br> <br>An update on this. I might have been wrong in the requirement of the other<br> firmware. What I instead found out is that if the card is in warmstate when<br>
 kernel boots, things doesn&#39;t work. (fails in the way posted first in this<br> thread).<br> If i poweroff machine and pull the plug. It boots and then device is in<br> cold state. Then everything works properly.<br> <br>
 What gives???<br> <br><br> Regards<br> Joakim<br> <br> <br> _______________________________________________<br> linux-dvb mailing list<br> <a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br> <a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
 </blockquote></div><br>

------=_Part_16095_30345613.1206527902485--


--===============1235556602==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1235556602==--
