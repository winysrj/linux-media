Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailout11.sul.t-online.de ([194.25.134.85])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hartmut.hackmann@t-online.de>) id 1Jbkjd-0004Jh-Qt
	for linux-dvb@linuxtv.org; Tue, 18 Mar 2008 23:56:46 +0100
Message-ID: <47E048A4.4070904@t-online.de>
Date: Tue, 18 Mar 2008 23:56:36 +0100
From: Hartmut Hackmann <hartmut.hackmann@t-online.de>
MIME-Version: 1.0
To: timf <timf@iinet.net.au>
References: <1204893775.10536.4.camel@ubuntu> <47D1A65B.3080900@t-online.de>	
	<1205480517.5913.8.camel@ubuntu> <47DEE11F.6060301@t-online.de>
	<1205851252.11231.7.camel@ubuntu>
In-Reply-To: <1205851252.11231.7.camel@ubuntu>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Kworld DVB-T 210 - dvb tuning problem
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

Hi, Tim

timf schrieb:
> Hi Hartmut,
> 
> 
> Apologies for the length of this msg, I'm not sure what info you may
> need, so I'm trying to show you that all is not right.
> 
> 1) New install of ubuntu 7.10 i386.
> 
> 2) Install Me-tv, Tvtime.
> Me-tv, in the absence of a channels.conf, scans
> via /usr/share/doc/dvb-utils/examples/scan/dvb-t
> 
> 3) I placed au-Perth_roleystone
> into /usr/share/doc/dvb-utils/examples/scan/dvb-t:
> 
> # Australia / Perth (Roleystone transmitter)
> # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
> # SBS
> T 704500000 7MHz 2/3 NONE QAM64 8k 1/8 NONE
> # ABC
> T 725500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
> # Seven
> T 746500000 7MHz 2/3 NONE QAM64 8k 1/16 NONE
> # Nine
> T 767500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
> # Ten
> T 788500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
> 

Hm, is that right? The transmitter at 704.5MHz has a different configuration
from all others? That's unusual...
There is a speciality with this channel decoder: If you define a parameter
like the GI, it takes this serious while many others ignore it.

<snip>
> 13) Most times, "tda1004x: found firmware revision 20 -- ok" appears
> from a new install of ubuntu.
> Shouldn't have to but will copy firmware into /lib...
> 
And here we have the problem: as long as the firmware download is not
reliable, the board is unusable.
There must be somehing wrong with the board configuration.
In saa7134-dvb.c, line 744, please try to excange:
	.gpio_config   = TDA10046_GP11_I,
with
	.gpio_config   = TDA10046_GP01_I,
does this make the firmware load stable?

Best regards
  Hartmut


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
