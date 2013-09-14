Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2461 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756169Ab3INDWu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Sep 2013 23:22:50 -0400
Message-ID: <5233D681.4000802@xs4all.nl>
Date: Sat, 14 Sep 2013 05:22:41 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: vkalia@codeaurora.org
CC: linux-media@vger.kernel.org
Subject: Re: User data propagation for video codecs
References: <79eef80b5fa29d83a7ae9a3f7d83cea8.squirrel@www.codeaurora.org>
In-Reply-To: <79eef80b5fa29d83a7ae9a3f7d83cea8.squirrel@www.codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/13/2013 11:54 PM, vkalia@codeaurora.org wrote:
> Hi
>
> For video decoder, our video driver, which is V4l2 based, exposes two
> capabilities:
>
> 1. V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE for transaction of compressed buffers.
> 2. V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE for transaction of
> decoded/uncompressed buffers.
>
> We have a requirement to propagate "user specific data" from compressed
> buffer to uncompressed buffer. We are not able to find any field in
> "struct v4l2_buffer" which can be used for this purpose. Please suggest if
> this can be achieved with current V4L2 framework.

It depends how the user data is organized. If it is situated right
before the actual data, then the data_offset field of v4l2_plane can be
used. If it is an independent piece of data, then you can pass it on in
an additional plane.

Regards,

    Hans
