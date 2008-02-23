Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bane.moelleritberatung.de ([77.37.2.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <artem@moelleritberatung.de>) id 1JT1zR-00078g-SE
	for linux-dvb@linuxtv.org; Sat, 23 Feb 2008 22:33:01 +0100
Date: Sat, 23 Feb 2008 22:32:58 +0100
From: Artem Makhutov <artem@makhutov.org>
To: Manu Abraham <abraham.manu@gmail.com>
Message-ID: <20080223213258.GE30387@moelleritberatung.de>
References: <32245669.2613.1203594791803.JavaMail.tomcat@dali.otenet.gr>
	<47C01325.10407@otenet.gr>
	<20080223174406.GB30387@moelleritberatung.de>
	<47C0803D.2020504@gmail.com>
	<20080223212013.GD30387@moelleritberatung.de>
	<47C0903B.70606@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <47C0903B.70606@gmail.com>
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

On Sun, Feb 24, 2008 at 01:29:31AM +0400, Manu Abraham wrote:
> Artem Makhutov wrote:
> >Hi,
> >
> >On Sun, Feb 24, 2008 at 12:21:17AM +0400, Manu Abraham wrote:
> >>[...]
> >>Can you guys please update from the multiproto tree and test again at
> >>the earliest and give me your feedback ?
> >
> >No, still the same:
> >
> >Try: 50
> >Failes: 37
> >Tunes: 13
> >
> >Maybe the problem is in the szap.c and not in the driver, as Reinhard
> >Nissl had no problems while tuning channels with VDR?
> >
> >An other thing that I noticed is that only first tunes are successful.
> >I continued the same tuning test to 100, but I got no more successfull 
> >locks.
> >The last successfull lock was try 20:
> >
> >Try: 100
> >Failes: 87
> >Tunes: 13
> >
> >I am running a new test with a 15 seconds break after each tune now and
> >will mail you the results when the test finises.
> 
> Are you sure that you got the top level 2 changes changeset 7204 and 7203
> respectively ?

Oh, I only got 7203. Will try with 7204 in a few minutes.

Regards, Artem

-- 
Artem Makhutov
Unterort Str. 36
D-65760 Eschborn

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
