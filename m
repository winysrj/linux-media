Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:38373 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbaCJHCk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 03:02:40 -0400
Received: by mail-ob0-f169.google.com with SMTP id va2so6562841obc.28
        for <linux-media@vger.kernel.org>; Mon, 10 Mar 2014 00:02:39 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 10 Mar 2014 00:02:39 -0700
Message-ID: <CABMudhTQDPTy9x1nZw1XCcyLb8ETn4dtMW2+=Am_0KOBf-v7wA@mail.gmail.com>
Subject: Question about set format call check for vb2_is_busy
From: m silverstri <michael.j.silverstri@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am studying v4l2 m2m driver example. I want to know why the set
format function in the example fails when it is called again after
user application req_buf? In set format function checks for
vb2_is_busy(vq) and that function returns true after user space app
calls req_buf.

For example in here:
http://stuff.mit.edu/afs/sipb/contrib/linux/drivers/media/platform/mem2mem_testdev.c

static int vidioc_s_fmt(struct m2mtest_ctx *ctx, struct v4l2_format *f)
{
//...
// Check for vb2_is_busy() here:
if (vb2_is_busy(vq)) {
v4l2_err(&ctx->dev->v4l2_dev, "%s queue busy\n", __func__);
return -EBUSY;
}
//...
}

Why the driver prevents user space application change format after it
request buffers?

Thank you.
