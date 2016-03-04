Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:45374 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165AbcCDMh2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Mar 2016 07:37:28 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: Re: tw686x driver
References: <56D6A50F.4060404@xs4all.nl> <m3povcnjfo.fsf@t19.piap.pl>
	<56D7E87B.1080505@xs4all.nl> <m3lh5zohsf.fsf@t19.piap.pl>
	<56D83E16.1010907@xs4all.nl> <m3h9gnod3t.fsf@t19.piap.pl>
	<56D84CA7.4050800@xs4all.nl> <m3d1raojqq.fsf@t19.piap.pl>
	<56D96D77.4060707@xs4all.nl>
Date: Fri, 04 Mar 2016 13:37:20 +0100
In-Reply-To: <56D96D77.4060707@xs4all.nl> (Hans Verkuil's message of "Fri, 4
	Mar 2016 12:11:51 +0100")
Message-ID: <m34mcmo1vj.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> writes:

> I have two drivers with different feature sets. Only one can be active
> at a time. I have to make a choice which one I'll take and Ezequiel's
> version has functionality (audio, interlaced support) which matches best
> with existing v4l applications and the typical use cases. I'm not going
> to have two drivers for the same hw in the media subsystem since only
> one can be active anyway. My decision, although Mauro can of course decide
> otherwise.

(BTW my driver supports interlace)

> I am OK with adding your driver to staging in the hope that someone will
> merged the functionalities of the two to make a new and better driver.

Then I don't really understand why there can be two drivers for the same
hw in the tree, but one has to be in "staging".
Staging isn't meant for this. My driver perfectly qualifies for being
merged in the non-staging media directory - doesn't it?

You are right, there can be two drivers in the tree for the same hw,
examples are known. You don't have to make a choice here, though you are
free to do so.

> My goal is to provide the end-user with the best experience, and this is
> IMHO the best option given the hand I've been dealt.

Then, if the moral side of the story can't be maintained, at least do it
legally as required by copyright laws (and the GPL license as well).
Doing so is not a "pollution" of git history, but your responsibility as
a maintainer.


To be honest, I still can't understand why are you afraid of adding
Ezequiel's changes on top of my driver properly. While probably far from
being a pretty changeset, it would make it legal, and this is the thing
that the author, I suppose, is entitled to.
Adding some "link" to a mail archive(?) is not a substitute.
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
