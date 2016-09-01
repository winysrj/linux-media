Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.goneo.de ([85.220.129.33]:45652 "EHLO smtp2.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933171AbcIAQiu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Sep 2016 12:38:50 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH] doc-rst:sphinx-extensions: add metadata parallel-safe
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <99F693FF-B49B-43DE-9D03-632121FCAE0A@darmarit.de>
Date: Thu, 1 Sep 2016 18:38:36 +0200
Cc: Jonathan Corbet <corbet@lwn.net>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <8F59F755-FCF7-47A6-81E3-8FD584436E82@darmarit.de>
References: <1472045724-14559-1-git-send-email-markus.heiser@darmarit.de> <20160901082136.597c37bf@lwn.net> <87inufzoa5.fsf@intel.com> <99F693FF-B49B-43DE-9D03-632121FCAE0A@darmarit.de>
To: Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 01.09.2016 um 18:22 schrieb Markus Heiser <markus.heiser@darmarit.de>:

> 
> Am 01.09.2016 um 16:29 schrieb Jani Nikula <jani.nikula@linux.intel.com>:
> 
>> On Thu, 01 Sep 2016, Jonathan Corbet <corbet@lwn.net> wrote:
>>> On Wed, 24 Aug 2016 15:35:24 +0200
>>> Markus Heiser <markus.heiser@darmarit.de> wrote:
>>> 
>>>> With metadata "parallel_read_safe = True" a extension is marked as
>>>> save for "parallel reading of source". This is needed if you want
>>>> build in parallel with N processes. E.g.:
>>>> 
>>>> make SPHINXOPTS=-j4 htmldocs
>>> 
>>> A definite improvement; applied to the docs tree, thanks.
>> 
>> The Sphinx docs say -jN "should be considered experimental" [1]. Any
>> idea *how* experimental that is, really? Could we add some -j by
>> default?
> 
> My experience is, that parallel build is only strong on "reading
> input" and weak on "writing output". I can't see any rich performance
> increase on more than -j2 ... 
> 
> Mauro posted [2] his experience with -j8 compared to serial. He
> also compares -j8 to -j16:
> 
>> PS: on my server with 16 dual-thread Xeon CPU, the gain with a
>> bigger value for -j was not impressive. Got about the same time as
>> with -j8 or -j32 there.
> 
> I guess he will get nearly the same results with -j2 ;)
> 
> If we want to add a -j default, I suggest -j2. 
> 
> [2] https://www.mail-archive.com/linux-doc%40vger.kernel.org/msg05552.html
> 
> -- Markus --
> 

Sorry, forget to mentioning, that there has been some improvements
to parallel build in Sphinx 1.3 compared to 1.2. But in 1.3.2 they
have also fixed a bug which lets parallel builds hang :-o

https://github.com/sphinx-doc/sphinx/blob/master/CHANGES#L665

This in mind and if we really support down to sphinx 1.2 ... we
should not use any -j default.

IMHO we should get rid of this sphinx 1.2. downward compatibility,
it makes so may problems (e.g. see [3]) ... but we have discussed
this already and I don't want to restart this thread ;-) 

[3] https://www.mail-archive.com/linux-doc%40vger.kernel.org/msg05695.html

-- Markus --



> 
>> BR,
>> Jani.
>> 
>> 
>> [1] http://www.sphinx-doc.org/en/stable/invocation.html#invocation-of-sphinx-build
>> 
>> -- 
>> Jani Nikula, Intel Open Source Technology Center
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-doc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

