Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:3305 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbcCII5N (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Mar 2016 03:57:13 -0500
From: Jani Nikula <jani.nikula@intel.com>
To: Dan Allen <dan@opendevise.io>
Cc: Russel Winder <russel@winder.org.uk>,
	Keith Packard <keithp@keithp.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jonathan Corbet <corbet@lwn.net>,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Graham Whaley <graham.whaley@linux.intel.com>
Subject: Re: Kernel docs: muddying the waters a bit
In-Reply-To: <CAKeHnO7e5Escm0Ndm50eFX-qUXf7Lg9n=iXvwUGjz2M4KHLMsQ@mail.gmail.com>
References: <20160213145317.247c63c7@lwn.net> <87y49zr74t.fsf@intel.com> <20160303071305.247e30b1@lwn.net> <20160303155037.705f33dd@recife.lan> <86egbrm9hw.fsf@hiro.keithp.com> <1457076530.13171.13.camel@winder.org.uk> <CAKeHnO6sSV1x2xh_HgbD5ddZ8rp+SVvbdjVhczhudc9iv_-UCQ@mail.gmail.com> <87a8m9qoy8.fsf@intel.com> <CAKeHnO7_7k8Qc5Jmu_x2OzAVT4YXxW8PSe_m6QUP-8V7XxbTVw@mail.gmail.com> <8737s1qdfz.fsf@intel.com> <CAKeHnO7e5Escm0Ndm50eFX-qUXf7Lg9n=iXvwUGjz2M4KHLMsQ@mail.gmail.com>
Date: Wed, 09 Mar 2016 10:57:08 +0200
Message-ID: <87si00owpn.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 09 Mar 2016, Dan Allen <dan@opendevise.io> wrote:
> On Tue, Mar 8, 2016 at 6:58 AM, Jani Nikula <jani.nikula@intel.com> wrote:
>
>> I need to look into this again. Is there a specific option or directive
>> to produce split output for includes? When I tried this, the result was
>> just one big output file. (And indeed we'd need both. Some includes we
>> want embedded, some includes should produce separate outputs.)
>>
>
> Nope. What I'm saying is that you run Asciidoctor on each sub-master
> include file (an include that manages a part or chapter). That gives you
> your individual part/chapter files. Then you need to make an index page,
> probably by using the Asciidoctor API to itemize all the chapters as a list
> or something.

Bummer.

Getting the inter-document cross references right may become
tricky. We'll be generating plenty of snippets of lightweight markup
from source code documentation comments. At the time of processing, we
won't know where e.g. a specific function to be cross referenced is
documented, if at all. We can't require the documentation comment
writers to figure that out either; it's too burdensome, too ugly in the
code, and they'll bitrot quickly.

Cross referencing in the asciidoc proofs of concept have worked because
they've all done the processing as a single single unit, with
includes. These hacks have also ignored any broken links, and there have
been

> Yes, it does require some thinking about cross references. There is a lot
> more we can do out of the box, but all those references can be fixed with a
> little bit of post-processing in the meantime.

It seems to me Sphinx provides much better support regarding cross
references, out of the box, within documents and to external documents
(intersphinx), with target roles and domains, including validation and
not creating broken links in the output.

Looking at the current hacks we have for post-processing references, I'm
really not thrilled about the prospect of keeping or redoing that.

See how this works in Jon's Sphinx test [1]. At the time of generating
the markup from source comments, there is no idea if and where
gem_init_hw() and intel_guc_ucode_init() are documented. Indeed,
documentation for the former does not exist, but there's no broken link.

BR,
Jani.


[1] http://static.lwn.net/kerneldoc/gpu.html#c.intel_guc_ucode_load


-- 
Jani Nikula, Intel Open Source Technology Center
