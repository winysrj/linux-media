Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:52767
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933205AbdCaSM2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Mar 2017 14:12:28 -0400
Date: Fri, 31 Mar 2017 15:12:20 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jani Nikula <jani.nikula@intel.com>,
        Takashi Iwai <tiwai@suse.de>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Silvio Fricke <silvio.fricke@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH 5/9] kernel-api.tmpl: convert it to ReST
Message-ID: <20170331151220.78cfff0d@vento.lan>
In-Reply-To: <20170331090537.567730e8@lwn.net>
References: <cover.1490904090.git.mchehab@s-opensource.com>
        <0186e4eb40e09f92a7ec59f195d93af38176433f.1490904090.git.mchehab@s-opensource.com>
        <20170331090537.567730e8@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 31 Mar 2017 09:05:37 -0600
Jonathan Corbet <corbet@lwn.net> escreveu:

> On Thu, 30 Mar 2017 17:11:32 -0300
> Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
> 
> > Brainless conversion of genericirq.tmpl book to ReST, via
> > 	Documentation/sphinx/tmplcvt  
> 
> This one kind of showcases why I'm nervous about bulk conversions.  It's
> a bit of a dumping-ground document, with a bit of everything, and I think
> we can do better.  And, in particular, this one contains a bunch of stuff
> that belongs in the driver-api manual instead.  So, at a minimum, I would
> really like to see this template split across those two manuals.

Yeah, I was in doubt if it should be either at driver-api or core-api
manuals.

> If you promise me a followup patch doing that, maybe I can go ahead and
> merge this series now :)

Surely I can do a patch moving things around.

> (That's mildly complicated by the fact that you didn't send me parts 6,
> 8, and 9; I really would rather get the whole series in cases like this.)

Sorry. Just forwarded those missing parts to your e-mail.

They basically fix some kernel-doc headers that are not properly
parsed by Sphinx.

Thanks,
Mauro
