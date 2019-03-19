Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59552C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 19:45:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 268962085A
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 19:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553024728;
	bh=SwJolD53mn2IWkxoufrQ0QYbzwbYWF1l+M1NvnjD74o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=fLjFdtZ5Gg+yJ8AjICPxqUxB6WC78Ba/9Wdeu/CU0rHEaRy2QOQZAKe06jFr3sFPr
	 HOspFqK39AQDvAF281BCt9UISCoA9YvqtZOkWhxigSqXXiPjAHLDc/yEcMTcrLolnV
	 nXg/drilMLJjHWHEXfZMmEzWU2wuyhbSzMJW1egs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfCSTp1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Mar 2019 15:45:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:45190 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726768AbfCSTp1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Mar 2019 15:45:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=iLxXno5LFjdUhYCPy4rb2jumE2aeX6JskxmeuiZIt8o=; b=ln8tPrBVwTCeqXHHfaf0Ka3ct4
        3KK9dkGg6JdJ42dirdd2Hk7f4+0Y2seP/L0jmtnjHQl1OwS7gSGOCjFf84HyEmMyZLIB+WQ8gQUbd
        p2losTuPsjPgKaP2nTTfsstBHHxPGfCBEb9z2ehLDlCPJWnpISoEd7V0ObFSccqZIoCS8j/CbQ04Y
        bhfQsQBJaPztxpucGFVcVefxyTbQQvsW1v83kQUoO3rruMjRabKyxRJJa4L2wuYBFSN6+wa+HLzD8
        3htcNU5n9dcS+JPjULDdhZ7Fhx3ZJv4j45zJ0ZdFUiIR4CSsLAslDYDC5pGZtSOnTpAMi0GpdNFkJ
        u9tSx2rA==;
Received: from [179.95.24.146] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1h6Kfq-0000hx-6O; Tue, 19 Mar 2019 19:45:24 +0000
Date:   Tue, 19 Mar 2019 16:45:16 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Gregor Jasny <gjasny@googlemail.com>
Cc:     Sean Young <sean@mess.org>,
        CHEMLA Samuel <chemla.samuel@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [Bug report] dvbv5-zap crash dvb-tool ARMHF builds
Message-ID: <20190319164507.7f95af89@coco.lan>
In-Reply-To: <20190317065242.137cb095@coco.lan>
References: <f4b69417-06c3-f9ab-2973-ae23d76088b8@gmail.com>
        <29bad771-843c-1dee-906c-6e9475aed7d8@gmail.com>
        <d291e164-993f-232a-f01b-0f8c17087004@googlemail.com>
        <20190315223425.hiq3qcjhjnirsizh@gofer.mess.org>
        <20190317065242.137cb095@coco.lan>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Gregor,

Samuel reported in priv that the issues he had with user after free were
solved by the patchsets merged at 1.12 and 1.16 stable branches.

Could you please generate a new staging release for them?

Thanks!
Mauro

Em Sun, 17 Mar 2019 06:52:42 -0300
Mauro Carvalho Chehab <mchehab+samsung@kernel.org> escreveu:

> Em Fri, 15 Mar 2019 22:34:25 +0000
> Sean Young <sean@mess.org> escreveu:
> 
> > Hi,
> > 
> > On Tue, Mar 12, 2019 at 04:07:23PM +0100, Gregor Jasny wrote:  
> > > Hello Mauro,
> > > 
> > > below you find a bug report about an use-after-free in dvbv5-zap.
> > > 
> > > On 12.03.19 13:37, CHEMLA Samuel wrote:    
> > > > please find a bug report that seems to concern ARMHF builds of dvbv5-zap
> > > > (dvb-tool package) : https://bugs.launchpad.net/raspbian/+bug/1819650
> > > > I filed it against raspbian because I thought it was a raspbian problem,
> > > > but don't think they re-build their own package, but use debian ones
> > > > instead...    
> > >     
> > 
> > So I can reproduce the issue with v4l-utils 1.12.3 but not with current
> > v4l-utils (or dvbv5-zap). It looks exactly like the issue fixed in
> > commit 6e21f6f34c1d7c3a7a059062e1ddd9705c984e2c (but I did not cherry-pick
> > and test that on top of 1.12.3 to test that theory).  
> 
> I added it to stable/1.12 and another patch fixing the initialization of 
> the parameters struct, with Samuel reported to fix the issue upstream
> (He pinged me in priv too, and I'm helping him to track it).
> 
> Samuel,
> 
> Could you please check if the 1.12 stable branch is OK now?
> 
> Regards,
> Mauro
> Thanks,
> Mauro



Thanks,
Mauro
