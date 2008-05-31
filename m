Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from main.gmane.org ([80.91.229.2] helo=ciao.gmane.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gldd-linux-dvb@m.gmane.org>) id 1K2Slo-0000Zq-Sz
	for linux-dvb@linuxtv.org; Sat, 31 May 2008 17:13:25 +0200
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1K2Sle-00087g-PA
	for linux-dvb@linuxtv.org; Sat, 31 May 2008 15:13:14 +0000
Received: from c83-254-20-12.bredband.comhem.se ([83.254.20.12])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Sat, 31 May 2008 15:13:14 +0000
Received: from elupus by c83-254-20-12.bredband.comhem.se with local (Gmexim
	0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Sat, 31 May 2008 15:13:14 +0000
To: linux-dvb@linuxtv.org
From: elupus <elupus@ecce.se>
Date: Sat, 31 May 2008 17:13:07 +0200
Message-ID: <2bey1nyib3as$.17amb76188wak.dlg@40tude.net>
References: <timjkg4t68k0.u9vss0x6vh17$.dlg@40tude.net>
	<19apj9y5ari7e$.iq8vatom4e8q.dlg@40tude.net>
	<a7d0idxnqmsq.1kxbekc9wr0n1.dlg@40tude.net>
	<ea4209750803260338k48f25e8mf95c5734481d2da7@mail.gmail.com>
	<loom.20080326T105420-829@post.gmane.org>
	<ea4209750803260417w38fd4ac2l82f50f8a9c0a29f2@mail.gmail.com>
	<5pvhprg5pgaz.1max8nss01igr.dlg@40tude.net>
	<1bor0hfgk1uo2$.9i9tmhrqox9d.dlg@40tude.net>
	<ea4209750805310554n159f180eyf86e769ee8debcf0@mail.gmail.com>
Mime-Version: 1.0
Subject: Re: [linux-dvb] STK7700-PH ( dib7700 + ConexantCX25842 + Xceive
	XC3028 )
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

On Sat, 31 May 2008 14:54:43 +0200, Albert Comerma wrote:

> Sorry, I forgot... I just tested this; first plug the card (it's detected as
> usual and works fine with kaffeine). Then reboot the system without removing
> the card. The led of the card stays on during all the process. Once system
> is restarted, reopen kaffeine and it works just fine.
> 
> Albert
> 

Right, yea. When i swapped back to original firmware, the reboot issue went
away. So the patch is as simple as adding the pci id's and the extra
section for the card without remote setups.

I'm not sure the new section is needed, as i'v got no clue what happens if
a card has no ir-port, and you add those keymaps settings to the section. 

(want it into main repo, so i don't have to keep mine :) )

Regards
Joakim


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
