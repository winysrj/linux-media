Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:42605 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932638AbcHNSJW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2016 14:09:22 -0400
Date: Sun, 14 Aug 2016 12:09:20 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jani Nikula <jani.nikula@intel.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH 0/7] doc-rst: sphinx sub-folders & parseheaders
 directive
Message-ID: <20160814120920.62098dae@lwn.net>
In-Reply-To: <1471097568-25990-1-git-send-email-markus.heiser@darmarit.de>
References: <1471097568-25990-1-git-send-email-markus.heiser@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 13 Aug 2016 16:12:41 +0200
Markus Heiser <markus.heiser@darmarit.de> wrote:

> this series is a consolidation on Jon's docs-next branch. It merges the "sphinx
> sub-folders" patch [1] and the "parseheaders directive" patch [2] on top of
> Jon's docs-next.
> 
> In sense of consolidation, it also includes:
> 
> *  doc-rst: add media/conf_nitpick.py
> 
>    Adds media/conf_nitpick.py from mchehab/docs-next [3].
> 
> *  doc-rst: migrated media build to parseheaders directive

OK, I have applied the first five of these, but stopped at parse-header.
At this point, I have a few requests.  These are in approximate order of
decreasing importance, but they're all important, I think.

- The new directive could really use some ... documentation.  Preferably in
  kernel-documentation.rst with the rest.  What is parse-header, how does
  it differ from kernel-doc, why might a kernel developer doing
  documentation want (or not want) to use it?  That's all pretty obscure
  now.  If we want others to jump onto this little bandwagon of ours, we
  need to make sure it's all really clear.

- Along those lines, is parse-header the right name for this thing?
  "Parsing" isn't necessarily the goal of somebody who uses this directive,
  right?  They want to extract documentation information.  Can we come up
  with a better name?

- Can we please try to get the coding style a bit more in line with both
  kernel and Python community norms?  I suspect some people will get grumpy
  if they see this code.  In particular:

    - Please try to stick to the 80-column limit when possible.  Python
      makes that a bit harder than C does, and please don't put in
      ridiculous line breaks that make the code worse.  But sticking a bit
      closer to the rule would be good.

    - The "#========================" lines around function/class
      definition lines or other comments are not helpful, please avoid
      them.  Instead, placing a real comment with actual informative text
      above the function/class would be a good thing.  (I could live with
      Python docstrings if you prefer, though I will confess I prefer
      ordinary comments).

    - No commas at the beginning of continuation lines, please; that would
      get you yelled at in C code.  If you need to break a function call
      (or whatever), please put the commas at the end of the line as is
      done elsewhere.

  Sorry to poke at nits here, but we want others in the kernel community to
  be able to look at this code, and that will be easier if we stick closer
  to the usual rules.

Thanks,

jon
