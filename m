Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1KhYla-0006HB-LX
	for linux-dvb@linuxtv.org; Mon, 22 Sep 2008 01:55:04 +0200
Date: Mon, 22 Sep 2008 01:54:29 +0200
From: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <200809211905.34424.hftom@free.fr>
Message-ID: <20080921235429.18440@gmx.net>
MIME-Version: 1.0
References: <200809211905.34424.hftom@free.fr>
To: Christophe Thommeret <hftom@free.fr>, linux-dvb@linuxtv.org,
	stoth@linuxtv.org
Subject: Re: [linux-dvb] hvr4000-s2api + QAM_AUTO
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


-------- Original-Nachricht --------
> Datum: Sun, 21 Sep 2008 19:05:34 +0200
> Von: Christophe Thommeret <hftom@free.fr>
> An: Steven Toth <stoth@linuxtv.org>, "linux-dvb" <linux-dvb@linuxtv.org>
> Betreff: [linux-dvb] hvr4000-s2api + QAM_AUTO

> Hi Steve,
> 
> I've managed to add S2 support to kaffeine, so it can scan and zap.
> However, i have a little problem with DVB-S:
> Before tuning to S2, S channels tune well with QAM_AUTO.
> But after having tuned to S2 channels, i can no more lock on S ones until
> i 
> set modulation to QPSK insteed of QAM_AUTO for these S channels.
> Is this known?
> 
> -- 
> Christophe Thommeret

Hi Christophe,
do you mean FEC_AUTO? There is a note in the comments in cx24116.c about
FEC_AUTO working for QPSK but not for S2 (8PSK or NBC-QPSK). 
Look for "Especially, no auto detect when in S2 mode."

Hope I'm not misunderstanding your question.

I'd be very happy to try out your patch for Kaffeine and give feedback if you are
ready to share it.

Regards,
Hans

-- 
Release early, release often.

Ist Ihr Browser Vista-kompatibel? Jetzt die neuesten 
Browser-Versionen downloaden: http://www.gmx.net/de/go/browser

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
