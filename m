Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f53.google.com ([209.85.219.53]:45187 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbaCJQN1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 12:13:27 -0400
Received: by mail-oa0-f53.google.com with SMTP id j17so7000496oag.26
        for <linux-media@vger.kernel.org>; Mon, 10 Mar 2014 09:13:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <531D67EC.4030202@xs4all.nl>
References: <CABMudhTQDPTy9x1nZw1XCcyLb8ETn4dtMW2+=Am_0KOBf-v7wA@mail.gmail.com>
	<531D67EC.4030202@xs4all.nl>
Date: Mon, 10 Mar 2014 09:13:27 -0700
Message-ID: <CABMudhR_e7pftOs8JL-3Wibe=dT-Y1vDzPxsLewAz0q7TSaedg@mail.gmail.com>
Subject: Re: Question about set format call check for vb2_is_busy
From: m silverstri <michael.j.silverstri@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 10, 2014 at 12:21 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 03/10/2014 08:02 AM, m silverstri wrote:
>> Hi,
>>
>> I am studying v4l2 m2m driver example. I want to know why the set
>> format function in the example fails when it is called again after
>> user application req_buf? In set format function checks for
>> vb2_is_busy(vq) and that function returns true after user space app
>> calls req_buf.
>>
>> For example in here:
>> http://stuff.mit.edu/afs/sipb/contrib/linux/drivers/media/platform/mem2mem_testdev.c
>>
>> static int vidioc_s_fmt(struct m2mtest_ctx *ctx, struct v4l2_format *f)
>> {
>> //...
>> // Check for vb2_is_busy() here:
>> if (vb2_is_busy(vq)) {
>> v4l2_err(&ctx->dev->v4l2_dev, "%s queue busy\n", __func__);
>> return -EBUSY;
>> }
>> //...
>> }
>>
>> Why the driver prevents user space application change format after it
>> request buffers?
>
> When you request the buffers they will be allocated based on the current format.
> Changing the format later will mean a change in buffer size, but once the buffers
> are allocated that is locked in place. It's generally a bad idea to, say, increase
> the image size and then watch how DMA overwrites your memory :-)
>
> This is not strictly speaking a v4l limitation, but a limitation of almost all
> hardware. It is possible to allow format changes after reqbufs is called, but
> that generally requires that the buffers all have the maximum possible size
> which wastes a lot of memory. And in addition you would have to have some sort
> of metadata as part of the captured frame so you know the actual size of the
> image stored in the buffer.
>
> None of the drivers in the kernel support this, BTW.
>
> Regards,
>
>         Hans

Hans,

Thank you.

Regards,
Mike
