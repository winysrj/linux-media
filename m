Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00252a01.pphosted.com ([91.207.212.211]:48472 "EHLO
        mx08-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726027AbeJAX60 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 Oct 2018 19:58:26 -0400
Received: from pps.filterd (m0102629.ppops.net [127.0.0.1])
        by mx08-00252a01.pphosted.com (8.16.0.23/8.16.0.23) with SMTP id w91HIlRi003618
        for <linux-media@vger.kernel.org>; Mon, 1 Oct 2018 18:19:36 +0100
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
        by mx08-00252a01.pphosted.com with ESMTP id 2mt048h79k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Mon, 01 Oct 2018 18:19:36 +0100
Received: by mail-pf1-f198.google.com with SMTP id b22-v6so8006234pfc.18
        for <linux-media@vger.kernel.org>; Mon, 01 Oct 2018 10:19:36 -0700 (PDT)
MIME-Version: 1.0
References: <03c10b29-6ead-1aa2-334a-c6357004a5ac@xs4all.nl>
 <2438028.OjeO6a9KTA@avalon> <71200c21-1073-789c-aa94-813042afc352@xs4all.nl>
 <1670593.gmhJL1mYtv@avalon> <177bb7e7efe18c4026c1e44b9cd9f73dc8352561.camel@collabora.com>
In-Reply-To: <177bb7e7efe18c4026c1e44b9cd9f73dc8352561.camel@collabora.com>
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
Date: Mon, 1 Oct 2018 18:19:21 +0100
Message-ID: <CAAoAYcN7XyjHtHMg9_Z_vpnT_wjp6EUU=MTUZZmb2uwpVfZ52w@mail.gmail.com>
Subject: Re: [RFC] V4L2_PIX_FMT_MJPEG vs V4L2_PIX_FMT_JPEG
To: ezequiel@collabora.com
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

On Mon, 1 Oct 2018 at 17:32, Ezequiel Garcia <ezequiel@collabora.com> wrote:
>
> Hi Hans,
>
> Thanks for looking into. I remember MJPEG vs. JPEG being a source
> of confusion for me a few years ago, so clarification is greatly
> welcome :-)
>
> On Mon, 2018-10-01 at 15:03 +0300, Laurent Pinchart wrote:
> > Hi Hans,
> >
> > On Monday, 1 October 2018 14:54:29 EEST Hans Verkuil wrote:
> > > On 10/01/2018 01:48 PM, Laurent Pinchart wrote:
> > > > On Monday, 1 October 2018 11:43:04 EEST Hans Verkuil wrote:
> > > > > It turns out that we have both JPEG and Motion-JPEG pixel formats
> > > > > defined.
> > > > >
> > > > > Furthermore, some drivers support one, some the other and some both.
> > > > >
> > > > > These pixelformats both mean the same.
> > > >
> > > > Do they ? I thought MJPEG was JPEG using fixed Huffman tables that were
> > > > not included in the JPEG headers.
> > >
> > > I'm not aware of any difference. If there is one, then it is certainly not
> > > documented.
> >
> > What I can tell for sure is that many UVC devices don't include Huffman tables
> > in their JPEG headers.
> >
> > > Ezequiel, since you've been working with this recently, do you know anything
> > > about this?
> >
> >
>
> JPEG frames must include huffman and quantization tables, as per the standard.
>
> AFAIK, there's no MJPEG specification per-se and vendors specify its own
> way of conveying a Motion JPEG stream.

There is the specfication for MJPEG in Quicktime containers, which
defines the MJPEG-A and MJPEG-B variants [1].
MJPEG-B is not a concatenation of JPEG frames as the framing is
different, so can't really be combined into V4L2_PIX_FMT_JPEG.
Have people encountered devices that produce MJPEG-A or MJPEG-B via
V4L2? I haven't, but I have been forced to support both variants on
decode.

On that thought, whilst capture devices generally don't care, is there
a need to differentiate for M2M codec devices which can support
encoding the variants? Or likewise on M2M decoders that support only
JPEG, how do they tell userspace that they don't support MJPEG-A or
MJPEG-B?

  Dave

[1] https://developer.apple.com/standards/qtff-2001.pdf

> For instance, omiting the huffman table seems to be a vendor thing. Microsoft
> explicitly omits the huffman tables from each frame:
>
> https://www.fileformat.info/format/bmp/spec/b7c72ebab8064da48ae5ed0c053c67a4/view.htm
>
> Others could be following the same things.
>
> Like I mentioned before, Gstreamer always check for missing huffman table
> and adds one if missing. Gstreamer has other quirks for missing markers,
> e.g. deal with a missing EOI:
>
> https://github.com/GStreamer/gst-plugins-good/commit/10ff3c8e14e8fba9e0a5d696dce0bea27de644d7
>
> I think Hans suggestion of settling on JPEG makes sense and it would
> be consistent with Gstreamer. Otherwise, we should specify exactly what we
> understand by MJPEG, but I don't think it's worth it.
>
> Thanks,
> Ezequiel
