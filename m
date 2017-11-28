Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:58683 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932075AbdK1SgI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Nov 2017 13:36:08 -0500
Date: Tue, 28 Nov 2017 16:35:54 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Soeren Moch <smoch@web.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andreas Regel <andreas.regel@gmx.de>,
        Manu Abraham <manu@linuxtv.org>,
        Oliver Endriss <o.endriss@gmx.de>, linux-media@vger.kernel.org,
        Eugene Syromiatnikov <esyr@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [GIT PULL] SAA716x DVB driver
Message-ID: <20171128163554.449dcb72@vento.lan>
In-Reply-To: <fab215f8-29f3-1857-6f33-c45e78bb5e3c@web.de>
References: <50e5ba3c-4e32-f2e4-7844-150eefdf71b5@web.de>
        <d693cf1b-de3d-5994-5ef0-eeb0e37065a3@web.de>
        <20170827073040.6e96d79a@vento.lan>
        <e9d87f55-18fc-e57b-f9aa-a41c7f983b34@web.de>
        <20170909181123.392cfbb0@vento.lan>
        <a44b8eb0-cdd5-aa28-ad30-68db0126b6f6@web.de>
        <20170916125042.78c4abad@recife.lan>
        <fab215f8-29f3-1857-6f33-c45e78bb5e3c@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 25 Sep 2017 00:17:00 +0200
Soeren Moch <smoch@web.de> escreveu:

> >  What I'm saying is that,
> > if we're adding it on staging, we need to have a plan to reimplement
> > it to whatever API replaces the DVB video API, as this API likely
> > won't stay upstream much longer.  
> AFAIK it is not usual linux policy to remove existing drivers
> with happy users and even someone who volunteered to
> maintain this.

The usual Linux policy doesn't apply to staging. The goal of staging is
to add drivers that have problems, but are fixable, and whose someone
is working to solve those issues. 

The staging policies include adding a TODO file describing the problems
that should be solved for the driver to be promoted. If such problems
aren't solved, the driver can be removed.

For example, this year, we removed some lirc staging drivers because
no developers were interested (and/or had the hardware) to convert
them to use the RC core (with is a Kernel's internal API).

In the case of saa716x, the issue is that it uses a deprecated
and undocumented userspace API, with is a way more serious issue.

I'm ok to add this driver to staging if we can agree on what
should be fixed, and if someone commits to try fixing it, knowing,
in advance, that, if it doesn't get fixed on a reasonable time, it
can be removed on later Kernel versions.

Thanks,
Mauro
