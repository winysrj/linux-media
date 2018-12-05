Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5A1BC04EBF
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 09:57:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B84E20989
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 09:57:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kyPJO+BT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6B84E20989
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728534AbeLEJ5x (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 04:57:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:51074 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727959AbeLEJ5v (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2018 04:57:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=EfZkaEMoi3Ed9ppy3hoGZOZM+hiJIUd70BPFAvXb6J0=; b=kyPJO+BTxgwEAxA0CUt7fQMiYN
        b+Rn6GNsW/FeOTysA89s+U9jS3DV8Up8WtlepVCLI0DyFsGEeC4hQUVajv6yB4ElbbsdD7vrYh3Ow
        Fk/AO+CfOC+mYwwOEIGp90hfoFQWAddMCZFVEdrS/MmMUcluEQy9ZYth6td1OaCKBGUOk9NiRHYuj
        qCLsv1G8LXzIaOR6/2a3yCqLtP4dryT1tFr9xth2Jz8zgF9wYcqeCcbwCJain4B7cV5YEzsU1U9rG
        uq8pC8MFSG4xJcqJD5imfu6kDvDJz6PYAFWZmaYiIefk/LN+cpEPkdoSxIWXMmUk01iNoLNcJWeFD
        iqq7ZvDw==;
Received: from [191.33.148.129] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gUTw9-0008G8-RN; Wed, 05 Dec 2018 09:57:46 +0000
Date:   Wed, 5 Dec 2018 07:57:40 -0200
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Marco Felsch <m.felsch@pengutronix.de>
Cc:     robh+dt@kernel.org, mark.rutland@arm.com, kernel@pengutronix.de,
        devicetree@vger.kernel.org, p.zabel@pengutronix.de,
        javierm@redhat.com, laurent.pinchart@ideasonboard.com,
        sakari.ailus@linux.intel.com, afshin.nasser@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v3 0/9] TVP5150 fixes and new features
Message-ID: <20181205075740.064e0f36@coco.lan>
In-Reply-To: <20181109134624.2fxin2erjun57lrh@pengutronix.de>
References: <20180918131453.21031-1-m.felsch@pengutronix.de>
        <20181029184113.5tfdjdlj75m2wd6m@pengutronix.de>
        <20181109134624.2fxin2erjun57lrh@pengutronix.de>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Marco,

Em Fri, 9 Nov 2018 14:46:24 +0100
Marco Felsch <m.felsch@pengutronix.de> escreveu:

> Hi Mauro,
> 
> I don't want to spam you. Can you give me some feedback? I know the
> merge window is a busy time, so maybe you have some time now.

Sorry for taking so long on looking into it... has been really busy
those days :-(

I applied patch 2/9. Patch 3 doesn't apply. Would you mind
rebasing it on the top of upstream? there are some non-trivial
conflicts (perhaps I just missed some other preparation patch?).

I suspect that it would be easier if you could rebase your tree
on the top of the latest upstream one, e. g.:

	git://linuxtv.org/media_tree.git
	
(master branch)

Regards,
Mauro
> 
> Regards,
> Marco
> 
> On 18-10-29 19:41, Marco Felsch wrote:
> > Hi Mauro,
> > 
> > just a reminder, Rob already added his ack/rev-by tags.
> > 
> > Thanks,
> > Marco
> > 
> > On 18-09-18 15:14, Marco Felsch wrote:  
> > > Hi,
> > > 
> > > this is my v3 with the integrated reviews from my v2 [1]. This serie
> > > applies to Mauro's experimental.git [2].
> > > 
> > > @Mauro:
> > > Patch ("media: tvp5150: fix irq_request error path during probe") is new
> > > in this series. Maybe you can squash them with ("media: tvp5150: Add sync lock
> > > interrupt handling"), thanks.
> > > 
> > > I've tested this series on a customer dt-based board. Unfortunately I
> > > haven't a device which use the em28xx driver. So other tester a welcome :)
> > > 
> > > [1] https://www.spinics.net/lists/devicetree/msg244129.html
> > > [2] https://git.linuxtv.org/mchehab/experimental.git/log/?h=tvp5150-4
> > > 
> > > Javier Martinez Canillas (1):
> > >   partial revert of "[media] tvp5150: add HW input connectors support"
> > > 
> > > Marco Felsch (7):
> > >   media: tvp5150: fix irq_request error path during probe
> > >   media: tvp5150: add input source selection of_graph support
> > >   media: dt-bindings: tvp5150: Add input port connectors DT bindings
> > >   media: v4l2-subdev: add stubs for v4l2_subdev_get_try_*
> > >   media: v4l2-subdev: fix v4l2_subdev_get_try_* dependency
> > >   media: tvp5150: add FORMAT_TRY support for get/set selection handlers
> > >   media: tvp5150: add s_power callback
> > > 
> > > Michael Tretter (1):
> > >   media: tvp5150: initialize subdev before parsing device tree
> > > 
> > >  .../devicetree/bindings/media/i2c/tvp5150.txt |  92 ++-
> > >  drivers/media/i2c/tvp5150.c                   | 657 +++++++++++++-----
> > >  include/dt-bindings/media/tvp5150.h           |   2 -
> > >  include/media/v4l2-subdev.h                   |  15 +-
> > >  4 files changed, 584 insertions(+), 182 deletions(-)
> > > 
> > > -- 
> > > 2.19.0
> > > 
> > > 
> > >   
> > 
> > -- 
> > Pengutronix e.K.                           |                             |
> > Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> > Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> > Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
> > 
> >   
> 



Thanks,
Mauro
