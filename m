Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from quechua.inka.de ([193.197.184.2] helo=mail.inka.de ident=mail)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jw@raven.inka.de>) id 1KY7Mp-0003WK-6X
	for linux-dvb@linuxtv.org; Wed, 27 Aug 2008 00:50:28 +0200
Date: Wed, 27 Aug 2008 00:45:19 +0200
From: Josef Wolf <jw@raven.inka.de>
To: linux-dvb@linuxtv.org
Message-ID: <20080826224519.GL32022@raven.wolf.lan>
References: <1219733348.3846.8.camel@suse.site>
	<709924.7684.qm@web46108.mail.sp1.yahoo.com>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <709924.7684.qm@web46108.mail.sp1.yahoo.com>
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

On Tue, Aug 26, 2008 at 05:00:18AM -0700, barry bouwsma wrote:

> For laughs, I now converted a short BBC-Four TS I had recorded as
> a test with `ts2ps', and there, the PTS/DTS are present in the PS
> and match those seen in the TS...
> 
>      ==> system_clock_reference_base: 859961626 (0x3341f91a)  [= 90 kHz-Timestamp: 2:39:15.1291]

This is a PS pack header, right?

>          ==> PTS: 5154932522 (0x13342072a)  [= 90 kHz-Timestamp: 15:54:37.0280]
>          ==> DTS: 5154921721 (0x13341dcf9)  [= 90 kHz-Timestamp: 15:54:36.9080]
>          ==> PTS: 5154925321 (0x13341eb09)  [= 90 kHz-Timestamp: 15:54:36.9480]
>          ==> PTS: 5154928921 (0x13341f919)  [= 90 kHz-Timestamp: 15:54:36.9880]

Are those PES headers from audio or from video?  Noticed the hop here?

>      ==> system_clock_reference_base: 859937348 (0x33419a44)  [= 90 kHz-Timestamp: 2:39:14.8594]

PS pack header again? Hop backwards from previous pack header?

>          ==> PTS: 5154908244 (0x13341a854)  [= 90 kHz-Timestamp: 15:54:36.7582]
>          ==> PTS: 5154943322 (0x13342315a)  [= 90 kHz-Timestamp: 15:54:37.1480]
>          ==> DTS: 5154932521 (0x133420729)  [= 90 kHz-Timestamp: 15:54:37.0280]
>          ==> PTS: 5154936121 (0x133421539)  [= 90 kHz-Timestamp: 15:54:37.0680]
>          ==> PTS: 5154939721 (0x133422349)  [= 90 kHz-Timestamp: 15:54:37.1080]
>          ==> PTS: 5154954122 (0x133425b8a)  [= 90 kHz-Timestamp: 15:54:37.2680]

Again hops.  Have you tried to play this stream with vlc?

BTW: what is the DTS good for?  Isn't PTS the relevant time for playbacK?
     What difference does it make when a frame was decoded as long as it
     is presented at the correct time?

     And what is the SCRB good for?  I am totally confused by all those times.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
