Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37108 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728807AbeIQWEn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Sep 2018 18:04:43 -0400
Received: by mail-wr1-f68.google.com with SMTP id u12-v6so17976129wrr.4
        for <linux-media@vger.kernel.org>; Mon, 17 Sep 2018 09:36:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9c33c57e-2ce2-8752-b851-f85c03a7d761@xs4all.nl>
References: <20180911150938.3844-1-mjourdan@baylibre.com> <9c33c57e-2ce2-8752-b851-f85c03a7d761@xs4all.nl>
From: Maxime Jourdan <mjourdan@baylibre.com>
Date: Mon, 17 Sep 2018 18:36:33 +0200
Message-ID: <CAMO6nay7u4nMZcND6+g-GJAFsFcGrp_GDKBhVjeXVzpjF0ND4Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] Add Amlogic video decoder driver
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018-09-17 16:51 GMT+02:00 Hans Verkuil <hverkuil@xs4all.nl>:
> On 09/11/2018 05:09 PM, Maxime Jourdan wrote:
>>  - Moved the single instance check (returning -EBUSY) to start/stop streaming
>>  The check was previously in queue_setup but there was no great location to
>>  clear it except for .close().
>
> Actually, you can clear it by called VIDIOC_REQBUFS with count set to 0. That
> freed all buffers and clears this.
>
> Now, the difference between queue_setup and start/stop streaming is that if you
> do this in queue_setup you'll know early on that the device is busy. It is
> reasonable to assume that you only allocate buffers when you also want to start
> streaming, so that it a good place to know this quickly.
>
> Whereas with start_streaming you won't know until you call STREAMON, or even later
> if you start streaming with no buffers queued, since start_streaming won't
> be called until you have at least 'min_buffers_needed' buffers queued (1 for this
> driver). So in that case EBUSY won't be returned until the first VIDIOC_QBUF.
>
> My preference is to check this in queue_setup, but it is up to you to decide.
> Just be aware of the difference between the two options.
>
> Regards,
>
>         Hans

I could for instance keep track of which queue(s) have been called
with queue_setup, catch calls to VIDIOC_REQBUFS with count set to 0,
and clear the current session once both queues have been reset ?

You leverage another issue with min_buffers_needed. It's indeed set to
1 but this value is wrong for the CAPTURE queue. The problem is that
this value changes depending on the codec and the amount of CAPTURE
buffers requested by userspace.
Ultimately I want it set to the total amount of CAPTURE buffers,
because the hardware needs the full buffer list before starting a
decode job.
Am I free to change this queue parameter later, or is m2m_queue_init
the only place to do it ?

Thanks,
Maxime
