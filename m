Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37288 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752737AbcITU6V (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Sep 2016 16:58:21 -0400
Date: Tue, 20 Sep 2016 17:58:11 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Markus Heiser <markus.heiser@darmarit.de>,
        Jani Nikula <jani.nikula@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "linux-doc@vger.kernel.org Mailing List" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] doc-rst:c-domain: fix some issues in the
 c-domain
Message-ID: <20160920175811.71f8b899@vento.lan>
In-Reply-To: <20160920130033.6bb8668d@lwn.net>
References: <1473232378-11869-1-git-send-email-markus.heiser@darmarit.de>
        <20160909090832.35c2d982@vento.lan>
        <73B0403A-272C-4058-A0D9-493C685EE332@darmarit.de>
        <1089B8C0-6296-4CC4-84B9-A1F62FA565AD@darmarit.de>
        <20160919120030.4e390e9a@vento.lan>
        <35B447A7-6C12-4560-8D06-110B8B33CB56@darmarit.de>
        <20160920130033.6bb8668d@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 20 Sep 2016 13:00:33 -0600
Jonathan Corbet <corbet@lwn.net> escreveu:

> On Tue, 20 Sep 2016 20:56:35 +0200
> Markus Heiser <markus.heiser@darmarit.de> wrote:
> 
> > > I submitted one patch fixing it. Not sure if it got merged by Jon
> > > or not.  
> > 
> > Ups, I might have overseen this patch .. as Jon said, its hard to
> > follow you ;)
> > 
> > I tested the above with Jon's docs-next, so it seems your patch is
> > not yet applied. Could you send me a link for this patch? (sorry,
> > I can't find it).
> 
> Send again, please?  I'll add it to the pile of other stuff, and try not
> to lose it again...:)

Gah, there are so many patches that I'm also confused whether I sent something
or just dreamed about sending it :)

I actually sent a patch doing this on a /47 patch series, but only
for macros:

	Subject: [PATCH 01/47] kernel-doc: ignore arguments on macro definitions

I was thinking on doing the same for functions, but didn't actually
submitted such patch.

Yet, it seems more coherent, IMHO, to use use same approach for both C
functions and macros: presenting just the name instead of printing the
arguments.

I'll work on it and submit, likely tomorrow.

Thanks,
Mauro
