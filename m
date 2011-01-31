Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35547 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab1AaRVf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Jan 2011 12:21:35 -0500
Date: Mon, 31 Jan 2011 09:21:27 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] Input: switch completely over to the new versions of
 get/setkeycode
Message-ID: <20110131172127.GB31891@core.coreip.homeip.net>
References: <20110131085640.GB30343@core.coreip.homeip.net>
 <4D46AB6C.4050108@redhat.com>
 <alpine.LNX.2.00.1101311332270.5725@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1101311332270.5725@pobox.suse.cz>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Jan 31, 2011 at 01:32:43PM +0100, Jiri Kosina wrote:
> On Mon, 31 Jan 2011, Mauro Carvalho Chehab wrote:
> 
> > > Input: switch completely over to the new versions of get/setkeycode
> > > 
> > > All users of old style get/setkeycode methids have been converted so
> > > it is time to retire them.
> > > 
> > > Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> > > ---
> > > 
> > > Jiri, Mauro,
> > > 
> > > There is not a good way to avoid crossing multiple subsystems but the
> > > changes are minimal, so if you are OK with the patch I'd like to move it
> > > through my tree for .39.
> > 
> > Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> Acked-by: Jiri Kosina <jkosina@suse.cz>
> 

Thanks guys.

-- 
Dmitry
