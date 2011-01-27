Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55477 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab1A0Txf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jan 2011 14:53:35 -0500
Date: Thu, 27 Jan 2011 11:53:25 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils ?
Message-ID: <20110127195325.GB29910@core.coreip.homeip.net>
References: <4D3F4D11.9040302@teksavvy.com>
 <20110125232914.GA20130@core.coreip.homeip.net>
 <20110126020003.GA23085@core.coreip.homeip.net>
 <4D403855.4050706@teksavvy.com>
 <4D40C3D7.90608@teksavvy.com>
 <4D40C551.4020907@teksavvy.com>
 <20110127021227.GA29709@core.coreip.homeip.net>
 <4D40E41D.2030003@teksavvy.com>
 <20110127163931.GA1825@core.coreip.homeip.net>
 <4D41B5A0.70704@teksavvy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D41B5A0.70704@teksavvy.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Jan 27, 2011 at 01:12:48PM -0500, Mark Lord wrote:
> On 11-01-27 11:39 AM, Dmitry Torokhov wrote:
> > On Wed, Jan 26, 2011 at 10:18:53PM -0500, Mark Lord wrote:
> >> No, it does not seem to segfault when I unload/reload ir-kbd-i2c
> >> and then invoke it by hand with the same parameters.
> >> Quite possibly the environment is different when udev invokes it,
> >> and my strace attempt with udev killed the system, so no info there.
> >>
> > 
> > Hmm, what about compiling with debug and getting a core then?
> 
> Sure.  debug is easy, -g, but you'll have to tell me how to get it
> do produce a core dump.
> 

See if adjusting /etc/security/limits.conf will enable it to dump core.
Otherwise you'll have to stick 'ulimit -c unlimited' somewhere...

-- 
Dmitry
