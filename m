Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay-pt2.poste.it ([62.241.5.253])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nicola.sabbi@poste.it>) id 1KXsNU-00025y-5Q
	for linux-dvb@linuxtv.org; Tue, 26 Aug 2008 08:50:08 +0200
From: Nico Sabbi <nicola.sabbi@poste.it>
To: Josef Wolf <jw@raven.inka.de>
In-Reply-To: <20080825195547.GI32022@raven.wolf.lan>
References: <20080821211437.GE32022@raven.wolf.lan>
	<!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PAKHAAAQAAAAOaJZETzR8EqzWu9A9o/UpwEAAAAA@tv-numeric.com>
	<20080825195547.GI32022@raven.wolf.lan>
Date: Tue, 26 Aug 2008 08:50:13 +0200
Message-Id: <1219733413.3846.10.camel@suse.site>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] RE : How to convert MPEG-TS to MPEG-PS on the fly?
Reply-To: nicola.sabbi@poste.it
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

Il giorno lun, 25/08/2008 alle 21.55 +0200, Josef Wolf ha scritto:
> On Fri, Aug 22, 2008 at 10:10:09AM +0200, Thierry Lelegard wrote:
> > On Thu, Aug 21, 2008 at 09:17:58PM +0200, Josef Wolf wrote:
> > 
> > >The more I look at this PES stream the more confused I get:  The
> > >stream_id 0xe0 seems to transport PTS and DTS _only_.  Everything
> > >else seems to be contained in PES packets with those unknown
> > >stream_id's.  Here is what I see:
> > 
> > As mentioned in my previous post, the "stream ids" below B9
> > are ISO 13818-2 "start codes".
> 
> Thanks for the explanation, Thierry!
> 
> I now have tried to convert via ffmpeg.  The command I used was
> 
>   ffmpeg -vcodec copy -acodec copy z.ps.mp2 -i z.ts


give the output a .dvd extension

> 
> This creates pack headers which don't seem to fit to the syntax
> defined in table 2-33 of iso-13818-1:
> 
>   00 00 01 ba 21 00 01 00  01 a1 9f 0d 00 00 01 bb
> 
> This looks strange to me.  According to the syntax, the pack
> header should be 14 bytes.  Maybe I used the wrong options and
> created  a mpeg1 stream?
> 



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
