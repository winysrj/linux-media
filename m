Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hs-out-0708.google.com ([64.233.178.249])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sergeniki@googlemail.com>) id 1K4csr-0001U7-26
	for linux-dvb@linuxtv.org; Fri, 06 Jun 2008 16:25:39 +0200
Received: by hs-out-0708.google.com with SMTP id 4so829594hsl.1
	for <linux-dvb@linuxtv.org>; Fri, 06 Jun 2008 07:25:29 -0700 (PDT)
Message-ID: <9e5406cc0806060725m1224882bu6c18393e56f96596@mail.gmail.com>
Date: Fri, 6 Jun 2008 15:25:29 +0100
From: "Serge Nikitin" <sergeniki@googlemail.com>
To: "Antti Palosaari" <crope@iki.fi>
In-Reply-To: <484941CB.8060805@iki.fi>
MIME-Version: 1.0
References: <71798b430806050447g1570a889ld2ad306a8b14b1f1@mail.gmail.com>
	<484941CB.8060805@iki.fi>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] PEAK DVB-T Digital Dual Tuner PCI - anyone got this
	card working?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1580006846=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1580006846==
Content-Type: multipart/alternative;
	boundary="----=_Part_6525_18161821.1212762329640"

------=_Part_6525_18161821.1212762329640
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Fri, Jun 6, 2008 at 2:55 PM, Antti Palosaari <crope@iki.fi> wrote:

> Andrew Herron wrote:
> > I have a PEAK DVB-T Digital Dual Tuner PCI card. Has anyone got one of
> > these working yet?
>
> Do you know USB IDs of this card?
> Probably those are not same as KWorkd ones, looks like KWorld uses
> 0x1b80 as vendor ID their new hardware. Is there any register where
> vendor ID owners can be checked?
>
> Antti
> --
> http://palosaari.fi/
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

Antti,

I do have PEAK DVB-T Dual tuner PCI (221544AGPK) and it is reported in
lsusb as:

Bus 2 Device 2: ID 1b80:c160

Moreover, .ini file for win driver provided on CD listed this card as KWorld
PC160 (with USB IDs 1b80:c160 and 1b80:c161) and I've definitely seen
"PC160" printed on card's PCB.

In my case those PEAK and KWorld look like the same card.

Serge.

------=_Part_6525_18161821.1212762329640
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<br><br><div class="gmail_quote">On Fri, Jun 6, 2008 at 2:55 PM, Antti Palosaari &lt;<a href="mailto:crope@iki.fi">crope@iki.fi</a>&gt; wrote:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Andrew Herron wrote:<br>
&gt; I have a PEAK DVB-T Digital Dual Tuner PCI card. Has anyone got one of<br>
&gt; these working yet?<br>
<br>
Do you know USB IDs of this card?<br>
Probably those are not same as KWorkd ones, looks like KWorld uses<br>
0x1b80 as vendor ID their new hardware. Is there any register where<br>
vendor ID owners can be checked?<br>
<br>
Antti<br>
<font color="#888888">--<br>
<a href="http://palosaari.fi/" target="_blank">http://palosaari.fi/</a><br>
<br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
</font></blockquote></div><br>Antti,<br><pre>I do have PEAK DVB-T Dual tuner PCI (221544AGPK) and it is reported in lsusb as: </pre>Bus 2 Device 2: ID 1b80:c160<br><br>Moreover, .ini file for win driver provided on CD listed this card as KWorld PC160 (with USB IDs 1b80:c160 and 1b80:c161) and I&#39;ve definitely seen &quot;PC160&quot; printed on card&#39;s PCB.<br>
<br>In my case those PEAK and KWorld look like the same card. <br><br>Serge. <br>

------=_Part_6525_18161821.1212762329640--


--===============1580006846==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1580006846==--
