Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F351C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 16:42:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2991C20859
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 16:42:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfAIQmj convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 11:42:39 -0500
Received: from kozue.soulik.info ([108.61.200.231]:41570 "EHLO
        kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726571AbfAIQmj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 11:42:39 -0500
Received: from [192.168.0.49] (unknown [192.168.0.49])
        by kozue.soulik.info (Postfix) with ESMTPSA id DC64C100C2B;
        Thu, 10 Jan 2019 01:43:21 +0900 (JST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: P010 fourcc format support - Was: Re: Kernel error "Unknown pixelformat 0x00000000" occurs when I start capture video
From:   Ayaka <ayaka@soulik.info>
X-Mailer: iPad Mail (16A404)
In-Reply-To: <20190109110155.39a185de@coco.lan>
Date:   Thu, 10 Jan 2019 00:42:32 +0800
Cc:     Sakari Ailus <sakari.ailus@iki.fi>,
        Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <0F13FA85-843C-43A6-ADFA-03C789D60120@soulik.info>
References: <CABXGCsNxy8-PUPhSSZ3MwUhHixE_R0R-jCw8yGfN88fSu-CXLw@mail.gmail.com> <386743082.UsI2JZZ8BA@avalon> <CABXGCsPfQY6HCJzN1+iX6qFBCnWpJzgT9bJttpD7z23B=qvOGg@mail.gmail.com> <32231660.SI74LuYRbz@avalon> <CABXGCsOMdyzXACZa9T1OdUmDhNPDK=cX+DfBCAnY2A4aozCFHA@mail.gmail.com> <20190108164916.55aa9b93@coco.lan> <20190109121900.hbrpttmxz3gaotwx@valkosipuli.retiisi.org.uk> <20190109110155.39a185de@coco.lan>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



Sent from my iPad

> On Jan 9, 2019, at 9:01 PM, Mauro Carvalho Chehab <mchehab+samsung@kernel.org> wrote:
> 
> Em Wed, 9 Jan 2019 14:19:00 +0200
> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> 
>>> On Tue, Jan 08, 2019 at 04:49:16PM -0200, Mauro Carvalho Chehab wrote:
>>> Em Tue, 8 Jan 2019 21:11:41 +0500
>>> Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com> escreveu:
>>> 
>>>> On Tue, 8 Jan 2019 at 20:57, Laurent Pinchart
>>>> <laurent.pinchart@ideasonboard.com> wrote:  
>>>>> 
>>>>> Thank you.
>>>>> 
>>>>> Your device exposes five formats: YUY2 (YUYV), YV12 (YVU420), NV12, P010 and
>>>>> BGR3 (BGR24). They are all supported by V4L2 and the uvcvideo driver except
>>>>> for the P010 format. This would be easy to fix in the uvcvideo driver if it
>>>>> wasn't for the fact that the P010 format isn't support by V4L2. Adding support
>>>>> for it isn't difficult, but I don't have time to do this myself at the moment.
>>>>> Would you consider volunteering if I guide you ? :-)
>>>>> 
>>>> 
>>>> Sure, I'd be happy to help. What is required of me?  
>>> 
>>> It shouldn't be hard. 
>>> 
>>> First, you need to add the new format at include/uapi/linux/videodev2.h,
>>> like this one:
>>> 
>>>    #define V4L2_PIX_FMT_YUV420M v4l2_fourcc('Y', 'M', '1', '2') /* 12  YUV420 planar */
>>> 
>>> Please put it together with the other YUV formats.
>>> 
>>> As the fourcc "P010" was not used on Linux yet, you could use it,
>>> e. g., something like:
>>> 
>>>    #define V4L2_PIX_FMT_YUV_P10 v4l2_fourcc('P', '0', '1', '0') /* 10  YUV420 planar */
>>> 
>>> You need then to document it. Each V4L2 format should have a description, 
>>> like this:
>>> 
>>>    https://linuxtv.org/downloads/v4l-dvb-apis-new/uapi/v4l/pixfmt-yuv420m.html
>>> 
>>> This is generated via a text file (using ReST syntax). On the above example,
>>> it is produced by this file:
>>> 
>>>    https://git.linuxtv.org/media_tree.git/tree/Documentation/media/uapi/v4l/pixfmt-yuv420m.rst
>>> 
>>> Writing it would take a little more time, but, provided that you don't 
>>> copy what's written from external docs, you could take a look at the
>>> Internet for the P010 descriptions, and use the pixfmt-yuy420m.rst file
>>> as the basis for a new pixfmt-p010.rst file.  
>> 
>> There is some work done on this but it's not finished; searching "P010" in
>> Patchwork yields this:
>> 
>> <URL:https://patchwork.linuxtv.org/patch/39752/>
> 
> Good point! I'm c/c the author of it.
> 
> The actual patch for media is this one:
> 
>    https://patchwork.linuxtv.org/patch/39753/
> 
> It sounds that the author didn't sent any version after that.
> 
> The goal seemed to be to add P010 support at DRM for the rockchip driver.
> 
> specifically with regards to patch 2/3, the issues seemed to be:
> 
>    - some naming issues with the multiplane format variants;
>    - a typo: simliar -> similar;
>    - a comment about the usage of 1/2 UTF code (½). Not sure if
>      Sphinx will handle it well for both html and pdf outputs.
>      It should, but better to double check.
> 
> Ayaka,
> 
> There is a UVC media device that supports P010 device. We're discussing
> about adding support for it on media. The full thread is at:
> 
> https://lore.kernel.org/linux-media/20190109121900.hbrpttmxz3gaotwx@valkosipuli.retiisi.org.uk/T/#m8c395156ca0e898e4c8b1e2c6309d912bc414804
> 
> We've seen that you tried to submit a patch series for DRM adding
> support for it at the rockship driver. What's the status of such
> series?
Rockchip would use another 10bit variant of NV12, which is merged as NV12LE40 at Gstreamer and I sent another patch for it, but I didn’t receive any feedback from that.
> 
> Thanks,
> Mauro

