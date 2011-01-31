Return-path: <mchehab@pedra>
Received: from cantor2.suse.de ([195.135.220.15]:59415 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752968Ab1AaMco (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Jan 2011 07:32:44 -0500
Date: Mon, 31 Jan 2011 13:32:43 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Linux Input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] Input: switch completely over to the new versions of
 get/setkeycode
In-Reply-To: <4D46AB6C.4050108@redhat.com>
Message-ID: <alpine.LNX.2.00.1101311332270.5725@pobox.suse.cz>
References: <20110131085640.GB30343@core.coreip.homeip.net> <4D46AB6C.4050108@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 31 Jan 2011, Mauro Carvalho Chehab wrote:

> > Input: switch completely over to the new versions of get/setkeycode
> > 
> > All users of old style get/setkeycode methids have been converted so
> > it is time to retire them.
> > 
> > Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> > ---
> > 
> > Jiri, Mauro,
> > 
> > There is not a good way to avoid crossing multiple subsystems but the
> > changes are minimal, so if you are OK with the patch I'd like to move it
> > through my tree for .39.
> 
> Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Acked-by: Jiri Kosina <jkosina@suse.cz>

Thanks Dmitry.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
