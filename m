Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:26869 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753550AbcJFImS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Oct 2016 04:42:18 -0400
From: Jani Nikula <jani.nikula@intel.com>
To: Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 0/4] reST-directive kernel-cmd / include contentent from scripts
In-Reply-To: <1475738420-8747-1-git-send-email-markus.heiser@darmarit.de>
References: <1475738420-8747-1-git-send-email-markus.heiser@darmarit.de>
Date: Thu, 06 Oct 2016 11:42:14 +0300
Message-ID: <87oa2xrhqx.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 06 Oct 2016, Markus Heiser <markus.heiser@darmarit.de> wrote:
> with this series a reST-directive kernel-cmd is introduced. The kernel-cmd
> directive includes contend from the stdout of a command-line (@mchehab asked
> for).

I like the fact that this removes Documentation/media/Makefile, and
cleans up the Sphinx build rule in Documentation/Makefile.sphinx. Does
this also make the documentation buildable with sphinx-build directly,
without the kernel build system? If so, great.

However, I would have much preferred the approach I proposed months ago,
having the extension itself do specifically what parse-headers.pl does
now. While it may seem generic on the surface, I don't think it's a
clean or a secure approach to allow running of arbitrary scripts from
PATH while building documentation. It's certainly not an approach that
should be encouraged.

In part, the reason the DocBook build became so unwieldy was the
proliferation of arbitrary scripts and tools required to make it
happen. I think it would be really sad to let this happen to the Sphinx
build. I am *already* sad about how parse-headers.pl was bolted on to
the build.

BR,
Jani.


-- 
Jani Nikula, Intel Open Source Technology Center
