Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33651 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab1J1BcO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Oct 2011 21:32:14 -0400
Received: by ggnb1 with SMTP id b1so3218826ggn.19
        for <linux-media@vger.kernel.org>; Thu, 27 Oct 2011 18:32:14 -0700 (PDT)
MIME-Version: 1.0
From: Gilles Gigan <gilles.gigan@gmail.com>
Date: Fri, 28 Oct 2011 12:31:53 +1100
Message-ID: <CAJWu0HN8WC-xfAy3cNnA_o3YPj7+9Eo5+YCvNtqRNs9dG18+8A@mail.gmail.com>
Subject: Switching input during capture
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I would like to know what is the correct way to switch the current
video input during capture on a card with a single BT878 chip and 4
inputs (http://store.bluecherry.net/products/PV%252d143-%252d-4-port-video-capture-card-%2830FPS%29-%252d-OEM.html).
I tried doing it in two ways:
- using VIDIOC_S_INPUT to change the current input. While this works,
the next captured frame shows video from the old input in its top half
and video from the new input in the bottom half.
- I tried setting the input field to the new input and flags to
V4L2_BUF_FLAG_INPUT in the struct v4l2_buffer passed to VIDIOC_QBUF
when enqueuing buffers. However, when doing so, the ioctl fails
altogether, and I cannot enqueue any buffers with the
V4L2_BUF_FLAG_INPUT flag set.
Is there another way of doing it ? or is there a way to synchronise
the input change (when using VIDIOC_S_INPUT) so it happens in between
2 frames and produces a clean switch ?
Thanks
Gilles
