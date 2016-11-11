Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45657 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965305AbcKKJe7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Nov 2016 04:34:59 -0500
Date: Fri, 11 Nov 2016 07:34:47 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Markus Heiser <markus.heiser@darmarit.de>,
        Josh Triplett <josh@joshtriplett.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org,
        ksummit-discuss@lists.linuxfoundation.org,
        linux-doc@vger.kernel.org
Subject: Re: [Ksummit-discuss] Including images on Sphinx documents
Message-ID: <20161111073447.4dd590b0.m.chehab@samsung.com>
In-Reply-To: <87shr0g90r.fsf@intel.com>
References: <20161107075524.49d83697@vento.lan>
        <20161107170133.4jdeuqydthbbchaq@x>
        <A4091944-D727-45B5-AC24-FE3B2700298E@darmarit.de>
        <8737j0hpi0.fsf@intel.com>
        <DC27B5F7-D69E-4F22-B184-B7B029392959@darmarit.de>
        <87shr0g90r.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 09 Nov 2016 13:58:12 +0200
Jani Nikula <jani.nikula@linux.intel.com> escreveu:

> On Wed, 09 Nov 2016, Markus Heiser <markus.heiser@darmarit.de> wrote:
> > Am 09.11.2016 um 12:16 schrieb Jani Nikula <jani.nikula@linux.intel.com>:  
> >>> So I vote for :
> >>>   
> >>>> 1) copy (or symlink) all rst files to Documentation/output (or to the
> >>>> build dir specified via O= directive) and generate the *.pdf there,
> >>>> and produce those converted images via Makefile.;  
> >> 
> >> We're supposed to solve problems, not create new ones.  
> >
> > ... new ones? ...  
> 
> Handle in-tree builds without copying.
> 
> Make dependency analysis with source rst and "intermediate" rst work.
> 
> Make sure your copying gets the timestamps right.
> 
> Make Sphinx dependency analysis look at the right copies depending on
> in-tree vs. out-of-tree. Generally make sure it doesn't confuse Sphinx's
> own dependency analysis.

I agree with Jani here: copy the files will make Sphinx recompile
the entire documentation every time, with is bad. Ok, Some Makefile
logic could be added to copy only on changes, but that will increase
the Makefile complexity.

So, I prefer not using copy. As I said before, a Sphinx extension that
would make transparent for PDF document generation when a non-PDF image
is included, doing whatever conversion needed, seems to be the right fix 
here, but someone would need to step up and write such extension.

-- 

Cheers,
Mauro
