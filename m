Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:42468 "EHLO smtp1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715AbcHEH3k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Aug 2016 03:29:40 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Functions and data structure cross references with Sphinx
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20160801082527.0eb7eace@recife.lan>
Date: Fri, 5 Aug 2016 09:29:23 +0200
Cc: Jani Nikula <jani.nikula@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-doc@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <91BDDA51-4A60-495F-9475-341950051EE9@darmarit.de>
References: <20160801082527.0eb7eace@recife.lan>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 01.08.2016 um 13:25 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:

> There's one remaining major issue I noticed after the conversion of the
> media books to Sphinx:
> 
> While sphinx complains if a cross-reference (using :ref:) points to an
> undefined reference, the same doesn't happen if the reference uses
> :c:func: and :c:type:.
> 
> In practice, it means that, if we do some typo there, or if we forget to
> add the function/struct prototype (or use the wrong domain, like :cpp:),
> Sphinx won't generate the proper cross-reference, nor warning the user.
> 
> That's specially bad for media, as, while we're using the c domain for
> the kAPI and driver-specific books, we need to use the cpp domain on the 
> uAPI book - as the c domain doesn't allow multiple declarations for
> syscalls, and we have multiple pages for read, write, open, close, 
> poll and ioctl.
> 
> It would be good to have a way to run Sphinx on some "pedantic"
> mode or have something similar to xmlint that would be complaining
> about invalid c/cpp domain references.
> 
> Thanks,
> Mauro

Hi Mauro,

there is a nit-picky mode [1], which could be activated by setting
"nitpicky=True" in the conf.py or alternative, set "-n" to the 
SPHINXOPTS:

  make SPHINXOPTS=-n htmldocs

Within nit-picky mode, Sphinx will warn about **all** references. This
might be more then you want. For this, in the conf.py you could
assemble a "nitpick_ignore" list [2]. But I think, assemble the
ignore list is quite a lot of work.

[1] http://www.sphinx-doc.org/en/stable/config.html#confval-nitpicky
[2] http://www.sphinx-doc.org/en/stable/config.html#confval-nitpick_ignore

-- Markus 