Return-path: <linux-media-owner@vger.kernel.org>
Received: from ms.lwn.net ([45.79.88.28]:49780 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751663AbdDBUeV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 2 Apr 2017 16:34:21 -0400
Date: Sun, 2 Apr 2017 14:34:18 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
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
Message-ID: <20170402143418.3de75239@lwn.net>
In-Reply-To: <cover.1490904090.git.mchehab@s-opensource.com>
References: <cover.1490904090.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 30 Mar 2017 17:11:27 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:

> This series converts just two documents, adding them to the
> core-api.rst book. It addresses the errors/warnings that popup
> after the conversion.
> 
> I had to add two fixes to scripts/kernel-doc, in order to solve
> some of the issues.

I've applied the set, including the add-on to move some stuff to
driver-api - thanks.

For whatever reason, I had a hard time applying a few of these; "git am"
would tell me this:

> Applying: docs-rst: core_api: move driver-specific stuff to drivers_api
> fatal: sha1 information is lacking or useless (Documentation/driver-api/index.rst).
> Patch failed at 0001 docs-rst: core_api: move driver-specific stuff to drivers_api
> The copy of the patch that failed is found in: .git/rebase-apply/patch

I was able to get around this, but it took some hand work.  How are you
generating these?

Thanks,

jon
