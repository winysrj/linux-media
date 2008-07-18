Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay.chp.ru ([213.170.120.254] helo=ns.chp.ru)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1KJkCV-0001yo-7l
	for linux-dvb@linuxtv.org; Fri, 18 Jul 2008 09:16:24 +0200
Received: from cherep2.ptl.ru (localhost.ptl.ru [127.0.0.1])
	by cherep.quantum.ru (Postfix) with SMTP id 8F83319E644C
	for <linux-dvb@linuxtv.org>; Fri, 18 Jul 2008 11:15:48 +0400 (MSD)
Received: from localhost.localdomain (hpool.chp.ptl.ru [213.170.123.250])
	by ns.chp.ru (Postfix) with ESMTP id 4E18D19E5C6C
	for <linux-dvb@linuxtv.org>; Fri, 18 Jul 2008 11:15:48 +0400 (MSD)
Date: Fri, 18 Jul 2008 11:22:56 +0400
From: Goga777 <goga777@bk.ru>
To: linux-dvb@linuxtv.org
Message-ID: <20080718112256.6da5bdf9@bk.ru>
In-Reply-To: <3efb10970807171311t46d075cdudef4b34cc069c265@mail.gmail.com>
References: <200807170023.57637.ajurik@quick.cz>
	<3efb10970807170320w39377ae9p9db0081dda9c3f5f@mail.gmail.com>
	<487F3365.4070306@chaosmedia.org>
	<3efb10970807171311t46d075cdudef4b34cc069c265@mail.gmail.com>
Mime-Version: 1.0
Subject: Re: [linux-dvb] szap - p - r options (was - T S2-3200 driver)
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

> > with szap2 you also can tune to FTA channels using the option "-p" and read
> > the stream from your frontend dvr (/dev/dvb/adapter0/dvr0) with mplayer for
> > example..


btw, could someone explain me what's difference between szap - r and szap - p options ?

when should I use -r options. when - p or both -r -p ???

  -r        : set up /dev/dvb/adapterX/dvr0 for TS recording
  -p        : add pat and pmt to TS recording (implies -r)


Goga





_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
