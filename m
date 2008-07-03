Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yx-out-2324.google.com ([74.125.44.28])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gujs.lists@gmail.com>) id 1KELBS-0004or-QG
	for linux-dvb@linuxtv.org; Thu, 03 Jul 2008 11:33:02 +0200
Received: by yx-out-2324.google.com with SMTP id 8so181065yxg.41
	for <linux-dvb@linuxtv.org>; Thu, 03 Jul 2008 02:32:53 -0700 (PDT)
Message-ID: <23be820f0807030232h56c10851w12b743d2ca841b1d@mail.gmail.com>
Date: Thu, 3 Jul 2008 11:32:53 +0200
From: "Gregor Fuis" <gujs.lists@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <23be820f0806130642n4ccb47cna0e0b404d360d0bb@mail.gmail.com>
MIME-Version: 1.0
References: <23be820f0806130642n4ccb47cna0e0b404d360d0bb@mail.gmail.com>
Subject: Re: [linux-dvb] new KNC One TV Station
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1994478815=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1994478815==
Content-Type: multipart/alternative;
	boundary="----=_Part_8013_29519134.1215077573267"

------=_Part_8013_29519134.1215077573267
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Is there really no one who knows something about that card. I would just
like to know if I keep it or not.

Thanks,
Gregor

On Fri, Jun 13, 2008 at 3:42 PM, Gregor Fuis <gujs.lists@gmail.com> wrote:

> Hello,
>
> I recently bought new KNC One TV Station card with Cineview CI module. When
> I installed it, it was detected and worked with no problems. I just noticed
> that tuner is not that sensitive and has a little problems with signal
> strentgh in some cases (rain, bad weather) where TT 2300S Premium didn't
> have. The problem got bigger when I tried Cineview module. I inserted
> Viaccess CAM module and RTV Slovenija smartcard. When I inserted CAM, card
> at the same moment lost lock of signal and signal was not good enough to
> lock again. When I get CAM out of the CI signal doesn't lock until I restart
> szap.
>
> I think that this card is not supported directly because lspci reports
> Unknown KNC One card. Is someone working on drivers to support this card?
>
> lspci output:
> 03:0f.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
>         Subsystem: KNC One Unknown device 0016
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 32 (3750ns min, 9500ns max)
>         Interrupt: pin A routed to IRQ 17
>         Region 0: Memory at ff7ff000 (32-bit, non-prefetchable) [size=512]
>
>
> dmesg reports this:
> [   28.572224] Linux video capture interface: v2.00
> [   28.702747] saa7146: register extension 'budget_av'.
> [   28.702815] ACPI: PCI Interrupt 0000:03:0f.0[A] -> GSI 17 (level, low)
> -> IRQ 17
> [   28.702853] saa7146: found saa7146 @ mem f8986000 (revision 1, irq 17)
> (0x1894,0x0016).
> [   28.702862] saa7146 (0): dma buffer size 192512
> [   28.702866] DVB: registering new adapter (KNC TV STAR DVB-S)
> [   28.762680] adapter failed MAC signature check
> [   28.762685] encoded MAC from EEPROM was
> ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff
> [   29.073159] KNC1-0: MAC addr = 00:09:d6:65:b6:57
> [   29.721965] DVB: registering frontend 0 (ST STV0299 DVB-S)...
> [   29.752958] budget-av: ci interface initialised.
>
>
> Here is my szap test:
> szap -a 0 -c /home/gregor/channels/channels.conf "SLO-TV2"
> reading channels from file '/home/gregor/channels/channels.conf'
> zapping to 2 'SLO-TV2':
> sat 1, frequency = 12303 MHz V, symbolrate 27500000, vpid = 0x00cb, apid =
> 0x00cc
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> status 03 | signal c13b | snr 9609 | ber 0000ff00 | unc 00000000 |
> status 1f | signal c1c1 | snr b0e2 | ber 0000ff03 | unc 00000000 |
> FE_HAS_LOCK
> status 1f | signal c312 | snr aa52 | ber 0000ff12 | unc 00000000 |
> FE_HAS_LOCK
> status 1f | signal c1bb | snr a2e1 | ber 0000ff06 | unc 00000000 |
> FE_HAS_LOCK
> status 1f | signal c2c6 | snr ab2d | ber 0000ff10 | unc 00000000 |
> FE_HAS_LOCK
> status 1f | signal c555 | snr b307 | ber 0000ff00 | unc 00000000 |
> FE_HAS_LOCK
> status 1f | signal c5d5 | snr ba54 | ber 0000ff00 | unc 00000000 |
> FE_HAS_LOCK
> status 1f | signal c440 | snr b748 | ber 0000ff00 | unc 00000000 |
> FE_HAS_LOCK
> <----- CAM inserted
> status 01 | signal 95ee | snr 7f74 | ber 00003383 | unc 00000000 |
> status 01 | signal 90e8 | snr 7f74 | ber 000035a0 | unc 00000000 |
> status 01 | signal 90b6 | snr 7f80 | ber 000032b9 | unc 00000000 |
> status 01 | signal 8715 | snr 8022 | ber 00003487 | unc 00000000 |
> status 01 | signal 8bf2 | snr 7fa7 | ber 00003321 | unc 00000000 |
> status 01 | signal 90f8 | snr 7f62 | ber 0000342c | unc 00000000 |
>
> dmesg when CAM inserted:
> [14494.791667] budget-av: cam inserted B
> [14497.000533] dvb_ca adapter 0: DVB CAM detected and initialised
> successfully
>
> I would realy like to know if card will be fully supported. I can help
> debuging problems and test solutions whithout a problem.
>
> Thanks!
>
> Regards,
> Gregor
>
>

------=_Part_8013_29519134.1215077573267
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Is there really no one who knows something about that card. I would just like to know if I keep it or not.<br><br>Thanks,<br>Gregor<br><br><div class="gmail_quote">On Fri, Jun 13, 2008 at 3:42 PM, Gregor Fuis &lt;<a href="mailto:gujs.lists@gmail.com">gujs.lists@gmail.com</a>&gt; wrote:<br>
<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">Hello,<br><br>I recently bought new KNC One TV Station card with Cineview CI module. When I installed it, it was detected and worked with no problems. I just noticed that tuner is not that sensitive and has a little problems with signal strentgh in some cases (rain, bad weather) where TT 2300S Premium didn&#39;t have. The problem got bigger when I tried Cineview module. I inserted Viaccess CAM module and RTV Slovenija smartcard. When I inserted CAM, card at the same moment lost lock of signal and signal was not good enough to lock again. When I get CAM out of the CI signal doesn&#39;t lock until I restart szap. <br>

<br>I think that this card is not supported directly because lspci reports Unknown KNC One card. Is someone working on drivers to support this card?<br>
<br>lspci output:<br>03:0f.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Subsystem: KNC One Unknown device 0016<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-<br>


&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium &gt;TAbort- &lt;TAbort- &lt;MAbort- &gt;SERR- &lt;PERR-<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Latency: 32 (3750ns min, 9500ns max)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Interrupt: pin A routed to IRQ 17<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Region 0: Memory at ff7ff000 (32-bit, non-prefetchable) [size=512]<br>


<br><br>dmesg reports this:<br>[&nbsp;&nbsp; 28.572224] Linux video capture interface: v2.00<br>[&nbsp;&nbsp; 28.702747] saa7146: register extension &#39;budget_av&#39;.<br>[&nbsp;&nbsp; 28.702815] ACPI: PCI Interrupt 0000:03:0f.0[A] -&gt; GSI 17 (level, low) -&gt; IRQ 17<br>


[&nbsp;&nbsp; 28.702853] saa7146: found saa7146 @ mem f8986000 (revision 1, irq 17) (0x1894,0x0016).<br>[&nbsp;&nbsp; 28.702862] saa7146 (0): dma buffer size 192512<br>[&nbsp;&nbsp; 28.702866] DVB: registering new adapter (KNC TV STAR DVB-S)<br>[&nbsp;&nbsp; 28.762680] adapter failed MAC signature check<br>


[&nbsp;&nbsp; 28.762685] encoded MAC from EEPROM was ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff<br>[&nbsp;&nbsp; 29.073159] KNC1-0: MAC addr = 00:09:d6:65:b6:57<br>[&nbsp;&nbsp; 29.721965] DVB: registering frontend 0 (ST STV0299 DVB-S)...<br>


[&nbsp;&nbsp; 29.752958] budget-av: ci interface initialised.<br><br><br>Here is my szap test:<br>szap -a 0 -c /home/gregor/channels/channels.conf &quot;SLO-TV2&quot;<br>reading channels from file &#39;/home/gregor/channels/channels.conf&#39;<br>

zapping to 2 &#39;SLO-TV2&#39;:<br>sat 1, frequency = 12303 MHz V, symbolrate 27500000, vpid = 0x00cb, apid = 0x00cc<br>using &#39;/dev/dvb/adapter0/frontend0&#39; and &#39;/dev/dvb/adapter0/demux0&#39;<br>status 03 | signal c13b | snr 9609 | ber 0000ff00 | unc 00000000 | <br>

status 1f | signal c1c1 | snr b0e2 | ber 0000ff03 | unc 00000000 | FE_HAS_LOCK<br>status 1f | signal c312 | snr aa52 | ber 0000ff12 | unc 00000000 | FE_HAS_LOCK<br>status 1f | signal c1bb | snr a2e1 | ber 0000ff06 | unc 00000000 | FE_HAS_LOCK<br>

status 1f | signal c2c6 | snr ab2d | ber 0000ff10 | unc 00000000 | FE_HAS_LOCK<br>status 1f | signal c555 | snr b307 | ber 0000ff00 | unc 00000000 | FE_HAS_LOCK<br>status 1f | signal c5d5 | snr ba54 | ber 0000ff00 | unc 00000000 | FE_HAS_LOCK<br>

status 1f | signal c440 | snr b748 | ber 0000ff00 | unc 00000000 | FE_HAS_LOCK&nbsp; <br>&lt;----- CAM inserted<br>status 01 | signal 95ee | snr 7f74 | ber 00003383 | unc 00000000 | <br>status 01 | signal 90e8 | snr 7f74 | ber 000035a0 | unc 00000000 | <br>

status 01 | signal 90b6 | snr 7f80 | ber 000032b9 | unc 00000000 | <br>status 01 | signal 8715 | snr 8022 | ber 00003487 | unc 00000000 | <br>status 01 | signal 8bf2 | snr 7fa7 | ber 00003321 | unc 00000000 | <br>status 01 | signal 90f8 | snr 7f62 | ber 0000342c | unc 00000000 | <br>

<br>dmesg when CAM inserted:<br>[14494.791667] budget-av: cam inserted B<br>[14497.000533] dvb_ca adapter 0: DVB CAM detected and initialised successfully<br><br>I would realy like to know if card will be fully supported. I can help debuging problems and test solutions whithout a problem.<br>

<br>Thanks!<br><br>Regards,<br><font color="#888888">Gregor<br><br>
</font></blockquote></div><br>

------=_Part_8013_29519134.1215077573267--


--===============1994478815==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1994478815==--
