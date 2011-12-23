Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62136 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757624Ab1LWS5X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Dec 2011 13:57:23 -0500
Received: by vcbfk14 with SMTP id fk14so7490928vcb.19
        for <linux-media@vger.kernel.org>; Fri, 23 Dec 2011 10:57:22 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 24 Dec 2011 00:27:22 +0530
Message-ID: <CAD6K1_OqO37F6omqDGHbn2D9pCBi9bmodQkmwNy_1WYyrksL6Q@mail.gmail.com>
Subject: Multiple channel capture support in V4l2 layer
From: Dilip Mannil <mannil.dilip@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I am trying to implement v4l2 slave driver for  ML86V76654  digital
video decoder that converts NTSC, PAL, SECAM analog video signals into
the YCbCr standard digital format. This codec takes 4 analog inputs(2
analog camera + 2 ext video in) and encodes in to digital(only one at
a time).

The driver should be able to switch between capture channels upon
request from user space application.

I couldn't find the support for multiple capture channels on a single
device in v4l2 layer. Please correct me if I am wrong.

Ideally I want the v4l2 slave driver to have following feature.

1. ioctl that can be used to enumerate/get/set the  capture channels
on the video encoder.
2. Able to capture video from the currently set capture channel and
pass to higher layers.

Which is the best way to implement this support?

Regards,
Dilip
