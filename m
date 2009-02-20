Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:60938 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754753AbZBTKiI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Feb 2009 05:38:08 -0500
Subject: Re: Minimum kernel version supported by v4l-dvb
From: hermann pitton <hermann-pitton@arcor.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	urishk@yahoo.com, linux-media@vger.kernel.org
In-Reply-To: <20090220104935.0c516a57@hyperion.delvare>
References: <43235.62.70.2.252.1234947353.squirrel@webmail.xs4all.nl>
	 <20090218140105.17c86bcb@hyperion.delvare>
	 <1235102231.2708.19.camel@pc10.localdom.local>
	 <200902200753.16856.hverkuil@xs4all.nl>
	 <20090220104935.0c516a57@hyperion.delvare>
Content-Type: text/plain
Date: Fri, 20 Feb 2009 11:39:10 +0100
Message-Id: <1235126350.3321.18.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Freitag, den 20.02.2009, 10:49 +0100 schrieb Jean Delvare:
> On Fri, 20 Feb 2009 07:53:16 +0100, Hans Verkuil wrote:
> > On Friday 20 February 2009 04:57:11 hermann pitton wrote:
> > > Hans decided deliberately to extend backward compat even down to 2.6.16,
> > > now seeing the bill.
> > 
> > I didn't extend it, instead I reduced the backward compat to 2.6.16 at the 
> > time. It supported older kernels as well back then, however since nobody 
> > ever compiled for those older kernels quite a few drivers were broken.
> > 
> > Creating the daily build system at least ensures that we know v4l-dvb can 
> > compile for those kernels we support officially. In the past this was more 
> > based on hope and a prayer :-)
> 
> That's better than before, but just because it builds doesn't mean it
> works...
> 

Given the restricted testing (!) capabilities in both directions, I
don't even know how many and different devices we support currently and
that it works is not always guaranteed on a released kernel either :)

Does Linus know it better ;)

Cheers,
Hermann


