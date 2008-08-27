Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bane.moelleritberatung.de ([77.37.2.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <artem@moelleritberatung.de>) id 1KYSV7-0005br-8h
	for linux-dvb@linuxtv.org; Wed, 27 Aug 2008 23:24:26 +0200
Date: Wed, 27 Aug 2008 23:24:13 +0200
From: Artem Makhutov <artem@makhutov.org>
To: linux-dvb@linuxtv.org
Message-ID: <20080827212413.GI7830@moelleritberatung.de>
References: <BAY137-W489CF3F8D962EC11AB96CD90610@phx.gbl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BAY137-W489CF3F8D962EC11AB96CD90610@phx.gbl>
Cc: johan_vdp@hotmail.com
Subject: Re: [linux-dvb] Inclusion of STB0899 support in kernel
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

Hi,

On Wed, Aug 27, 2008 at 10:19:06PM +0200, johan vdp wrote:
> 
> What happened to STB0899 support?
> Building a kernel, patching it (with some luck), building applications with patches to match the driver, it is simply too much work.
> (It might be fun once, but starts to be annoying when automatic package updates start to fail, the next day.)
> Having support in the kernel, will lead to applications that 'automatically' start to support it.
>  
> Back in the days that 'multiproto' development was still alive and buzzing. The STB0899 cards looked like having the best support.
> I have followed these lists for some time and opted to buy a STB0899 based DVB-S2 tuner card because the outlook for support was good; THEN.
> NOW it must have been two years, and it is still not merged into the kernel.

Same here. I am using multiproto for a long time now. Personally for me
it works great, but it is really bad, that it is still not included in
the kernel.

Manu Abrahams hg tree is "out of date" and it is impossible to compile
it with a recent kernel without patching it.

Hopefully Igor M. Liplianin has created an hg tree, which merges all the
different dvb-trees in one single tree (http://liplianindvb.sourceforge.net/hg/liplianindvb).
This really helps in compiling multiproto, but this is not the solution.

What is required to get multiproto into the kernel?
Where are the problems?

Regards, Artem

-- 
Artem Makhutov
Unterort Str. 36
D-65760 Eschborn

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
