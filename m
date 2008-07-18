Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from main.gmane.org ([80.91.229.2] helo=ciao.gmane.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gldd-linux-dvb@m.gmane.org>) id 1KJpbR-00056t-Qe
	for linux-dvb@linuxtv.org; Fri, 18 Jul 2008 15:02:32 +0200
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KJpbJ-0004zG-Sw
	for linux-dvb@linuxtv.org; Fri, 18 Jul 2008 13:02:21 +0000
Received: from h30n2fls32o1121.telia.com ([217.211.84.30])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Fri, 18 Jul 2008 13:02:21 +0000
Received: from dvenion by h30n2fls32o1121.telia.com with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Fri, 18 Jul 2008 13:02:21 +0000
To: linux-dvb@linuxtv.org
From: Daniel =?utf-8?b?SGVsbHN0csO2bQ==?= <dvenion@hotmail.com>
Date: Fri, 18 Jul 2008 13:02:14 +0000 (UTC)
Message-ID: <loom.20080718T125917-359@post.gmane.org>
References: <200807170023.57637.ajurik@quick.cz>
Mime-Version: 1.0
Subject: Re: [linux-dvb] TT S2-3200 driver
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

Ales Jurik <ajurik <at> quick.cz> writes:

> 
> Hi,
> 
> please try attached patch. With this patch I'm able to get lock on channels 
> before it was impossible. But not at all problematic channels and the 
> reception is not without errors. Also it seems to me that channel switching is 
> quicklier.

I have tested the transponder with Eurosport now. It has DVB-S2, 8PSK, Fec 3/4
and 30000 in symbolrate. I get instant lock but no picture. Just black screen.
All the other transponders locks fast and I get picture.




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
