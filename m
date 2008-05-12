Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [84.77.67.98] (helo=ventoso.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <luca@ventoso.org>) id 1JvYzX-0005iq-Pz
	for linux-dvb@linuxtv.org; Mon, 12 May 2008 16:27:08 +0200
Received: from [127.0.0.1] (localhost.localdomain [127.0.0.1])
	by ventoso.org (Postfix) with ESMTP id 6A93DC312AD
	for <linux-dvb@linuxtv.org>; Mon, 12 May 2008 16:26:28 +0200 (CEST)
Message-ID: <48285391.4010202@ventoso.org>
Date: Mon, 12 May 2008 16:26:25 +0200
From: Luca Olivetti <luca@ventoso.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <482560EB.2000306@gmail.com>		<200805101717.23199@orion.escape-edv.de>		<200805101727.55810@orion.escape-edv.de>		<1210456421.7632.29.camel@palomino.walls.org>	<48261EB5.2090604@gmail.com>	<1210463068.7632.102.camel@palomino.walls.org>	<48268EB9.6060000@gmail.com>
	<4827851D.2000104@gmx.net>
In-Reply-To: <4827851D.2000104@gmx.net>
Subject: Re: [linux-dvb] [PATCH] Fix the unc for the frontends tda10021	and
 stv0297
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

En/na P. van Gaans ha escrit:

> Not necessarily. Here some femon output from my Technotrend T-1500:
> 
> status SCVYL | signal  54% | snr  99% | ber 188 | unc 0 | FE_HAS_LOCK
> status SCVYL | signal  54% | snr  99% | ber 230 | unc 0 | FE_HAS_LOCK
> status SCVYL | signal  54% | snr  99% | ber 240 | unc 0 | FE_HAS_LOCK
> status SCVYL | signal  54% | snr  99% | ber 234 | unc 0 | FE_HAS_LOCK
> status SCVYL | signal  54% | snr  99% | ber 228 | unc 21 | FE_HAS_LOCK
> status SCVYL | signal  54% | snr  99% | ber 248 | unc 0 | FE_HAS_LOCK
> status SCVYL | signal  54% | snr  99% | ber 280 | unc 0 | FE_HAS_LOCK
> status SCVYL | signal  54% | snr  99% | ber 234 | unc 0 | FE_HAS_LOCK

Considering that, according to the dvb api spec, unc never should go 
back to 0, I think that the driver is giving bogus values (aren't they 
all, anyway?).

Bye
-- 
Luca


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
