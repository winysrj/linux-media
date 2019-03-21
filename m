Return-Path: <SRS0=WMbR=RY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44BB6C43381
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 11:30:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15367218E2
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 11:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553167853;
	bh=EmPTr5B+2KUpMZreQB2G+20Eyu25Gi4G1N9g0VvBE/4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=vJ5lBFkEHX5dCui5yrBlNFqpqzShw5VkvlB9MGoL1bpbM1xLVE59C8nsLMI5CSSEm
	 T4YTvjTrIvc3dYGXDfD4ogkTDcXOrhpLWrAhs9iyOQrSFbgBXfEtBlom20dcKAquQz
	 HNDcGHmnAoanoZ14kwgUt6bqV/jGJSTV4ucoQ2dI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbfCULaw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Mar 2019 07:30:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:48760 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfCULaw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Mar 2019 07:30:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=zkqkHwrHNTmZX7NakDUOYW6MWAE8GQQZXkOTo1+phCw=; b=p9rw2ibqL+36nOvq9ZZzvJvwU1
        O3m0muSRtiVj7MpT8U7YDUz9wOBp6OWdbiPTRvAKqHM2xf+vpEiXVr/V95N6G/rdC7WlqDbhfZNmc
        2fTZcpbgQHU6j49702tSPto2HSOjl6C/FnhCqFxRnvRJNQRaCWMXw+1M33KcadoEmSygU5S6K4shd
        WYYJsDZ9kqPXM5TtdHwF+/7IXRVGUn+q03oEi+cHtm/irSlLNkmvxnDDPeY6N51bCd14AKZiQH25Z
        ifybBNlXr8iLtpLrP0cEUVofxp4NZmqlHH+62ojCCO3om5TYscTwmKsZPvTaOeyP6mIJnX7weIM3F
        IRpk9BtQ==;
Received: from [179.95.24.146] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1h6vuK-0008P8-C5; Thu, 21 Mar 2019 11:30:49 +0000
Date:   Thu, 21 Mar 2019 08:30:44 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Sean Young <sean@mess.org>
Cc:     Gregor Jasny <gjasny@googlemail.com>,
        CHEMLA Samuel <chemla.samuel@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [Bug report] dvbv5-zap crash dvb-tool ARMHF builds
Message-ID: <20190321083044.621f1922@coco.lan>
In-Reply-To: <20190321094127.ysurm4u26zugmnmv@gofer.mess.org>
References: <f4b69417-06c3-f9ab-2973-ae23d76088b8@gmail.com>
        <29bad771-843c-1dee-906c-6e9475aed7d8@gmail.com>
        <d291e164-993f-232a-f01b-0f8c17087004@googlemail.com>
        <20190315223425.hiq3qcjhjnirsizh@gofer.mess.org>
        <20190317065242.137cb095@coco.lan>
        <20190319164507.7f95af89@coco.lan>
        <a1f296ba-3c27-ed2c-3912-4edbeeb21eba@googlemail.com>
        <20190321094127.ysurm4u26zugmnmv@gofer.mess.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Thu, 21 Mar 2019 09:41:28 +0000
Sean Young <sean@mess.org> escreveu:

> On Wed, Mar 20, 2019 at 08:38:52PM +0100, Gregor Jasny wrote:
> > Hello Mauro,
> > 
> > On 19.03.19 20:45, Mauro Carvalho Chehab wrote:
> > > Hi Gregor,
> > > 
> > > Samuel reported in priv that the issues he had with user after free were
> > > solved by the patchsets merged at 1.12 and 1.16 stable branches.
> > > 
> > > Could you please generate a new staging release for them?
> > 
> > Sure, I can create a new 1.12 and 1.16 stable release. But when reviewing
> > the patches for approval by debian release managers I noticed an additional
> > double-free that Sean addressed with the following patch:
> > 
> > > https://git.linuxtv.org/v4l-utils.git/commit/?id=ebd890019ba7383b8b486d829f6683c8f49fdbda
> > 
> > Could you please give that patch a thorough review, some testing, and
> > cherry-pick it to stable-1.12 and -1.16 as well?
> 
> I did test it myself (and also under valgrind). The bad paths are hard
> to hit though. I'd say just go ahead with merging and releasing, the patch
> isn't that controversial (I hope!).

I went ahead and cherry-picked the relevant patches to -1.12, -1.14 and
-1.16, and tested both dvbv5-zap and dvbv5-scan with all versions. So, we can
release a new minor version for all those stable branches.

After the patches, on my tests, I didn't get any memory leaks or
double-free issues.

It should be noticed that I had to add a new patch at -1.14, due to
the usage of minor() and major() macros, as one of the files there
were not including sys/sysmacros.h. Without that, I was getting
compilation errors.

Funny enough, this header was already included on two other places
within -1.14.

As the major() and minor() macros were added at glibc 2.3.3[1], released
in 2004 [2], it should be save to include sys/sysmacros.h
unconditionally at stable-1.14.

[1] according with "man 3 makedev", as pointed by:
https://stackoverflow.com/questions/22240973/major-and-minor-macros-defined-in-sys-sysmacros-h-pulled-in-by-iterator

[2] https://ftp.gnu.org/gnu/libc/'s glibc tarball is from 2004-08-03.

Thanks,
Mauro
