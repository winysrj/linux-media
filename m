Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38611 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352AbbBBObn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Feb 2015 09:31:43 -0500
Date: Mon, 2 Feb 2015 12:31:38 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCHv2 1/2] regmap: add configurable lock class key for
 lockdep
Message-ID: <20150202123138.2b2a2fa4@recife.lan>
In-Reply-To: <20141222150515.GV17800@sirena.org.uk>
References: <1419114892-4550-1-git-send-email-crope@iki.fi>
	<20141222124411.GK17800@sirena.org.uk>
	<549814BB.3040808@iki.fi>
	<20141222133142.GM17800@sirena.org.uk>
	<54982246.20300@iki.fi>
	<20141222150515.GV17800@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antti/Mark,

Any news with regards to this?

Regards,
Mauro

Em Mon, 22 Dec 2014 15:05:15 +0000
Mark Brown <broonie@kernel.org> escreveu:

> On Mon, Dec 22, 2014 at 03:53:10PM +0200, Antti Palosaari wrote:
> > On 12/22/2014 03:31 PM, Mark Brown wrote:
> 
> > >>>Why is this configurable, how would a device know if the system it is in
> > >>>needs a custom locking class and can safely use one?
> 
> > >>If RegMap instance is bus master, eg. I2C adapter, then you should define
> > >>own custom key. If you don't define own key and there will be slave on that
> > >>bus which uses RegMap too, there will be recursive locking from a lockdep
> > >>point of view.
> 
> > >That doesn't really explain to me why this is configurable, why should
> > >drivers have to worry about this?
> 
> > Did you read the lockdep documentation I pointed previous mail?
> 
> No, quite apart from the fact that you pasted a good chunk of it into
> your mail I don't think it's a good idea to require people to have to
> reverse engineer everything to figure out if they're supposed to use
> this, or expect people reviewing code using this feature to do that in
> order to figure out if it's being used correctly or not.
> 
> Suggesting that I'm not thinking hard enough isn't helping here; this
> stuff needs to be clear and easy so that people naturally get it right
> when they need to and don't break things as a result of confusion or
> error, requiring people to directly work with infrequently used things
> like lock classes with minimal explanation doesn't achieve that goal.
> 
> > One possibility is to disable lockdep checking from that driver totally,
> > then drivers do not need to care it about. But I don't think it is proper
> > way. One solution is to use custom regmap locking available already, but
> > Mauro nor me didn't like that hack:
> 
> You don't seem to be answering any of my questions here...  for example,
> you keep saying that this is something bus masters should do.  Why does
> it make sense for people writing such drivers to have to figure out that
> they need to do this and how to do it?  Are there some bus masters that
> shouldn't be doing so?  Should anything that isn't a bus master have to
> do it?
> 
> > >Please also write technical terms like regmap normally.
> 
> > Lower-case letters?
> 
> Yes, the way it's written in every place it's used in the kernel except
> a few I see you've added.
