Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:34056 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab2DMQb0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Apr 2012 12:31:26 -0400
Received: from epcpsbgm1.samsung.com (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0M2F00GTWF8BNA40@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Sat, 14 Apr 2012 01:31:24 +0900 (KST)
Received: from AMDN157 ([106.116.48.215])
 by mmp2.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0M2F0050DF881420@mmp2.samsung.com>
 for linux-media@vger.kernel.org; Sat, 14 Apr 2012 01:31:24 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: Andrzej Hajda <a.hajda@samsung.com>, linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Sakari Ailus' <sakari.ailus@iki.fi>,
	'Hans Verkuil' <hverkuil@xs4all.nl>
References: <1334051442-28359-1-git-send-email-a.hajda@samsung.com>
In-reply-to: <1334051442-28359-1-git-send-email-a.hajda@samsung.com>
Subject: RE: [RFC/PATCH] v4l: added V4L2_BUF_FLAG_EOS flag indicating the last
 frame in the stream
Date: Fri, 13 Apr 2012 18:31:19 +0200
Message-id: <003801cd1992$ddcece50$996c6af0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> Sent: 10 April 2012 11:51
> 
> v4l: added V4L2_BUF_FLAG_EOS flag indicating the last frame in the stream
> 
> Some devices requires indicator if the buffer is the last one in the
> stream.
> Applications and drivers can use this flag in such case.
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> 
> Hello,
> 
> This patch adds new v4l2_buffer flag V4L2_BUF_FLAG_EOS. This flag is set
> by applications on the output buffer to indicate the last buffer of the
> stream.
> 
> Some devices (eg. s5p_mfc) requires presence of the end-of-stream
> indicator
> together with the last buffer.
> Common practice of sending empty buffer to indicate end-of-strem do not
> work in
> such case.
> 
> I would like to ask for review and comments.
> 
> Apologies for duplicated e-mails - sendmail problems.
> 
> Regards
> Andrzej Hajda
> 

[snip]

Maybe I could throw some more light at the problem.

The problem is that when the encoding is done it is necessary to mark the
last frame of the video that is encoded. It is needed because the hardware
may need to return some encoded buffers that are kept in the hardware.

Why the buffers are kept in hardware one might ask? The answer to this
question is following. The video frames are enqueued in MFC in presentation
order and the encoded frames are dequeued in decoding order.

Let's see an example:
			           1234567
The presentation order is:   IBBPBBP--
The decoding order here is:  --IPBBPBB
(the P frames have to be decoded before B frames as B frames reference
both preceding and following frame; when no B frames are used then
there is no delay)

So there is a delay of two buffers returned on the CAPTURE side to the
OUTPUT queue. After the last frame is encoded these buffers have to be
returned to the user. Our hardware needs to know that it is the last frame
before it is encoded, so the idea is to add a flag that would mark the
buffer as the last one.

The flag could also be used to mark the last frame during decoding - now
it is done by setting bytesused to 0. The EOS flag could be used in addition
to that.

Comments are welcome.

Best wishes,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center

