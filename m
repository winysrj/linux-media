Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay.chp.ru ([213.170.120.254] helo=ns.chp.ru)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1KMp3d-0004b8-2R
	for linux-dvb@linuxtv.org; Sat, 26 Jul 2008 21:03:59 +0200
Received: from cherep2.ptl.ru (localhost.ptl.ru [127.0.0.1])
	by cherep.quantum.ru (Postfix) with SMTP id C13A219E6190
	for <linux-dvb@linuxtv.org>; Sat, 26 Jul 2008 23:03:00 +0400 (MSD)
Received: from localhost.localdomain (unknown [213.170.123.250])
	by ns.chp.ru (Postfix) with ESMTP id 89C1319E60E6
	for <linux-dvb@linuxtv.org>; Sat, 26 Jul 2008 23:03:00 +0400 (MSD)
Date: Sat, 26 Jul 2008 23:11:07 +0400
From: Goga777 <goga777@bk.ru>
To: linux-dvb@linuxtv.org
Message-ID: <20080726231107.19a36cc6@bk.ru>
In-Reply-To: <20080725140411.248480@gmx.net>
References: <20080725140411.248480@gmx.net>
Mime-Version: 1.0
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

> are there any documentation or HOWTOS about the 
> differences of some funktions declared in frontend.h 
> It`s not so clear  how and when to use 
> the   fe_xxx   dvbfe_xxx dvb_frontend_xxx 
> 
> Is it possilble resp. does it make sense to use all of them? 
> 
> I use the multiproto modules and get with patched szap or own application 
> 
> `FE_READ_STATUS failed: Invalid argument 

did you use the szap2 from TEST directory of dvb-apps ?
http://linuxtv.org/hg/dvb-apps/file/dea7edede819/test/szap2.c



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
