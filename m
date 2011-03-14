Return-path: <mchehab@pedra>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:59466 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab1CNKtJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2011 06:49:09 -0400
Received: by qyg14 with SMTP id 14so4192223qyg.19
        for <linux-media@vger.kernel.org>; Mon, 14 Mar 2011 03:49:08 -0700 (PDT)
MIME-Version: 1.0
Reply-To: subash.rp@gmail.com
In-Reply-To: <4D7DEA68.2050604@samsung.com>
References: <4D7DEA68.2050604@samsung.com>
Date: Mon, 14 Mar 2011 16:19:08 +0530
Message-ID: <AANLkTimA070CdJxDR5A7Yq_e6cRG_0TUFG3Cf1VCBbCh@mail.gmail.com>
Subject: Re: [Query] VIDIOC_QBUF and VIDIOC_STREAMON order
From: Subash Patel <subashrp@gmail.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

VIDIOC_STREAMON expects buffers to be queued before hardware part of
image/video pipe is enabled. From my experience of V4L2 user space, I
have always QBUFfed before invoking the STREAMON. Below is the API
specification which also speaks something same:

http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-streamon.html

I think its better to return EINVAL if there are no queued buffers
when VIDIOC_STREAMON is invoked.

Regards,
Subash

On Mon, Mar 14, 2011 at 3:44 PM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:
> Hello,
>
> As far as I know V4L2 applications are allowed to call VIDIOC_STREAMON before
> queuing buffers with VIDIOC_QBUF.
>
> This leads to situation that a H/W is attempted to be enabled by the driver
> when it has no any buffer ownership.
>
> Effectively actual activation of the data pipeline has to be deferred
> until first buffer arrived in the driver. Which makes it difficult
> to signal any errors to user during enabling the data pipeline.
>
> Is this allowed to force applications to queue some buffers before calling
> STREAMON, by returning an error in vidioc_streamon from the driver, when
> no buffers have been queued at this time?
>
> I suppose this could render some applications to stop working if this kind
> of restriction is applied e.g. in camera capture driver.
>
> What the applications really expect?
>
> With the above I refer mostly to a snapshot mode where we have to be careful
> not to lose any frame, as there could be only one..
>
>
> Please share you opinions.
>
>
> Regards,
> --
> Sylwester Nawrocki
> Samsung Poland R&D Center
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
