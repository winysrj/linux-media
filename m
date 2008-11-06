Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]
	helo=sasl.smtp.pobox.com) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <torgeir@pobox.com>) id 1Ky2H9-0007cW-St
	for linux-dvb@linuxtv.org; Thu, 06 Nov 2008 11:39:45 +0100
Message-Id: <C2D0EF7E-95E6-40B5-9FFE-BF1292F25DF3@pobox.com>
From: Torgeir Veimo <torgeir@pobox.com>
To: Jelle De Loecker <skerit@kipdola.com>
In-Reply-To: <4912BA94.8060809@kipdola.com>
Mime-Version: 1.0 (Apple Message framework v929.2)
Date: Thu, 6 Nov 2008 20:38:52 +1000
References: <BF8F0D96-3ED8-4D3D-8EF7-899FCAC4514E@pobox.com>
	<4912BA94.8060809@kipdola.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] dvbloopback:
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


On 6 Nov 2008, at 19:36, Jelle De Loecker wrote:

> Are you using S2API and the S2API patch found on open-sasc-ng's trac?
> Because I have the same problem ("error 14", I don't get the  
> "private data" bit, though) with kernel 2.6.26 (which came with  
> Debian Lenny) AND with my own compiled 2.6.27
>
> In my case it must be an S2API thing, because when I was using  
> Multiproto everything worked fine.


I am using a pretty recent version of the hg code yes. DVB version is  
set to 5. I guess I need to find a less recent version.

-- 
Torgeir Veimo
torgeir@pobox.com





_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
