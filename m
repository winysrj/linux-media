Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout02.posteo.de ([185.67.36.66]:46442 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751591AbcJEHkj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Oct 2016 03:40:39 -0400
Received: from submission (posteo.de [89.146.220.130])
        by mout02.posteo.de (Postfix) with ESMTPS id A06AC209DD
        for <linux-media@vger.kernel.org>; Wed,  5 Oct 2016 09:40:37 +0200 (CEST)
Date: Wed, 5 Oct 2016 09:40:36 +0200
From: Patrick Boettcher <patrick.boettcher@posteo.de>
To: Jiri Kosina <jikos@kernel.org>
Cc: =?UTF-8?B?SsO2cmc=?= Otte <jrg.otte@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: dvb-usb stack-memory used for URB-buffers (was: Re: Problem with
 VMAP_STACK=y)
Message-ID: <20161005094036.3ffa11b5@vdr>
In-Reply-To: <alpine.LRH.2.00.1610041519160.1123@gjva.wvxbf.pm>
References: <CADDKRnB1=-zj8apQ3vBfbxVZ8Dc4DJbD1MHynC9azNpfaZeF6Q@mail.gmail.com>
        <alpine.LRH.2.00.1610041519160.1123@gjva.wvxbf.pm>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Tue, 4 Oct 2016 15:26:28 +0200 (CEST)
Jiri Kosina <jikos@kernel.org> wrote:

> On Tue, 4 Oct 2016, Jörg Otte wrote:
> 
> > With kernel 4.8.0-01558-g21f54dd I get thousands of
> > "dvb-usb: bulk message failed: -11 (1/0)"
> > messages in the logs and the DVB adapter is not working.
> > 
> > It tourned out the new config option VMAP_STACK=y (which is the
> > default) is the culprit.
> > No problems for me with VMAP_STACK=n.  
> 
> I'd guess that this is EAGAIN coming from usb_hcd_map_urb_for_dma()
> as the DVB driver is trying to perform on-stack DMA.

I really thought that this youngster-mistake of mien (these
drivers+framework date from 2004-2006 and there it worked just fine)
had been fixed some years ago. 

Seems not the be the case :-(.

However, I'm happy to see people using these devices now. Even
though I don't have them anymore (or never had them in the first place).

Mauro, could you please bring me up to speed or remind when and
where you did changes in this regard? I got a little bit rusty
regarding linux-media, but I'd be happy to help.

regards,
-- 
Patrick.
