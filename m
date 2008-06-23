Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from main.gmane.org ([80.91.229.2] helo=ciao.gmane.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gldd-linux-dvb@m.gmane.org>) id 1KAnlX-0002an-Bs
	for linux-dvb@linuxtv.org; Mon, 23 Jun 2008 17:15:35 +0200
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KAnlT-0000JO-LQ
	for linux-dvb@linuxtv.org; Mon, 23 Jun 2008 15:15:31 +0000
Received: from h240n2fls32o1121.telia.com ([217.211.84.240])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Mon, 23 Jun 2008 15:15:31 +0000
Received: from dvenion by h240n2fls32o1121.telia.com with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Mon, 23 Jun 2008 15:15:31 +0000
To: linux-dvb@linuxtv.org
From: Daniel <dvenion@hotmail.com>
Date: Mon, 23 Jun 2008 15:15:21 +0000 (UTC)
Message-ID: <loom.20080623T150749-54@post.gmane.org>
References: <18643.82.95.219.165.1214055480.squirrel@webmail.xs4all.nl>
Mime-Version: 1.0
Subject: Re: [linux-dvb] s2-3200 fec problem?
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

Niels Wagenaar <n.wagenaar <at> xs4all.nl> writes:

> 
> I know the following (Swedish, but we all speak code!) guide seems to work:
> 
>http://www.minhembio.com/forum/index.php?s=344f35e74353fb173446a5c7d3250854&showtopic=172770&st=30&start=30
>  
> It's a combine of multiproto and the mantis or v4l tree if I've got it
> right. The last revisions of multiproto didn't seem to work for me (a lot
> of lock problems on DVB-S2 transponders with H264 channles). I have to use
> the revisions from March to get it working.
> 
> 
> Niels Wagenaar
> 


I am the one who put those guidelines in swedish together and can report that
they don't work at this moment since they changed the fec from 2/3 to 3/4 and
turned pilot of on the DVB-S2 channels with 8PSK modulation.
Niels, do you have any DVB-S2 channels with 8PSK modulation and fec 3/4 or
higher that you could try to get a lock on? Becuse the channels with QPSK
modulation all seem to work.

Daniel


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
