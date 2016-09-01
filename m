Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:63572 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754206AbcIAOdM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Sep 2016 10:33:12 -0400
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Jonathan Corbet <corbet@lwn.net>,
        Markus Heiser <markus.heiser@darmarit.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] doc-rst:sphinx-extensions: add metadata parallel-safe
In-Reply-To: <20160901082136.597c37bf@lwn.net>
References: <1472045724-14559-1-git-send-email-markus.heiser@darmarit.de> <20160901082136.597c37bf@lwn.net>
Date: Thu, 01 Sep 2016 17:29:38 +0300
Message-ID: <87inufzoa5.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 01 Sep 2016, Jonathan Corbet <corbet@lwn.net> wrote:
> On Wed, 24 Aug 2016 15:35:24 +0200
> Markus Heiser <markus.heiser@darmarit.de> wrote:
>
>> With metadata "parallel_read_safe = True" a extension is marked as
>> save for "parallel reading of source". This is needed if you want
>> build in parallel with N processes. E.g.:
>> 
>>   make SPHINXOPTS=-j4 htmldocs
>
> A definite improvement; applied to the docs tree, thanks.

The Sphinx docs say -jN "should be considered experimental" [1]. Any
idea *how* experimental that is, really? Could we add some -j by
default?

BR,
Jani.


[1] http://www.sphinx-doc.org/en/stable/invocation.html#invocation-of-sphinx-build

-- 
Jani Nikula, Intel Open Source Technology Center
