Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web38806.mail.mud.yahoo.com ([209.191.125.97])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <krabaey@yahoo.com>) id 1KppXa-0002Yb-RH
	for linux-dvb@linuxtv.org; Tue, 14 Oct 2008 21:26:50 +0200
Date: Tue, 14 Oct 2008 12:26:12 -0700 (PDT)
From: Koen Rabaey <krabaey@yahoo.com>
To: linux-dvb <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Message-ID: <178287.57665.qm@web38806.mail.mud.yahoo.com>
Subject: Re: [linux-dvb] S2API / TT3200 / STB0899 support
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

Hi,


just replaced in my pc an HVR4000 by TT-3200 device, did a 'hg clone http://mercurial.intuxication.org/hg/s2-liplianin' and then built and installed the tree.

This is what I see in /var/log/messages after rebooting(relevant section):

Oct 14 20:55:23 krabaey-desktop kernel: [   15.480872] saa7146: register extension 'budget_ci dvb'.
Oct 14 20:55:23 krabaey-desktop kernel: [   15.480906] budget_ci dvb 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Oct 14 20:55:23 krabaey-desktop kernel: [   15.480924] saa7146: found saa7146 @ mem f8aacc00 (revision 1, irq 16) (0x13c2,0x1019).
Oct 14 20:55:23 krabaey-desktop kernel: [   15.480929] saa7146 (0): dma buffer size 192512
Oct 14 20:55:23 krabaey-desktop kernel: [   15.480931] DVB: registering new adapter (TT-Budget S2-3200 PCI)
Oct 14 20:55:23 krabaey-desktop kernel: [   15.504947] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
Oct 14 20:55:23 krabaey-desktop kernel: [   15.516983] adapter has MAC addr = 00:d0:5c:68:22:11
Oct 14 20:55:23 krabaey-desktop kernel: [   15.517314] input: Budget-CI dvb ir receiver saa7146 (0) as /devices/pci0000:00/0000:00:1e.0/0000:04:00.0/input/input6
Oct 14 20:55:23 krabaey-desktop kernel: [   15.537961] hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
Oct 14 20:55:23 krabaey-desktop kernel: [   15.903289] stb0899_attach: Attaching STB0899
Oct 14 20:55:23 krabaey-desktop kernel: [   15.917736] stb6100_attach: Attaching STB6100
Oct 14 20:55:23 krabaey-desktop kernel: [   15.937033] DVB: registering frontend 0 (STB0899 Multistandard)...

Using vdr I am then succesfully able to watch these HD channels (normal DVB-S channels were also fine).

Premiere HD
Astra HD Demo
Discovery HD
Anixe HD

My dish is currently pointed to Astra 19.2 so I guess these are the only one HD channels I can receive.

I have no clue what kind of modulation these channels use.

If you have specific tests which may help you in evaluating this patch let me know.

Kind regards,

Koen



----- Original Message ----
> From: Steven Toth <stoth@linuxtv.org>
> To: linux-dvb <linux-dvb@linuxtv.org>
> Sent: Tuesday, October 14, 2008 8:09:24 PM
> Subject: [linux-dvb] S2API / TT3200 / STB0899 support
> 
> As you have all seen on the list recently, on the 'stb0899 and TT 
> s2-3200' thread, Igor has ported Manu's TT3200 drivers to the S2API.
> 
> Personally, I have not had the time to test, but I hear they are working 
> very well for some people, OK for others, and bad for some people.
> 
> Can everyone please post their comments into this thread?
> 
> Thanks,
> 
> Steve
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb



      

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
