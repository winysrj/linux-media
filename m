Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42717 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067Ab0ASMoO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2010 07:44:14 -0500
Message-ID: <4B55A915.1000207@infradead.org>
Date: Tue, 19 Jan 2010 10:44:05 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Johannes Stezenbach <js@linuxtv.org>
CC: Patrick Boettcher <pboettcher@kernellabs.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: [ANNOUNCE] git tree repositories
References: <4B55445A.10300@infradead.org> <201001190853.11050.hverkuil@xs4all.nl> <201001190910.39479.pboettcher@kernellabs.com> <20100119112057.GC9187@linuxtv.org>
In-Reply-To: <20100119112057.GC9187@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Johannes Stezenbach wrote:
> On Tue, Jan 19, 2010 at 09:10:39AM +0100, Patrick Boettcher wrote:
>> BTW: I just made a clone of the git-tree - 365MB *ouff*. Maybe it's worth to 
>> mention right now, that one big difference to HG in the way we have used it, is 
>> that one developer now can do all the work only with one clone of v4l-dvb and 
>> using branches for each development.
> 
> Please note that you SHOULD NOT clone from linuxtv.org.
> Please follow the description on the top of
> http://linuxtv.org/git/
> 
> Most linux developers will have a clone of Linus' tree already,
> and you can add as many "remotes" to that tree as you like.

Yes. I have here one "stable" tree that have one "remote" for every stable
tree since 2.6.16.

> It's much faster and more flexible that way.  If you once pulled
> a clone of Linus' tree there is simply no need to ever clone
> any other Linux tree ever again.

Yes. I personally prefer to have a bare clone (bare trees have just
the -git objects, and not a workig tree), and several working copies.
I do the work at the working copies, and, after they are fine, I push
into the bare and send the branches from bare to upstream.

> Oh, and if you manage to get your git tree in a state where
> you don't know how to fix the mess, don't throw it away.
> Go to the git mailing list and ask for advice. They love
> customer feeedback. Helps them to improve their product
> and make it more user friendly ;-)

Yes. One good thing to do is to take a look at "git reflog". It tracks
all the changes you do, and you can always ask git to move to a different
object at the tree, undoing the bad thing you did ;)
> 
> 
> Johannes

