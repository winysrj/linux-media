Return-path: <linux-media-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44770 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725867AbeLAJIi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 1 Dec 2018 04:08:38 -0500
Message-ID: <1543615069.3031.27.camel@HansenPartnership.com>
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
Date: Fri, 30 Nov 2018 13:57:49 -0800
In-Reply-To: <20181130214405.GG23772@linux.intel.com>
References: <20181130192737.15053-1-jarkko.sakkinen@linux.intel.com>
         <CAGXu5j+jBNBsD3pvUSfEh6Lc5T1YMpbM0HeG1c6BHiJe+cKVOQ@mail.gmail.com>
         <20181130195652.7syqys76646kpaph@linux-r8p5>
         <20181130205521.GA21006@linux.intel.com>
         <1543611662.3031.20.camel@HansenPartnership.com>
         <20181130214405.GG23772@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2018-11-30 at 13:44 -0800, Jarkko Sakkinen wrote:
> On Fri, Nov 30, 2018 at 01:01:02PM -0800, James Bottomley wrote:
> > No because use of what some people consider to be bad language
> > isn't necessarily abusive, offensive or degrading.  Our most
> > heavily censored medium is TV and "fuck" is now considered
> > acceptable in certain contexts on most channels in the UK and EU.
> 
> This makes following the CoC extremely hard to a non-native speaker
> as it is not too explicit on what is OK and what is not. I did
> through the whole thing with an eye glass and this what I deduced
> from it.

OK, so something that would simply be considered in some quarters as
bad language isn't explicitly banned.  The thing which differentiates
simple bad language from "abusive, offensive or degrading language",
which is called out by the CoC, is the context and the target.

So when it's a simple expletive or the code of the author or even the
hardware is the target, I'd say it's an easy determination it's not a
CoC violation.  If someone else's code is the target or the inventor of
the hardware is targetted by name, I'd say it is.  Even non-native
English speakers should be able to determine target and context,
because that's the essence of meaning.

James
