Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:54098 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754462AbcHSMtq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 08:49:46 -0400
From: Jani Nikula <jani.nikula@intel.com>
To: Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/7] doc-rst: generic way to build only sphinx sub-folders
In-Reply-To: <09880F76-6FE1-48E6-B76D-DFC4F47182D7@darmarit.de>
References: <1471097568-25990-1-git-send-email-markus.heiser@darmarit.de> <1471097568-25990-2-git-send-email-markus.heiser@darmarit.de> <20160818163514.43539c11@lwn.net> <09880F76-6FE1-48E6-B76D-DFC4F47182D7@darmarit.de>
Date: Fri, 19 Aug 2016 15:49:06 +0300
Message-ID: <8737m0udod.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 19 Aug 2016, Markus Heiser <markus.heiser@darmarit.de> wrote:
> Am 19.08.2016 um 00:35 schrieb Jonathan Corbet <corbet@lwn.net>:
> * the pdf goes to the "latex" folder .. since this is WIP
>   and there are different solutions conceivable ... I left
>   it open for the first.

Mea culpa. As I said, I intended my patches as RFC only.

>
> * in the index.html we miss some links to pdf-/man- etc files
>   
> The last point needs some discussion. Hopefully, this discussion
> starts right here.
>
>
>> I'm not sure that we actually need the format-specific subfolders, but we
>> should be consistent across all the formats and in the documentation and,
>> as of this patch, we're not.
>
> IMHO a structure where only non-HTML formats are placed in subfolders
> (described above) is the better choice.
>
> In the long run I like to get rid of all the intermediate formats
> (latex, .doctrees) and build a clear output-folder (with all formats
> in) which could be copied 1:1 to a static HTTP-server.

When I added the Documentation/output subfolder, my main intention was
to separate the source documents from everything that is generated,
intermediate or final. I suggest you keep the generated files somewhere
under output. This'll be handly also when ensuring O= works.

I set up the format specific subfolders, because I thought people would
want to keep them separated and independent. For me, all the formats
were equal and at the same level in that regard. You're suggesting to
make html the root of everything?


BR,
Jani.


-- 
Jani Nikula, Intel Open Source Technology Center
