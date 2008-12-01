Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ik-out-1112.google.com ([66.249.90.183])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <user.vdr@gmail.com>) id 1L7CEr-00070u-Gk
	for linux-dvb@linuxtv.org; Mon, 01 Dec 2008 18:07:14 +0100
Received: by ik-out-1112.google.com with SMTP id c28so2515325ika.1
	for <linux-dvb@linuxtv.org>; Mon, 01 Dec 2008 09:07:10 -0800 (PST)
Message-ID: <a3ef07920812010907r694baf8ey91b1ef34a26f5222@mail.gmail.com>
Date: Mon, 1 Dec 2008 09:07:07 -0800
From: "VDR User" <user.vdr@gmail.com>
To: Alain <aturbide@rogers.com>
In-Reply-To: <496119.70264.qm@web88306.mail.re4.yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <496119.70264.qm@web88306.mail.re4.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Bug Report - Twinhan vp-1020,
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

2008/12/1 Alain <aturbide@rogers.com>:
> Hi. I didnt find a report of this issue so I'm posting it to the list in
> case.    I noted that in changeset 9349, specifically changes to
> dvb_frontend.c caused my budget dvb card (Twinhan vp-1020a) to no longer be
> able to tune.  All drivers compile and load correctly.  All changesets after
> 9348 (including the current set of 9767)   also exibit the same issue.
> Using the dvb_frontend.c source file from 9348 and recompiling allows the
> drivers to function normally with the latest changeset.

I heard a lot of people with the same problem.  AFAIK everyone just
used an older v4l tree and unfortunately hasn't posted to the ml about
this.  :\

My vp-1020 died so I wasn't able to do any testing here.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
