Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B58A5C04EB8
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 06:11:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66EA62084E
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 06:11:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="nSTybpQS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 66EA62084E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbeLJGLl (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 01:11:41 -0500
Received: from mail-yb1-f172.google.com ([209.85.219.172]:35601 "EHLO
        mail-yb1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbeLJGLl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 01:11:41 -0500
Received: by mail-yb1-f172.google.com with SMTP id z2-v6so4787976ybj.2
        for <linux-media@vger.kernel.org>; Sun, 09 Dec 2018 22:11:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yFcKeFD/K9u6B0zd3tWE7xBzBMi6adgOcqB2FAhtjH4=;
        b=nSTybpQSdxXYHd2z+uQfJ2N/7Efh+3qilqEASFhK7KuTzIoqvqFoxJL6oxKJGp+5T7
         cDAF6H+oTNNRFZsfql1DzQ+/q3vRjJQu4hWpQFN432BmyFuV6LNC4giUMpeLVImr4lxv
         iFqKnF26gytVigNwu1tIns+rvZo2rGURET5GQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yFcKeFD/K9u6B0zd3tWE7xBzBMi6adgOcqB2FAhtjH4=;
        b=uelhn6vajNNfSARqiF93g2NtkQI+9Kn88r0SuyY+sAs2FY5SSNJcyZaPPRdBbZ7fin
         2gbLD8Iw/9KxJP4rUt4OsFeSgkFM6URH0GRbTjYpXOX9sWINKGxdrgt4tkiYuhRX6+eH
         d210OM8Yc/uK+7OTF4ko97qPn4ghT2CJafm0o16w+3DpApGhdTuz+QxSG8iiPtlB7Hul
         eB88cJfH8ZpfkzpU2pLT6bzflVUOE1cADcjLFAlnJgdc8VgZ9TMmv2RGwDBtXi/OnUG7
         k8Jsy7EOBi4wIKg1hfqM0Bfh56ewyz5b5j1e1szhUydgiaB114joH8R797ClVISlTLFD
         7wtA==
X-Gm-Message-State: AA+aEWaNsqtmNMom/setEfSlQHql2Vc4fgl9YkcJHoVdjkv6YREnLyug
        ULvgXXFF2SLJcLlK3HSOnkou3yS6Gm48dA==
X-Google-Smtp-Source: AFSGD/WlHwjSkftiDKnn/YLfFn0gsvXoQiBwlnduxP0wH2RGLj3pxGIh6SjMNIucALInZaiSYLQAhA==
X-Received: by 2002:a25:53c8:: with SMTP id h191-v6mr10496450ybb.169.1544422299484;
        Sun, 09 Dec 2018 22:11:39 -0800 (PST)
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com. [209.85.219.174])
        by smtp.gmail.com with ESMTPSA id p3sm3398329ywc.14.2018.12.09.22.11.37
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Dec 2018 22:11:38 -0800 (PST)
Received: by mail-yb1-f174.google.com with SMTP id f9so1232482ybm.13
        for <linux-media@vger.kernel.org>; Sun, 09 Dec 2018 22:11:37 -0800 (PST)
X-Received: by 2002:a25:a44:: with SMTP id 65-v6mr10709150ybk.373.1544422297486;
 Sun, 09 Dec 2018 22:11:37 -0800 (PST)
MIME-Version: 1.0
References: <20181205102040.11741-1-hverkuil-cisco@xs4all.nl>
 <20181205102040.11741-2-hverkuil-cisco@xs4all.nl> <dee778ea-89d5-ddaf-c5d9-6423b7dee005@xs4all.nl>
 <CAAFQd5Bshhc+npq8VgFWpOOvoc-ym8xytF4n49ZSe4iTGMnkAg@mail.gmail.com>
 <B8C205F2-A5EA-4502-B2D0-2B5A592C31FD@osg.samsung.com> <27D09D62-E6F0-4F22-94F4-E253FE5B45ED@kernel.org>
In-Reply-To: <27D09D62-E6F0-4F22-94F4-E253FE5B45ED@kernel.org>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Mon, 10 Dec 2018 15:11:26 +0900
X-Gmail-Original-Message-ID: <CAAFQd5BiL9EG5CgkSUhrSpCW+KGK4s2XZxTCnBw+RaE1sRf+vw@mail.gmail.com>
Message-ID: <CAAFQd5BiL9EG5CgkSUhrSpCW+KGK4s2XZxTCnBw+RaE1sRf+vw@mail.gmail.com>
Subject: Re: Invite for IRC meeting: Re: [PATCHv4 01/10] videodev2.h: add tag support
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     hverkuil-cisco@xs4all.nl,
        Alexandre Courbot <acourbot@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        nicolas@ndufresne.ca, Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro,

On Mon, Dec 10, 2018 at 1:31 PM Mauro Carvalho Chehab
<mchehab@kernel.org> wrote:
>
> In time: please reply to mchehab@kernel.org.
>
>
>
> Em 10 de dezembro de 2018 02:28:21 BRST, Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:
>>
>> Let's do it on Wed.
>>
>> I'm very busy on Monday and Tuesday.

Do you mean Wednesday in your time zone? If so, that would be Thursday
for Europe and Asia.

Regardless of that, it should work for me.

Best regards,
Tomasz

>>
>> Regards,
>> Mauro
>>
>> Em 10 de dezembro de 2018 01:18:38 BRST, Tomasz Figa <tfiga@chromium.org> escreveu:
>>>
>>> Hi Hans,
>>>
>>> On Fri, Dec 7, 2018 at 12:08 AM Hans Verkuil <hverkuil-cisco@xs4all.nl> wrote:
>>>>
>>>>
>>>>  Mauro raised a number of objections on irc regarding tags:
>>>>
>>>>  https://linuxtv.org/irc/irclogger_log/media-maint?date=2018-12-06,Thu
>>>>
>>>>  I would like to setup an irc meeting to discuss this and come to a
>>>>  conclusion, since we need to decide this soon since this is critical
>>>>  for stateless codec support.
>>>>
>>>>  Unfortunately timezone-wise this is a bit of a nightmare. I think
>>>>  that at least Mauro, myself and Tomasz Figa should be there, so UTC-2,
>>>>  UTC+1 and UTC+9 (if I got that right).
>>>>
>>>>  I propose 9 AM UTC which I think will work for everyone except Nicolas.
>>>>  Any day next week works for me, and (for now) as well for Mauro. Let's pick
>>>>  Monday to start with, and if you want to join in, then let me know. If that
>>>>  day doesn't work for you, let me know what other days next week do work for
>>>>  you.
>>>
>>>
>>> 9am UTC (which should be 6pm JST)  works for me on any day this week.
>>>
>>> Best regards,
>>> Tomasz
>>>
>>>>
>>>>  Regards,
>>>>
>>>>          Hans
>>>>
>>>>  On 12/05/18 11:20, hverkuil-cisco@xs4all.nl wrote:
>>>>>
>>>>>  From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>>>>>
>>>>>  Add support for 'tags' to struct v4l2_buffer. These can be used
>>>>>  by m2m devices so userspace can set a tag for an output buffer and
>>>>>  this value will then be copied to the capture buffer(s).
>>>>>
>>>>>  This tag can be used to refer to capture buffers, something that
>>>>>  is needed by stateless HW codecs.
>>>>>
>>>>>  The new V4L2_BUF_CAP_SUPPORTS_TAGS capability indicates whether
>>>>>  or not tags are supported.
>>>>>
>>>>>  Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>>>>>  Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
>>>>>  Reviewed-by: Alexandre Courbot <acourbot@chromium.org>
>>>>> ________________________________
>>>>>   include/uapi/linux/videodev2.h | 9 ++++++++-
>>>>>   1 file changed, 8 insertions(+), 1 deletion(-)
>>>>>
>>>>>  diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
>>>>>  index 2db1635de956..9095d7abe10d 100644
>>>>>  --- a/include/uapi/linux/videodev2.h
>>>>>  +++ b/include/uapi/linux/videodev2.h
>>>>>  @@ -881,6 +881,7 @@ struct v4l2_requestbuffers {
>>>>>   #define V4L2_BUF_CAP_SUPPORTS_DMABUF (1 << 2)
>>>>>   #define V4L2_BUF_CAP_SUPPORTS_REQUESTS       (1 << 3)
>>>>>   #define V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS (1 << 4)
>>>>>  +#define V4L2_BUF_CAP_SUPPORTS_TAGS   (1 << 5)
>>>>>
>>>>>   /**
>>>>>    * struct v4l2_plane - plane info for multi-planar buffers
>>>>>  @@ -940,6 +941,7 @@ struct v4l2_plane {
>>>>>    * @length:  size in bytes of the buffer (NOT its payload) for single-plane
>>>>>    *           buffers (when type != *_MPLANE); number of elements in the
>>>>>    *           planes array for multi-plane buffers
>>>>>  + * @tag:     buffer tag
>>>>>    * @request_fd: fd of the request that this buffer should use
>>>>>    *
>>>>>    * Contains data exchanged by application and driver using one of the Streaming
>>>>>  @@ -964,7 +966,10 @@ struct v4l2_buffer {
>>>>>                __s32           fd;
>>>>>        } m;
>>>>>        __u32                   length;
>>>>>  -     __u32                   reserved2;
>>>>>  +     union {
>>>>>  +             __u32           reserved2;
>>>>>  +             __u32           tag;
>>>>>  +     };
>>>>>        union {
>>>>>                __s32           request_fd;
>>>>>                __u32           reserved;
>>>>>  @@ -990,6 +995,8 @@ struct v4l2_buffer {
>>>>>   #define V4L2_BUF_FLAG_IN_REQUEST             0x00000080
>>>>>   /* timecode field is valid */
>>>>>   #define V4L2_BUF_FLAG_TIMECODE                       0x00000100
>>>>>  +/* tag field is valid */
>>>>>  +#define V4L2_BUF_FLAG_TAG                    0x00000200
>>>>>   /* Buffer is prepared for queuing */
>>>>>   #define V4L2_BUF_FLAG_PREPARED                       0x00000400
>>>>>   /* Cache handling flags */
>>>>>
>>>>
>
> --
>
> Sent from my Android device with K-9 Mail. Please excuse my brevity.
