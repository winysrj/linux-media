Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1K5QoI-0002bT-Ha
	for linux-dvb@linuxtv.org; Sun, 08 Jun 2008 21:44:17 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Sun, 8 Jun 2008 21:20:04 +0200
References: <65922d730806081149j2ba9085bm1984155ebf8eebd2@mail.gmail.com>
In-Reply-To: <65922d730806081149j2ba9085bm1984155ebf8eebd2@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806082120.04766@orion.escape-edv.de>
Subject: Re: [linux-dvb] TT-Budget/WinTV-NOVA-CI is recognized as sound card
Reply-To: linux-dvb@linuxtv.org
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

Michael Stepanov wrote:
> Hi,
> 
> I have following problem with my TT-Budget/WinTV-NOVA-CI DVB card. It's
> recognized as Audiowerk2 sound card instead of DVB:
> 
> linuxmce@dcerouter:~$ cat /proc/asound/cards
>  0 [Audiowerk2     ]: aw2 - Audiowerk2
>                       Audiowerk2 with SAA7146 irq 16
>  1 [NVidia         ]: HDA-Intel - HDA NVidia
>                       HDA NVidia at 0xfe020000 irq 20
> 
> This is what I can see in the dmesg output:
> [   81.311527] saa7146: register extension 'budget_ci dvb'.
> 
> I use LinxuMCE which is built on the top of Kubuntu Gutsy, AMD64.
> 
> Linux dcerouter 2.6.22-14-generic #1 SMP Sun Oct 14 21:45:15 GMT 2007
> x86_64 GNU/Linux
> 
> Any suggestion how to solve that will be very appreciated.

Complain to the developers of the Audiowerk2 driver for this:

| static struct pci_device_id snd_aw2_ids[] = {
| 	{PCI_VENDOR_ID_SAA7146, PCI_DEVICE_ID_SAA7146, PCI_ANY_ID, PCI_ANY_ID,
| 	 0, 0, 0},
|	{0}
| };

This will grab _all_ saa7146-based cards. :-(

For now you should blacklist that driver.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
