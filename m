Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8AEBC43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 19:00:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B45BE206BB
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 19:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546974007;
	bh=9hvIMqiFdLSd2C/rkAsaVu+OCNpNe2Cp9NTQR/OhWLc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=KNk8HAphO5hEtKZ/HLDw1cN9k2IOzSPelvkRwd2ULe/K0HK6ZjrD6R03E4BFNYzYR
	 HThgS27J/+g3HxBQ8Ldtnh2luX9aQF+QBcv37ztpiOZUQ4s5qvjeBWd7gVGg0Yc3U6
	 4Dde9JCMbYkY1jzM3++uH7Ta02JsdqVIxnPDx6YA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbfAHTAG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 14:00:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:56750 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727947AbfAHTAG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 14:00:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=bf0kDfzoG8GP/gKj91+34l+yy+Fgumrdc7Hnie3pSBU=; b=dV8wCS9RXyCqgLz1RrO90Uj1Rm
        FA/5Zr2NiZoFl45smbnu/2pXMuov0mdhP6tdsKxTs8Oqq6HdFDDDefAVLAwjKwSuiM/t9d8+qcIiG
        KPbG41RmVnimF5Ye0vjG87nBsGV5gBKpmeQflahtvdRSCVh0grJHduHvwrYAg3fKeud78PVEFiDtB
        LqwIfe7U1s1k6rhn0YUHmLWR4x8q5aV36FzzxLGUuZoLt443T82KPD2IeaPPjpn1C/610PSZAg8rV
        yl2eyMwMbyP7sga/CaLsknmd6bxccAVHMrE35XFjUp8lfELmYFIZ/BrAT4CVQ8artcBUwN6kuHe9D
        C65eiwoA==;
Received: from 177.41.113.230.dynamic.adsl.gvt.net.br ([177.41.113.230] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1ggwbc-0004bV-Bf; Tue, 08 Jan 2019 19:00:05 +0000
Date:   Tue, 8 Jan 2019 17:00:00 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Subject: Re: Kernel error "Unknown pixelformat 0x00000000" occurs when I
 start capture video
Message-ID: <20190108170000.4f0d6e6d@coco.lan>
In-Reply-To: <20190108164916.55aa9b93@coco.lan>
References: <CABXGCsNxy8-PUPhSSZ3MwUhHixE_R0R-jCw8yGfN88fSu-CXLw@mail.gmail.com>
        <386743082.UsI2JZZ8BA@avalon>
        <CABXGCsPfQY6HCJzN1+iX6qFBCnWpJzgT9bJttpD7z23B=qvOGg@mail.gmail.com>
        <32231660.SI74LuYRbz@avalon>
        <CABXGCsOMdyzXACZa9T1OdUmDhNPDK=cX+DfBCAnY2A4aozCFHA@mail.gmail.com>
        <20190108164916.55aa9b93@coco.lan>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Tue, 8 Jan 2019 16:49:16 -0200
Mauro Carvalho Chehab <mchehab+samsung@kernel.org> escreveu:

> Em Tue, 8 Jan 2019 21:11:41 +0500
> Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com> escreveu:
> 
> > On Tue, 8 Jan 2019 at 20:57, Laurent Pinchart
> > <laurent.pinchart@ideasonboard.com> wrote:  
> > >
> > > Thank you.
> > >
> > > Your device exposes five formats: YUY2 (YUYV), YV12 (YVU420), NV12, P010 and
> > > BGR3 (BGR24). They are all supported by V4L2 and the uvcvideo driver except
> > > for the P010 format. This would be easy to fix in the uvcvideo driver if it
> > > wasn't for the fact that the P010 format isn't support by V4L2. Adding support
> > > for it isn't difficult, but I don't have time to do this myself at the moment.
> > > Would you consider volunteering if I guide you ? :-)
> > >    
> > 
> > Sure, I'd be happy to help. What is required of me?  
> 
> It shouldn't be hard. 
> 
> First, you need to add the new format at include/uapi/linux/videodev2.h,
> like this one:
> 
> 	#define V4L2_PIX_FMT_YUV420M v4l2_fourcc('Y', 'M', '1', '2') /* 12  YUV420 planar */
> 
> Please put it together with the other YUV formats.
> 
> As the fourcc "P010" was not used on Linux yet, you could use it,
> e. g., something like:
> 
> 	#define V4L2_PIX_FMT_YUV_P10 v4l2_fourcc('P', '0', '1', '0') /* 10  YUV420 planar */
> 
> You need then to document it. Each V4L2 format should have a description, 
> like this:
> 
> 	https://linuxtv.org/downloads/v4l-dvb-apis-new/uapi/v4l/pixfmt-yuv420m.html
> 
> This is generated via a text file (using ReST syntax). On the above example,
> it is produced by this file:
> 
> 	https://git.linuxtv.org/media_tree.git/tree/Documentation/media/uapi/v4l/pixfmt-yuv420m.rst
> 
> Writing it would take a little more time, but, provided that you don't 
> copy what's written from external docs, you could take a look at the
> Internet for the P010 descriptions, and use the pixfmt-yuy420m.rst file
> as the basis for a new pixfmt-p010.rst file.
> 
> This will produce a patch similar to this one:
> 
> 	https://git.linuxtv.org/media_tree.git/commit/?id=5df082e2312c
> 
> Finally, you need to teach the uvc driver that it should report P010
> format, instead of 0x00000000, by adding it at uvc_format_desc uvc_fmts,
> with the corresponding UVC GUID. We usually do this on a separate patch.
> Something like this:

> 	https://git.linuxtv.org/media_tree.git/commit/?id=6ea0d588d35b
Sorry. Wrong link. Please ignore it.

I meant to say, instead:
	https://git.linuxtv.org/media_tree.git/commit/?id=557a5c7fe6503230f6a3a41441981aed6e897d17

> 
> Once you have the patches, submit it to the ML :-)
> 
> You could take a look at the LinuxTV wiki page about how to submit,
> at the developer's section:
> 
> 	https://linuxtv.org/wiki/index.php/Developer_section
> 
> In particular, take a look at "Submitting Your Work" section there.
> 
> Thanks,
> Mauro



Thanks,
Mauro
