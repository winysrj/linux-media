Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bar.sig21.net ([88.198.146.85])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <js@sig21.net>) id 1KYok0-0002T1-7W
	for linux-dvb@linuxtv.org; Thu, 28 Aug 2008 23:09:18 +0200
Date: Thu, 28 Aug 2008 23:09:56 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Josef Wolf <jw@raven.inka.de>
Message-ID: <20080828210956.GA6453@linuxtv.org>
References: <20080826224519.GL32022@raven.wolf.lan>
	<949376.11164.qm@web46110.mail.sp1.yahoo.com>
	<20080827220019.GM32022@raven.wolf.lan>
	<20080828144050.GA9065@linuxtv.org>
	<20080828193405.GN32022@raven.wolf.lan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20080828193405.GN32022@raven.wolf.lan>
Cc: linux-dvb@linuxtv.org
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

On Thu, Aug 28, 2008 at 09:34:05PM +0200, Josef Wolf wrote:
> On Thu, Aug 28, 2008 at 04:40:50PM +0200, Johannes Stezenbach wrote:
> 
> > Have you tried iso13818ps from http://www.scara.com/~schirmer/o/mplex13818/ ?
> 
> Thanks for the link.  Description looks promising.  But neither mplayer
> nor vlc plays the output created by
> 
>   mplex13818-1.1.1/iso13818ps --ts z.ts >z.iso.ps

I think the idea is to select _one_ of the services from the TS
by giving the service_id to iso13818ps. And maybe even select
a subset of the PES streams by giving their ids, too. But I have
to admit I never used iso13818ps. At Convergence we used iso13818ts
so that one is know to work.

> Mplayer gives no audio and 8x8 (or 16x16?) squares which keep changing
> colors.  vlc gives black video and no audio.
> 
> The output of my parsing script looks like this:

seems screwed up

> > Try to feed the original
> > TS to iso13818ps (not your filtered one), it should handle it correctly.
> 
> I _am_ feeding the original TS (including adaptation-only packets).  As
> you can see in my previous mail, I am capturing the TS into a file and
> feed this file as input to any of the test candidates.  Whether I ignore
> adaptation should not affect the other candidates in any way.

How do you capture the TS, and does it play OK in vlc?

Johannes

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
