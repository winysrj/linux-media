Return-Path: <SRS0=A0HE=OJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42AF8C04EB8
	for <linux-media@archiver.kernel.org>; Fri, 30 Nov 2018 22:29:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C28920863
	for <linux-media@archiver.kernel.org>; Fri, 30 Nov 2018 22:29:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0C28920863
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727147AbeLAJkm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 1 Dec 2018 04:40:42 -0500
Received: from mga01.intel.com ([192.55.52.88]:43859 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727018AbeLAJkl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 1 Dec 2018 04:40:41 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Nov 2018 14:29:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,300,1539673200"; 
   d="scan'208";a="294225952"
Received: from jsakkine-mobl1.jf.intel.com (HELO localhost) ([10.241.225.27])
  by fmsmga006.fm.intel.com with ESMTP; 30 Nov 2018 14:29:51 -0800
Date:   Fri, 30 Nov 2018 14:29:51 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
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
        Helge Deller <deller@gmx.de>, Joshua Kinard <kumba@gentoo.org>,
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
Subject: Re: [PATCH RFC 00/15] Zero ****s, hugload of hugs <3
Message-ID: <20181130222951.GA26980@linux.intel.com>
References: <20181130192737.15053-1-jarkko.sakkinen@linux.intel.com>
 <CAGXu5j+jBNBsD3pvUSfEh6Lc5T1YMpbM0HeG1c6BHiJe+cKVOQ@mail.gmail.com>
 <20181130195652.7syqys76646kpaph@linux-r8p5>
 <20181130205521.GA21006@linux.intel.com>
 <1543611662.3031.20.camel@HansenPartnership.com>
 <20181130214405.GG23772@linux.intel.com>
 <1543615069.3031.27.camel@HansenPartnership.com>
 <20181130221219.GA25537@linux.intel.com>
 <20181130151459.3ca2f5c8@lwn.net>
 <20181130222605.GA26261@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181130222605.GA26261@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org
Message-ID: <20181130222951.7Z-W2aaznONOjDmNFIjci3QCGU71gBcqRj0hjbmAleM@z>

On Fri, Nov 30, 2018 at 02:26:05PM -0800, Jarkko Sakkinen wrote:
> On Fri, Nov 30, 2018 at 03:14:59PM -0700, Jonathan Corbet wrote:
> > On Fri, 30 Nov 2018 14:12:19 -0800
> > Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com> wrote:
> > 
> > > As a maintainer myself (and based on somewhat disturbed feedback from
> > > other maintainers) I can only make the conclusion that nobody knows what
> > > the responsibility part here means.
> > > 
> > > I would interpret, if I read it like at lawyer at least, that even for
> > > existing code you would need to do the changes postmorterm.
> > > 
> > > Is this wrong interpretation?  Should I conclude that I made a mistake
> > > by reading the CoC and trying to understand what it *actually* says?
> > > After this discussion, I can say that I understand it less than before.
> > 
> > Have you read Documentation/process/code-of-conduct-interpretation.rst?
> > As has been pointed out, it contains a clear answer to how things should
> > be interpreted here.
> 
> Ugh, was not aware that there two documents.
> 
> Yeah, definitely sheds light. Why the documents could not be merged to
> single common sense code of conduct?

I.e. if the latter that you pointed out tells you what you actually
should do what value does the former bring?

Just looked up archives and realized that there has been whole alot
of CoC related discussions. No wonder this is seen as waste of time.

/Jarkko
