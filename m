Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from cable-85.28.84.48.coditel.net ([85.28.84.48]
	helo=ibiza.bxl.tuxicoman.be)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gmsoft@tuxicoman.be>) id 1JmS2q-0005rl-1z
	for linux-dvb@linuxtv.org; Thu, 17 Apr 2008 13:12:48 +0200
Date: Thu, 17 Apr 2008 13:12:02 +0200
From: Guy Martin <gmsoft@tuxicoman.be>
To: Robert Schedel <r.schedel@yahoo.de>
Message-Id: <20080417131202.16bcf354.gmsoft@tuxicoman.be>
In-Reply-To: <48066F62.8000709@yahoo.de>
References: <47F9E95D.6070705@yahoo.de>
	<200804120100.14568@orion.escape-edv.de>
	<48066F62.8000709@yahoo.de>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] High CPU load in "top" due to budget_av slot polling
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



Hi Robert,

This patch looks great. I tested it with Easywatch DVB-C (1011:0019) without CI/CAM and load is 0 now while it was ~0.6 constantly before.

uname -a : Linux devbox 2.6.25 #1 Thu Apr 17 12:18:32 CEST 2008 i686 AMD Athlon(tm) Processor AuthenticAMD GNU/Linux

Cheers,
  Guy

On Wed, 16 Apr 2008 23:28:02 +0200
Robert Schedel <r.schedel@yahoo.de> wrote:

> 
> Attached a patch for 2.6.24.4. Opinions?
> 

-- 
Guy Martin
Gentoo Linux - HPPA port lead


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
