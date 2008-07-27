Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <markus.o.hahn@gmx.de>) id 1KN4rG-00082o-CH
	for linux-dvb@linuxtv.org; Sun, 27 Jul 2008 13:56:15 +0200
From: Markus Hahn <markus.o.hahn@gmx.de>
To: linux-dvb@linuxtv.org
Date: Sun, 27 Jul 2008 13:55:39 +0200
References: <20080725140411.248480@gmx.net> <20080726231107.19a36cc6@bk.ru>
In-Reply-To: <20080726231107.19a36cc6@bk.ru>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807271355.39521.markus.o.hahn@gmx.de>
Subject: Re: [linux-dvb] multipoto frontend.h missmatch
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

Am Samstag, 26. Juli 2008 21:18:29 schrieb Goga777:
thanx goga, 
 playing with  zap ist just a first step, I want hack some own application.
since it is evident for me to have a clear picture of all that fe_xx and dvb_xx dvbfe_xx stuff. 

regards markus 

Am Samstag, 26. Juli 2008 21:11:07 schrieb Goga777:
> > are there any documentation or HOWTOS about the 
> > differences of some funktions declared in frontend.h 
> > It`s not so clear  how and when to use 
> > the   fe_xxx   dvbfe_xxx dvb_frontend_xxx 
> > 
> > Is it possilble resp. does it make sense to use all of them? 
> > 
> > I use the multiproto modules and get with patched szap or own application 
> > 
> > `FE_READ_STATUS failed: Invalid argument 
> 
> did you use the szap2 from TEST directory of dvb-apps ?
> http://linuxtv.org/hg/dvb-apps/file/dea7edede819/test/szap2.c
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
