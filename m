Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3.goneo.de ([85.220.129.37]:41654 "EHLO smtp3.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751032AbcJ0OtF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Oct 2016 10:49:05 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Documentation/media/uapi/cec/ sporadically unnecessarily rebuilding
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <871sz6p17k.fsf@intel.com>
Date: Thu, 27 Oct 2016 16:48:23 +0200
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <F520076A-A05A-42B3-B416-288E67833AA9@darmarit.de>
References: <871sz6p17k.fsf@intel.com>
To: Jani Nikula <jani.nikula@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jani,

Am 24.10.2016 um 11:04 schrieb Jani Nikula <jani.nikula@intel.com>:

> I think I saw some of this in the past [1], but then couldn't reproduce
> it after all. Now I'm seeing it again. Sporadically
> Documentation/media/uapi/cec/ gets rebuilt on successive runs of make
> htmldocs, even when nothing has changed.
> 
> Output of 'make SPHINXOPTS="-v -v" htmldocs' attached for both cases.
> 
> Using Sphinx (sphinx-build) 1.4.6

I can't see what's  wrong with your "rebuild" file ...

<build-cec-rebuilding.txt --------->
loading pickled environment... done
building [mo]: targets for 0 po files that are out of date
building [html]: targets for 0 source files that are out of date
updating environment: 0 added, 0 changed, 0 removed
looking for now-outdated files... none found
no targets are out of date.
build succeeded.
  HTML    Documentation/DocBook/index.html
<build-cec-rebuilding.txt --------->

Sphinx loads the cached (pickled) environment and says, that no
target was outdated. The build succeeded without any rebuild.
IMO it is sane build ... or do I misunderstood you?

-- Markus --

