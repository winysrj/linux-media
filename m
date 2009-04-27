Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.viadmin.org ([195.145.128.101]:60038 "EHLO www.viadmin.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870AbZD0XWQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Apr 2009 19:22:16 -0400
Date: Tue, 28 Apr 2009 01:21:51 +0200
From: "H. Langos" <henrik-dvb@prak.org>
To: Johannes Stezenbach <js@linuxtv.org>
Cc: linux-media@vger.kernel.org
Subject: Re: wiki on linixtv.org locked
Message-ID: <20090427232151.GP2895@www.viadmin.org>
References: <20090427164321.GN2895@www.viadmin.org> <20090427173741.GA20847@linuxtv.org> <20090427202925.GO2895@www.viadmin.org> <20090427221416.GA22707@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090427221416.GA22707@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 28, 2009 at 12:14:16AM +0200, Johannes Stezenbach wrote:
> On Mon, Apr 27, 2009 at 10:29:25PM +0200, H. Langos wrote:
> > 
> > the next step would be to update the mediwiki software to 1.11.1 if you have
> > $wgEnableAPI = true, that is. (i know it is only a XSS that hits internet 
> > explorer users ..  but hey, they are people, too ;-)
> 
> I will update to 1.14.0. This is the current version, and it is
> also used by wiki.kernel.org (there is a secret plan to eventually
> move the wiki there). And all the shiny new anti-spam extensions
> don't seem to work with 1.11 anymore...

reCAPTCHA seems to work with anything newer than 1.7.
 
> > if i remember right, the linuxtv wiki only allows editing to registered 
> > users. therefore you could simply temporarily disable new user registration
> > and enable editing again for registered users.
> 
> I will do the update first.
> 
> > then i'd suggest installing the reCAPTCHA extention. not only will it
> > prevent bots from registering, you also help to digitize old books.
> > 
> > http://recaptcha.net/plugins/mediawiki/
> 
> Looked at that and noticed they don't provide any statement
> regarding confidentiality / data protection. Who knows if
> they aren't creating a huge database of who did what in Wikis
> and Blogs around the net...

I'd rather take a look at the code to see what kind of data is sent
off-site. My guess is that there isn't any identification data involved at
all. but you are right. they could add that to their faq. 
OTAH they are a university project and probably didn't approach the whole
thing with sufficient paranoia to think about such a question ;-)

> Besides that, this wouldn't have stopped the present attack
> since the bot used does a manual login assisted by a human user.
> To thwart that I'd have to enable the captcha for every page save...

hmm, manualy asisted bots are nasty. but maybe there is a way to lower the
limit of edits that can be done automatically. maybe a soft limit that would
trigger captcha usage way before hitting the hard limit that stoped the bot
this time....

cheers
-henrik

