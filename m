Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from quechua.inka.de ([193.197.184.2] helo=mail.inka.de ident=mail)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jw@raven.inka.de>) id 1KYqJu-0007hx-0y
	for linux-dvb@linuxtv.org; Fri, 29 Aug 2008 00:50:27 +0200
Date: Fri, 29 Aug 2008 00:48:56 +0200
From: Josef Wolf <jw@raven.inka.de>
To: linux-dvb@linuxtv.org
Message-ID: <20080828224856.GO32022@raven.wolf.lan>
References: <20080826224519.GL32022@raven.wolf.lan>
	<949376.11164.qm@web46110.mail.sp1.yahoo.com>
	<20080827220019.GM32022@raven.wolf.lan>
	<20080828144050.GA9065@linuxtv.org>
	<20080828193405.GN32022@raven.wolf.lan>
	<20080828210956.GA6453@linuxtv.org>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20080828210956.GA6453@linuxtv.org>
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

On Thu, Aug 28, 2008 at 11:09:56PM +0200, Johannes Stezenbach wrote:
> On Thu, Aug 28, 2008 at 09:34:05PM +0200, Josef Wolf wrote:
> > On Thu, Aug 28, 2008 at 04:40:50PM +0200, Johannes Stezenbach wrote:
> > 
> > > Have you tried iso13818ps from http://www.scara.com/~schirmer/o/mplex13818/ ?
> > 
> > Thanks for the link.  Description looks promising.  But neither mplayer
> > nor vlc plays the output created by
> > 
> >   mplex13818-1.1.1/iso13818ps --ts z.ts >z.iso.ps
> 
> I think the idea is to select _one_ of the services from the TS
> by giving the service_id to iso13818ps.

The TS contains only one service.

> And maybe even select a subset of the PES streams by giving their
> ids, too.

Hmm, I don't see an option to specify multiple streams (one audio
and one video).  Apart from that, IMHO it should be possible to
have multiple audio streams in a single PS.

> > Mplayer gives no audio and 8x8 (or 16x16?) squares which keep changing
> > colors.  vlc gives black video and no audio.
> > 
> > The output of my parsing script looks like this:
> 
> seems screwed up

:-)

> > > Try to feed the original
> > > TS to iso13818ps (not your filtered one), it should handle it correctly.
> > 
> > I _am_ feeding the original TS (including adaptation-only packets).  As
> > you can see in my previous mail, I am capturing the TS into a file and
> > feed this file as input to any of the test candidates.  Whether I ignore
> > adaptation should not affect the other candidates in any way.
> 
> How do you capture the TS,

I have written my own beast to demux a complete transponder and split
it into separate transport streams (every service gets its stream).
The PIDs which are mentioned in the PMT for the given service are passed
unmodified.  In addition, new PAT/PMT are created (stripped down just to
the given service).

> and does it play OK in vlc?

Both, mplayer and vlc play those streams with no problems.

Do you think the TS may be screwed?  I pass the a/v-PIDs which are
mentioned in PMT unmodified.  PAT is trivial.  PMT reflects the
contents from the original PMT (reconstructed just to keep
continuity_counter consistent).  I don't think anything can be
screwed here.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
