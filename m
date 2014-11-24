Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:61357 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaKXJ5I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Nov 2014 04:57:08 -0500
Received: by mail-oi0-f48.google.com with SMTP id u20so6251748oif.7
        for <linux-media@vger.kernel.org>; Mon, 24 Nov 2014 01:57:07 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 24 Nov 2014 09:57:07 +0000
Message-ID: <CAPuGpVx8QrWe4gJr5UVDU8KDh0_pNSabLr0GuVfY7kpuQVGR=g@mail.gmail.com>
Subject: bttv:The output of card name is truncated to 32 characters
From: triniton adam <trinitonadam@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When use struct v4l2_capability to get out card name in bttv the
output of card name is truncated to 32 characters.
I use this code to get card name:

    char *v4l2_get_name(char *device)
    {
        struct v4l2_capability caps;

        if ((fd = open(device, O_RDONLY)) < 0)
            goto err;

        if (ioctl(fd, VIDIOC_QUERYCAP, &caps) < 0) {
            perror("VIDIOC_QUERYCAP");
            goto err;
        }
        close(fd);

        return strndup((char *)caps.card, sizeof(caps.card));

    err:
        if (fd >= 0)
            close(dev->fd);
        fd = -1;

        return NULL;
    }

print truncated card name output (example for card=165):

    BT878 video (Kworld V-Stream XP

instade of full card name:

    Kworld V-Stream Xpert TV PVR878

I here same way to get full card name?
