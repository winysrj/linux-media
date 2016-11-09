Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:57043 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753125AbcKIL6P (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Nov 2016 06:58:15 -0500
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org,
        ksummit-discuss@lists.linuxfoundation.org,
        linux-doc@vger.kernel.org
Subject: Re: [Ksummit-discuss] Including images on Sphinx documents
In-Reply-To: <DC27B5F7-D69E-4F22-B184-B7B029392959@darmarit.de>
References: <20161107075524.49d83697@vento.lan> <20161107170133.4jdeuqydthbbchaq@x> <A4091944-D727-45B5-AC24-FE3B2700298E@darmarit.de> <8737j0hpi0.fsf@intel.com> <DC27B5F7-D69E-4F22-B184-B7B029392959@darmarit.de>
Date: Wed, 09 Nov 2016 13:58:12 +0200
Message-ID: <87shr0g90r.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 09 Nov 2016, Markus Heiser <markus.heiser@darmarit.de> wrote:
> Am 09.11.2016 um 12:16 schrieb Jani Nikula <jani.nikula@linux.intel.com>:
>>> So I vote for :
>>> 
>>>> 1) copy (or symlink) all rst files to Documentation/output (or to the
>>>> build dir specified via O= directive) and generate the *.pdf there,
>>>> and produce those converted images via Makefile.;
>> 
>> We're supposed to solve problems, not create new ones.
>
> ... new ones? ...

Handle in-tree builds without copying.

Make dependency analysis with source rst and "intermediate" rst work.

Make sure your copying gets the timestamps right.

Make Sphinx dependency analysis look at the right copies depending on
in-tree vs. out-of-tree. Generally make sure it doesn't confuse Sphinx's
own dependency analysis.

The stuff I didn't think of.

Sure, it's all supposed to be basic Makefile stuff, but don't make the
mistake of thinking just one invocation of 'cp' will solve all the
problems. It all adds to the complexity we were trying to avoid when
dumping DocBook. It adds to the complexity of debugging stuff. (And hey,
there's still the one rebuilding-stuff-for-no-reason issue open.)

If you want to keep the documentation build sane, try to avoid the
Makefile preprocessing. And same old story, if you fix this for real,
even if as a Sphinx extension, *other* people than kernel developers
will be interested, and *we* don't have to do so much ourselves.


BR,
Jani.



>
>>> IMO placing 'sourcedir' to O= is more sane since this marries the
>>> Linux Makefile concept (relative to $PWD) with the sphinx concept
>>> (in or below 'sourcedir').
>
> -- Markus --

-- 
Jani Nikula, Intel Open Source Technology Center
