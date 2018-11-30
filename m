Return-Path: <SRS0=A0HE=OJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD366C04EB8
	for <linux-media@archiver.kernel.org>; Fri, 30 Nov 2018 22:30:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8134220867
	for <linux-media@archiver.kernel.org>; Fri, 30 Nov 2018 22:30:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="a+CNSOJU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8134220867
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbeLAJlj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 1 Dec 2018 04:41:39 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45804 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726893AbeLAJlj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 1 Dec 2018 04:41:39 -0500
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 8C8D38EE44B;
        Fri, 30 Nov 2018 14:30:49 -0800 (PST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 8c47FSmjyd5w; Fri, 30 Nov 2018 14:30:49 -0800 (PST)
Received: from [153.66.254.194] (unknown [50.35.68.20])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 5B9368EE0C3;
        Fri, 30 Nov 2018 14:30:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1543617048;
        bh=rkLSx0HqCjrRdqYbTD8S6Z+rTyePvq+QkL4Gbx1luRo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=a+CNSOJUqwybLKA6tzMT03GWBcpuZb5C9eRSpYhXFC0dUBiuPHOORuv1KzknBulBR
         vLovfc1AjuwF+haP+XE5WmgcmydNcaHwLhK75Xei+1vR5xvTnj1kwWGTjqiYVLt427
         N3enzotRIfoMgjKDxO2adZoNRhPCzr7ilwmFz5I0=
Message-ID: <1543617045.3031.41.camel@HansenPartnership.com>
Subject: Re: [PATCH RFC 00/15] Zero ****s, hugload of hugs <3
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Davidlohr Bueso <dave@stgolabs.net>,
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
Date:   Fri, 30 Nov 2018 14:30:45 -0800
In-Reply-To: <20181130222605.GA26261@linux.intel.com>
References: <20181130192737.15053-1-jarkko.sakkinen@linux.intel.com>
         <CAGXu5j+jBNBsD3pvUSfEh6Lc5T1YMpbM0HeG1c6BHiJe+cKVOQ@mail.gmail.com>
         <20181130195652.7syqys76646kpaph@linux-r8p5>
         <20181130205521.GA21006@linux.intel.com>
         <1543611662.3031.20.camel@HansenPartnership.com>
         <20181130214405.GG23772@linux.intel.com>
         <1543615069.3031.27.camel@HansenPartnership.com>
         <20181130221219.GA25537@linux.intel.com> <20181130151459.3ca2f5c8@lwn.net>
         <20181130222605.GA26261@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org
Message-ID: <20181130223045.ReiyacVrziJEp-jsehwKf-pwd5q7aThcF_TMnYIqyaU@z>

On Fri, 2018-11-30 at 14:26 -0800, Jarkko Sakkinen wrote:
> On Fri, Nov 30, 2018 at 03:14:59PM -0700, Jonathan Corbet wrote:
[...]
> > Have you read Documentation/process/code-of-conduct-
> > interpretation.rst? 
> > As has been pointed out, it contains a clear answer to how things
> > should be interpreted here.
> 
> Ugh, was not aware that there two documents.
> 
> Yeah, definitely sheds light. Why the documents could not be merged
> to single common sense code of conduct?

The fact that we've arrived at essentially an original CoC
reinterpreted to the point where it's effectively a new CoC has been
the source of much debate and recrimination over the last few months
... you can read it in the ksummit-discuss archives, but I really think
we don't want to reopen that can of worms.

James


