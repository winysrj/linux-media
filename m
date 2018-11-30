Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbeLAIN2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 1 Dec 2018 03:13:28 -0500
Date: Fri, 30 Nov 2018 16:02:48 -0500
From: Steven Rostedt <rostedt@goodmis.org>
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
        "Tobin C. Harding" <me@tobin.cc>, makita.toshiaki@lab.ntt.co.jp,
        Willem de Bruijn <willemb@google.com>,
        Yonghong Song <yhs@fb.com>, yanjun.zhu@oracle.com
Subject: Re: [PATCH RFC 00/15] Zero ****s, hugload of hugs <3
Message-ID: <20181130160248.45b02f07@gandalf.local.home>
In-Reply-To: <20181130205521.GA21006@linux.intel.com>
References: <20181130192737.15053-1-jarkko.sakkinen@linux.intel.com>
        <CAGXu5j+jBNBsD3pvUSfEh6Lc5T1YMpbM0HeG1c6BHiJe+cKVOQ@mail.gmail.com>
        <20181130195652.7syqys76646kpaph@linux-r8p5>
        <20181130205521.GA21006@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 30 Nov 2018 12:55:21 -0800
Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com> wrote:

> On Fri, Nov 30, 2018 at 11:56:52AM -0800, Davidlohr Bueso wrote:
> > On Fri, 30 Nov 2018, Kees Cook wrote:
> >   
> > > On Fri, Nov 30, 2018 at 11:27 AM Jarkko Sakkinen
> > > <jarkko.sakkinen@linux.intel.com> wrote:  
> > > > 
> > > > In order to comply with the CoC, replace **** with a hug.  
> > 
> > I hope this is some kind of joke. How would anyone get offended by reading
> > technical comments? This is all beyond me...  
> 
> Well... Not a joke really but more like conversation starter :-)
> 
> I had 10h flight from Amsterdam to Portland and one of the things that I
> did was to read the new CoC properly.
> 
> This a direct quote from the CoC:
> 
> "Harassment includes the use of abusive, offensive or degrading
> language, intimidation, stalking, harassing photography or recording,
> inappropriate physical contact, sexual imagery and unwelcome sexual
> advances or requests for sexual favors."
> 
> Doesn't this fall into this category?
>

It has also been discussed that existing code (and past conduct) will
not be covered under the CoC. It's about new code and conduct moving
forward.

-- Steve
