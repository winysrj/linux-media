Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:52344 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427AbcCCMlY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Mar 2016 07:41:24 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: Re: tw686x driver
References: <56D6A50F.4060404@xs4all.nl> <m3povcnjfo.fsf@t19.piap.pl>
	<56D7E87B.1080505@xs4all.nl>
Date: Thu, 03 Mar 2016 13:41:20 +0100
In-Reply-To: <56D7E87B.1080505@xs4all.nl> (Hans Verkuil's message of "Thu, 3
	Mar 2016 08:32:11 +0100")
Message-ID: <m3lh5zohsf.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> writes:

> When a driver is merged for the first time in the kernel it is always as
> a single change, i.e. you don't include the development history as that
> would pollute the kernel's history.

We don't generally add new drivers with long patch series, that's right.
That's because there is usually no reason to do so. This situation is
different, there is a very good reason.

I'm not asking for doing this with a long patch set. A single patch from
me + single patch containing the Ezequiel changes would suffice.

> Those earlier versions have never
> been tested/reviewed to the same extent as the final version

This is not a real problem, given the code will be changed immediately
again.

> and adding
> them could break git bisect.

Not really. You can apply the version based on current media tree,
I have posted it a week ago or so. This doesn't require any effort.

BTW applying the thing in two consecutive patches (the old version +
changes) doesn't break git bisect at all. It only breaks the compiling,
and only in the very case when git bisect happens to stop between the
first and second patch, and the driver is configured in. Very unlikely,
though the remedy is very easy as shown in "man git-bisect".
This is a common thing when you do git bisect, though the related
patches are usually much more distant and thus the probability that the
kernel won't compile is much much greater.

Alternatively one could apply the original version to an older kernel and
merge the product. Less trivial and I don't know why one would want to
do so, given #1.

One could also disable the CONFIG_VIDEO_TW686X in Kconfig (at the
original patch). Possibilities are endless.

We have to face it: there is absolutely no problem with adding the
driver with two patches, either using my original patch or the updated
one. And it doesn't require any effort, just a couple of git commands.

> It is a quite unusual situation and the only way I could make it worse would
> by not merging anything.

Not really.
There is a very easy way out. You can just add the driver properly with
two patches.


Though I don't know why do you think my driver alone doesn't qualify to
be merged (without subsequent Ezequiel's changes). It's functional
and stable, and I have been using it (in various versions) for many
months. It's much more mature than many other drivers which make it to
the kernel regularly.

It is definitely _not_ my driver that is problematic.
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
