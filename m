Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5081FC43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 18:49:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 245AC20827
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 18:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546973366;
	bh=AsQY+3gjCTqOumZxVzn0aXwjO9eCpQizUUzA7OF/B4M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=P7Y7DxIgSV7iwwdzAw973I+o43bK3kghmnQGKj2vE6B/1Zx+sXYVIeE2fezut1H1B
	 QrGjW68AlB2VfL9dbk2gwBnsEAj6SmMAdS4amap0IUtg1+DK1W9oNzUNHvQHH3022L
	 9rYWPdDeH0t3dpOC1Kf9/RkBWbfYNC+8jmS8YDrY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbfAHStZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 13:49:25 -0500
Received: from casper.infradead.org ([85.118.1.10]:55992 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727829AbfAHStZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 13:49:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6lExWkuQjrMMKa/msQhHJQCpUBgjycvpg3BX+QN+CT0=; b=vQ9ChDQwC1mpDn14EWwHQRk5S8
        x53NpvX6pwYi34ZnfOYlV1f/TFu7fyR8QwIHl/Ld/hwughCMkd9k3u0tknLH+B/F6xZGRyUDGYg5w
        vT+vEDEE60hto12qy4pjtVTTfCMEO9n2ut76TeAT4R3VV+ustTJGbuD0K6QEhixJahoiDqssZ7ydx
        z8Sf7/AXxQPCqdZG06lWavFgBrgdxPk5iIIy2/p/JKDcqUv2GmbRYIgUXRO2PvR2q39WUHh7a+qV6
        X840yxo/VXq8JJ6VjNW2Yacn5GbXU69aH/CeaArUZ1eNECsKIk9RRcU2663L6TPW2lnTMhHvXk8t2
        9Xdn/w2w==;
Received: from 177.41.113.230.dynamic.adsl.gvt.net.br ([177.41.113.230] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1ggwRG-000466-D3; Tue, 08 Jan 2019 18:49:22 +0000
Date:   Tue, 8 Jan 2019 16:49:16 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Subject: Re: Kernel error "Unknown pixelformat 0x00000000" occurs when I
 start capture video
Message-ID: <20190108164916.55aa9b93@coco.lan>
In-Reply-To: <CABXGCsOMdyzXACZa9T1OdUmDhNPDK=cX+DfBCAnY2A4aozCFHA@mail.gmail.com>
References: <CABXGCsNxy8-PUPhSSZ3MwUhHixE_R0R-jCw8yGfN88fSu-CXLw@mail.gmail.com>
        <386743082.UsI2JZZ8BA@avalon>
        <CABXGCsPfQY6HCJzN1+iX6qFBCnWpJzgT9bJttpD7z23B=qvOGg@mail.gmail.com>
        <32231660.SI74LuYRbz@avalon>
        <CABXGCsOMdyzXACZa9T1OdUmDhNPDK=cX+DfBCAnY2A4aozCFHA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Tue, 8 Jan 2019 21:11:41 +0500
Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com> escreveu:

> On Tue, 8 Jan 2019 at 20:57, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
> >
> > Thank you.
> >
> > Your device exposes five formats: YUY2 (YUYV), YV12 (YVU420), NV12, P010 and
> > BGR3 (BGR24). They are all supported by V4L2 and the uvcvideo driver except
> > for the P010 format. This would be easy to fix in the uvcvideo driver if it
> > wasn't for the fact that the P010 format isn't support by V4L2. Adding support
> > for it isn't difficult, but I don't have time to do this myself at the moment.
> > Would you consider volunteering if I guide you ? :-)
> >  
> 
> Sure, I'd be happy to help. What is required of me?

It shouldn't be hard. 

First, you need to add the new format at include/uapi/linux/videodev2.h,
like this one:

	#define V4L2_PIX_FMT_YUV420M v4l2_fourcc('Y', 'M', '1', '2') /* 12  YUV420 planar */

Please put it together with the other YUV formats.

As the fourcc "P010" was not used on Linux yet, you could use it,
e. g., something like:

	#define V4L2_PIX_FMT_YUV_P10 v4l2_fourcc('P', '0', '1', '0') /* 10  YUV420 planar */

You need then to document it. Each V4L2 format should have a description, 
like this:

	https://linuxtv.org/downloads/v4l-dvb-apis-new/uapi/v4l/pixfmt-yuv420m.html

This is generated via a text file (using ReST syntax). On the above example,
it is produced by this file:

	https://git.linuxtv.org/media_tree.git/tree/Documentation/media/uapi/v4l/pixfmt-yuv420m.rst

Writing it would take a little more time, but, provided that you don't 
copy what's written from external docs, you could take a look at the
Internet for the P010 descriptions, and use the pixfmt-yuy420m.rst file
as the basis for a new pixfmt-p010.rst file.

This will produce a patch similar to this one:

	https://git.linuxtv.org/media_tree.git/commit/?id=5df082e2312c

Finally, you need to teach the uvc driver that it should report P010
format, instead of 0x00000000, by adding it at uvc_format_desc uvc_fmts,
with the corresponding UVC GUID. We usually do this on a separate patch.
Something like this:

	https://git.linuxtv.org/media_tree.git/commit/?id=6ea0d588d35b

Once you have the patches, submit it to the ML :-)

You could take a look at the LinuxTV wiki page about how to submit,
at the developer's section:

	https://linuxtv.org/wiki/index.php/Developer_section

In particular, take a look at "Submitting Your Work" section there.

Thanks,
Mauro
