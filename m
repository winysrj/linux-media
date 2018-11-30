Return-Path: <SRS0=A0HE=OJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 155D5C64EB4
	for <linux-media@archiver.kernel.org>; Fri, 30 Nov 2018 22:15:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D667E2082F
	for <linux-media@archiver.kernel.org>; Fri, 30 Nov 2018 22:15:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D667E2082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lwn.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbeLAJZs (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 1 Dec 2018 04:25:48 -0500
Received: from ms.lwn.net ([45.79.88.28]:44048 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725867AbeLAJZs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 1 Dec 2018 04:25:48 -0500
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 47EEA30D;
        Fri, 30 Nov 2018 22:15:00 +0000 (UTC)
Date:   Fri, 30 Nov 2018 15:14:59 -0700
From:   Jonathan Corbet <corbet@lwn.net>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
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
Message-ID: <20181130151459.3ca2f5c8@lwn.net>
In-Reply-To: <20181130221219.GA25537@linux.intel.com>
References: <20181130192737.15053-1-jarkko.sakkinen@linux.intel.com>
        <CAGXu5j+jBNBsD3pvUSfEh6Lc5T1YMpbM0HeG1c6BHiJe+cKVOQ@mail.gmail.com>
        <20181130195652.7syqys76646kpaph@linux-r8p5>
        <20181130205521.GA21006@linux.intel.com>
        <1543611662.3031.20.camel@HansenPartnership.com>
        <20181130214405.GG23772@linux.intel.com>
        <1543615069.3031.27.camel@HansenPartnership.com>
        <20181130221219.GA25537@linux.intel.com>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org
Message-ID: <20181130221459.T3ycrMXtYoeEaTrc4lPqswVR1m_ORTkj9bfYc2gCBKE@z>

On Fri, 30 Nov 2018 14:12:19 -0800
Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com> wrote:

> As a maintainer myself (and based on somewhat disturbed feedback from
> other maintainers) I can only make the conclusion that nobody knows what
> the responsibility part here means.
> 
> I would interpret, if I read it like at lawyer at least, that even for
> existing code you would need to do the changes postmorterm.
> 
> Is this wrong interpretation?  Should I conclude that I made a mistake
> by reading the CoC and trying to understand what it *actually* says?
> After this discussion, I can say that I understand it less than before.

Have you read Documentation/process/code-of-conduct-interpretation.rst?
As has been pointed out, it contains a clear answer to how things should
be interpreted here.

Thanks,

jon
