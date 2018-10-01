Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:46906 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728921AbeJASkR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 1 Oct 2018 14:40:17 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: Re: [RFC] V4L2_PIX_FMT_MJPEG vs V4L2_PIX_FMT_JPEG
Date: Mon, 01 Oct 2018 15:03:04 +0300
Message-ID: <1670593.gmhJL1mYtv@avalon>
In-Reply-To: <71200c21-1073-789c-aa94-813042afc352@xs4all.nl>
References: <03c10b29-6ead-1aa2-334a-c6357004a5ac@xs4all.nl> <2438028.OjeO6a9KTA@avalon> <71200c21-1073-789c-aa94-813042afc352@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday, 1 October 2018 14:54:29 EEST Hans Verkuil wrote:
> On 10/01/2018 01:48 PM, Laurent Pinchart wrote:
> > On Monday, 1 October 2018 11:43:04 EEST Hans Verkuil wrote:
> >> It turns out that we have both JPEG and Motion-JPEG pixel formats
> >> defined.
> >> 
> >> Furthermore, some drivers support one, some the other and some both.
> >> 
> >> These pixelformats both mean the same.
> > 
> > Do they ? I thought MJPEG was JPEG using fixed Huffman tables that were
> > not included in the JPEG headers.
> 
> I'm not aware of any difference. If there is one, then it is certainly not
> documented.

What I can tell for sure is that many UVC devices don't include Huffman tables 
in their JPEG headers.

> Ezequiel, since you've been working with this recently, do you know anything
> about this?

-- 
Regards,

Laurent Pinchart
