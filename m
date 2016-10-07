Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33488
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932982AbcJGRaM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Oct 2016 13:30:12 -0400
Date: Fri, 7 Oct 2016 14:30:03 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: =?UTF-8?B?SsO2cmc=?= Otte <jrg.otte@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Johannes Stezenbach <js@linuxtv.org>,
        Jiri Kosina <jikos@kernel.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2] cinergyT2-core: don't do DMA on stack
Message-ID: <20161007143003.67b90018@vento.lan>
In-Reply-To: <CADDKRnAXgBNFy_csDEB5veA=XXPnu=jY_rTOEun7f-QNyzr4uQ@mail.gmail.com>
References: <20161005155805.27dc4d33@vento.lan>
        <CALCETrVg5FczwRaJuRe6G_FxX7yDsPS-L4JnR475UW4TwQWWzg@mail.gmail.com>
        <20161006152905.2f9a9b13@vento.lan>
        <CADDKRnAXgBNFy_csDEB5veA=XXPnu=jY_rTOEun7f-QNyzr4uQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 7 Oct 2016 15:50:40 +0200
Jörg Otte <jrg.otte@gmail.com> escreveu:

> 2016-10-06 20:29 GMT+02:00 Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> > Em Thu, 6 Oct 2016 10:27:56 -0700
> > Andy Lutomirski <luto@amacapital.net> escreveu:
> >  
 
> Patch works for me!
> Thanks, Jörg

Thanks for testing!

I just sent a 26 patch series to address this issue. There are 4 patches
on it that affects cinergyT2 (one is this patch, but the other ones
should be addressing other problems there).

Could you please test them, and if they're ok, reply to me with a
Tested-by: tag?

PS.: I'm also putting those patches on my development tree, at:
	git://git.linuxtv.org/mchehab/experimental.git media_dmastack_fixes

(please notice that my tree is based on Kernel 4.8 - so, to test with
VMAP_STACK, you'll likely need to pull also from Linus tree)

Thanks,
Mauro
