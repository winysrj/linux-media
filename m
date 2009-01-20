Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110811.mail.gq1.yahoo.com ([67.195.13.234]:25636 "HELO
	web110811.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753726AbZATJak (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2009 04:30:40 -0500
Date: Tue, 20 Jan 2009 01:30:39 -0800 (PST)
From: Uri Shkolnik <urishk@yahoo.com>
Reply-To: urishk@yahoo.com
Subject: Re: Siano's patches
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	linux-media@vger.kernel.org, linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <Pine.LNX.4.58.0901191737550.11165@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <532534.51935.qm@web110811.mail.gq1.yahoo.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>




--- On Tue, 1/20/09, Trent Piepho <xyzzy@speakeasy.org> wrote:

> From: Trent Piepho <xyzzy@speakeasy.org>
> Subject: Re: Siano's patches
> To: "Uri Shkolnik" <urishk@yahoo.com>
> Cc: "Mauro Carvalho Chehab" <mchehab@infradead.org>, "Michael Krufky" <mkrufky@linuxtv.org>, linux-media@vger.kernel.org, "linux-dvb" <linux-dvb@linuxtv.org>
> Date: Tuesday, January 20, 2009, 3:49 AM
> On Mon, 19 Jan 2009, Uri Shkolnik wrote:
> > Siano has some dozens of commercial Linux-based
> customers using the
> > discussed sources.  Those customers have their own QA
> engineers
> > additionally to Siano internal QA team (which includes
> dedicated engineer
> > for this task).  Some of those companies products are
> already in the
> > market (production level).
> 
> But how much testing do you give other manufacturers'
> hardware with your
> code?  Your hardware might work, but you could have broken
> someone else's.
> 
> I've found that getting patches into the kernel is
> usually significantly
> harder than writing them in the first place.

mmm.... You have a good point here. I don't know, there is a kind of catch-22 here. True the code may break someone else', or violate something unknown to me. But, how can it be tested if you don't have suitable hardware?

Take the SPI as example. The code is for system with PXA CPU, which is connected with SPI/SPP bus to the SMS DTV chip-set. You need such (hw) device in order to check/test it. Who has this hardware but some manufacturers? Maybe someone bought & hacked such a commercial device, but I never got any indication that anyone did such a thing.

You can of course just compile the code and see if the build is completed successfully, without running it on a real target. This is some kind of code testing, and that is what I referred to as "kernel-coding related remarks" in my post. 

Uri 


      
