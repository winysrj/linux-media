Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BDE6C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 12:20:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3E9F20665
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 12:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730566AbfAIMUU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 07:20:20 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47380 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727828AbfAIMUT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Jan 2019 07:20:19 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 10FAE634C7F;
        Wed,  9 Jan 2019 14:19:01 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1ghCp2-0002Z1-Ai; Wed, 09 Jan 2019 14:19:00 +0200
Date:   Wed, 9 Jan 2019 14:19:00 +0200
From:   Sakari Ailus <sakari.ailus@iki.fi>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Subject: Re: Kernel error "Unknown pixelformat 0x00000000" occurs when I
 start capture video
Message-ID: <20190109121900.hbrpttmxz3gaotwx@valkosipuli.retiisi.org.uk>
References: <CABXGCsNxy8-PUPhSSZ3MwUhHixE_R0R-jCw8yGfN88fSu-CXLw@mail.gmail.com>
 <386743082.UsI2JZZ8BA@avalon>
 <CABXGCsPfQY6HCJzN1+iX6qFBCnWpJzgT9bJttpD7z23B=qvOGg@mail.gmail.com>
 <32231660.SI74LuYRbz@avalon>
 <CABXGCsOMdyzXACZa9T1OdUmDhNPDK=cX+DfBCAnY2A4aozCFHA@mail.gmail.com>
 <20190108164916.55aa9b93@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190108164916.55aa9b93@coco.lan>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Jan 08, 2019 at 04:49:16PM -0200, Mauro Carvalho Chehab wrote:
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

There is some work done on this but it's not finished; searching "P010" in
Patchwork yields this:

<URL:https://patchwork.linuxtv.org/patch/39752/>

Just FYI.

> 
> This will produce a patch similar to this one:
> 
> 	https://git.linuxtv.org/media_tree.git/commit/?id=5df082e2312c
> 
> Finally, you need to teach the uvc driver that it should report P010
> format, instead of 0x00000000, by adding it at uvc_format_desc uvc_fmts,
> with the corresponding UVC GUID. We usually do this on a separate patch.
> Something like this:
> 
> 	https://git.linuxtv.org/media_tree.git/commit/?id=6ea0d588d35b
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

-- 
Sakari Ailus
