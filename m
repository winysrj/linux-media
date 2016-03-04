Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:32946 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751313AbcCDNkp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Mar 2016 08:40:45 -0500
Subject: Re: tw686x driver
To: =?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>
References: <56D6A50F.4060404@xs4all.nl> <m3povcnjfo.fsf@t19.piap.pl>
 <56D7E87B.1080505@xs4all.nl> <m3lh5zohsf.fsf@t19.piap.pl>
 <56D83E16.1010907@xs4all.nl> <m3h9gnod3t.fsf@t19.piap.pl>
 <56D84CA7.4050800@xs4all.nl> <m3d1raojqq.fsf@t19.piap.pl>
 <56D96D77.4060707@xs4all.nl> <m34mcmo1vj.fsf@t19.piap.pl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56D99058.2030302@xs4all.nl>
Date: Fri, 4 Mar 2016 14:40:40 +0100
MIME-Version: 1.0
In-Reply-To: <m34mcmo1vj.fsf@t19.piap.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 03/04/2016 01:37 PM, Krzysztof Hałasa wrote:
> Hans Verkuil <hverkuil@xs4all.nl> writes:
> 
>> I have two drivers with different feature sets. Only one can be active
>> at a time. I have to make a choice which one I'll take and Ezequiel's
>> version has functionality (audio, interlaced support) which matches best
>> with existing v4l applications and the typical use cases. I'm not going
>> to have two drivers for the same hw in the media subsystem since only
>> one can be active anyway. My decision, although Mauro can of course decide
>> otherwise.
> 
> (BTW my driver supports interlace)

Sorry, I meant V4L2_FIELD_INTERLACED support. Very few applications support
FIELD_TOP/BOTTOM, let alone SEQ_BT.

> 
>> I am OK with adding your driver to staging in the hope that someone will
>> merged the functionalities of the two to make a new and better driver.
> 
> Then I don't really understand why there can be two drivers for the same
> hw in the tree, but one has to be in "staging".
> Staging isn't meant for this. My driver perfectly qualifies for being
> merged in the non-staging media directory - doesn't it?
> 
> You are right, there can be two drivers in the tree for the same hw,
> examples are known. You don't have to make a choice here, though you are
> free to do so.
> 
>> My goal is to provide the end-user with the best experience, and this is
>> IMHO the best option given the hand I've been dealt.
> 
> Then, if the moral side of the story can't be maintained, at least do it
> legally as required by copyright laws (and the GPL license as well).
> Doing so is not a "pollution" of git history, but your responsibility as
> a maintainer.
> 
> 
> To be honest, I still can't understand why are you afraid of adding
> Ezequiel's changes on top of my driver properly. While probably far from
> being a pretty changeset, it would make it legal, and this is the thing
> that the author, I suppose, is entitled to.
> Adding some "link" to a mail archive(?) is not a substitute.
> 

I don't get it. Getting your driver in staging is much better for you since
your code is in there and can be compiled for those who want to. I'm not
going to add your driver and then replace it with Ezequiel's version.

Heck, if you prefer your driver can be added to staging first, then Ezequiel's
driver commit can directly refer to the staging driver as being derived from it.

I'm not going to put both drivers in drivers/media. The functionalities of
these drivers should be merged. If I put both drivers in drivers/media then
that will never happen given human nature.

Regards,

	Hans
