Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:51407 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357AbcCGGlx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Mar 2016 01:41:53 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: Re: tw686x driver
References: <56D6A50F.4060404@xs4all.nl> <m3povcnjfo.fsf@t19.piap.pl>
	<56D7E87B.1080505@xs4all.nl> <m3lh5zohsf.fsf@t19.piap.pl>
	<56D83E16.1010907@xs4all.nl> <m3h9gnod3t.fsf@t19.piap.pl>
	<56D84CA7.4050800@xs4all.nl> <m3d1raojqq.fsf@t19.piap.pl>
	<56D96D77.4060707@xs4all.nl> <m34mcmo1vj.fsf@t19.piap.pl>
	<56D99058.2030302@xs4all.nl>
Date: Mon, 07 Mar 2016 07:41:49 +0100
In-Reply-To: <56D99058.2030302@xs4all.nl> (Hans Verkuil's message of "Fri, 4
	Mar 2016 14:40:40 +0100")
Message-ID: <m3ziuan61e.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> writes:

> Sorry, I meant V4L2_FIELD_INTERLACED support. Very few applications support
> FIELD_TOP/BOTTOM, let alone SEQ_BT.

Well, that's doable, though not in SG mode. It still doesn't require
memcpy() of uncompressed video.

> I don't get it. Getting your driver in staging is much better for you since
> your code is in there and can be compiled for those who want to. I'm not
> going to add your driver and then replace it with Ezequiel's version.

Then simply add my driver and don't replace it.
Face it: Ezequiel's driver adds the audio support, and I guess he can
add this audio code without breaking the existing driver.
I also have (old) audio code for this driver, but it has only been
tested without an actual audio input, so it's not ready for deployment.
I simply don't use audio at the moment.

Otherwise, "his driver" is a regression - it removes critical
functionality, in exchange giving only the V4L2_FIELD_INTERLACED, which
can be easily implemented without breaking the rest.

> Heck, if you prefer your driver can be added to staging first, then Ezequiel's
> driver commit can directly refer to the staging driver as being
> derived from it.

Well, I will have to think about it. Though I wonder - if you do that,
perhaps my next request should be to swap them.
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
