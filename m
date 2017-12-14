Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:42348 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754165AbdLNSEZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 13:04:25 -0500
Date: Thu, 14 Dec 2017 16:04:11 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: "Bird, Timothy" <Tim.Bird@sony.com>
Cc: Philippe Ombredanne <pombredanne@nexb.com>,
        "Takiguchi, Yasunari" <Yasunari.Takiguchi@sony.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "tbird20d@gmail.com" <tbird20d@gmail.com>,
        "frowand.list@gmail.com" <frowand.list@gmail.com>,
        "Yamamoto, Masayuki" <Masayuki.Yamamoto@sony.com>,
        "Nozawa, Hideki (STWN)" <Hideki.Nozawa@sony.com>,
        "Yonezawa, Kota" <Kota.Yonezawa@sony.com>,
        "Matsumoto, Toshihiko" <Toshihiko.Matsumoto@sony.com>,
        "Watanabe, Satoshi (SSS)" <Satoshi.C.Watanabe@sony.com>
Subject: Re: [PATCH v4 00/12] [dt-bindings] [media] Add document file and
 driver for Sony CXD2880 DVB-T2/T tuner + demodulator
Message-ID: <20171214160411.32f23456@vento.lan>
In-Reply-To: <ECADFF3FD767C149AD96A924E7EA6EAF40AE4BB5@USCULXMSG01.am.sony.com>
References: <20171013054635.20946-1-Yasunari.Takiguchi@sony.com>
        <20171213173633.57edca85@vento.lan>
        <02699364973B424C83A42A84B04FDA85431742@JPYOKXMS113.jp.sony.com>
        <20171214085503.289f06f8@vento.lan>
        <CAOFm3uEYfMH8Zj8uEx-D9yYrTyDMTG_j02619esHu-j0brQKaA@mail.gmail.com>
        <ECADFF3FD767C149AD96A924E7EA6EAF40AE4BB5@USCULXMSG01.am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 14 Dec 2017 17:32:34 +0000
"Bird, Timothy" <Tim.Bird@sony.com> escreveu:

> > -----Original Message-----
> > From: Philippe on Thursday, December 14, 2017 6:25 AM
> > Dear Mauro,
> > 
> > On Thu, Dec 14, 2017 at 11:55 AM, Mauro Carvalho Chehab
> > <mchehab@s-opensource.com> wrote:
> >   
> > > SPDX is a new requirement that started late on Kernel 4.14 development
> > > cycle (and whose initial changes were merged directly at Linus tree).
> > > Not all existing files have it yet, as identifying the right license
> > > on existing files is a complex task, but if you do a:
> > >
> > >         $ git grep SPDX $(find . -name Makefile) $(find . -name Kconfig)
> > >
> > > You'll see that lot of such files have it already.  
> > 
> > FWIW, short of having SPDX tags, identifying the right license on
> > existing files is not a super complex task: if boils down to running
> > many diffs.
> > 
> > Take the ~60K files in kernel, and about 6K license and notices
> > reference texts. Then compute a pairwise diff of each of the 60K file
> > against the 6K reference texts. Repeat the pairwise diff a few more
> > times, say 10 times, as multiple licenses may appear in any given
> > kernel file. And keep the diffs that have the fewest
> > difference/highest similarity with the reference texts as the detected
> > license. Done!  
> 
> You can't do license detection and assignment in this automated fashion - 
> at least not generally.
> 
> Even a single word of difference between the notice in the source
> code and the reference license notice or text may have legal implications
> that are not conveyed by the simplified SPDX tag.  When differences are
> found, we're going to have to kick the discrepancies to a human for review.
> This is especially true for files with multiple licenses.
> 
> For a work of original authorship, or a single copyright holder, the author
> or copyright holder may be able to change the notice or text, or gloss
> over any difference from the reference text, and make the SPDX  assignment
> (or even change the license, if they want).  This would apply to something
> new like this Sony driver.  However, for code that is already in the kernel
> tree, with likely multiple contributors, the legal situation gets a little
> more murky.

Precisely. This is easily fixable when the code author changes the
license text, or when someone from the Company that holds copyrights sends
the SPDX markups (as emails @company can be seen as official e-mails, except
if explicitly noticed otherwise). So, from my side, I'm now requiring
SPDX for new drivers.

However, if someone else is doing the changes, it can be tricky and risky
to pick up the patch, adding my SOB, if not endorsed by the copyright
owners, or by LF legal counseling. So, I prefer to not pick those myself,
except from people I trust.

> I suspect the vast majority of the ~60k files will probably fall neatly into an
> SPDX category, but I'm guessing a fair number (maybe hundreds) will require
> some review and discussion.

Thanks,
Mauro
