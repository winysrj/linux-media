Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from quechua.inka.de ([193.197.184.2] helo=mail.inka.de ident=mail)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jw@raven.inka.de>) id 1KVvZU-0002l4-Rg
	for linux-dvb@linuxtv.org; Wed, 20 Aug 2008 23:50:29 +0200
Date: Wed, 20 Aug 2008 23:48:14 +0200
From: Josef Wolf <jw@raven.inka.de>
To: linux-dvb@linuxtv.org
Message-ID: <20080820214814.GB32022@raven.wolf.lan>
References: <20080820211005.GA32022@raven.wolf.lan>
	<48AC89DE.9010502@linuxtv.org>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <48AC89DE.9010502@linuxtv.org>
Subject: Re: [linux-dvb] How to convert MPEG-TS to MPEG-PS on the fly?
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

On Wed, Aug 20, 2008 at 05:17:18PM -0400, Steven Toth wrote:
> Josef Wolf wrote:
> >Hello,
> >
> >I'd like to convert live mpeg-ts streams from DVB-S on the fly into
> >a mpeg-ps stream.  I know that (for example)
> >
> >  mencoder -oac copy -ovc copy -of mpeg -quiet infile -o outfile.mpg
> 
> Can't you use named pipes with mencoder and direct the flow into your 
> target process?

In principle, yes.  But there is a big drawback to such a solution:
the pipes (and demuxing/muxing in a different process) will introduce
lots of context switches.  Since I want to convert four full
transponders at the same time (about 25 channels), this will certainly
kill my 450MHz PII machine.  Let alone the 25 additional mencoder
processes all running in parallel.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
