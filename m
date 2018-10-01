Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:53452 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725735AbeJAXKj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 1 Oct 2018 19:10:39 -0400
Message-ID: <177bb7e7efe18c4026c1e44b9cd9f73dc8352561.camel@collabora.com>
Subject: Re: [RFC] V4L2_PIX_FMT_MJPEG vs V4L2_PIX_FMT_JPEG
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Mon, 01 Oct 2018 13:31:54 -0300
In-Reply-To: <1670593.gmhJL1mYtv@avalon>
References: <03c10b29-6ead-1aa2-334a-c6357004a5ac@xs4all.nl>
         <2438028.OjeO6a9KTA@avalon>
         <71200c21-1073-789c-aa94-813042afc352@xs4all.nl>
         <1670593.gmhJL1mYtv@avalon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for looking into. I remember MJPEG vs. JPEG being a source
of confusion for me a few years ago, so clarification is greatly
welcome :-)

On Mon, 2018-10-01 at 15:03 +0300, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Monday, 1 October 2018 14:54:29 EEST Hans Verkuil wrote:
> > On 10/01/2018 01:48 PM, Laurent Pinchart wrote:
> > > On Monday, 1 October 2018 11:43:04 EEST Hans Verkuil wrote:
> > > > It turns out that we have both JPEG and Motion-JPEG pixel formats
> > > > defined.
> > > > 
> > > > Furthermore, some drivers support one, some the other and some both.
> > > > 
> > > > These pixelformats both mean the same.
> > > 
> > > Do they ? I thought MJPEG was JPEG using fixed Huffman tables that were
> > > not included in the JPEG headers.
> > 
> > I'm not aware of any difference. If there is one, then it is certainly not
> > documented.
> 
> What I can tell for sure is that many UVC devices don't include Huffman tables 
> in their JPEG headers.
> 
> > Ezequiel, since you've been working with this recently, do you know anything
> > about this?
> 
> 

JPEG frames must include huffman and quantization tables, as per the standard.

AFAIK, there's no MJPEG specification per-se and vendors specify its own
way of conveying a Motion JPEG stream.

For instance, omiting the huffman table seems to be a vendor thing. Microsoft
explicitly omits the huffman tables from each frame:

https://www.fileformat.info/format/bmp/spec/b7c72ebab8064da48ae5ed0c053c67a4/view.htm

Others could be following the same things.

Like I mentioned before, Gstreamer always check for missing huffman table
and adds one if missing. Gstreamer has other quirks for missing markers,
e.g. deal with a missing EOI:

https://github.com/GStreamer/gst-plugins-good/commit/10ff3c8e14e8fba9e0a5d696dce0bea27de644d7

I think Hans suggestion of settling on JPEG makes sense and it would
be consistent with Gstreamer. Otherwise, we should specify exactly what we
understand by MJPEG, but I don't think it's worth it.

Thanks,
Ezequiel
