Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bane.moelleritberatung.de ([77.37.2.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <artem@moelleritberatung.de>) id 1JTOG2-00083l-NH
	for linux-dvb@linuxtv.org; Sun, 24 Feb 2008 22:19:38 +0100
Date: Sun, 24 Feb 2008 22:19:35 +0100
From: Artem Makhutov <artem@makhutov.org>
To: Manu Abraham <abraham.manu@gmail.com>
Message-ID: <20080224211935.GK30387@moelleritberatung.de>
References: <20080223212013.GD30387@moelleritberatung.de>
	<47C0903B.70606@gmail.com>
	<20080223213258.GE30387@moelleritberatung.de>
	<20080223214718.GF30387@moelleritberatung.de>
	<47C09519.2090904@gmail.com> <47C09BCC.50403@gmail.com>
	<20080224123736.GH30387@moelleritberatung.de>
	<47C176A7.9070608@gmail.com>
	<20080224180013.GJ30387@moelleritberatung.de>
	<47C1C416.8060903@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <47C1C416.8060903@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TechniSat SkyStar HD: Problems scaning and zaping
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

On Sun, Feb 24, 2008 at 11:23:02PM +0400, Manu Abraham wrote:
> Artem Makhutov wrote:
> >Hi,
> >
> >On Sun, Feb 24, 2008 at 05:52:39PM +0400, Manu Abraham wrote:
> >>Artem Makhutov wrote:
> >>>Hi,
> >>>
> >>>On Sun, Feb 24, 2008 at 02:18:52AM +0400, Manu Abraham wrote:
> >>>>Also, can you please do a benchmark in lock timings between changeset 
> >>>>7205 and 7200 ?
> >>>Do you mean changeset 7200 or 7204
> >>yep. 7205 is head, but just a minor change.
> >
> >I did the benchmark betweet 7205 and 7204.
> >The modules were loaded with no additional parameters.
> >
> >Tuning time in 7204: ~0.83 seconds (min 0.81191 sec ; max 2.428967 sec)
> >Tuning time in 7205: ~0.26 seconds (min 0.24789 sec ; max 1.994216 sec)
> 
> 
> Can you test the time between 7200 and 7204/7205.
> (7201 - 7204 contains an optimization, compared to 7200 and hence
> the need to check the results. So need to exclude 7201 and 7204)

Ok, I got it. I was in the believe that the tuning will only work ~50 percent
successfull with rev 7200...)

Here are the results of the benchmarks with rev 7200:

A tune needs ~1 second.
Min: 0.829529 ; Max: 3.074599

The log file is available at:
http://www.makhutov.org/downloads/dvb/logs/7200.log.gz

So your optimizations works great ;)

Regards, Artem

-- 
Artem Makhutov
Unterort Str. 36
D-65760 Eschborn

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
