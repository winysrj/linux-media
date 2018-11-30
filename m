Return-Path: <SRS0=A0HE=OJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A72DC04EB8
	for <linux-media@archiver.kernel.org>; Fri, 30 Nov 2018 21:01:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0659020663
	for <linux-media@archiver.kernel.org>; Fri, 30 Nov 2018 21:01:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="q/JYY991"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0659020663
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbeLAILl (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 1 Dec 2018 03:11:41 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43558 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726690AbeLAILl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 1 Dec 2018 03:11:41 -0500
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 8CA018EE1F7;
        Fri, 30 Nov 2018 13:01:05 -0800 (PST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id VYmKxIaK2Tn6; Fri, 30 Nov 2018 13:01:05 -0800 (PST)
Received: from [153.66.254.194] (unknown [50.35.68.20])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id CD3088EE0C3;
        Fri, 30 Nov 2018 13:01:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1543611665;
        bh=eitEXQPISaa+oyVQhYw/njiOzNoCTXek/1SqSvBbxzg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=q/JYY991GxHCfCz/3qbUh6BtU/MBDW6EfGouzzAJ3672W/SG0U/frghauPAk+DBk/
         wNulaYudRy0mPjn6YrCVVoZYQUcaiYZcrhv7IJhni1o7FcHE1moD+cQoN7RvvnIAvQ
         BiwuavkD5IwItvemvPdW0NtvWbAhLZv78yK44Eeg=
Message-ID: <1543611662.3031.20.camel@HansenPartnership.com>
Subject: Re: [PATCH RFC 00/15] Zero ****s, hugload of hugs <3
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Davidlohr Bueso <dave@stgolabs.net>
Cc:     Kees Cook <keescook@chromium.org>,
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
Date:   Fri, 30 Nov 2018 13:01:02 -0800
In-Reply-To: <20181130205521.GA21006@linux.intel.com>
References: <20181130192737.15053-1-jarkko.sakkinen@linux.intel.com>
         <CAGXu5j+jBNBsD3pvUSfEh6Lc5T1YMpbM0HeG1c6BHiJe+cKVOQ@mail.gmail.com>
         <20181130195652.7syqys76646kpaph@linux-r8p5>
         <20181130205521.GA21006@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org
Message-ID: <20181130210102.zrANussuvyQuUDuqpqriUi_4NOc9C8hAhKjby_5aTK8@z>

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

