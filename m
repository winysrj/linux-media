Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout02.posteo.de ([185.67.36.66]:33874 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754740AbcJEHeX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Oct 2016 03:34:23 -0400
Received: from submission (posteo.de [89.146.220.130])
        by mout02.posteo.de (Postfix) with ESMTPS id D504920AF8
        for <linux-media@vger.kernel.org>; Wed,  5 Oct 2016 09:34:20 +0200 (CEST)
Date: Wed, 5 Oct 2016 09:34:17 +0200
From: Patrick Boettcher <patrick.boettcher@posteo.de>
To: Jiri Kosina <jikos@kernel.org>
Cc: =?UTF-8?B?SsO2cmc=?= Otte <jrg.otte@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Problem with VMAP_STACK=y
Message-ID: <20161005093417.6e82bd97@vdr>
In-Reply-To: <alpine.LNX.2.00.1610050925470.31629@cbobk.fhfr.pm>
References: <CADDKRnB1=-zj8apQ3vBfbxVZ8Dc4DJbD1MHynC9azNpfaZeF6Q@mail.gmail.com>
        <alpine.LRH.2.00.1610041519160.1123@gjva.wvxbf.pm>
        <CADDKRnA1qjyejvmmKQ9MuxH6Dkc7Uhwq4BSFVsOS3U-eBWP9GA@mail.gmail.com>
        <alpine.LNX.2.00.1610050925470.31629@cbobk.fhfr.pm>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 5 Oct 2016 09:26:29 +0200 (CEST)
Jiri Kosina <jikos@kernel.org> wrote:

> On Tue, 4 Oct 2016, Jörg Otte wrote:
> 
> > Thanks for the quick response.
> > Drivers are:
> > dvb_core, dvb_usb, dbv_usb_cynergyT2  
> 
> This dbv_usb_cynergyT2 is not from Linus' tree, is it? I don't seem
> to be able to find it, and the only google hit I am getting is your
> very mail to LKML :)

It's a typo, it should say dvb_usb_cinergyT2.

-- 
Patrick.
