Return-path: <linux-media-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43558 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726690AbeLAILl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 1 Dec 2018 03:11:41 -0500
Message-ID: <1543611662.3031.20.camel@HansenPartnership.com>
Subject: Re: [PATCH RFC 00/15] Zero ****s, hugload of hugs <3
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Davidlohr Bueso <dave@stgolabs.net>
Cc: Kees Cook <keescook@chromium.org>,
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
Date: Fri, 30 Nov 2018 13:01:02 -0800
In-Reply-To: <20181130205521.GA21006@linux.intel.com>
References: <20181130192737.15053-1-jarkko.sakkinen@linux.intel.com>
         <CAGXu5j+jBNBsD3pvUSfEh6Lc5T1YMpbM0HeG1c6BHiJe+cKVOQ@mail.gmail.com>
         <20181130195652.7syqys76646kpaph@linux-r8p5>
         <20181130205521.GA21006@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2018-11-30 at 12:55 -0800, Jarkko Sakkinen wrote:
> On Fri, Nov 30, 2018 at 11:56:52AM -0800, Davidlohr Bueso wrote:
> > On Fri, 30 Nov 2018, Kees Cook wrote:
> > 
> > > On Fri, Nov 30, 2018 at 11:27 AM Jarkko Sakkinen
> > > <jarkko.sakkinen@linux.intel.com> wrote:
> > > > 
> > > > In order to comply with the CoC, replace **** with a hug.
> > 
> > I hope this is some kind of joke. How would anyone get offended by
> > reading technical comments? This is all beyond me...
> 
> Well... Not a joke really but more like conversation starter :-)
> 
> I had 10h flight from Amsterdam to Portland and one of the things
> that I did was to read the new CoC properly.
> 
> This a direct quote from the CoC:
> 
> "Harassment includes the use of abusive, offensive or degrading
> language, intimidation, stalking, harassing photography or recording,
> inappropriate physical contact, sexual imagery and unwelcome sexual
> advances or requests for sexual favors."
> 
> Doesn't this fall into this category?

No because use of what some people consider to be bad language isn't
necessarily abusive, offensive or degrading.  Our most heavily censored
medium is TV and "fuck" is now considered acceptable in certain
contexts on most channels in the UK and EU.

> Your argument is not that great because you could say that from any
> LKML discussion. If you don't like hugging, please propose something
> else
> :-)

The interpretation document also says this:

   ontributions submitted for the kernel should use appropriate
   language. Content that already exists predating the Code of Conduct
   will not be addressed now as a violation.

So that definitely means there should be no hunting down of existing
comments in kernel code.

James
