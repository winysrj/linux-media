Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:39134 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1034029AbcJ0OwU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Oct 2016 10:52:20 -0400
From: Jani Nikula <jani.nikula@intel.com>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: Re: Documentation/media/uapi/cec/ sporadically unnecessarily rebuilding
In-Reply-To: <F520076A-A05A-42B3-B416-288E67833AA9@darmarit.de>
References: <871sz6p17k.fsf@intel.com> <F520076A-A05A-42B3-B416-288E67833AA9@darmarit.de>
Date: Thu, 27 Oct 2016 17:52:01 +0300
Message-ID: <87lgx9lu9a.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 27 Oct 2016, Markus Heiser <markus.heiser@darmarit.de> wrote:
> Hi Jani,
>
> Am 24.10.2016 um 11:04 schrieb Jani Nikula <jani.nikula@intel.com>:
>
>> I think I saw some of this in the past [1], but then couldn't reproduce
>> it after all. Now I'm seeing it again. Sporadically
>> Documentation/media/uapi/cec/ gets rebuilt on successive runs of make
>> htmldocs, even when nothing has changed.
>> 
>> Output of 'make SPHINXOPTS="-v -v" htmldocs' attached for both cases.
>> 
>> Using Sphinx (sphinx-build) 1.4.6
>
> I can't see what's  wrong with your "rebuild" file ...
>
> <build-cec-rebuilding.txt --------->
> loading pickled environment... done
> building [mo]: targets for 0 po files that are out of date
> building [html]: targets for 0 source files that are out of date
> updating environment: 0 added, 0 changed, 0 removed
> looking for now-outdated files... none found
> no targets are out of date.
> build succeeded.
>   HTML    Documentation/DocBook/index.html
> <build-cec-rebuilding.txt --------->

Awesome, I screwed up the file names, please check again with
build-cec-rebuilding.txt <-> build-ok.txt...

BR,
Jani.

>
> Sphinx loads the cached (pickled) environment and says, that no
> target was outdated. The build succeeded without any rebuild.
> IMO it is sane build ... or do I misunderstood you?
>
> -- Markus --
>

-- 
Jani Nikula, Intel Open Source Technology Center
