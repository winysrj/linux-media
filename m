Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wj0-f177.google.com ([209.85.210.177]:34935 "EHLO
        mail-wj0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752020AbcK0R6u (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 27 Nov 2016 12:58:50 -0500
Received: by mail-wj0-f177.google.com with SMTP id v7so97560908wjy.2
        for <linux-media@vger.kernel.org>; Sun, 27 Nov 2016 09:58:50 -0800 (PST)
MIME-Version: 1.0
From: Luis de Arquer <ldearquer@gmail.com>
Date: Sun, 27 Nov 2016 18:58:48 +0100
Message-ID: <CAGqyy=ZDCukwEYSytfnYbVncYzc=R8BM50Oz0kixSoPumBL8Tg@mail.gmail.com>
Subject: VIDIOC_QUERYCTRL ioctl( ) failing with errno 5 (EIO, Input/output error)
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

When making a VIDIOC_QUERYCTRL ioctl( ) call on a UVC video capture
device (USB camera), occasionally I get an Input/Output error
(errno=5, EIO). However, it is not defined as a possible returned
error either in the VIDIOC_QUERYCTRL docs here

https://linuxtv.org/downloads/v4l-dvb-apis/uapi/v4l/vidioc-queryctrl.html

, nor as a generic error for ioctl( ) calls or for v4l2 calls. After
digging in the code, it looks that this ioctl( ) eventually makes a
USB request and calls usb_start_wait_urb( ), which, I guess, is what
ends up returning EIO if something goes wrong.

So my question is, shouldn't this be documented in the link above? At
least for the UVC case?

Luis
