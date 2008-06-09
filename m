Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gv-out-0910.google.com ([216.239.58.184])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zeno.zoli@gmail.com>) id 1K5oRp-0003eK-QB
	for linux-dvb@linuxtv.org; Mon, 09 Jun 2008 22:58:38 +0200
Received: by gv-out-0910.google.com with SMTP id n29so764880gve.16
	for <linux-dvb@linuxtv.org>; Mon, 09 Jun 2008 13:58:34 -0700 (PDT)
Message-ID: <45e226e50806091358l12f6999dq9a4680066fdd7c92@mail.gmail.com>
Date: Mon, 9 Jun 2008 22:58:33 +0200
From: "Zeno Zoli" <zeno.zoli@gmail.com>
To: Goga777 <goga777@bk.ru>
In-Reply-To: <20080608232246.46ac431b@bk.ru>
MIME-Version: 1.0
References: <45e226e50806060327s7e3ecf86wb9141ee394e854d1@mail.gmail.com>
	<E1K4ZQk-000ARd-00.goga777-bk-ru@f145.mail.ru>
	<45e226e50806060353o32b215afwc3017e3ab8a2dd10@mail.gmail.com>
	<854d46170806060550u5c238e26ia003c713ed68095e@mail.gmail.com>
	<45e226e50806071017y4e09413dl23c119da0910fae2@mail.gmail.com>
	<854d46170806071111s65b96325mfc8beaa6171259dd@mail.gmail.com>
	<20080607225006.51805d6f@bk.ru>
	<854d46170806071240m5f918690t91bd7883f4c1a5e2@mail.gmail.com>
	<20080608232246.46ac431b@bk.ru>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Terratec Cinergy S2 PCI HD ioctl DVBFE_GET_INFO
	failed:Operation not supported
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0406014519=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0406014519==
Content-Type: multipart/alternative;
	boundary="----=_Part_2841_19832896.1213045113840"

------=_Part_2841_19832896.1213045113840
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I'm able to scan dvb-s2 transponders, but haven't tuned to them yet. (..and
it says using "DVB-S2" when scanning.)
Followed the updated subsection @
http://linuxtv.org/wiki/index.php/TerraTec_Cinergy_S2_PCI_HD_CIHOWTO:
install dvb-apps (scan/szap2 based on DVB API 3.3) (Testing based on
revision 1200Basically an organized guide with the  help I got from Faruk.

On Sun, Jun 8, 2008 at 9:22 PM, Goga777 <goga777@bk.ru> wrote:

> > I'm using multiproto and this works 100% just tested with two machines.
>
> can you scan dvb-s2 transponders with patched scan ?
>
> Goga
>
> > I'm not sure if multiproto_plus is using new API or the old one anyway
> > the best advice that i can give you is to try the old scan without any
> patches.
> >
> > http://jusst.de/manu/scan.tar.bz2
> >
> > Good Luck
> >
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_2841_19832896.1213045113840
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I&#39;m able to scan dvb-s2 transponders, but haven&#39;t tuned to them yet. (..and&nbsp; it says using &quot;DVB-S2&quot; when scanning.)<br><h3><span style="font-weight: normal;">Followed the updated subsection @ <a href="http://linuxtv.org/wiki/index.php/TerraTec_Cinergy_S2_PCI_HD_CI">http://linuxtv.org/wiki/index.php/TerraTec_Cinergy_S2_PCI_HD_CI</a></span></h3>
<h3><span style="font-weight: normal;" class="mw-headline">HOWTO: install dvb-apps (scan/szap2 based on DVB API 3.3) (Testing based on revision 1200</span></h3>Basically an organized guide with the&nbsp; help I got from Faruk. <br>
<br><div class="gmail_quote">On Sun, Jun 8, 2008 at 9:22 PM, Goga777 &lt;<a href="mailto:goga777@bk.ru">goga777@bk.ru</a>&gt; wrote:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div class="Ih2E3d">&gt; I&#39;m using multiproto and this works 100% just tested with two machines.<br>
<br>
</div>can you scan dvb-s2 transponders with patched scan ?<br>
<br>
Goga<br>
<div class="Ih2E3d"><br>
&gt; I&#39;m not sure if multiproto_plus is using new API or the old one anyway<br>
&gt; the best advice that i can give you is to try the old scan without any patches.<br>
&gt;<br>
&gt; <a href="http://jusst.de/manu/scan.tar.bz2" target="_blank">http://jusst.de/manu/scan.tar.bz2</a><br>
&gt;<br>
&gt; Good Luck<br>
&gt;<br>
<br>
<br>
</div><div><div></div><div class="Wj3C7c">_______________________________________________<br>
linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
</div></div></blockquote></div><br>

------=_Part_2841_19832896.1213045113840--


--===============0406014519==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0406014519==--
