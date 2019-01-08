Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35365C43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 12:27:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F14E220685
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 12:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546950456;
	bh=WldO2dPP7GY2rGr27/x5DPaU8RBi56GVXQvW1MaRndg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=mwIKGyCURLoSw26KoxJxZSidT6AyXw/R3nTfaYIptobyLrKTTyQ78avCrrWppUMS0
	 bms3XBO0LoKwzp2Ex745JIfHveMnyFUICVJI6bYKDu+2Xmidj9URH+C3baDhCyXoNO
	 gkO3wytD6/ygIKdzgCLtykOPqB0N3+1LR39jyp6U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728791AbfAHM1f (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 07:27:35 -0500
Received: from casper.infradead.org ([85.118.1.10]:47960 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728709AbfAHM1f (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 07:27:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=qBq/sICLozZR7FBTeqi9PfRRaZ/iwHgojQAeu+Oy7Xw=; b=EasR06/npd3qlb0//efh/dB1S9
        XzIrmv/fykxO9/qhWZ/YJbT/OuxpGCdv/D9/7uO7WmuO89AHEWTX0REHdzjSvSksH7cUJTfYYPMLp
        myGYxK4v9Lwd8dMcOxIEX7/Izh4jSWeZlWZEkYcH0In/8EnBPaxxkXs4vxm3CiprW3d+BMgadkwmN
        JtefBYIqMRrAKtoknTNq1AykZLkJvkqw9SOgTMbFf/3EqUdfTSQM97yOzjzrjy9AhjDB2KI0W3eXT
        KsfuSwLzOCZCpjCVsAZ+sD26tPD2VON3ds0kMq03o2Zq2NYLrXv7RrLfLM5zezeu6ydABMZ25cR4b
        lZgk95pw==;
Received: from 177.41.113.230.dynamic.adsl.gvt.net.br ([177.41.113.230] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1ggqTj-0001h8-Lg; Tue, 08 Jan 2019 12:27:31 +0000
Date:   Tue, 8 Jan 2019 10:27:26 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Sakari Ailus <sakari.ailus@iki.fi>
Cc:     linux-media@vger.kernel.org,
        Bingbu Cao <bingbu.cao@linux.intel.com>
Subject: Re: [GIT PULL v4 for 4.21] META_OUTPUT buffer type and the ipu3
 staging driver
Message-ID: <20190108102726.394a15d4@coco.lan>
In-Reply-To: <20190107225125.6jizdimhzpilra6g@valkosipuli.retiisi.org.uk>
References: <20181213120340.2oakeelp2b5w7zzq@valkosipuli.retiisi.org.uk>
        <20190107160107.7dd9af05@coco.lan>
        <20190107161134.1d0d9f73@coco.lan>
        <20190107225125.6jizdimhzpilra6g@valkosipuli.retiisi.org.uk>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Tue, 8 Jan 2019 00:51:25 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> On Mon, Jan 07, 2019 at 04:11:34PM -0200, Mauro Carvalho Chehab wrote:
> > Em Mon, 7 Jan 2019 16:01:07 -0200
> > Mauro Carvalho Chehab <mchehab+samsung@kernel.org> escreveu:
> >   
> > > Hi Sakari/Bingbu,
> > > 
> > > Em Thu, 13 Dec 2018 14:03:40 +0200
> > > sakari.ailus@iki.fi escreveu:
> > >   
> > > > Hi Mauro,
> > > > 
> > > > Here's the ipu3 staging driver plus the META_OUTPUT buffer type needed to
> > > > pass the parameters for the device. If you think this there's still time to
> > > > get this to 4.21, then please pull. The non-staging patches have been
> > > > around for more than half a year and they're relatively simple.    
> > > 
> > > I'm now getting a lot of new warnings when building it:
> > > 

<snip>

> > > Could you please send ASAP a patch series fixing them?
> > > 
> > > Thanks,
> > > Mauro  
> > 
> > In time, I fixed a few really trivial warnings there, due to the
> > lack of an #include directive.
> > 
> > As this patch is trivial enough, I'll go ahead and just apply it.
> > I'll let the others for you to handle.  
> 
> Interestingly enough, I haven't seen these warnings here. I presume you use
> W=1 when compiling? 

Yes, that's the case. I always build here with:

	W=1 CF=-D__CHECK_ENDIAN__ CONFIG_DEBUG_SECTION_MISMATCH=y

Most of the time, I use ARCH=i386 on my builds, in order to get errors
about div64() stuff (also, gcc warnings seem to work better on x86).

Btw, are you compiling against 5.0-rc1 and using an updated gcc compiler?

Please notice that there were a patchset merged recently changing
the enabled warning flags for W=0 and W=1. Those got merged (I think)
on 5.0-rc1.

Here, As I use Fedora, with gets updated every 6 months, I'm usually
not far behind gcc upstream. Right now (Fedora 29), I'm using gcc
version 8.2.1:

	gcc (GCC) 8.2.1 20181215 (Red Hat 8.2.1-6)

> Some of these are worth more attention than just trying
> to squash them by including the necessary headers. 

Agreed. Several of them are not trivial to solve, yet seem relevant
enough to be fixed.

Thanks,
Mauro
