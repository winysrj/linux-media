Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:44054 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754189AbdLNSXO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 13:23:14 -0500
Received: by mail-wr0-f194.google.com with SMTP id l22so5933791wrc.11
        for <linux-media@vger.kernel.org>; Thu, 14 Dec 2017 10:23:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ECADFF3FD767C149AD96A924E7EA6EAF40AE4BB5@USCULXMSG01.am.sony.com>
References: <20171013054635.20946-1-Yasunari.Takiguchi@sony.com>
 <20171213173633.57edca85@vento.lan> <02699364973B424C83A42A84B04FDA85431742@JPYOKXMS113.jp.sony.com>
 <20171214085503.289f06f8@vento.lan> <CAOFm3uEYfMH8Zj8uEx-D9yYrTyDMTG_j02619esHu-j0brQKaA@mail.gmail.com>
 <ECADFF3FD767C149AD96A924E7EA6EAF40AE4BB5@USCULXMSG01.am.sony.com>
From: Philippe Ombredanne <pombredanne@nexb.com>
Date: Thu, 14 Dec 2017 19:22:31 +0100
Message-ID: <CAOFm3uEk2yD0hsusOtHRpVW6rMigNUpLyqe4T3DaKqAnP5dQWw@mail.gmail.com>
Subject: Re: [PATCH v4 00/12] [dt-bindings] [media] Add document file and
 driver for Sony CXD2880 DVB-T2/T tuner + demodulator
To: "Bird, Timothy" <Tim.Bird@sony.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
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
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tim,

On Thu, Dec 14, 2017 at 6:32 PM, Bird, Timothy <Tim.Bird@sony.com> wrote:
>
>
>> -----Original Message-----
>> From: Philippe on Thursday, December 14, 2017 6:25 AM
>> Dear Mauro,
>>
>> On Thu, Dec 14, 2017 at 11:55 AM, Mauro Carvalho Chehab
>> <mchehab@s-opensource.com> wrote:
>>
>> > SPDX is a new requirement that started late on Kernel 4.14 development
>> > cycle (and whose initial changes were merged directly at Linus tree).
>> > Not all existing files have it yet, as identifying the right license
>> > on existing files is a complex task, but if you do a:
>> >
>> >         $ git grep SPDX $(find . -name Makefile) $(find . -name Kconfig)
>> >
>> > You'll see that lot of such files have it already.
>>
>> FWIW, short of having SPDX tags, identifying the right license on
>> existing files is not a super complex task: if boils down to running
>> many diffs.
>>
>> Take the ~60K files in kernel, and about 6K license and notices
>> reference texts. Then compute a pairwise diff of each of the 60K file
>> against the 6K reference texts. Repeat the pairwise diff a few more
>> times, say 10 times, as multiple licenses may appear in any given
>> kernel file. And keep the diffs that have the fewest
>> difference/highest similarity with the reference texts as the detected
>> license. Done!
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
>
> I suspect the vast majority of the ~60k files will probably fall neatly into an
> SPDX category, but I'm guessing a fair number (maybe hundreds) will require
> some review and discussion.

You are completely and 100% right. I was just describing the mechanics
of the license detection side. The actual process has been and always
will be scan then review carefully and then discuss. There is no sane
automated tool that could do it all for sure.

As a funny side note, there are over 80+ licenses in the kernel and
there is (or rather was before starting adding SPDX tags) 1000+
different license notices and over 700+ variations of "this file in
under the GPL"... This starts to diminish a bit with the addition of
SPDX tags and eventually most or all boilerplate could be removed over
time with reviews and discussions, IMHO for the better: I will then be
able to trash my tool and use a good ole grep instead ;)

-- 
Cordially
Philippe Ombredanne
