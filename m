Return-path: <linux-media-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:32968 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755906Ab0ASLUc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2010 06:20:32 -0500
Date: Tue, 19 Jan 2010 12:20:57 +0100
From: Johannes Stezenbach <js@linuxtv.org>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: [ANNOUNCE] git tree repositories
Message-ID: <20100119112057.GC9187@linuxtv.org>
References: <4B55445A.10300@infradead.org>
 <201001190853.11050.hverkuil@xs4all.nl>
 <201001190910.39479.pboettcher@kernellabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001190910.39479.pboettcher@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 19, 2010 at 09:10:39AM +0100, Patrick Boettcher wrote:
> 
> BTW: I just made a clone of the git-tree - 365MB *ouff*. Maybe it's worth to 
> mention right now, that one big difference to HG in the way we have used it, is 
> that one developer now can do all the work only with one clone of v4l-dvb and 
> using branches for each development.

Please note that you SHOULD NOT clone from linuxtv.org.
Please follow the description on the top of
http://linuxtv.org/git/

Most linux developers will have a clone of Linus' tree already,
and you can add as many "remotes" to that tree as you like.
It's much faster and more flexible that way.  If you once pulled
a clone of Linus' tree there is simply no need to ever clone
any other Linux tree ever again.

Oh, and if you manage to get your git tree in a state where
you don't know how to fix the mess, don't throw it away.
Go to the git mailing list and ask for advice. They love
customer feeedback. Helps them to improve their product
and make it more user friendly ;-)


Johannes
