Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-out1.iol.cz ([194.228.2.86])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ajurik@quick.cz>) id 1KGsKT-00058R-Sq
	for linux-dvb@linuxtv.org; Thu, 10 Jul 2008 11:20:46 +0200
Received: from ales-debian.local (unknown [88.103.120.47])
	by smtp-out1.iol.cz (Postfix) with ESMTP id EF73E5DDD4
	for <linux-dvb@linuxtv.org>; Thu, 10 Jul 2008 11:15:10 +0200 (CEST)
From: Ales Jurik <ajurik@quick.cz>
To: linux-dvb@linuxtv.org
Date: Thu, 10 Jul 2008 11:15:06 +0200
References: <loom.20080628T180915-166@post.gmane.org>
	<Pine.LNX.4.64.0807100053310.6335@shogun.pilppa.org>
	<20080710121844.5c7e9502@bk.ru>
In-Reply-To: <20080710121844.5c7e9502@bk.ru>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807101115.06323.ajurik@quick.cz>
Subject: Re: [linux-dvb] Re : Re : How to solve the TT-S2-3200 tuning
	problems?
Reply-To: ajurik@quick.cz
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

On Thursday 10 of July 2008, Goga777 wrote:
> try please updated multiproto with some fixes
> http://jusst.de/hg/multiproto/summary

Hi,

thanks for your hint.

I've just tried. My opinion:
- little more slowly when switching 
- still no lock possible at some transponders when changing satellite
- still no lock possible at some DVB-S2 8PSK channels (or after few minutes 
and only for few seconds)

BR,

Ales


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
