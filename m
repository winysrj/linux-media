Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from psmtp04.wxs.nl ([195.121.247.13])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jan-conceptronic@h-i-s.nl>) id 1KGKc3-0006mw-M2
	for linux-dvb@linuxtv.org; Tue, 08 Jul 2008 23:20:40 +0200
Received: from his01.frop.org (ip545779c6.direct-adsl.nl [84.87.121.198])
	by psmtp04.wxs.nl
	(iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14 2006))
	with ESMTP id <0K3P008EFHVT8J@psmtp04.wxs.nl> for linux-dvb@linuxtv.org;
	Tue, 08 Jul 2008 23:19:05 +0200 (MEST)
Received: from [10.0.0.151] (his08.frop.org [10.0.0.151])
	by his01.frop.org (8.11.0/8.11.0) with ESMTP id m68LJ4A03105	for
	<linux-dvb@linuxtv.org>; Tue, 08 Jul 2008 23:19:04 +0200
Date: Tue, 08 Jul 2008 23:19:03 +0200
From: Jan Hoogenraad <jan-conceptronic@h-i-s.nl>
In-reply-to: <4830A30D.2050804@h-i-s.nl>
To: linux-dvb@linuxtv.org
Message-id: <4873D9C7.6090607@h-i-s.nl>
MIME-version: 1.0
References: <1203538678.8313.12.camel@srv-roden.vogelwikke.nl>
	<47BCAC32.9050601@h-i-s.nl> <47BCB371.2020809@h-i-s.nl>
	<20080227075056.34a80abd@areia> <47D462DD.5080500@h-i-s.nl>
	<20080312180321.6a6800a1@gaivota> <47DAED1E.4030002@h-i-s.nl>
	<20080315112427.6b6c55a4@gaivota> <47DC4C77.2020201@h-i-s.nl>
	<4830A30D.2050804@h-i-s.nl>
Subject: [linux-dvb] Final version for Freecom / Conceptronic / Realtek /
 haihua /Videomate / Vestel DVB-T cards with RTL2831U
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

I have stopped the development in the second archive for splitting off 
the tuner code.
I succeeded in understanding the code, and where to put the callbacks.
However, actually splitting the driver is more work than I expected.
Furthermore, nobody reacted with a card with a mxl500x tuner.
Putting any code back into the archive without testing for both main 
configurations does not seem a good idea.

I have just synchronized the archive with linuxtv.org/hg/v4l-dvb
      http://linuxtv.org/hg/~jhoogenraad/rtl2831-r2
I suggest we call it a day, and let that branch persist for a while.

Jan Hoogenraad wrote:
> There are new drivers posted for the Freecom / Conceptronic / Realtek
> cards on:
>     http://linuxtv.org/hg/~jhoogenraad/rtl2831-r2
> 
>         PLEASE FETCH AND TEST THIS VERSION
> 
> The code as gotten from Realtek, and found on the old link, does not
> compile with other current v4l sources anymore. Please stiop using:
>     http://linuxtv.org/hg/~mchehab/rtl2831
> 
> This code is recently synchronised with the mail v4l line, and needs
> testing. Compared to the original code, a switch for the IR type is
> added. It can now be selected using modprobe. For example if you need
> type 2: unload the automatically loaded driver, and reloca the good codes.
> 
> sudo modprobe -r dvb_usb_rtl2831u
> sudo modprobe  dvb_usb_rtl2831u ir_protocol=2
> 
> -----------------
> The following devices are supported (numbers and names do NOT correspond):
> grep rtl2831 /lib/modules/2.6.24-16-generic/modules.usbmap | sed -e
> 's/0x0000.*$//' -e 's/^.*0x0003//'
>       0x0bda   0x2831
>       0x2304   0x022b
>       0x13d3   0x3216
>       0x13d3   0x3220
>       0x13d3   0x3236
>       0x13d3   0x3238
>       0x13d3   0x3244
>       0x08dd   0x2103
>       0x185b   0x0100
>       0x1a46   0x1601
>       0x14aa   0x0160
> 
>          .name = "RTL2831U DVB-T USB2.0 DEVICE",
>          .name = "RTL2831U DVB-T USB2.0 DEVICE",
>          .name = "DVB-T TV-Tuner Card-R",
>          .name = "VideoMate TV U100",
>          .name = "Vestel DVB-T TV Card",
>          .name = "Freecom USB 2.0 DVB-T Device",
>          .name = "DTV-DVB UDTT 7047-USB 2.0 DVB-T Driver",
>          .name = "DTV-DVB UDTT 7047M-USB 2.0 DVB-T Driver",
>          .name = "DTV-DVB UDTT 7047A-USB 2.0 DVB-T Driver",
>          .name = "DTV-DVB UDTT 704L-USB 2.0 DVB-T Driver",
>          .name = "DTV-DVB UDTT 7047Z-USB 2.0 DVB-T Driver",
> 
> -------------
> I have started a second archive for splitting off the tuner code.
> For the mxl5005s tuner, this should be straightforward, as the code
> found its way into the mainstream v4l already.
> 
> However, I ran into problems with the mt2060 (which is the tuner I own).
> In the function  MT2060_LocateIF1 is making this hard.
> This function doe some sort of calibration, and there is both internal
> data from the tuner required, and input from the demodulator.
> 
> I don't see yet how we can put this into the framework of the current
> struct dvb_tuner_ops from dev_frontend.h.
> 
> I'd appreciate some help from somebody more proficient in splitting 
> drivers.
> 
> 
> 
> 

-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
