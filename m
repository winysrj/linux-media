Return-path: <mchehab@pedra>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56957 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab1AZWHt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jan 2011 17:07:49 -0500
Date: Wed, 26 Jan 2011 14:07:41 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils ?
Message-ID: <20110126220741.GB29484@core.coreip.homeip.net>
References: <20110125232914.GA20130@core.coreip.homeip.net>
 <20110126020003.GA23085@core.coreip.homeip.net>
 <4D403855.4050706@teksavvy.com>
 <4D405A9D.4070607@redhat.com>
 <4D4076FD.6070207@teksavvy.com>
 <20110126194127.GE29268@core.coreip.homeip.net>
 <4D407A46.4080407@teksavvy.com>
 <20110126195011.GF29268@core.coreip.homeip.net>
 <4D4094F3.3020607@teksavvy.com>
 <4D4096DA.804@teksavvy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D4096DA.804@teksavvy.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Jan 26, 2011 at 04:49:14PM -0500, Mark Lord wrote:
> Or perhaps get rid of that unworkable "version number" thing
> (just freeze it in time with the 2.6.35 value returned),
> and implement a "get_feature_flags" ioctl or something for going forward.
> Then you can just turn on new bits in the flags as new features are added.
>

That could be done but I do not expect retire features so far so version
is about the same. Plus, what guarantees that someone in the future
won't write a utility that compares exact capability bitmap and refuse
to work when new ones will be added?

-- 
Dmitry
