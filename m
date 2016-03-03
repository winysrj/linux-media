Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:54514 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932070AbcCCOWd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Mar 2016 09:22:33 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: Re: tw686x driver
References: <56D6A50F.4060404@xs4all.nl> <m3povcnjfo.fsf@t19.piap.pl>
	<56D7E87B.1080505@xs4all.nl> <m3lh5zohsf.fsf@t19.piap.pl>
	<56D83E16.1010907@xs4all.nl>
Date: Thu, 03 Mar 2016 15:22:30 +0100
In-Reply-To: <56D83E16.1010907@xs4all.nl> (Hans Verkuil's message of "Thu, 3
	Mar 2016 14:37:26 +0100")
Message-ID: <m3h9gnod3t.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> writes:

> There is no point whatsoever in committing a driver and then replacing it
> with another which has a different feature set. I'm not going to do
> that.

Sure, that's why I haven't asked you to do it.
Now there is no another driver, as Ezequiel stated - there is just one
driver.

The point is clear, showing who exactly wrote what.

> One option that might be much more interesting is to add your driver to
> staging with a TODO stating that the field support should be added to
> the mainline driver.

Field mode is one thing. What's a bit more important is that Ezequiel's
changes take away the SG DMA, and basically all DMA. The chip has to use
DMA, but his driver then simply memcpy() all the data to userspace
buffers. This doesn't work on low-power machines.

Staging is meant for completely different situation - for immature,
incomplete code. It has nothing to do with the case.

> I'm not sure if Mauro would go for it, but I think this is a fair option.

I don't expect the situation to be fair to me, anymore.

I also don't want to pursue the legal stuff, copyright laws etc.,
but a quick glance at the COPYING file at the root of the kernel sources
may be helpful:

> 2. You may modify your copy or copies of the Program or any portion
> of it, thus forming a work based on the Program, and copy and
> distribute such modifications or work under the terms of Section 1
> above, provided that you also meet all of these conditions:
>
>     a) You must cause the modified files to carry prominent notices
>     stating that you changed the files and the date of any change.

I don't even ask for that much - I only ask that the single set of
changes from Ezequiel has this very information. This is BTW one of the
reasons we switched to git.
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
