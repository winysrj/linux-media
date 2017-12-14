Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:41992 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752307AbdLNOZz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 09:25:55 -0500
Received: by mail-wm0-f68.google.com with SMTP id b199so11754809wme.1
        for <linux-media@vger.kernel.org>; Thu, 14 Dec 2017 06:25:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171214085503.289f06f8@vento.lan>
References: <20171013054635.20946-1-Yasunari.Takiguchi@sony.com>
 <20171213173633.57edca85@vento.lan> <02699364973B424C83A42A84B04FDA85431742@JPYOKXMS113.jp.sony.com>
 <20171214085503.289f06f8@vento.lan>
From: Philippe Ombredanne <pombredanne@nexb.com>
Date: Thu, 14 Dec 2017 15:25:13 +0100
Message-ID: <CAOFm3uEYfMH8Zj8uEx-D9yYrTyDMTG_j02619esHu-j0brQKaA@mail.gmail.com>
Subject: Re: [PATCH v4 00/12] [dt-bindings] [media] Add document file and
 driver for Sony CXD2880 DVB-T2/T tuner + demodulator
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: "Takiguchi, Yasunari" <Yasunari.Takiguchi@sony.com>,
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
        "Watanabe, Satoshi (SSS)" <Satoshi.C.Watanabe@sony.com>,
        "Bird, Timothy" <Tim.Bird@sony.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Mauro,

On Thu, Dec 14, 2017 at 11:55 AM, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:

> SPDX is a new requirement that started late on Kernel 4.14 development
> cycle (and whose initial changes were merged directly at Linus tree).
> Not all existing files have it yet, as identifying the right license
> on existing files is a complex task, but if you do a:
>
>         $ git grep SPDX $(find . -name Makefile) $(find . -name Kconfig)
>
> You'll see that lot of such files have it already.

FWIW, short of having SPDX tags, identifying the right license on
existing files is not a super complex task: if boils down to running
many diffs.

Take the ~60K files in kernel, and about 6K license and notices
reference texts. Then compute a pairwise diff of each of the 60K file
against the 6K reference texts. Repeat the pairwise diff a few more
times, say 10 times, as multiple licenses may appear in any given
kernel file. And keep the diffs that have the fewest
difference/highest similarity with the reference texts as the detected
license. Done!

The only complex thing is that if you have a fast diff that runs at
0.1 millisec end-to-end per diff, you still have 3.6B diffs to do and
this would take about 250 days on one thread. Even with a beefy 250
core CPU, that would still be a day (and quite few kilo watts) . So
the whole trick is to avoid doing a diffs if not really needed. This
is what I do in my scancode-toolkit (that I used/use to help Greg and
Thomas with kernel license scans). Net effect is that on a laptop on 8
threads it takes ~20 minutes to scan a whole kernel using this
diff-based approach and obtain a fairly accurate license detection.
-- 
Cordially
Philippe Ombredanne
