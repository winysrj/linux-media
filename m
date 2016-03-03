Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:45175 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbcCCGvM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Mar 2016 01:51:12 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: Re: tw686x driver
References: <56D6A50F.4060404@xs4all.nl>
Date: Thu, 03 Mar 2016 07:51:07 +0100
In-Reply-To: <56D6A50F.4060404@xs4all.nl> (Hans Verkuil's message of "Wed, 2
	Mar 2016 09:32:15 +0100")
Message-ID: <m3povcnjfo.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Hans Verkuil <hverkuil@xs4all.nl> writes:

> So lessons learned:
>
> Krzysztof, next time don't wait many months before posting a new version fixing
> requested changes.

Actually, this is not how it happened.

On July 3, 2015 I posted the original driver:
http://www.spinics.net/lists/linux-media/msg91474.html

Ezequiel reviewed the code on 6 Jul 2015:
http://www.spinics.net/lists/linux-media/msg91516.html

On 27 Jul 2015, as you can easily find in your own mail archive, he
informed me that he's working on the driver and that he's going to post
updated patches himself. This was holidays time for me and I stated
that I have to suspend my work till the end of August.

I asked him to add his changes on top of my code several times (and this
is really easy with git). This never happened, and on 14 Aug 2015 he
posted:

> Problem is I've re-written the driver, taking yours as a starting point
> and reference.

> In other words, I don't have a proper git branch with a history, starting
> from the patch you submitted. Instead, I would be submitting a new
> patch for Hans and Mauro to review.

Maybe I got the meaning of this wrong, and he wasn't writing about
rewriting the driver "from scratch". Yes, after receiving this mail
I stopped my development, waiting for his driver to show up. That's
where the "many months" are. Yes, Ezequiel waited for "many months" with
his version - not me.

Only after he has posted "his" driver, I could find out what the
"rewriting" meant.

Don't get me wrong, I was never opposed to him improving my driver.
I only requested that his contributions are clearly shown, in a form
of a patch or a patch set (or a git tree etc.), and so are my own.
I really can't understand why his code can't be transparently applied
over my original patch (or the updated one, which compiles and works
fine with recent media tree).

Is it too much to ask?


The lesson I learned is thus this instead:
- don't publish code because it can be hijacked, twisted and you'll
have to fight for even getting your authorship back. Forget about proper
attribution and history.
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
