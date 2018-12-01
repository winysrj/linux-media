Return-path: <linux-media-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45620 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725867AbeLAJhV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 1 Dec 2018 04:37:21 -0500
Message-ID: <1543616788.3031.38.camel@HansenPartnership.com>
Subject: Re: [PATCH RFC 00/15] Zero ****s, hugload of hugs <3
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Axtens <dja@axtens.net>,
        "David S. Miller" <davem@davemloft.net>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Maling list - DRI developers
        <dri-devel@lists.freedesktop.org>,
        Eric Dumazet <edumazet@google.com>, federico.vaga@vaga.pv.it,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Helge Deller <deller@gmx.de>, Jonathan Corbet <corbet@lwn.net>,
        Joshua Kinard <kumba@gentoo.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-ide@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        Linux mtd <linux-mtd@lists.infradead.org>,
        linux-parisc <linux-parisc@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        linux-scsi@vger.kernel.org, matthias.bgg@gmail.com,
        Network Development <netdev@vger.kernel.org>,
        nouveau <nouveau@lists.freedesktop.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Paul Burton <paul.burton@mips.com>,
        Petr Mladek <pmladek@suse.com>, Rob Herring <robh@kernel.org>,
        sean.wang@mediatek.com,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        shannon.nelson@oracle.com, Stefano Brivio <sbrivio@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Tobin C. Harding" <me@tobin.cc>, makita.toshiaki@lab.ntt.co.jp,
        Willem de Bruijn <willemb@google.com>,
        Yonghong Song <yhs@fb.com>, yanjun.zhu@oracle.com
Date: Fri, 30 Nov 2018 14:26:28 -0800
In-Reply-To: <20181130221219.GA25537@linux.intel.com>
References: <20181130192737.15053-1-jarkko.sakkinen@linux.intel.com>
         <CAGXu5j+jBNBsD3pvUSfEh6Lc5T1YMpbM0HeG1c6BHiJe+cKVOQ@mail.gmail.com>
         <20181130195652.7syqys76646kpaph@linux-r8p5>
         <20181130205521.GA21006@linux.intel.com>
         <1543611662.3031.20.camel@HansenPartnership.com>
         <20181130214405.GG23772@linux.intel.com>
         <1543615069.3031.27.camel@HansenPartnership.com>
         <20181130221219.GA25537@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2018-11-30 at 14:12 -0800, Jarkko Sakkinen wrote:
[...]
> I pasted this already to another response and this was probably the
> part that ignited me to send the patch set (was a few days ago, so
> had to revisit to find the exact paragraph):

I replied in to the other thread.

> "Maintainers have the right and responsibility to remove, edit, or
> reject comments, commits, code, wiki edits, issues, and other
> contributions that are not aligned to this Code of Conduct, or to ban
> temporarily or permanently any contributor for other behaviors that
> they deem inappropriate, threatening, offensive, or harmful."
> 
> The whole patch set is neither a joke/troll nor something I would
> necessarily want to be include myself. It does have the RFC tag.
> 
> As a maintainer myself (and based on somewhat disturbed feedback from
> other maintainers) I can only make the conclusion that nobody knows
> what the responsibility part here means.
> 
> I would interpret, if I read it like at lawyer at least, that even
> for existing code you would need to do the changes postmorterm.

That's wrong in the light of the interpretation document, yes.

> Is this wrong interpretation?  Should I conclude that I made a
> mistake by reading the CoC and trying to understand what it
> *actually* says?

You can't read it in isolation, you need to read it along with the
interpretation document.  The latter was created precisely because
there was a lot of push back on interpretation problems and ambiguities
with the original CoC and it specifically covers this case (and a lot
of others).

James


> After this discussion, I can say that I understand it less than
> before.
> 
> /Jarkko
> 
