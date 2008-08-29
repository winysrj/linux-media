Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from quechua.inka.de ([193.197.184.2] helo=mail.inka.de ident=mail)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jw@raven.inka.de>) id 1KYwsM-0004Zz-62
	for linux-dvb@linuxtv.org; Fri, 29 Aug 2008 07:50:28 +0200
Date: Fri, 29 Aug 2008 07:49:07 +0200
From: Josef Wolf <jw@raven.inka.de>
To: linux-dvb@linuxtv.org
Message-ID: <20080829054907.GP32022@raven.wolf.lan>
References: <20080826224519.GL32022@raven.wolf.lan>
	<949376.11164.qm@web46110.mail.sp1.yahoo.com>
	<20080827220019.GM32022@raven.wolf.lan>
	<20080828144050.GA9065@linuxtv.org>
	<20080828193405.GN32022@raven.wolf.lan>
	<20080828210956.GA6453@linuxtv.org>
	<20080828224856.GO32022@raven.wolf.lan>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20080828224856.GO32022@raven.wolf.lan>
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

On Fri, Aug 29, 2008 at 12:48:56AM +0200, Josef Wolf wrote:
> On Thu, Aug 28, 2008 at 11:09:56PM +0200, Johannes Stezenbach wrote:
> > How do you capture the TS,
> 
> I have written my own beast to demux a complete transponder and split
> it into separate transport streams (every service gets its stream).
> The PIDs which are mentioned in the PMT for the given service are passed
> unmodified.  In addition, new PAT/PMT are created (stripped down just to
> the given service).

One thing I make different is that I filter out all sections with
current_next_indicator==0 and never generate such sections.  But
since PAT never changes and PMT can change only on event boundaries,
this should not affect streams with length of a couple of seconds.

> > and does it play OK in vlc?
> 
> Both, mplayer and vlc play those streams with no problems.
> 
> Do you think the TS may be screwed?  I pass the a/v-PIDs which are
> mentioned in PMT unmodified.  PAT is trivial.  PMT reflects the
> contents from the original PMT (reconstructed just to keep
> continuity_counter consistent).  I don't think anything can be
> screwed here.
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
