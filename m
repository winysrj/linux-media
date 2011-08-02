Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56996 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab1HBL7b (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Aug 2011 07:59:31 -0400
Received: by ywn13 with SMTP id 13so1264778ywn.19
        for <linux-media@vger.kernel.org>; Tue, 02 Aug 2011 04:59:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E37C7D7.40301@samsung.com>
References: <4E37C7D7.40301@samsung.com>
Date: Tue, 2 Aug 2011 20:59:30 +0900
Message-ID: <CAHQjnONh3=dRfL-_6gBT2pa=erRKUe9OMiMQjXDQyN493Gz4tw@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] Buffer sharing proof-of-concept
From: KyongHo Cho <pullip.cho@samsung.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi.

On Tue, Aug 2, 2011 at 6:48 PM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> Hello Everyone,
>
> This patchset introduces the proof-of-concept infrastructure for buffer
> sharing between multiple devices using file descriptors. The infrastructure
> has been integrated with V4L2 framework, more specifically videobuf2 and two
> S5P drivers FIMC (capture interface) and TV drivers, but it can be easily
> used by other kernel subsystems, like DRI.
>
> In this patch the buffer object has been simplified to absolute minimum - it
> contains only the buffer physical address (only physically contiguous
> buffers are supported), but this can be easily extended to complete scatter
> list in the future.
>

Is this patch set an attempt to share a buffer between different
processes via open file descriptors?
Your patches seems to include several constructs to pack information
about a buffer in an open file descriptor
and to unpack it.

I don't have any idea what is the purpose of your attempts.
Is it the first step to the unified memory model that is being
discussed in Linaro?

Regards,
Cho KyongHo.
