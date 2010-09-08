Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:5514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568Ab0IHOKd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Sep 2010 10:10:33 -0400
Date: Wed, 8 Sep 2010 10:10:24 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/5] rc-code: merge and rename ir-core
Message-ID: <20100908141024.GA22323@redhat.com>
References: <20100907214943.30935.29895.stgit@localhost.localdomain>
 <20100907215143.30935.71857.stgit@localhost.localdomain>
 <4C8792B2.2010809@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C8792B2.2010809@infradead.org>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Wed, Sep 08, 2010 at 10:42:10AM -0300, Mauro Carvalho Chehab wrote:
> Em 07-09-2010 18:51, David Härdeman escreveu:
> > This patch merges the files which makes up ir-core and renames the
> > resulting module to rc-core. IMHO this makes it much easier to hack
> > on the core module since all code is in one file.
> > 
> > This also allows some simplification of ir-core-priv.h as fewer internal
> > functions need to be exposed.
> 
> I'm not sure about this patch. Big files tend to be harder to maintain,
> as it takes more time to find the right functions inside it. Also, IMO, 
> it makes sense to keep the raw-event code on a separate file.

There's definitely a balance to be struck between file size and file
count. Having all the relevant code in one file definitely has its
advantage in that its easier to jump around from function to function and
trace code paths taken, but I can see the argument for isolating the raw
event handling code a bit too, especially if its going to be further
expanded, which I believe is likely the case. So I guess I'm on the
fence here. :)

> Anyway, if we apply this patch right now, it will cause merge conflicts with
> the input tree, due to the get/setkeycodebig patches, and with some other
> patches that are pending merge/review. The better is to apply such patch
> just after the release of 2.6.37-rc1, after having all those conflicts
> solved.

The imon patch that moves mouse/panel/knob input to its own input device
should be possible to take in advance of everything else, more or less,
though I need to finish actually testing it out (and should probably make
some further imon fixes for issues listed in a kernel.org bugzilla, the
number of which escapes me at the moment).

-- 
Jarod Wilson
jarod@redhat.com

