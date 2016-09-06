Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48358 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933523AbcIFPz0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2016 11:55:26 -0400
Date: Tue, 6 Sep 2016 12:55:18 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Jani Nikula <jani.nikula@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/3] doc-rst:c-domain: fix sphinx version
 incompatibility
Message-ID: <20160906125518.05a9d9fd@vento.lan>
In-Reply-To: <3F2C3A86-D578-4978-AFFB-8B34DA758BE6@darmarit.de>
References: <1472657372-21039-1-git-send-email-markus.heiser@darmarit.de>
        <1472657372-21039-2-git-send-email-markus.heiser@darmarit.de>
        <20160906061909.36aa2986@lwn.net>
        <87k2epxiby.fsf@intel.com>
        <3F2C3A86-D578-4978-AFFB-8B34DA758BE6@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 6 Sep 2016 17:10:53 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> Am 06.09.2016 um 15:34 schrieb Jani Nikula <jani.nikula@intel.com>:
> 
> > On Tue, 06 Sep 2016, Jonathan Corbet <corbet@lwn.net> wrote:  
> >> On Wed, 31 Aug 2016 17:29:30 +0200
> >> Markus Heiser <markus.heiser@darmarit.de> wrote:
> >>   
> >>> +            if major >= 1 and minor < 4:
> >>> +                # indexnode's tuple changed in 1.4
> >>> +                # https://github.com/sphinx-doc/sphinx/commit/e6a5a3a92e938fcd75866b4227db9e0524d58f7c
> >>> +                self.indexnode['entries'].append(
> >>> +                    ('single', indextext, targetname, ''))
> >>> +            else:
> >>> +                self.indexnode['entries'].append(
> >>> +                    ('single', indextext, targetname, '', None))  
> >> 
> >> So this doesn't seem right.  We'll get the four-entry tuple behavior with
> >> 1.3 and the five-entry behavior with 1.4...but what happens when 2.0
> >> comes out?
> >> 
> >> Did you want maybe:
> >> 
> >> 	if major == 1 and minor < 4:
> >> 
> >> ?
> >> 
> >> (That will fail on 0.x, but we've already stated that we don't support
> >> below 1.2).  
> > 
> > Is there a way to check the number of entries expected in the tuples
> > instead of trying to match the version?  
> 
> Sadly not, the dissection of the tuple is spread around the source :(
> 
> Sphinx has some more of these tuples with fixed length (remember
> conf.py, the latex_documents settings) where IMHO hash/value pairs
> (dicts) are more suitable.

Well, the LaTeX stuff at conf.py seems to have a new field on version
1.4.x. At least, our config has:

# (source start file, name, description, authors, manual section).

but 1.4.x docs mentions another tuple: toctree_only.

Regards,
Mauro
