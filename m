Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44475 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbcHARIm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Aug 2016 13:08:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Steven Toth <stoth@kernellabs.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Kazunori Kobayashi <kkobayas@igel.co.jp>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Damian Hobson-Garcia <dhobsong@igel.co.jp>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: Memory freeing when dmabuf fds are exported with VIDIOC_EXPBUF
Date: Mon, 01 Aug 2016 19:56:33 +0300
Message-ID: <1625689.yhf3QdObg4@avalon>
In-Reply-To: <CALzAhNX-AhiaVJ3UrTodHRZg__h5itwCqwJw9FhhJoT_K4sp5w@mail.gmail.com>
References: <36bf3ef2-e43a-3910-16e2-b51439be5622@igel.co.jp> <1771120.d40lGdzCeM@avalon> <CALzAhNX-AhiaVJ3UrTodHRZg__h5itwCqwJw9FhhJoT_K4sp5w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 01 Aug 2016 12:16:25 Steven Toth wrote:
> > That's a good question. On one extreme an application trying to allocate
> > 32 50MB buffers would seem suspicious to me, but on the other hand it
> > would be difficult to answer the question in a way that can be translated
> > into code.
> 
> 8k video in the ARGB 8bit 4:4:4 colorspace, would need a 126MB per frame
> buffer.

Hopefully not 32 of them though.

There's no easy way to compute an accurate limit, but maybe we could do 
improve the current situation with some heuristics based on the maximum 
resolution a device can capture.

-- 
Regards,

Laurent Pinchart

