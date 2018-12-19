Return-Path: <SRS0=l98e=O4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B9EFC43387
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 14:11:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 078792084A
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 14:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545228685;
	bh=XKLQUPIf/89RrUOEQxC/Z/Qr5R53TjHX+Cj2gpBHduI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=qxDq9T/TnGJycrmnp3/gWcpENOtZxFFEWWHlRDKBx3uwIZPhdaVOQLf73DS8A/FCS
	 +2m8MSIrMqBpIGNXoJOD9VjmDoqoVkD8+p32E9X5DVktE/oeFjffYtGffEuKGq17La
	 Uh1NNgUFU8nwvl7mfvXO4kF/X93/CgyvKnutBJ1M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727594AbeLSOLY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 19 Dec 2018 09:11:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:51742 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727310AbeLSOLY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Dec 2018 09:11:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=5XMBj8N/43y8ZibssIeerh/+QDy6dwdwHUNwyagmgyc=; b=mumbeDP9emSy0gb3TCO0JU71mP
        RGOJzucHVfxhBDW3CmWEt3iUCHq+PLUUv3JZQqjTCehF3p4qp/7ENXMSY3raaiD991qxANmB5FRD7
        V8WzuQ9cCm+G/fgwXf22ZRATm4CBXsjJT2wGiwTmsm4xoYz68UDleGb4hmhS5ItkRKA3MTTO2pMVr
        XqpIDuvutYM1gkH8x3508u1yVypS1WZoCKJYl3wgP85I2GPUEsiERQuUT9sZKfvOBZOxdV8VHFvaH
        EBKFHXzvTR22tGKYqXrl+rHWk4o4e8Xz8R2bdM5sd5cQlrhnb4gYOXBmVIZU8NAzSlLOyZMVLV5my
        D7Dgl4JA==;
Received: from [191.33.191.108] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gZcZG-00079u-LT; Wed, 19 Dec 2018 14:11:23 +0000
Date:   Wed, 19 Dec 2018 12:11:17 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Josef Wolf <jw@raven.inka.de>
Cc:     linux-media@vger.kernel.org
Subject: Re: SYS_DVBS vs. SYS_DVBS2
Message-ID: <20181219121117.0a942d85@coco.lan>
In-Reply-To: <20181219121649.GK11337@raven.inka.de>
References: <20181219102846.GJ11337@raven.inka.de>
        <20181219092211.16d67c61@coco.lan>
        <20181219121649.GK11337@raven.inka.de>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Wed, 19 Dec 2018 13:16:49 +0100
Josef Wolf <jw@raven.inka.de> escreveu:

> Thanks for your response, Mauro!
> 
> On Wed, Dec 19, 2018 at 09:22:11AM -0200, Mauro Carvalho Chehab wrote:
> > Em Wed, 19 Dec 2018 11:28:46 +0100
> > Josef Wolf <jw@raven.inka.de> escreveu:  
> 
> > > I would like to know how to know whether for a specific program SYS_DVBS or
> > > SYS_DVBS2 should be specified to the FE_SET_PROPERTY ioctl() call.  
> > 
> > This is not specific to a program. It affects the hole transponder. Either
> > the transponder is DVB-S or DVB-S2.  
> 
> Yes, I'm aware of it. In my question I meant: when I want to tune to some
> program, I need to set the SYS_DVBx property in addition to the other tuning
> parameters (like frequency, polarization, FEC etc/pp)
> 
> > > Is this somehow broadcasted in some PAT/PMT tables?  
> > 
> > It is at the NAT tables. They contain all needed information to properly
> > tune into the transponders. There are different tables, depending if the
> > transponder is -S or -S2.  
> 
> OK.
> 
> > > Or is it possible to simple always specify SYS_DVBS2 and the kernel will
> > > manage the backwards compatibilities when a DVB-S transponder is specified in
> > > the tuning parameters?  
> > 
> > The Kernel can't and shouldn't guess the tuning parameters. It depends
> > on userspace to parse the NAT tables and get it right.  
> 
> It is pretty much obvois to me that the kernel can't guess tuning parameters
> like diseqc-sequence, polarity, frequency and symrate. This is because the
> kernel needs those parameters to get a signal at all.
> 
> But, on the other side, there are lots of parameters that the kernel (or
> hardware?) _can_ guess: INVERSION_AUTO, FEC_AUTO, QAM_AUTO just to name some.

The Kernel implements only INVERSION_AUTO. The rest is implemented by
the device itself, if it has support for it.

> So what' so special about SYS_DVBS/SYS_DVBS2 that it has to be handled
> differently from those other parameters?

DVB-S2 adds a lot more parameters, including the possibility of using
different modulations (QPSK, 8PSK, 16APSK, 32APSK). DVB-S was just QPSK.

The rolloff parameter also can be changed. DVB-S was just 0.35. On
DVB-S2 it can also be 0.20 and 0.25. That affects frequency filtering.

It even allows to have multiple MPEG-TS streams inside a physical
transponder, each with a separate ID. 

If, for example, there are multiple streams, neither the device nor 
the Kernel could know what ID would contain the MPEG stream that
the user wants.

It may also use a scrambling code, with requires userspace to
pass the gold code, in order to de-scramble it.

So, if the transponder is using those extra features provided by
DVB-S2, the device has to know how to properly tune transponder and 
how filter/de-scramble the transport stream that contains the program
the user wants.

It is worth to say that DVB-S2 is a superset of DVB-S. If your
tuner can do DVB-S2 and you want to tune to a DVB-S transponder,
provided that you properly fill all DVB-S2 properties to match
a DVB-S channel (rollback, modulation, ...), in thesis[1] you could
use SYS_DVBS2 as delivery system.

[1] In practice, I'm not so sure, as this is something that
developers don't usually test. Both userspace apps and Kernelspace
don't assume that. So, it is not warranted to work.
I guess that, if one uses SYS_DVBS2 to tune, the results will vary
from driver to driver. Things like gold code and PLS ID, if set wrong,
could prevent the channel to tune.

Thanks,
Mauro
