Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from dyn60-31.dsl.spy.dnainternet.fi ([83.102.60.31]
	helo=shogun.pilppa.org) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lamikr@pilppa.org>) id 1KNvsC-00009p-Di
	for linux-dvb@linuxtv.org; Tue, 29 Jul 2008 22:32:46 +0200
Date: Tue, 29 Jul 2008 23:31:47 +0300 (EEST)
From: Mika Laitio <lamikr@pilppa.org>
To: Goga777 <goga777@bk.ru>
In-Reply-To: <20080724132047.10c6688d@bk.ru>
Message-ID: <Pine.LNX.4.64.0807292330020.15498@shogun.pilppa.org>
References: <Pine.LNX.4.64.0807240030280.20479@shogun.pilppa.org>
	<20080724132047.10c6688d@bk.ru>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] latest hvr-4000 driver patches
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

> I have vdr 170 , hvr4000 and fresh drivers form "Igor M. Liplianin's repo (repo includes hg multiproto + hvr4000 patch +
> some fixes)
> http://liplianindvb.sourceforge.net/cgi-bin/hgwebdir.cgi/liplianindvb/
> It works well. I recommend it for your case
> Of course it's not multifrontend drivers

I build and installed the drivers from Liplianin's repository to 2.6.26
kernel. I think driver loads now ok and dvb-s is used by default. (at
least that is reported by the kaffeine and scan from dvb-apps)

Should the dvb-apps/util/scan/scan from dvb-apps repository head work with
the Liplianin's driver?

I think I found at least some satellite according to cheap peeper hardware 
I have used while rotating dish. Command
"./scan dvb-s/Hotbird-13.0E" does not find any channels for me.

And could I use the util/femon indicate some non-zero values if I run 
that alone for the debugging purposes, when some satellite gives good 
signal?

Mika


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
