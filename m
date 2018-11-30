Return-Path: <SRS0=A0HE=OJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 954D1C64EB4
	for <linux-media@archiver.kernel.org>; Fri, 30 Nov 2018 21:35:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E71E20663
	for <linux-media@archiver.kernel.org>; Fri, 30 Nov 2018 21:35:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5E71E20663
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbeLAIpe (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 1 Dec 2018 03:45:34 -0500
Received: from mga18.intel.com ([134.134.136.126]:19764 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726663AbeLAIpd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 1 Dec 2018 03:45:33 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Nov 2018 13:34:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,299,1539673200"; 
   d="scan'208";a="294214223"
Received: from jsakkine-mobl1.jf.intel.com (HELO localhost) ([10.241.225.27])
  by fmsmga006.fm.intel.com with ESMTP; 30 Nov 2018 13:34:52 -0800
Date:   Fri, 30 Nov 2018 13:34:52 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Matthias Brugger <matthias.bgg@gmail.com>
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
        linux-scsi@vger.kernel.org,
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
Message-ID: <20181130213452.GD23772@linux.intel.com>
References: <20181130192737.15053-1-jarkko.sakkinen@linux.intel.com>
 <CAGXu5j+jBNBsD3pvUSfEh6Lc5T1YMpbM0HeG1c6BHiJe+cKVOQ@mail.gmail.com>
 <f9c2db3b-2c9a-5e8c-e899-59bb5f554d19@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9c2db3b-2c9a-5e8c-e899-59bb5f554d19@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org
Message-ID: <20181130213452.fDlwUuLYjytB4DDYiGDBM0-iAy37_WTBnnVR7UpEX8s@z>

On Fri, Nov 30, 2018 at 09:31:13PM +0100, Matthias Brugger wrote:
> Like John I don't think that the word "fuck" is something we have to ban from
> the source code, but I don't care too much. Anyway, please don't change it to
> something like heck as it might be difficult for non-english speaker to understand.

I make context sensitive better thought updates based on the feedback
that Kees gave. I used RFC tag for a reason.

/Jarkko
