Return-Path: <SRS0=+2CU=RU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A104C4360F
	for <linux-media@archiver.kernel.org>; Sun, 17 Mar 2019 10:13:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08E3921019
	for <linux-media@archiver.kernel.org>; Sun, 17 Mar 2019 10:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552817632;
	bh=R45zHYJkslc5A3gTgwXVxAJYNng3pnx7vOW37OeA3PM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=BZciXL3yfBseeSQZGOyQVrAwU5RrdqfqaZA0irsqlggq77/o+UrzFKsCq2TRUeG5M
	 2XMqyGD/eClNklDgd+Kzc05B50NVxj5q4G/B7WQ8BSuERiPzftQmiZ72BzmBOfx91p
	 nAupFlsPRrCOUx9rtsReDdt3KK+JmaOP4PomNMuQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbfCQKNv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 17 Mar 2019 06:13:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:58106 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726058AbfCQKNu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Mar 2019 06:13:50 -0400
X-Greylist: delayed 1258 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Mar 2019 06:13:49 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Xsy8xaIJjqrTMkTg9fAMaEg4jkHLxa+gHbpWbr63U7A=; b=CnHn2yHonN5rwf39+/3JqRwLnr
        ePFXXt9tQENTWBBuu8ZY5uRU0Hlq4evCtCMKtwgwFPNCyyHG7DqgLTf40haKzad1B5L7RgzuTdrnl
        1amXt9NFw84f4lZQu/tKMZB+/Way00MBY1YFuJOwdw4QV07Woc8xv+9jjXjLs8oS0nsIzpgKfg+HZ
        zscyOGBJttWdnOGLQPx+NTGg121KvJ2gcVP4G2IXVyPz32GuW3eW2LvjJzy02Tl7Zp1vXJ6r/WCQh
        J04zSplRZJvDFhtAQc/dg3Zh5CFsipoQPo8Fi/q/Idt+HAwmC3bY3SaYRTFEsN/zZGjbslmsHjNgZ
        Z50LTs0A==;
Received: from 177.133.95.217.dynamic.adsl.gvt.net.br ([177.133.95.217] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1h5STH-0000iB-E1; Sun, 17 Mar 2019 09:52:48 +0000
Date:   Sun, 17 Mar 2019 06:52:42 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Sean Young <sean@mess.org>, CHEMLA Samuel <chemla.samuel@gmail.com>
Cc:     Gregor Jasny <gjasny@googlemail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [Bug report] dvbv5-zap crash dvb-tool ARMHF builds
Message-ID: <20190317065242.137cb095@coco.lan>
In-Reply-To: <20190315223425.hiq3qcjhjnirsizh@gofer.mess.org>
References: <f4b69417-06c3-f9ab-2973-ae23d76088b8@gmail.com>
        <29bad771-843c-1dee-906c-6e9475aed7d8@gmail.com>
        <d291e164-993f-232a-f01b-0f8c17087004@googlemail.com>
        <20190315223425.hiq3qcjhjnirsizh@gofer.mess.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Fri, 15 Mar 2019 22:34:25 +0000
Sean Young <sean@mess.org> escreveu:

> Hi,
> 
> On Tue, Mar 12, 2019 at 04:07:23PM +0100, Gregor Jasny wrote:
> > Hello Mauro,
> > 
> > below you find a bug report about an use-after-free in dvbv5-zap.
> > 
> > On 12.03.19 13:37, CHEMLA Samuel wrote:  
> > > please find a bug report that seems to concern ARMHF builds of dvbv5-zap
> > > (dvb-tool package) : https://bugs.launchpad.net/raspbian/+bug/1819650
> > > I filed it against raspbian because I thought it was a raspbian problem,
> > > but don't think they re-build their own package, but use debian ones
> > > instead...  
> >   
> 
> So I can reproduce the issue with v4l-utils 1.12.3 but not with current
> v4l-utils (or dvbv5-zap). It looks exactly like the issue fixed in
> commit 6e21f6f34c1d7c3a7a059062e1ddd9705c984e2c (but I did not cherry-pick
> and test that on top of 1.12.3 to test that theory).

I added it to stable/1.12 and another patch fixing the initialization of 
the parameters struct, with Samuel reported to fix the issue upstream
(He pinged me in priv too, and I'm helping him to track it).

Samuel,

Could you please check if the 1.12 stable branch is OK now?

Regards,
Mauro
Thanks,
Mauro
