Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:45301 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753354AbcCJHQw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2016 02:16:52 -0500
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
Date: Thu, 10 Mar 2016 08:16:47 +0100
In-Reply-To: <56D99058.2030302@xs4all.nl> (Hans Verkuil's message of "Fri, 4
	Mar 2016 14:40:40 +0100")
Message-ID: <m3shzyls4g.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> writes:

> Heck, if you prefer your driver can be added to staging first, then Ezequiel's
> driver commit can directly refer to the staging driver as being derived from it.

Ok, I guess it's fair enough for me. Would you like me to send a patch
with paths changed to staging/?


However I'm not sure if Greg will like it - staging was meant for code
not otherwise ready for mainline. Not a place for alternate drivers.
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
