Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from quechua.inka.de ([193.197.184.2] helo=mail.inka.de ident=mail)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jw@raven.inka.de>) id 1KY5xW-00075d-MQ
	for linux-dvb@linuxtv.org; Tue, 26 Aug 2008 23:20:20 +0200
Date: Tue, 26 Aug 2008 23:19:41 +0200
From: Josef Wolf <jw@raven.inka.de>
To: linux-dvb@linuxtv.org
Message-ID: <20080826211941.GJ32022@raven.wolf.lan>
References: <20080821211437.GE32022@raven.wolf.lan>
	<!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PAKHAAAQAAAAOaJZETzR8EqzWu9A9o/UpwEAAAAA@tv-numeric.com>
	<20080825195547.GI32022@raven.wolf.lan>
	<1219733413.3846.10.camel@suse.site>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1219733413.3846.10.camel@suse.site>
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

On Tue, Aug 26, 2008 at 08:50:13AM +0200, Nico Sabbi wrote:

> > I now have tried to convert via ffmpeg.  The command I used was
> >   ffmpeg -vcodec copy -acodec copy z.ps.mp2 -i z.ts
> 
> give the output a .dvd extension

Thanks for the hint, Nico!  Though the ffmpeg FAQ explicitly states
that file types should _not_ be recognized by extensions, this did
the trick.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
