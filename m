Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hs-out-0708.google.com ([64.233.178.249])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rune.evjen@gmail.com>) id 1L27Zp-0004Le-VQ
	for linux-dvb@linuxtv.org; Mon, 17 Nov 2008 18:07:55 +0100
Received: by hs-out-0708.google.com with SMTP id 4so1500950hsl.1
	for <linux-dvb@linuxtv.org>; Mon, 17 Nov 2008 09:07:48 -0800 (PST)
Message-ID: <57808ff0811170907n59e8ec73p42bd451956c21511@mail.gmail.com>
Date: Mon, 17 Nov 2008 18:07:47 +0100
From: "Rune Evjen" <rune.evjen@gmail.com>
To: "Tomas Drajsajtl" <linux-dvb@drajsajtl.cz>
In-Reply-To: <006c01c94653$edd44070$f4c6a5c1@tommy>
MIME-Version: 1.0
References: <001101c93ce7$23bcfdb0$7f79a8c0@tommy>
	<57808ff0811130556l4c182aaak5d95be36c2ff2e07@mail.gmail.com>
	<006c01c94653$edd44070$f4c6a5c1@tommy>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Any DVB-C tuner with working CAM?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0823141524=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0823141524==
Content-Type: multipart/alternative;
	boundary="----=_Part_47692_13246647.1226941667393"

------=_Part_47692_13246647.1226941667393
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I use kernel 2.6.27 (amd64 architecture) but have used multiple kernels over
the last year, both amd64 and i386 without problems.

The only problem is that once in while (every month or two maybe ?) I cannot
get lock on any channel and the only way to solve this is to power off the
computer, and power it up again (a restart doesn't help).

Rune
2008/11/14 Tomas Drajsajtl <linux-dvb@drajsajtl.cz>

>  Dear Rune,
> what is your kernel version? I have the same tuner from the same shop but
> the CAM is Technisat. I cannot replace the CAM provided by my cable
> oprerator because they won't pair their Conax card with the CAM like you
> have for me. :-(
> Is it possible that TT 2300-C Premium + Technisat Technicrypt CX
> http://www.technisat.com/index9acb.html?nav=CI_modules,en,68-32 can have
> problems with the linux driver?
>
> Regards,
> Tomas
>
>
> ----- Original Message -----
> *From:* Rune Evjen <rune.evjen@gmail.com>
> *To:* Tomas Drajsajtl <linux-dvb@drajsajtl.cz>
> *Cc:* linux-dvb@linuxtv.org
> *Sent:* Thursday, November 13, 2008 2:56 PM
> *Subject:* Re: [linux-dvb] Any DVB-C tuner with working CAM?
>
> Hi,
>
> I use the TT 2300-C Premium card with a Conax CAM (rev 1.1) - 4.00e and
> this works fine with my cable provider. The CAM was ordered from
> www.dvb-shop.net along with the DVB-C card.
>
> Apparently they only ship rev 1.2 ( (
> http://www.dvbshop.net/product_info.php/info/p20_Conax-CAM
> --Rev--1-2----4-00e.html) now which also supports the bitrates of HDTV,
> but I have not tested this CAM, although dvb-shop states that rev 1.2 is
> compatible as well.
>
> My cable provider is not Technisat, but I guess that if Technisat
> encryption is based on Conax 4.00e then the CAM should be okay.
>
> My configuration works in mythtv and (by recollection) mplayer and xine.
>
> I get the same dmesg output as you for the tt-dvbpci card.
>
>
>
>

------=_Part_47692_13246647.1226941667393
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I use kernel 2.6.27 (amd64 architecture) but have used multiple kernels over the last year, both amd64 and i386 without problems.<br><br>The only problem is that once in while (every month or two maybe ?) I cannot get lock on any channel and the only way to solve this is to power off the computer, and power it up again (a restart doesn&#39;t help).<br>
<br>Rune<br><div class="gmail_quote">2008/11/14 Tomas Drajsajtl <span dir="ltr">&lt;<a href="mailto:linux-dvb@drajsajtl.cz">linux-dvb@drajsajtl.cz</a>&gt;</span><br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">






<div bgcolor="#ffffff">
<div><font size="2" face="Arial">Dear Rune,</font></div>
<div><font size="2" face="Arial">what is your kernel version? I have the same tuner 
from the same shop but the&nbsp;CAM is Technisat. I cannot replace the CAM 
provided by my cable oprerator because they won&#39;t pair their Conax card 
with&nbsp;the&nbsp;CAM like you have for me. :-(</font></div>
<div><font size="2" face="Arial">Is it possible that TT 2300-C Premium&nbsp;+ 
Technisat Technicrypt CX&nbsp;<a href="http://www.technisat.com/index9acb.html?nav=CI_modules,en,68-32" target="_blank">http://www.technisat.com/index9acb.html?nav=CI_modules,en,68-32</a></font>&nbsp;<font size="2" face="Arial">can have problems with the linux driver?</font></div>

<div><font size="2" face="Arial"></font>&nbsp;</div>
<div><font size="2" face="Arial">Regards,</font></div>
<div><font size="2" face="Arial">Tomas</font></div><div class="Ih2E3d">
<div><font size="2" face="Arial"></font>&nbsp;</div>
<blockquote style="border-left: 2px solid rgb(0, 0, 0); padding-right: 0px; padding-left: 5px; margin-left: 5px; margin-right: 0px;">
  <div style="font-family: arial; font-style: normal; font-variant: normal; font-weight: normal; font-size: 10pt; line-height: normal; font-size-adjust: none; font-stretch: normal;">----- Original Message ----- </div>
  <div style="background: rgb(228, 228, 228) none repeat scroll 0% 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; font-family: arial; font-style: normal; font-variant: normal; font-weight: normal; font-size: 10pt; line-height: normal; font-size-adjust: none; font-stretch: normal;">
<b>From:</b> 
  <a title="rune.evjen@gmail.com" href="mailto:rune.evjen@gmail.com" target="_blank">Rune 
  Evjen</a> </div>
  <div style="font-family: arial; font-style: normal; font-variant: normal; font-weight: normal; font-size: 10pt; line-height: normal; font-size-adjust: none; font-stretch: normal;"><b>To:</b> <a title="linux-dvb@drajsajtl.cz" href="mailto:linux-dvb@drajsajtl.cz" target="_blank">Tomas Drajsajtl</a> </div>

  <div style="font-family: arial; font-style: normal; font-variant: normal; font-weight: normal; font-size: 10pt; line-height: normal; font-size-adjust: none; font-stretch: normal;"><b>Cc:</b> <a title="linux-dvb@linuxtv.org" href="mailto:linux-dvb@linuxtv.org" target="_blank">linux-dvb@linuxtv.org</a> </div>

  <div style="font-family: arial; font-style: normal; font-variant: normal; font-weight: normal; font-size: 10pt; line-height: normal; font-size-adjust: none; font-stretch: normal;"><b>Sent:</b> Thursday, November 13, 2008 2:56 
  PM</div>
  <div style="font-family: arial; font-style: normal; font-variant: normal; font-weight: normal; font-size: 10pt; line-height: normal; font-size-adjust: none; font-stretch: normal;"><b>Subject:</b> Re: [linux-dvb] Any DVB-C tuner 
  with working CAM?</div>
  <div><font size="2" face="Arial"></font><font size="2" face="Arial"></font><br></div>Hi,<br><br>I use the TT 2300-C Premium card with a 
  Conax CAM (rev 1.1) - 4.00e and this works fine with my cable provider. The 
  CAM was ordered from <a href="http://www.dvb-shop.net" target="_blank">www.dvb-shop.net</a> 
  along with the DVB-C card.<br><br>Apparently they only ship rev 1.2 ( (<a href="http://www.dvbshop.net/product_info.php/info/p20_Conax-CAM--Rev--1-2----4-00e.html" target="_blank">http://www.dvbshop.net/product_info.php/info/p20_Conax-<span>CAM</span>--Rev--1-2----4-00e.html</a>) now which also supports 
  the bitrates of HDTV, but I have not tested this CAM, although dvb-shop states 
  that rev 1.2 is compatible as well.<br><br>My cable provider is not Technisat, 
  but I guess that if Technisat encryption is based on Conax 4.00e then the CAM 
  should be okay. <br><br>My configuration works in mythtv and (by recollection) 
  mplayer and xine.<br><br>I get the same dmesg output as you for the tt-dvbpci 
  card.<br><br>
  <div class="gmail_quote">
  <blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><font size="2" face="Arial"></font>&nbsp;</blockquote></div></blockquote></div></div>
</blockquote></div><br>

------=_Part_47692_13246647.1226941667393--


--===============0823141524==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0823141524==--
