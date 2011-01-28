Return-path: <mchehab@pedra>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:65521 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab1A1VKK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jan 2011 16:10:10 -0500
Date: Fri, 28 Jan 2011 13:09:58 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils ?
Message-ID: <20110128210958.GJ6252@core.coreip.homeip.net>
References: <4D40C3D7.90608@teksavvy.com>
 <4D40C551.4020907@teksavvy.com>
 <20110127021227.GA29709@core.coreip.homeip.net>
 <4D40E41D.2030003@teksavvy.com>
 <20110127163931.GA1825@core.coreip.homeip.net>
 <4D41B5A0.70704@teksavvy.com>
 <20110127195325.GB29910@core.coreip.homeip.net>
 <20110128164244.GB6252@core.coreip.homeip.net>
 <4D432D47.2000600@teksavvy.com>
 <4D432F0B.70808@teksavvy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D432F0B.70808@teksavvy.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Jan 28, 2011 at 04:03:07PM -0500, Mark Lord wrote:
> On 11-01-28 03:55 PM, Mark Lord wrote:
> > On 11-01-28 11:42 AM, Dmitry Torokhov wrote:
> >> On Thu, Jan 27, 2011 at 11:53:25AM -0800, Dmitry Torokhov wrote:
> >>> On Thu, Jan 27, 2011 at 01:12:48PM -0500, Mark Lord wrote:
> >>>> On 11-01-27 11:39 AM, Dmitry Torokhov wrote:
> > ..
> >>>>> Hmm, what about compiling with debug and getting a core then?
> >>>>
> >>>> Sure.  debug is easy, -g, but you'll have to tell me how to get it
> >>>> do produce a core dump.
> >>>>
> >>>
> >>> See if adjusting /etc/security/limits.conf will enable it to dump core.
> >>> Otherwise you'll have to stick 'ulimit -c unlimited' somewhere...
> > ..
> >> Any luck with getting the core? I'd really like to resolve this issue.
> > ..
> > 
> > I'm upgrading the box to new userspace now.
> > But I still have the old installation drive,
> > so perhaps I'll go there now and try this.
> > 
> > My plan is to replace /usr/bin/ir-keytable with a script
> > that issues the 'ulimit -c unlimited' command and then
> > invokes the original /usr/bin/ir-keytable binary.
> > 
> > Should take half an hour or so before I get back here again.
> 
> No-go.  According to the syslog, the segfault has not happened
> since I reconfigured the kernel and startup sequence two days
> ago to resolve an XFS mount issue.
> 
> Something in there changed the init timing just enough to make
> it go away, I believe.

OK, this reinforces my suspicion that the cause of segfault is the race
we were discussing with Mauro, not the keymap retrieval fix.

I shall be sending the patch to Linus/stable in the next pull then.

Thank you for your help.

-- 
Dmitry
