Return-path: <mchehab@pedra>
Received: from mail-px0-f174.google.com ([209.85.212.174]:37097 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab1A1Qmy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jan 2011 11:42:54 -0500
Date: Fri, 28 Jan 2011 08:42:44 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils ?
Message-ID: <20110128164244.GB6252@core.coreip.homeip.net>
References: <20110125232914.GA20130@core.coreip.homeip.net>
 <20110126020003.GA23085@core.coreip.homeip.net>
 <4D403855.4050706@teksavvy.com>
 <4D40C3D7.90608@teksavvy.com>
 <4D40C551.4020907@teksavvy.com>
 <20110127021227.GA29709@core.coreip.homeip.net>
 <4D40E41D.2030003@teksavvy.com>
 <20110127163931.GA1825@core.coreip.homeip.net>
 <4D41B5A0.70704@teksavvy.com>
 <20110127195325.GB29910@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110127195325.GB29910@core.coreip.homeip.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Jan 27, 2011 at 11:53:25AM -0800, Dmitry Torokhov wrote:
> On Thu, Jan 27, 2011 at 01:12:48PM -0500, Mark Lord wrote:
> > On 11-01-27 11:39 AM, Dmitry Torokhov wrote:
> > > On Wed, Jan 26, 2011 at 10:18:53PM -0500, Mark Lord wrote:
> > >> No, it does not seem to segfault when I unload/reload ir-kbd-i2c
> > >> and then invoke it by hand with the same parameters.
> > >> Quite possibly the environment is different when udev invokes it,
> > >> and my strace attempt with udev killed the system, so no info there.
> > >>
> > > 
> > > Hmm, what about compiling with debug and getting a core then?
> > 
> > Sure.  debug is easy, -g, but you'll have to tell me how to get it
> > do produce a core dump.
> > 
> 
> See if adjusting /etc/security/limits.conf will enable it to dump core.
> Otherwise you'll have to stick 'ulimit -c unlimited' somewhere...
> 

Mark,

Any luck with getting the core? I'd really like to resolve this issue.

Thanks.

-- 
Dmitry
