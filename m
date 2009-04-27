Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.viadmin.org ([195.145.128.101]:59885 "EHLO www.viadmin.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638AbZD0U3w (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Apr 2009 16:29:52 -0400
Date: Mon, 27 Apr 2009 22:29:25 +0200
From: "H. Langos" <henrik-dvb@prak.org>
To: Johannes Stezenbach <js@linuxtv.org>
Cc: linux-media@vger.kernel.org
Subject: Re: wiki on linixtv.org locked
Message-ID: <20090427202925.GO2895@www.viadmin.org>
References: <20090427164321.GN2895@www.viadmin.org> <20090427173741.GA20847@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090427173741.GA20847@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hi johannes,

thank you for your quick reply.

On Mon, Apr 27, 2009 at 07:37:41PM +0200, Johannes Stezenbach wrote:
> On Mon, Apr 27, 2009 at 06:43:21PM +0200, H. Langos wrote:
> > 
> > Yesterday a stupid kid vandalized a bunch of pages on the linuxtv wiki and 
> > a sysop locked to database to undo the damage. 
> ...
> The damage was done by a bot script and it affected as many pages
> as the edit rate limiter would allow it to do until I noticed it.
> If you search for "GRAWP'S MASSIVE" you'll see this is not
> limited to linuxtv.org.

ah, ok ..  so it is a stupid kid with scripting knowledge. :-)

> > Anyway .. Now, after about 24h the wiki is still locked.
> > Any reason for that?
> 
> It is locked until I had time to take measures to prevent
> similar damage from happening again right away. I'm
> open to suggestions if someone has experience with this.

first of all. please, replace "sigh..." with a more informative locking
message. 

the next step would be to update the mediwiki software to 1.11.1 if you have
$wgEnableAPI = true, that is. (i know it is only a XSS that hits internet 
explorer users ..  but hey, they are people, too ;-)

if i remember right, the linuxtv wiki only allows editing to registered 
users. therefore you could simply temporarily disable new user registration
and enable editing again for registered users.

then i'd suggest installing the reCAPTCHA extention. not only will it
prevent bots from registering, you also help to digitize old books.

http://recaptcha.net/plugins/mediawiki/

with that in place you can re-enable new user registration. you can even 
make logins optional and require captcha solving for anonymous edits. this
would probably improve the wiki in general as new users would not jump through 
yet another loop just in order to help other users... i know, new users can
cost more time than they are worth but hope springs eternaly :-)

cheers
-henrik


