Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wa-out-1112.google.com ([209.85.146.177])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <michael@stepanoff.org>) id 1K5azq-0006uB-5r
	for linux-dvb@linuxtv.org; Mon, 09 Jun 2008 08:36:51 +0200
Received: by wa-out-1112.google.com with SMTP id n7so1530423wag.13
	for <linux-dvb@linuxtv.org>; Sun, 08 Jun 2008 23:36:45 -0700 (PDT)
Message-ID: <65922d730806082336o560a54e4k2e7e1d5eda6c2347@mail.gmail.com>
Date: Mon, 9 Jun 2008 09:36:45 +0300
From: "Michael Stepanov" <michael@stepanoff.org>
To: linux-dvb@linuxtv.org
In-Reply-To: <200806082120.04766@orion.escape-edv.de>
MIME-Version: 1.0
References: <65922d730806081149j2ba9085bm1984155ebf8eebd2@mail.gmail.com>
	<200806082120.04766@orion.escape-edv.de>
Subject: Re: [linux-dvb] TT-Budget/WinTV-NOVA-CI is recognized as sound card
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0540644643=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0540644643==
Content-Type: multipart/alternative;
	boundary="----=_Part_18151_15017393.1212993405420"

------=_Part_18151_15017393.1212993405420
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Thanks a lot, Oliver. Will try to add Audiowerk2 driver into black list.

On Sun, Jun 8, 2008 at 10:20 PM, Oliver Endriss <o.endriss@gmx.de> wrote:

> Michael Stepanov wrote:
> > Hi,
> >
> > I have following problem with my TT-Budget/WinTV-NOVA-CI DVB card. It's
> > recognized as Audiowerk2 sound card instead of DVB:
> >
> > linuxmce@dcerouter:~$ cat /proc/asound/cards
> >  0 [Audiowerk2     ]: aw2 - Audiowerk2
> >                       Audiowerk2 with SAA7146 irq 16
> >  1 [NVidia         ]: HDA-Intel - HDA NVidia
> >                       HDA NVidia at 0xfe020000 irq 20
> >
> > This is what I can see in the dmesg output:
> > [   81.311527] saa7146: register extension 'budget_ci dvb'.
> >
> > I use LinxuMCE which is built on the top of Kubuntu Gutsy, AMD64.
> >
> > Linux dcerouter 2.6.22-14-generic #1 SMP Sun Oct 14 21:45:15 GMT 2007
> > x86_64 GNU/Linux
> >
> > Any suggestion how to solve that will be very appreciated.
>
> Complain to the developers of the Audiowerk2 driver for this:
>
> | static struct pci_device_id snd_aw2_ids[] = {
> |       {PCI_VENDOR_ID_SAA7146, PCI_DEVICE_ID_SAA7146, PCI_ANY_ID,
> PCI_ANY_ID,
> |        0, 0, 0},
> |       {0}
> | };
>
> This will grab _all_ saa7146-based cards. :-(
>
> For now you should blacklist that driver.
>
> CU
> Oliver
>
> --
> ----------------------------------------------------------------
> VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
> ----------------------------------------------------------------
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>



-- 
Cheers,
Michael

------=_Part_18151_15017393.1212993405420
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Thanks a lot, Oliver. Will try to add Audiowerk2 driver into black list.<br><br><div class="gmail_quote">On Sun, Jun 8, 2008 at 10:20 PM, Oliver Endriss &lt;<a href="mailto:o.endriss@gmx.de">o.endriss@gmx.de</a>&gt; wrote:<br>
<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><div><div></div><div class="Wj3C7c">Michael Stepanov wrote:<br>
&gt; Hi,<br>
&gt;<br>
&gt; I have following problem with my TT-Budget/WinTV-NOVA-CI DVB card. It&#39;s<br>
&gt; recognized as Audiowerk2 sound card instead of DVB:<br>
&gt;<br>
&gt; linuxmce@dcerouter:~$ cat /proc/asound/cards<br>
&gt; &nbsp;0 [Audiowerk2 &nbsp; &nbsp; ]: aw2 - Audiowerk2<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Audiowerk2 with SAA7146 irq 16<br>
&gt; &nbsp;1 [NVidia &nbsp; &nbsp; &nbsp; &nbsp; ]: HDA-Intel - HDA NVidia<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; HDA NVidia at 0xfe020000 irq 20<br>
&gt;<br>
&gt; This is what I can see in the dmesg output:<br>
&gt; [ &nbsp; 81.311527] saa7146: register extension &#39;budget_ci dvb&#39;.<br>
&gt;<br>
&gt; I use LinxuMCE which is built on the top of Kubuntu Gutsy, AMD64.<br>
&gt;<br>
&gt; Linux dcerouter 2.6.22-14-generic #1 SMP Sun Oct 14 21:45:15 GMT 2007<br>
&gt; x86_64 GNU/Linux<br>
&gt;<br>
&gt; Any suggestion how to solve that will be very appreciated.<br>
<br>
</div></div>Complain to the developers of the Audiowerk2 driver for this:<br>
<br>
| static struct pci_device_id snd_aw2_ids[] = {<br>
| &nbsp; &nbsp; &nbsp; {PCI_VENDOR_ID_SAA7146, PCI_DEVICE_ID_SAA7146, PCI_ANY_ID, PCI_ANY_ID,<br>
| &nbsp; &nbsp; &nbsp; &nbsp;0, 0, 0},<br>
| &nbsp; &nbsp; &nbsp; {0}<br>
| };<br>
<br>
This will grab _all_ saa7146-based cards. :-(<br>
<br>
For now you should blacklist that driver.<br>
<br>
CU<br>
Oliver<br>
<br>
--<br>
----------------------------------------------------------------<br>
VDR Remote Plugin 0.4.0: <a href="http://www.escape-edv.de/endriss/vdr/" target="_blank">http://www.escape-edv.de/endriss/vdr/</a><br>
----------------------------------------------------------------<br>
<br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
</blockquote></div><br><br clear="all"><br>-- <br>Cheers,<br>Michael

------=_Part_18151_15017393.1212993405420--


--===============0540644643==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0540644643==--
