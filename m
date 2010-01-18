Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:54041 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752422Ab0ARWnE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2010 17:43:04 -0500
Subject: RE: How to use saa7134 gpio via gpio-sysfs?
From: hermann pitton <hermann-pitton@arcor.de>
To: William Tate <wtate@RTD.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Trent Piepho <xyzzy@speakeasy.org>,
	Gordon Smith <spider.karma+linux-media@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"'willytate@gmail.com'" <willytate@gmail.com>
In-Reply-To: <EAF55B080F530E428574542A7925428705EA7F1C66@INTMBX1.RTD.com>
References: <2df568dc1001111012u627f07b8p9ec0c2577f14b5d9@mail.gmail.com>
	 <2df568dc1001111059p54de8635k6c207fb3f4d96a14@mail.gmail.com>
	 <1263266020.3198.37.camel@pc07.localdom.local>
	 <1263602137.3184.23.camel@pc07.localdom.local>
	 <Pine.LNX.4.58.1001151650410.4729@shell2.speakeasy.net>
	 <1263622815.3178.31.camel@pc07.localdom.local>
	 <Pine.LNX.4.58.1001160400230.4729@shell2.speakeasy.net>
	 <1263686928.3394.4.camel@pc07.localdom.local>
	 <1263689544.8899.3.camel@pc07.localdom.local>
	 <1263769323.3182.8.camel@pc07.localdom.local>
	 <EAF55B080F530E428574542A7925428705EA7F1C66@INTMBX1.RTD.com>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 18 Jan 2010 23:40:00 +0100
Message-Id: <1263854400.6804.15.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Montag, den 18.01.2010, 09:13 -0500 schrieb William Tate:
> Gentlemen,
> 
> I may be able to assist here.  Specifically what information/photographs are you looking for?
> 
> Regards,
> 
> 
> William Tate
> RTD Embedded Technologies, Inc.

Gordon, please explain, why you would like to have access to some of the
saa713x gpios on that device from userspace.

Unknown to me previously, it seems RTD already provides software for
their customers to use the digital I/Os, but restricted to owners of
such devices.

"For an example of how to use VFG73xx digital I/O, please see the
Software Product SWP-700010065 “Linux
Software (VFG73xx)” available from the RTD web site"

William, is there a desire to have such gpio access from userspace on
your side? Trent kindly outlined some details. Please give us some brief
explanations in that case.

Thanks for offering your help.

Hermann

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-owner@vger.kernel.org] On Behalf Of hermann pitton
> Sent: Sunday, January 17, 2010 6:02 PM
> To: Trent Piepho
> Cc: Gordon Smith; linux-media@vger.kernel.org
> Subject: Re: How to use saa7134 gpio via gpio-sysfs?
> 
> [snip]
> > 
> > Damned, seems the opto-isolated I/Os might be in question.
> > 
> > For the RTD stuff we don't have any high resolution photographs or
> > anything else ...
> 
> Gordon,
> 
> we should wait for, if RTD and Philips/NXP do have a agreement on such.
> 
> I doubt it, given how it came in.
> 
> Else, you can of course still do what you ever want on that driver.
> 
> Cheers,
> Hermann
> 
> 


