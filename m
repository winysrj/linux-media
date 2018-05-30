Return-path: <linux-media-owner@vger.kernel.org>
Received: from 11pmail.ess.barracuda.com ([64.235.150.228]:49440 "EHLO
        11pmail.ess.barracuda.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932268AbeE3VU1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 17:20:27 -0400
From: Greg Wilson-Lindberg <GWilson@sakuraus.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: mmap permissions failure on Raspberry Pi
Date: Wed, 30 May 2018 21:05:13 +0000
Message-ID: <55cd45a324714ce692154d8475c85bac@sakuraus.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm trying to use c++ to open a raspberry pi camera using v4l2. I found several examples that follow a standard set of operations:

open up the device (in my case /dev/video0)
using ioctl calls query capabilities and formats
set video format
request a buffer
query the buffer
and finally mmap the buffer

Everything works properly, I can open the device, query all of the capabilities and formats, set the format needed, request the buffer and query the buffer.
When I try to mmap the buffer I get permission denied. Here is the call I'm using:

buffer = (qint8 *)mmap(NULL, buf.length, PROT_READ | PROT_WRITE, MAP_SHARED, camera->handle(), buf.m.offset);

This is the same as the examples that I have seen. Also, I have tried it on both the Raspberry Pi camera and on a webcam. 
I've checked the group and permissions for the /dev/video0 and /dev/shm and I don't see anything wrong. I even tried running my program as root with the same result.

I'm obviously missing something, but I don't see what it could be. Any help would be greatly appreciated.

Regards,
Greg Wilson-Lindberg
