Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from f60.mail.ru ([194.67.57.94])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1JRT6v-0007Mq-Bt
	for linux-dvb@linuxtv.org; Tue, 19 Feb 2008 15:06:17 +0100
From: Igor <goga777@bk.ru>
To: Zenon Mousmoulas <zmousm@admin.grnet.gr>
Mime-Version: 1.0
Date: Tue, 19 Feb 2008 17:05:39 +0300
In-Reply-To: <66500EF2-F708-4E3D-BB57-4120D867C793@admin.grnet.gr>
References: <66500EF2-F708-4E3D-BB57-4120D867C793@admin.grnet.gr>
Message-Id: <E1JRT6J-000M4v-00.goga777-bk-ru@f60.mail.ru>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb]
	=?koi8-r?b?SGF1cHBhdWdlIFdpblRWLUhWUjQwMDAgYW5kIERW?=
	=?koi8-r?b?Qi1TMi4uLg==?=
Reply-To: Igor <goga777@bk.ru>
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

> As I wrote in my first mail, I also tried those (more specifically the  
> sfe patch), but it didn't work for S2 (DVB-S worked with 2.6.22):

it should work, I checked it in last year.

> > I have also tried the patches from http://dev.kewl.org/hauppauge/  
> > against the v4l-dvb tree. The patches didn't apply cleanly with the  
> > current tip. I had to go back to 7192 (b6e3eee46ca2) to apply the  
> > 2008-02-07 sfe patch. Compiled for 2.6.22, DVB-S works, with the  
> > default sysctl value of dev.cx24116.modfec=0xfe30. 

does fec for your channel is 2/3 ?
could you show the szap2 output during dvb-s2 tuning 

> Is there something else I am missing?

may be :)

Igor


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
