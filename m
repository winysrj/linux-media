Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ik-out-1112.google.com ([66.249.90.181])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <user.vdr@gmail.com>) id 1L7ZCA-0002a0-LG
	for linux-dvb@linuxtv.org; Tue, 02 Dec 2008 18:37:59 +0100
Received: by ik-out-1112.google.com with SMTP id c28so3047345ika.1
	for <linux-dvb@linuxtv.org>; Tue, 02 Dec 2008 09:37:55 -0800 (PST)
Message-ID: <a3ef07920812020937jb0feff7q695f91dbd2156b5e@mail.gmail.com>
Date: Tue, 2 Dec 2008 09:37:54 -0800
From: "VDR User" <user.vdr@gmail.com>
To: "Alain Turbide" <aturbide@rogers.com>
In-Reply-To: <003301c953fc$84e23110$0000fea9@cr344472a>
MIME-Version: 1.0
Content-Disposition: inline
References: <99503.50867.qm@web88302.mail.re4.yahoo.com>
	<003301c953fc$84e23110$0000fea9@cr344472a>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [FIXEd] Bug Report - Twinhan vp-1020,
	bt_8xx driver + frontend
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

2008/12/1 Alain Turbide <aturbide@rogers.com>:
> Digging in a little further.The dst_algo (which the twinhan uses) is set to
> return  0 as the default setting for the SW algo in dst.c, yet in
> dvb_frontend.h, the DVBFE_ALGO_SW algo is defined as 2.  Which is the
> correct one here? Should dst.c be changed to return 2 as sw or is 0 the
> correct number for the SW algo and thus DVBFE_ALGO_SW be changed to return
> 0?

Is nobody else looking into this?!  I would think this bug would have
received a little more attention considering the number of people
affected!

Please keep up the work, it's much appreciated!  I, on behalf of
several others who aren't subscribed to the ml, am monitoring this
thread in hopes of a proper fix.

Thanks!
-Derek

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
