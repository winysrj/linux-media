Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.153])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <albert.comerma@gmail.com>) id 1JRpOT-0001tx-2e
	for linux-dvb@linuxtv.org; Wed, 20 Feb 2008 14:53:53 +0100
Received: by fg-out-1718.google.com with SMTP id 22so1921494fge.25
	for <linux-dvb@linuxtv.org>; Wed, 20 Feb 2008 05:53:49 -0800 (PST)
Message-ID: <ea4209750802200553g13eb8ef5yb4abc2c1e012b803@mail.gmail.com>
Date: Wed, 20 Feb 2008 14:53:49 +0100
From: "Albert Comerma" <albert.comerma@gmail.com>
To: "Antti Palosaari" <crope@iki.fi>
In-Reply-To: <47BC2189.8070308@iki.fi>
MIME-Version: 1.0
References: <ea4209750801161224p6b75d7fanbdcd29e7d367802d@mail.gmail.com>
	<47B9D533.7050504@iki.fi>
	<ea4209750802181306tcc8c98clff330d4289523d96@mail.gmail.com>
	<47BA011D.9060003@iki.fi>
	<ea4209750802181424q4ac90c7ag33ad8b8d79e258fd@mail.gmail.com>
	<47BA0C4D.4070102@iki.fi>
	<ea4209750802181530p7bd2ec78j562e7fdf281890b5@mail.gmail.com>
	<47BC2189.8070308@iki.fi>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Yuan EC372S (STK7700D based device)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1186525186=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1186525186==
Content-Type: multipart/alternative;
	boundary="----=_Part_7085_33096148.1203515629244"

------=_Part_7085_33096148.1203515629244
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

moikka (I love this expression),

Michel (the person wich tested the driver, reported the same error as you).
But the solution is not trivial, I post his mail about this stuff;

This is the errors he was having (same as you);

scan -c -o zap
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
Network Name 'RTBF BE'
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x003c
WARNING: filter timeout pid 0x0038
WARNING: filter timeout pid 0x0032
WARNING: filter timeout pid 0x0820
WARNING: filter timeout pid 0x0020
WARNING: filter timeout pid 0x003a
WARNING: filter timeout pid 0x0898
WARNING: filter timeout pid 0x0034
WARNING: filter timeout pid 0x0420
dumping lists (10 services)
[0001]:0:h:0:0:0:0:1
[0002]:0:h:0:0:0:0:2
[0003]:0:h:0:0:0:0:3
[0004]:0:h:0:0:0:0:4
[000b]:0:h:0:0:0:0:11
[000c]:0:h:0:0:0:0:12
[000d]:0:h:0:0:0:55:13
[000e]:0:h:0:0:0:0:14
[000f]:0:h:0:0:0:0:15
[0010]:0:h:0:0:0:0:16

And here is what he says solved it;

Is it a coincidence, but there have been updates in kaffeine (0.8.5-35.pm)
(libxine1, libxine1-dvb version: 1.1.9-1-0.pm , for example) and since then
everything works. To be confirmed in time.

So please try if you can use this versions (or newer) and let me know.

Albert


2008/2/20, Antti Palosaari <crope@iki.fi>:
>
> Albert Comerma wrote:
> > It seems ok. Could you test a scan with kaffeine instead of looking for
> > a specific location? And if you do so it reports signal strenght?
>
>
> Kaffeine reports 100% signal strength. There must be some setting wrong
> in the driver. Tuner locks to the correct frequency but signal from
> uner to demodulator could be wrong and thats why PID-filter timeouts.
>
> Even bad, I cannot snoop it in windows because I did not find all the
> required Windows XP drivers for my brand new laptop. Laptop is only
> computer I have ExpressCard slot...
>
>
> > By the way, what does it mean moi and moikka? Hello in finish?
>
> yes :)
>
> regards
> Antti
>
> --
> http://palosaari.fi/
>

------=_Part_7085_33096148.1203515629244
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

moikka (I love this expression),<br><br>Michel (the person wich tested the driver, reported the same error as you). But the solution is not trivial, I post his mail about this stuff;<br><br>This is the errors he was having (same as you);<br>
<br>scan -c -o zap
<br>using &#39;/dev/dvb/adapter0/frontend0&#39; and &#39;/dev/dvb/adapter0/demux0&#39;
<br>Network Name &#39;RTBF BE&#39;
<br>WARNING: filter timeout pid 0x0011
<br>WARNING: filter timeout pid 0x003c
<br>WARNING: filter timeout pid 0x0038
<br>WARNING: filter timeout pid 0x0032
<br>WARNING: filter timeout pid 0x0820
<br>WARNING: filter timeout pid 0x0020
<br>WARNING: filter timeout pid 0x003a
<br>WARNING: filter timeout pid 0x0898
<br>WARNING: filter timeout pid 0x0034
<br>WARNING: filter timeout pid 0x0420
<br>dumping lists (10 services)
<br>[0001]:0:h:0:0:0:0:1
<br>[0002]:0:h:0:0:0:0:2
<br>[0003]:0:h:0:0:0:0:3
<br>[0004]:0:h:0:0:0:0:4
<br>[000b]:0:h:0:0:0:0:11
<br>[000c]:0:h:0:0:0:0:12
<br>[000d]:0:h:0:0:0:55:13
<br>[000e]:0:h:0:0:0:0:14
<br>[000f]:0:h:0:0:0:0:15
<br>[0010]:0:h:0:0:0:0:16&nbsp;&nbsp; <br><br>And here is what he says solved it;<br><br>Is it a coincidence, but there have been updates in kaffeine 
(<a href="http://0.8.5-35.pm">0.8.5-35.pm</a>)&nbsp; (libxine1, libxine1-dvb version: <a href="http://1.1.9-1-0.pm">1.1.9-1-0.pm</a> , for 
example) and since then everything works. To be confirmed in time.
<br><br>So please try if you can use this versions (or newer) and let me know.<br><br>Albert<br><br><br><div><span class="gmail_quote">2008/2/20, Antti Palosaari &lt;<a href="mailto:crope@iki.fi">crope@iki.fi</a>&gt;:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Albert Comerma wrote:<br> &gt; It seems ok. Could you test a scan with kaffeine instead of looking for<br> &gt; a specific location? And if you do so it reports signal strenght?<br> <br> <br>Kaffeine reports 100% signal strength. There must be some setting wrong<br>
 in the driver. Tuner locks to the correct frequency but signal from<br> uner to demodulator could be wrong and thats why PID-filter timeouts.<br> <br> Even bad, I cannot snoop it in windows because I did not find all the<br>
 required Windows XP drivers for my brand new laptop. Laptop is only<br> computer I have ExpressCard slot...<br> <br><br> &gt; By the way, what does it mean moi and moikka? Hello in finish?<br> <br>yes :)<br> <br> regards<br>
 Antti<br> <br>--<br> <a href="http://palosaari.fi/">http://palosaari.fi/</a><br> </blockquote></div><br>

------=_Part_7085_33096148.1203515629244--


--===============1186525186==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1186525186==--
