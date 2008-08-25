Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from quechua.inka.de ([193.197.184.2] helo=mail.inka.de ident=mail)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jw@raven.inka.de>) id 1KXiEj-0007xI-5m
	for linux-dvb@linuxtv.org; Mon, 25 Aug 2008 22:00:25 +0200
Date: Mon, 25 Aug 2008 21:55:47 +0200
From: Josef Wolf <jw@raven.inka.de>
To: linux-dvb@linuxtv.org
Message-ID: <20080825195547.GI32022@raven.wolf.lan>
References: <20080821211437.GE32022@raven.wolf.lan>
	<!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PAKHAAAQAAAAOaJZETzR8EqzWu9A9o/UpwEAAAAA@tv-numeric.com>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PAKHAAAQAAAAOaJZETzR8EqzWu9A9o/UpwEAAAAA@tv-numeric.com>
Subject: Re: [linux-dvb] RE : How to convert MPEG-TS to MPEG-PS on the fly?
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

On Fri, Aug 22, 2008 at 10:10:09AM +0200, Thierry Lelegard wrote:
> On Thu, Aug 21, 2008 at 09:17:58PM +0200, Josef Wolf wrote:
> 
> >The more I look at this PES stream the more confused I get:  The
> >stream_id 0xe0 seems to transport PTS and DTS _only_.  Everything
> >else seems to be contained in PES packets with those unknown
> >stream_id's.  Here is what I see:
> 
> As mentioned in my previous post, the "stream ids" below B9
> are ISO 13818-2 "start codes".

Thanks for the explanation, Thierry!

I now have tried to convert via ffmpeg.  The command I used was

  ffmpeg -vcodec copy -acodec copy z.ps.mp2 -i z.ts

This creates pack headers which don't seem to fit to the syntax
defined in table 2-33 of iso-13818-1:

  00 00 01 ba 21 00 01 00  01 a1 9f 0d 00 00 01 bb

This looks strange to me.  According to the syntax, the pack
header should be 14 bytes.  Maybe I used the wrong options and
created  a mpeg1 stream?

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
