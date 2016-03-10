Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:44648 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752163AbcCJHYJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2016 02:24:09 -0500
Subject: Re: tw686x driver
To: =?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>
References: <56D6A50F.4060404@xs4all.nl> <m3povcnjfo.fsf@t19.piap.pl>
 <56D7E87B.1080505@xs4all.nl> <m3lh5zohsf.fsf@t19.piap.pl>
 <56D83E16.1010907@xs4all.nl> <m3h9gnod3t.fsf@t19.piap.pl>
 <56D84CA7.4050800@xs4all.nl> <m3d1raojqq.fsf@t19.piap.pl>
 <56D96D77.4060707@xs4all.nl> <m34mcmo1vj.fsf@t19.piap.pl>
 <56D99058.2030302@xs4all.nl> <m3shzyls4g.fsf@t19.piap.pl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56E12112.40204@xs4all.nl>
Date: Thu, 10 Mar 2016 08:24:02 +0100
MIME-Version: 1.0
In-Reply-To: <m3shzyls4g.fsf@t19.piap.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/10/2016 08:16 AM, Krzysztof Hałasa wrote:
> Hans Verkuil <hverkuil@xs4all.nl> writes:
> 
>> Heck, if you prefer your driver can be added to staging first, then Ezequiel's
>> driver commit can directly refer to the staging driver as being derived from it.
> 
> Ok, I guess it's fair enough for me. Would you like me to send a patch
> with paths changed to staging/?

Yes please!

> However I'm not sure if Greg will like it - staging was meant for code
> not otherwise ready for mainline. Not a place for alternate drivers.

As I said before, it's for anything that is not considered ready for mainline for
whatever reason. In pretty sure Greg is only too happy to see an 'almost ready for
mainline' driver in staging instead of the usual crap :-)

Thanks!

	Hans
