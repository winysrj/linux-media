Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.29])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rune.evjen@gmail.com>) id 1L0cgX-0003aO-Vm
	for linux-dvb@linuxtv.org; Thu, 13 Nov 2008 14:56:38 +0100
Received: by yw-out-2324.google.com with SMTP id 3so373580ywj.41
	for <linux-dvb@linuxtv.org>; Thu, 13 Nov 2008 05:56:33 -0800 (PST)
Message-ID: <57808ff0811130556l4c182aaak5d95be36c2ff2e07@mail.gmail.com>
Date: Thu, 13 Nov 2008 14:56:31 +0100
From: "Rune Evjen" <rune.evjen@gmail.com>
To: "Tomas Drajsajtl" <linux-dvb@drajsajtl.cz>
In-Reply-To: <001101c93ce7$23bcfdb0$7f79a8c0@tommy>
MIME-Version: 1.0
References: <001101c93ce7$23bcfdb0$7f79a8c0@tommy>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Any DVB-C tuner with working CAM?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1091829664=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1091829664==
Content-Type: multipart/alternative;
	boundary="----=_Part_4990_27355454.1226584591985"

------=_Part_4990_27355454.1226584591985
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

I use the TT 2300-C Premium card with a Conax CAM (rev 1.1) - 4.00e and this
works fine with my cable provider. The CAM was ordered from
www.dvb-shop.netalong with the DVB-C card.

Apparently they only ship rev 1.2 ( (
http://www.dvbshop.net/product_info.php/info/p20_Conax-CAM
--Rev--1-2----4-00e.html) now which also supports the bitrates of HDTV, but
I have not tested this CAM, although dvb-shop states that rev 1.2 is
compatible as well.

My cable provider is not Technisat, but I guess that if Technisat encryption
is based on Conax 4.00e then the CAM should be okay.

My configuration works in mythtv and (by recollection) mplayer and xine.

I get the same dmesg output as you for the tt-dvbpci card.

I also use a Terratec Cinergy-C Card using the mantis drivers but the CI
interface of that card is not yet supported as well.

Rune

2008/11/2 Tomas Drajsajtl <linux-dvb@drajsajtl.cz>

> Hello,
> I have bought and tested two DVB-C cards which are supported according to
> http://www.linuxtv.org/wiki/index.php/DVB-C_PCI_Cards
> Both are perfectly working with FTA but none with the CAM.
>
> 1. TechnoTrend Premium DVB-C 2300
>
> DVB: registering new adapter (Technotrend/Hauppauge WinTV Nexus-CA rev1.X)
> adapter has MAC addr = ....
> dvb-ttpci: gpioirq unknown type=0 len=0
> dvb-ttpci: info @ card 3: firm f0240009, rtsl b0250018, vid 71010068, app
> 80002622
> dvb-ttpci: firmware @ card 3 supports CI link layer interface
> dvb-ttpci: DVB-C analog module @ card 3 detected, initializing MSP3415
> dvb_ttpci: saa7113 not accessible.
> saa7146_vv: saa7146 (0): registered device video2 [v4l2]
> saa7146_vv: saa7146 (0): registered device vbi2 [v4l2]
> DVB: registering frontend 3 (ST STV0297 DVB-C)...
>
> Applications detect the inserted CAM even if the CAM is not inserted ;-)
> but
> even when it is, no scrambled channel is decrypted.
>
> 2. Technisat CableStar HD2
>
> found a VP-2040 PCI DVB-C device on (01:02.0),
>    Mantis Rev 1 [1ae4:0002], irq: 18, latency: 64
>    memory: 0xefeff000, mmio: 0xffffc20000aee000
>    MAC Address=[....]
> mantis_alloc_buffers (0): DMA=0x7d820000 cpu=0xffff81007d820000 size=65536
> mantis_alloc_buffers (0): RISC=0x7e50e000 cpu=0xffff81007e50e000 size=1000
> DVB: registering new adapter (Mantis dvb adapter)
>
> It says that an unsupported CAM is inserted. :-( Then I found in this
> mailing list that the mantis CI-CAM support is not finalized yet. I
> appreciate the work that Manu does with the mantis driver and I trust that
> it will be supported in the comming months but I would expect that the Wiki
> page mentioned above will have also the information about not yet supported
> CI! :-(
>
> So I have the CAM, two DVB-C cards but can't watch the channels I pay every
> month... I spent many days with Google to find out a working solution with
> these two or another card but unsuccessfully. Can somebody please advice me
> a DVB-C card with CI which _is on market_ and does work with Technisat
> Conax
> CAM?
>
> Thanks in advance,
> Tomas
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_4990_27355454.1226584591985
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,<br><br>I use the TT 2300-C Premium card with a Conax CAM (rev 1.1) - 4.00e and this works fine with my cable provider. The CAM was ordered from <a href="http://www.dvb-shop.net">www.dvb-shop.net</a> along with the DVB-C card.<br>
<br>Apparently they only ship rev 1.2 (
(<a href="http://www.dvbshop.net/product_info.php/info/p20_Conax-CAM--Rev--1-2----4-00e.html" target="_blank">http://www.dvbshop.net/product_info.php/info/p20_Conax-<span class="nfakPe">CAM</span>--Rev--1-2----4-00e.html</a>) now which also supports the bitrates of HDTV, but I have not tested this CAM, although dvb-shop states that rev 1.2 is compatible as well.<br>
<br>My cable provider is not Technisat, but I guess that if Technisat encryption is based on Conax 4.00e then the CAM should be okay. <br><br>My configuration works in mythtv and (by recollection) mplayer and xine.<br><br>
I get the same dmesg output as you for the tt-dvbpci card.<br><br>I also use a Terratec Cinergy-C Card using the mantis drivers but the CI interface of that card is not yet supported as well.<br><br>Rune <br><br><div class="gmail_quote">
2008/11/2 Tomas Drajsajtl <span dir="ltr">&lt;<a href="mailto:linux-dvb@drajsajtl.cz">linux-dvb@drajsajtl.cz</a>&gt;</span><br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Hello,<br>
I have bought and tested two DVB-C cards which are supported according to<br>
<a href="http://www.linuxtv.org/wiki/index.php/DVB-C_PCI_Cards" target="_blank">http://www.linuxtv.org/wiki/index.php/DVB-C_PCI_Cards</a><br>
Both are perfectly working with FTA but none with the CAM.<br>
<br>
1. TechnoTrend Premium DVB-C 2300<br>
<br>
DVB: registering new adapter (Technotrend/Hauppauge WinTV Nexus-CA rev1.X)<br>
adapter has MAC addr = ....<br>
dvb-ttpci: gpioirq unknown type=0 len=0<br>
dvb-ttpci: info @ card 3: firm f0240009, rtsl b0250018, vid 71010068, app<br>
80002622<br>
dvb-ttpci: firmware @ card 3 supports CI link layer interface<br>
dvb-ttpci: DVB-C analog module @ card 3 detected, initializing MSP3415<br>
dvb_ttpci: saa7113 not accessible.<br>
saa7146_vv: saa7146 (0): registered device video2 [v4l2]<br>
saa7146_vv: saa7146 (0): registered device vbi2 [v4l2]<br>
DVB: registering frontend 3 (ST STV0297 DVB-C)...<br>
<br>
Applications detect the inserted CAM even if the CAM is not inserted ;-) but<br>
even when it is, no scrambled channel is decrypted.<br>
<br>
2. Technisat CableStar HD2<br>
<br>
found a VP-2040 PCI DVB-C device on (01:02.0),<br>
 &nbsp; &nbsp;Mantis Rev 1 [1ae4:0002], irq: 18, latency: 64<br>
 &nbsp; &nbsp;memory: 0xefeff000, mmio: 0xffffc20000aee000<br>
 &nbsp; &nbsp;MAC Address=[....]<br>
mantis_alloc_buffers (0): DMA=0x7d820000 cpu=0xffff81007d820000 size=65536<br>
mantis_alloc_buffers (0): RISC=0x7e50e000 cpu=0xffff81007e50e000 size=1000<br>
DVB: registering new adapter (Mantis dvb adapter)<br>
<br>
It says that an unsupported CAM is inserted. :-( Then I found in this<br>
mailing list that the mantis CI-CAM support is not finalized yet. I<br>
appreciate the work that Manu does with the mantis driver and I trust that<br>
it will be supported in the comming months but I would expect that the Wiki<br>
page mentioned above will have also the information about not yet supported<br>
CI! :-(<br>
<br>
So I have the CAM, two DVB-C cards but can&#39;t watch the channels I pay every<br>
month... I spent many days with Google to find out a working solution with<br>
these two or another card but unsuccessfully. Can somebody please advice me<br>
a DVB-C card with CI which _is on market_ and does work with Technisat Conax<br>
CAM?<br>
<br>
Thanks in advance,<br>
Tomas<br>
<br>
<br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
</blockquote></div><br>

------=_Part_4990_27355454.1226584591985--


--===============1091829664==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1091829664==--
