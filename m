Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-bw0-f18.google.com ([209.85.218.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <oobe.trouble@gmail.com>) id 1LD8iD-00049D-8k
	for linux-dvb@linuxtv.org; Thu, 18 Dec 2008 03:34:05 +0100
Received: by bwz11 with SMTP id 11so422006bwz.17
	for <linux-dvb@linuxtv.org>; Wed, 17 Dec 2008 18:33:31 -0800 (PST)
Message-ID: <21aab41d0812171833l7f7ec7b3m7aadf09bba5b2fa@mail.gmail.com>
Date: Thu, 18 Dec 2008 13:33:30 +1100
From: "Kemble Wagner" <oobe.trouble@gmail.com>
To: drappa <drappa@iinet.net.au>
In-Reply-To: <3373E53765AB44F8BF670FDF42C3CD3A@mce>
MIME-Version: 1.0
References: <3373E53765AB44F8BF670FDF42C3CD3A@mce>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DViCO FusionHDTV DVB-T Dual Digital 4 (rev 2) -
	Remote Control Key Mapping
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0990687183=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0990687183==
Content-Type: multipart/alternative;
	boundary="----=_Part_19233_28693352.1229567610321"

------=_Part_19233_28693352.1229567610321
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

please look at and read carefully these to posts

http://ubuntuforums.org/showthread.php?t=616103

and

http://ubuntuforums.org/showpost.php?p=6232229&postcount=42

On Tue, Dec 16, 2008 at 6:36 PM, drappa <drappa@iinet.net.au> wrote:

> Hello
>
> I installed a DVICO Dual digital 4 revision2 DVB-T card in a Mythbuntu 8.10
> system
>
> The card wasn't originally detected so I built the driver from the current
> v4l-dvb tree and it works great.
> Only problem is the included DVICO remote control has very limited
> functionality. Apart from the numeric keypad only three keys work.
>
> DMESG is below.
>
> Any pointers to getting the proper key mapping, please?
>
> Ta
> D
>
> [   13.921567] dvb-usb: found a ' in warm state.
> [   13.921802] dvb-usb: will pass the complete MPEG2 transport stream to
> the
> software demuxer.
> [   13.952919] DVB: registering new adapter (DViCO FusionHDTV DVB-T Dual
> Digital 4 (rev 2))
> [   13.994729] input: PC Speaker as /devices/platform/pcspkr/input/input4
> [   14.117557] DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
> [   14.120807] Linux agpgart interface v0.103
> [   14.275066] DiB0070: successfully identified
> [   14.275641] input: IR-receiver inside an USB DVB receiver as
> /devices/pci0000:00/0000:00:08.0/0000:01:08.2/usb5/5-1/input/input5
> [   14.304726] dvb-usb: schedule remote query interval to 100 msecs.
> [   14.304733] dvb-usb: DViCO FusionHDTV DVB-T Dual Digital 4 (rev 2)
> successfully initialized and connected.
> [   14.304750] dvb-usb: found a 'DViCO FusionHDTV DVB-T Dual Digital 4 (rev
> 2)' in warm state.
> [   14.304877] dvb-usb: will pass the complete MPEG2 transport stream to
> the
> software demuxer.
> [   14.335977] DVB: registering new adapter (DViCO FusionHDTV DVB-T Dual
> Digital 4 (rev 2))
> [   14.355636] nvidia: module license 'NVIDIA' taints kernel.
> [   14.497865] DVB: registering adapter 1 frontend 0 (DiBcom 7000PC)...
> [   14.611161] ACPI: PCI Interrupt Link [SGRU] enabled at IRQ 20
> [   14.611169] nvidia 0000:02:00.0: PCI INT A -> Link[SGRU] -> GSI 20
> (level, low) -> IRQ 20
> [   14.611175] nvidia 0000:02:00.0: setting latency timer to 64
> [   14.611408] NVRM: loading NVIDIA UNIX x86 Kernel Module  177.80  Wed Oct
> 1 14:38:10 PDT 2008
> [   14.655134] DiB0070: successfully identified
> [   14.655812] input: IR-receiver inside an USB DVB receiver as
> /devices/pci0000:00/0000:00:08.0/0000:01:08.2/usb5/5-2/input/input6
> [   14.680687] dvb-usb: schedule remote query interval to 100 msecs.
> [   14.680693] dvb-usb: DViCO FusionHDTV DVB-T Dual Digital 4 (rev 2)
> successfully initialized and connected.
> [   14.680723] usbcore: registered new interface driver dvb_usb_cxusb
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_19233_28693352.1229567610321
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

please look at and read carefully these to posts <br><br><a href="http://ubuntuforums.org/showthread.php?t=616103">http://ubuntuforums.org/showthread.php?t=616103</a><br><br>and<br><br><a href="http://ubuntuforums.org/showpost.php?p=6232229&amp;postcount=42">http://ubuntuforums.org/showpost.php?p=6232229&amp;postcount=42</a><br>
<br><div class="gmail_quote">On Tue, Dec 16, 2008 at 6:36 PM, drappa <span dir="ltr">&lt;<a href="mailto:drappa@iinet.net.au">drappa@iinet.net.au</a>&gt;</span> wrote:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Hello<br>
<br>
I installed a DVICO Dual digital 4 revision2 DVB-T card in a Mythbuntu 8.10<br>
system<br>
<br>
The card wasn&#39;t originally detected so I built the driver from the current<br>
v4l-dvb tree and it works great.<br>
Only problem is the included DVICO remote control has very limited<br>
functionality. Apart from the numeric keypad only three keys work.<br>
<br>
DMESG is below.<br>
<br>
Any pointers to getting the proper key mapping, please?<br>
<br>
Ta<br>
D<br>
<br>
[ &nbsp; 13.921567] dvb-usb: found a &#39; in warm state.<br>
[ &nbsp; 13.921802] dvb-usb: will pass the complete MPEG2 transport stream to the<br>
software demuxer.<br>
[ &nbsp; 13.952919] DVB: registering new adapter (DViCO FusionHDTV DVB-T Dual<br>
Digital 4 (rev 2))<br>
[ &nbsp; 13.994729] input: PC Speaker as /devices/platform/pcspkr/input/input4<br>
[ &nbsp; 14.117557] DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...<br>
[ &nbsp; 14.120807] Linux agpgart interface v0.103<br>
[ &nbsp; 14.275066] DiB0070: successfully identified<br>
[ &nbsp; 14.275641] input: IR-receiver inside an USB DVB receiver as<br>
/devices/pci0000:00/0000:00:08.0/0000:01:08.2/usb5/5-1/input/input5<br>
[ &nbsp; 14.304726] dvb-usb: schedule remote query interval to 100 msecs.<br>
[ &nbsp; 14.304733] dvb-usb: DViCO FusionHDTV DVB-T Dual Digital 4 (rev 2)<br>
successfully initialized and connected.<br>
[ &nbsp; 14.304750] dvb-usb: found a &#39;DViCO FusionHDTV DVB-T Dual Digital 4 (rev<br>
2)&#39; in warm state.<br>
[ &nbsp; 14.304877] dvb-usb: will pass the complete MPEG2 transport stream to the<br>
software demuxer.<br>
[ &nbsp; 14.335977] DVB: registering new adapter (DViCO FusionHDTV DVB-T Dual<br>
Digital 4 (rev 2))<br>
[ &nbsp; 14.355636] nvidia: module license &#39;NVIDIA&#39; taints kernel.<br>
[ &nbsp; 14.497865] DVB: registering adapter 1 frontend 0 (DiBcom 7000PC)...<br>
[ &nbsp; 14.611161] ACPI: PCI Interrupt Link [SGRU] enabled at IRQ 20<br>
[ &nbsp; 14.611169] nvidia 0000:02:00.0: PCI INT A -&gt; Link[SGRU] -&gt; GSI 20<br>
(level, low) -&gt; IRQ 20<br>
[ &nbsp; 14.611175] nvidia 0000:02:00.0: setting latency timer to 64<br>
[ &nbsp; 14.611408] NVRM: loading NVIDIA UNIX x86 Kernel Module &nbsp;177.80 &nbsp;Wed Oct<br>
1 14:38:10 PDT 2008<br>
[ &nbsp; 14.655134] DiB0070: successfully identified<br>
[ &nbsp; 14.655812] input: IR-receiver inside an USB DVB receiver as<br>
/devices/pci0000:00/0000:00:08.0/0000:01:08.2/usb5/5-2/input/input6<br>
[ &nbsp; 14.680687] dvb-usb: schedule remote query interval to 100 msecs.<br>
[ &nbsp; 14.680693] dvb-usb: DViCO FusionHDTV DVB-T Dual Digital 4 (rev 2)<br>
successfully initialized and connected.<br>
[ &nbsp; 14.680723] usbcore: registered new interface driver dvb_usb_cxusb<br>
<br>
<br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
</blockquote></div><br>

------=_Part_19233_28693352.1229567610321--


--===============0990687183==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0990687183==--
