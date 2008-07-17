Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from main.gmane.org ([80.91.229.2] helo=ciao.gmane.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gldd-linux-dvb@m.gmane.org>) id 1KJVgN-00071e-Ff
	for linux-dvb@linuxtv.org; Thu, 17 Jul 2008 17:46:33 +0200
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KJVfU-0006C7-5r
	for linux-dvb@linuxtv.org; Thu, 17 Jul 2008 15:45:20 +0000
Received: from h30n2fls32o1121.telia.com ([217.211.84.30])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Thu, 17 Jul 2008 15:45:20 +0000
Received: from dvenion by h30n2fls32o1121.telia.com with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Thu, 17 Jul 2008 15:45:20 +0000
To: linux-dvb@linuxtv.org
From: Daniel =?utf-8?b?SGVsbHN0csO2bQ==?= <dvenion@hotmail.com>
Date: Thu, 17 Jul 2008 15:45:09 +0000 (UTC)
Message-ID: <loom.20080717T154146-799@post.gmane.org>
References: <200807170023.57637.ajurik@quick.cz>
	<3efb10970807170320w39377ae9p9db0081dda9c3f5f@mail.gmail.com>
	<1216295683l.6831l.1l@manu-laptop>
Mime-Version: 1.0
Subject: Re: [linux-dvb] Re :  TT S2-3200 driver
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

manu <eallaud <at> yahoo.fr> writes:

> If you want to use myth you can try the attached patch (against trunk).
> Make sure that the includes in /usr/include/linux/dvb/ are the one from 
> your multiproto tree (check for a DVBFE_SET_DELSYS define in the 
> frontend.h source).
> Bye
> Manu
> 

I use the patch on this site to add multiprotosupport to MythTV

http://svn.mythtv.org/trac/ticket/5403

It also modifies the channelscanning section in mythtv-setup so you can set the
modulationtype for the transport.





_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
