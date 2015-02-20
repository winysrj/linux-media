Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:47301 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441AbbBTJu2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Feb 2015 04:50:28 -0500
Date: Fri, 20 Feb 2015 07:50:24 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL 3.19] si2168 fix
Message-ID: <20150220075024.220df8e8@recife.lan>
In-Reply-To: <54E6917C.8010300@iki.fi>
References: <54C0CCEF.8080500@iki.fi>
	<54E68430.6010607@iki.fi>
	<20150219233641.72340a03@recife.lan>
	<54E6917C.8010300@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 20 Feb 2015 03:44:28 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> On 02/20/2015 03:36 AM, Mauro Carvalho Chehab wrote:
> > Em Fri, 20 Feb 2015 02:47:44 +0200
> > Antti Palosaari <crope@iki.fi> escreveu:
> >
> >> Mauro
> >> Did that patch went to stable? I see you have committed original patch
> >> from patchwork, but there is no stable tag.
> >
> > It went upstream, but I'm unsure if it arrived for 3.19 or 3.20.
> >
> > That's the upstream changeset:
> >
> > $ git show 551c33e729f6
> > commit 551c33e729f654ecfaed00ad399f5d2a631b72cb
> > Author: Jurgen Kramer <gtmkramer@xs4all.nl>
> > Date:   Mon Dec 8 05:30:44 2014 -0300
> >
> >      [media] Si2168: increase timeout to fix firmware loading
> >
> >      Increase si2168 cmd execute timeout to prevent firmware load failures. Tests
> >      shows it takes up to 52ms to load the 'dvb-demod-si2168-a30-01.fw' firmware.
> >      Increase timeout to a safe value of 70ms.
> >
> >      Signed-off-by: Jurgen Kramer <gtmkramer@xs4all.nl>
> >      Reviewed-by: Antti Palosaari <crope@iki.fi>
> >      Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> >
> > Weird, it is missing the Cc tag on its commit message. I double-checked
> > re-applying it on a scratch branch: my scripts are properly recognizing
> > the Cc tag.
> >
> > I've no idea what happened. Perhaps you've added this patch on some other
> > branch that you asked me to pull?
> >
> > Anyway, now the proper solution is to send this patch directly to
> > stable@vger.kernel.org, C/C the mailing list.
> 
> I added proper stable tag to patchwork and then waited looong time you 
> pick it from patchwork. After a month or so, I picked whole patch from 
> patchwork to my tree, yet again added proper stable tags and made 
> PULL-request. So there is stable tag on both patchwork and PULL-request. 
> You applied patchwork - but without stable tag....
> 
> So I am very surprised to see original patch applied to master, but 
> without stable tag.
> 
> Si2168: increase timeout to fix firmware loading
> https://patchwork.linuxtv.org/patch/27382/
> 
> [GIT PULL 3.19] si2168 fix
> http://www.spinics.net/lists/linux-media/msg85713.html

Ah, I know what happened: you replied with "Reviewed-by:" on 2014-12-08,
but you sent the pull request only in 2015-01-22.

The "Accepted" state for the #27382 patch indicates that I picked the
version that was at patchwork, instead of the one from your pull request,
because I saw that you've replied with a reviewed-by tag.

Unfortunately, patchwork doesn't consider "Cc:" as a tag to honor,
nor it brings the full history of the replies on its pwclient interface.
So, I didn't notice the Cc: on your reply.

Next time, if you intend to send the patch on a separate pull request,
please don't reply with a "reviewed-by:" tag, as I my understanding
when I see acked-by/reviewed-by from a driver maintainer is that he
won't be sending me a pull request about that specific patch. When
I have time, I sometimes double check, but, as I was just arriving from
vacations in the end of January, I had a very long backlog to handle.

Regards,
Mauro
