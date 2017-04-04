Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:34787
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753852AbdDDMet (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Apr 2017 08:34:49 -0400
Date: Tue, 4 Apr 2017 09:34:25 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Noam Camus <noamca@mellanox.com>,
        James Morris <james.l.morris@oracle.com>,
        zijun_hu <zijun_hu@htc.com>,
        Markus Heiser <markus.heiser@darmarit.de>,
        linux-clk@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Nicholas Piggin <npiggin@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-block@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Ingo Molnar <mingo@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Michal Hocko <mhocko@suse.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>, linux-mm@kvack.org,
        linux-security-module@vger.kernel.org,
        Silvio Fricke <silvio.fricke@gmail.com>,
        Takashi Iwai <tiwai@suse.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jan Kara <jack@suse.cz>, Vlastimil Babka <vbabka@suse.cz>,
        linux-pci@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Andy Lutomirski <luto@kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Hillf Danton <hillf.zj@alibaba-inc.com>
Subject: Re: [PATCH 0/9] convert genericirq.tmpl and kernel-api.tmpl to
 DocBook
Message-ID: <20170404093425.54da2050@vento.lan>
In-Reply-To: <20170402143418.3de75239@lwn.net>
References: <cover.1490904090.git.mchehab@s-opensource.com>
        <20170402143418.3de75239@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 2 Apr 2017 14:34:18 -0600
Jonathan Corbet <corbet@lwn.net> escreveu:

> On Thu, 30 Mar 2017 17:11:27 -0300
> Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
> 
> > This series converts just two documents, adding them to the
> > core-api.rst book. It addresses the errors/warnings that popup
> > after the conversion.
> > 
> > I had to add two fixes to scripts/kernel-doc, in order to solve
> > some of the issues.  
> 
> I've applied the set, including the add-on to move some stuff to
> driver-api - thanks.

Thanks!

> For whatever reason, I had a hard time applying a few of these; "git am"
> would tell me this:
> 
> > Applying: docs-rst: core_api: move driver-specific stuff to drivers_api
> > fatal: sha1 information is lacking or useless (Documentation/driver-api/index.rst).
> > Patch failed at 0001 docs-rst: core_api: move driver-specific stuff to drivers_api
> > The copy of the patch that failed is found in: .git/rebase-apply/patch  
> 
> I was able to get around this, but it took some hand work.  How are you
> generating these?

That's weird. I'm using this to generate the patches:

	git format-patch -o $tmp_dir --stat --summary --patience --signoff --thread=shallow

plus some scripting that runs scripts/get_maintainers.

After that, I run:

	git send-email $tmp_dir

Then, exim sends the patches to a smart SMTP server (currently,
infradead.org, but I'm switching to s-opensource.org, as I'm getting
some troubles because the IP doesn't match the From: line).

Thanks,
Mauro
