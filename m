Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from quechua.inka.de ([193.197.184.2] helo=mail.inka.de ident=mail)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jw@raven.inka.de>) id 1KZ6Ex-0008Tk-FU
	for linux-dvb@linuxtv.org; Fri, 29 Aug 2008 17:50:24 +0200
Date: Fri, 29 Aug 2008 17:45:43 +0200
From: Josef Wolf <jw@raven.inka.de>
To: linux-dvb@linuxtv.org
Message-ID: <20080829154543.GQ32022@raven.wolf.lan>
References: <1219733348.3846.8.camel@suse.site>
	<709924.7684.qm@web46108.mail.sp1.yahoo.com>
	<20080826224519.GL32022@raven.wolf.lan>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20080826224519.GL32022@raven.wolf.lan>
Subject: Re: [linux-dvb] PTS/DTS clarification (Was: How to convert MPEG-TS
	to MPEG-PS on the fly?)
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

On Wed, Aug 27, 2008 at 12:45:19AM +0200, Josef Wolf wrote:

> BTW: what is the DTS good for?  Isn't PTS the relevant time for playbacK?
>      What difference does it make when a frame was decoded as long as it
>      is presented at the correct time?
> 
>      And what is the SCRB good for?  I am totally confused by all those
>      times.

I have found a good reading on

  http://www.tek.com/Measurement/programs/mpeg_fundamentals/

This reading is much more comprehensive than the iso-13818-1.  Page 47
explains PTS/DTS.  In a nutshell, DTS is needed because of bidirectional
video encoding.  As an example, pictures can be presented in order IBBP,
but for decoding the order would be IPBB because the B pictures depend
on the I and P pictures.  Since decoders can decode only one picture at
a time, DTS is used to signal that decoding have to be done in a
different order than presentation.

So now my understanding is that for determining packet order in the PS,
DTS has to be used if it exists.  If no DTS exists, then PTS is to be
used.

Guess, my understanding is still wrong.  But I need a starting point
from which I can remove errors step by step ;-)


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
