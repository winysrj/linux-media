Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04593C04EB8
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 07:57:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD8F720855
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 07:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544428673;
	bh=wsf8jNmMgLKWvILkaGZR20nYpi8sZwmMk5suHOyxyKg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=XoH6b7gW5Raxho0epO/EzIjbDeHZ/+s+Mn6AEbhelWzIDFgjxP4JVZioYmVr8MWuJ
	 SzZ+bWiCBvoYqGIs1IdGXG8Avn0B7BEhiGzfY3lIAgKhCQtJlq6CvpBxH+6TLKFUbF
	 IJVSS+Q4utmTJX6CMsC8/XyYRpmDx7qQR/K6UjG0=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD8F720855
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726176AbeLJH5w (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 02:57:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:37954 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbeLJH5w (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 02:57:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=HC2sJVIcd693iZwWIXb8RE3SPde3l2FmRswGorGWFGk=; b=O0NJcdZ2Vo+ck37Mh1wZOVLGq8
        WrDn9kK4VcTe0xCovnoT5m4DO0F6JM7ODg29Og2xfaNJNxnmwG5woFdAcdM8h5MGIHTD7lc7wVueN
        kJ4tfIq4WGMDSCicrovvx+dM+RiIiAJNI8304ooCozu5vArWR401MpLZNUBg4Ni0qBcLBiBPJjaTm
        B/u8t2dg0favrvj+QPuX4egAI0Po1rwSWCm0Oz4VK1eUjLZVMiFIVyG/iAf0Jrx0WZSw57HGMjqJK
        W03U1DUvbG2Q21GE4HSticw/uQ1dx7lbyhYx6ySxMxxlKGPrAhxKI74EiOza1cI70RYxG9olN8ANs
        AzqlP9RQ==;
Received: from [191.33.136.50] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gWGRl-0005zL-TP; Mon, 10 Dec 2018 07:57:46 +0000
Date:   Mon, 10 Dec 2018 05:57:40 -0200
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Tomasz Figa <tfiga@chromium.org>
Cc:     hverkuil-cisco@xs4all.nl,
        Alexandre Courbot <acourbot@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        nicolas@ndufresne.ca, Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Invite for IRC meeting: Re: [PATCHv4 01/10] videodev2.h: add
 tag support
Message-ID: <20181210055740.6563e8a0@coco.lan>
In-Reply-To: <CAAFQd5BiL9EG5CgkSUhrSpCW+KGK4s2XZxTCnBw+RaE1sRf+vw@mail.gmail.com>
References: <20181205102040.11741-1-hverkuil-cisco@xs4all.nl>
        <20181205102040.11741-2-hverkuil-cisco@xs4all.nl>
        <dee778ea-89d5-ddaf-c5d9-6423b7dee005@xs4all.nl>
        <CAAFQd5Bshhc+npq8VgFWpOOvoc-ym8xytF4n49ZSe4iTGMnkAg@mail.gmail.com>
        <B8C205F2-A5EA-4502-B2D0-2B5A592C31FD@osg.samsung.com>
        <27D09D62-E6F0-4F22-94F4-E253FE5B45ED@kernel.org>
        <CAAFQd5BiL9EG5CgkSUhrSpCW+KGK4s2XZxTCnBw+RaE1sRf+vw@mail.gmail.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Tomasz,

I mean Wed morning on my TZ, with would be Wed late afternoon on your TZ :-)

As Hans pointed, we are at UTC-2 (Brazil), UTC+1 (Europe CET)
and UTC+9 (Japan). Hans is proposing to have it 9am UTC.

E, g:

	https://www.timeanddate.com/worldclock/meetingdetails.html?year=2018&month=12&day=12&hour=9&min=0&sec=0&p1=45&p2=101&p3=248

Regards,
Mauro



Em Mon, 10 Dec 2018 15:11:26 +0900
Tomasz Figa <tfiga@chromium.org> escreveu:

> Hi Mauro,
> 
> On Mon, Dec 10, 2018 at 1:31 PM Mauro Carvalho Chehab
> <mchehab@kernel.org> wrote:
> >
> > In time: please reply to mchehab@kernel.org.
> >
> >
> >
> > Em 10 de dezembro de 2018 02:28:21 BRST, Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:  
> >>
> >> Let's do it on Wed.
> >>
> >> I'm very busy on Monday and Tuesday.  
> 
> Do you mean Wednesday in your time zone? If so, that would be Thursday
> for Europe and Asia.
> 
> Regardless of that, it should work for me.
> 
> Best regards,
> Tomasz
> 
> >>
> >> Regards,
> >> Mauro
> >>
> >> Em 10 de dezembro de 2018 01:18:38 BRST, Tomasz Figa <tfiga@chromium.org> escreveu:  
> >>>
> >>> Hi Hans,
> >>>
> >>> On Fri, Dec 7, 2018 at 12:08 AM Hans Verkuil <hverkuil-cisco@xs4all.nl> wrote:  
> >>>>
> >>>>
> >>>>  Mauro raised a number of objections on irc regarding tags:
> >>>>
> >>>>  https://linuxtv.org/irc/irclogger_log/media-maint?date=2018-12-06,Thu
> >>>>
> >>>>  I would like to setup an irc meeting to discuss this and come to a
> >>>>  conclusion, since we need to decide this soon since this is critical
> >>>>  for stateless codec support.
> >>>>
> >>>>  Unfortunately timezone-wise this is a bit of a nightmare. I think
> >>>>  that at least Mauro, myself and Tomasz Figa should be there, so UTC-2,
> >>>>  UTC+1 and UTC+9 (if I got that right).
> >>>>
> >>>>  I propose 9 AM UTC which I think will work for everyone except Nicolas.
> >>>>  Any day next week works for me, and (for now) as well for Mauro. Let's pick
> >>>>  Monday to start with, and if you want to join in, then let me know. If that
> >>>>  day doesn't work for you, let me know what other days next week do work for
> >>>>  you.  
> >>>
> >>>
> >>> 9am UTC (which should be 6pm JST)  works for me on any day this week.
> >>>
> >>> Best regards,
> >>> Tomasz
> >>>  
> >>>>
> >>>>  Regards,
> >>>>
> >>>>          Hans
> >>>>
> >>>>  On 12/05/18 11:20, hverkuil-cisco@xs4all.nl wrote:  
> >>>>>
> >>>>>  From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> >>>>>
> >>>>>  Add support for 'tags' to struct v4l2_buffer. These can be used
> >>>>>  by m2m devices so userspace can set a tag for an output buffer and
> >>>>>  this value will then be copied to the capture buffer(s).
> >>>>>
> >>>>>  This tag can be used to refer to capture buffers, something that
> >>>>>  is needed by stateless HW codecs.
> >>>>>
> >>>>>  The new V4L2_BUF_CAP_SUPPORTS_TAGS capability indicates whether
> >>>>>  or not tags are supported.
> >>>>>
> >>>>>  Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> >>>>>  Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> >>>>>  Reviewed-by: Alexandre Courbot <acourbot@chromium.org>
> >>>>> ________________________________
> >>>>>   include/uapi/linux/videodev2.h | 9 ++++++++-
> >>>>>   1 file changed, 8 insertions(+), 1 deletion(-)
> >>>>>
> >>>>>  diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> >>>>>  index 2db1635de956..9095d7abe10d 100644
> >>>>>  --- a/include/uapi/linux/videodev2.h
> >>>>>  +++ b/include/uapi/linux/videodev2.h
> >>>>>  @@ -881,6 +881,7 @@ struct v4l2_requestbuffers {
> >>>>>   #define V4L2_BUF_CAP_SUPPORTS_DMABUF (1 << 2)
> >>>>>   #define V4L2_BUF_CAP_SUPPORTS_REQUESTS       (1 << 3)
> >>>>>   #define V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS (1 << 4)
> >>>>>  +#define V4L2_BUF_CAP_SUPPORTS_TAGS   (1 << 5)
> >>>>>
> >>>>>   /**
> >>>>>    * struct v4l2_plane - plane info for multi-planar buffers
> >>>>>  @@ -940,6 +941,7 @@ struct v4l2_plane {
> >>>>>    * @length:  size in bytes of the buffer (NOT its payload) for single-plane
> >>>>>    *           buffers (when type != *_MPLANE); number of elements in the
> >>>>>    *           planes array for multi-plane buffers
> >>>>>  + * @tag:     buffer tag
> >>>>>    * @request_fd: fd of the request that this buffer should use
> >>>>>    *
> >>>>>    * Contains data exchanged by application and driver using one of the Streaming
> >>>>>  @@ -964,7 +966,10 @@ struct v4l2_buffer {
> >>>>>                __s32           fd;
> >>>>>        } m;
> >>>>>        __u32                   length;
> >>>>>  -     __u32                   reserved2;
> >>>>>  +     union {
> >>>>>  +             __u32           reserved2;
> >>>>>  +             __u32           tag;
> >>>>>  +     };
> >>>>>        union {
> >>>>>                __s32           request_fd;
> >>>>>                __u32           reserved;
> >>>>>  @@ -990,6 +995,8 @@ struct v4l2_buffer {
> >>>>>   #define V4L2_BUF_FLAG_IN_REQUEST             0x00000080
> >>>>>   /* timecode field is valid */
> >>>>>   #define V4L2_BUF_FLAG_TIMECODE                       0x00000100
> >>>>>  +/* tag field is valid */
> >>>>>  +#define V4L2_BUF_FLAG_TAG                    0x00000200
> >>>>>   /* Buffer is prepared for queuing */
> >>>>>   #define V4L2_BUF_FLAG_PREPARED                       0x00000400
> >>>>>   /* Cache handling flags */
> >>>>>  
> >>>>  
> >
> > --
> >
> > Sent from my Android device with K-9 Mail. Please excuse my brevity.  



Thanks,
Mauro
