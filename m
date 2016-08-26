Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37062 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753168AbcHZLeh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Aug 2016 07:34:37 -0400
Date: Fri, 26 Aug 2016 08:34:27 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Jonathan Corbet <corbet@lwn.net>,
        Jani Nikula <jani.nikula@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/3] doc-rst: generic way to build PDF of sub-folder
Message-ID: <20160826083427.10a58f25@vento.lan>
In-Reply-To: <1472052976-22541-1-git-send-email-markus.heiser@darmarit.de>
References: <1472052976-22541-1-git-send-email-markus.heiser@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Markus,

Em Wed, 24 Aug 2016 17:36:13 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> From: Markus Heiser <markus.heiser@darmarIT.de>
> 
> Hi Mauro,
> 
> here is a small patch series which extends the method to build only sub-folders
> to the targets "latexdocs" and "pdfdocs".
> 
> If you think, that the two first patches works for you, path them with your next
> merge to Jon's doc-next.
> 
> The last patch in this series is just for you. It is a small example to
> illustrate how we can build small books and link them with intersphinx.

Didn't actually review the patches (I'm about to take a short trip).
Just tested the results of those 3 patches. 

It worked. However, I saw two issues there:

1) Now, the documentation, when using SPHINXDIRS=media is not output
at the Documentation/output/latex anymore, but, instead it created a
Documentation/output/media/latex and wrote the books there.

2) If built without SPHINXDIRS, it is producing just one document and
storing it at Documentation/output. I would expect it to do the same
on both cases.

Btw, I'm planning to split the media documentation on 4 books even when
building without SPHINXDIRS. There are two reasons for that:

1) the uAPI book has a different licence than the other books;

2) the uAPI book should be split into 5 parts, and each part should
reset the chapter numberation to 1, in order to produce the same
chapter numbering as the HTML book.

>From what I saw, the control if LaTeX will use parts/chapter/section
or just chapter section is controlled per conf.py file. It means that
we'll need to have a separate conf.py for the uAPI book - or to have
an Sphinx extension that would allow adjusting the LaTeX layout via
some meta-tags at the book's index.rst.

Regards,
Mauro
