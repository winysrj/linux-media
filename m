Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1Kj1RM-0001h5-75
	for linux-dvb@linuxtv.org; Fri, 26 Sep 2008 02:44:13 +0200
From: Andy Walls <awalls@radix.net>
To: Michel Verbraak <michel@verbraak.org>
In-Reply-To: <48DB3388.2030303@verbraak.org>
References: <48DB3388.2030303@verbraak.org>
Date: Thu, 25 Sep 2008 20:42:56 -0400
Message-Id: <1222389776.2762.35.camel@morgan.walls.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [RFC] Let the future decide between the two.
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

On Thu, 2008-09-25 at 08:45 +0200, Michel Verbraak wrote:
> I have been following the story about the discussion of the future of 
> the DVB API for the last two years and after seen all the discussion I 
> would like to propose the following:
> 
> - Keep the two different DVB API sets next to one another. Both having a 
> space on Linuxtv.org to explain their knowledge and how to use them.
> - Each with their own respective maintainers to get stuff into the 
> kernel. I mean V4L had two versions.
> - Let driver developers decide which API they will follow. Or even 
> develop for both.
> - Let application developers decide which API they will support.
> - Let distribution packagers decide which API they will have activated 
> by default in their distribution.
> - Let the end users decide which one will be used most. (Probably they 
> will decide on: Is my hardware supported or not).

Having two API's is a software maintenance burden both for kernel
developers and application dev's that want their stuff to "just work"
for the end user in all situations.

The purpose of an API is to insulate apps developers from kernel
changes.  What you propose is, I would think, the worst case scenario
for an application developer: an API that can change completely out from
under them at any time (e.g. at the choice of a distribution packager).

If you really want that sort of choice for application developers, you
would build a library that is a thunking layer to present a different
API to the app than the in kernel API.  (I am not a serious application
developer, but for what it's worth, I don't think I would bother with
that unless I had a large complex app already written.)

Regards,
Andy

> - If democracy is that strong one of them will win or maybey the two 
> will get merged and we, the end users, get best of both worlds.


> As the subject says: This is a Request For Comment.
> 
> Regards,
> 
> Michel (end user and application developer).



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
