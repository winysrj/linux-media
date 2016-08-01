Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f181.google.com ([209.85.217.181]:33666 "EHLO
	mail-ua0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445AbcHARUx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Aug 2016 13:20:53 -0400
Received: by mail-ua0-f181.google.com with SMTP id k90so111044149uak.0
        for <linux-media@vger.kernel.org>; Mon, 01 Aug 2016 10:20:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1771120.d40lGdzCeM@avalon>
References: <36bf3ef2-e43a-3910-16e2-b51439be5622@igel.co.jp>
 <1677075.k8UG1Er7L0@avalon> <b3161f8d-b958-41ca-f0e6-65a16c63f22c@xs4all.nl> <1771120.d40lGdzCeM@avalon>
From: Steven Toth <stoth@kernellabs.com>
Date: Mon, 1 Aug 2016 12:16:25 -0400
Message-ID: <CALzAhNX-AhiaVJ3UrTodHRZg__h5itwCqwJw9FhhJoT_K4sp5w@mail.gmail.com>
Subject: Re: Memory freeing when dmabuf fds are exported with VIDIOC_EXPBUF
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Kazunori Kobayashi <kkobayas@igel.co.jp>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Damian Hobson-Garcia <dhobsong@igel.co.jp>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> That's a good question. On one extreme an application trying to allocate 32
> 50MB buffers would seem suspicious to me, but on the other hand it would be
> difficult to answer the question in a way that can be translated into code.

8k video in the ARGB 8bit 4:4:4 colorspace, would need a 126MB per frame buffer.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
