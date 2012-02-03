Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34095 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab2BCPsU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Feb 2012 10:48:20 -0500
Received: by vcge1 with SMTP id e1so2665785vcg.19
        for <linux-media@vger.kernel.org>; Fri, 03 Feb 2012 07:48:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F212167.9090607@samsung.com>
References: <1327326675-8431-1-git-send-email-t.stanislaws@samsung.com>
 <1327326675-8431-6-git-send-email-t.stanislaws@samsung.com> <4F212167.9090607@samsung.com>
From: Pawel Osciak <pawel@osciak.com>
Date: Fri, 3 Feb 2012 07:47:39 -0800
Message-ID: <CAMm-=zCfNVP497-4o7FUOjkcQW7F2RPhuPO62YrwK9C_1Z+ctQ@mail.gmail.com>
Subject: Re: [PATCH 05/10] v4l: add buffer exporting via dmabuf
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	sumit.semwal@ti.com, jesse.barker@linaro.org, rob@ti.com,
	daniel@ffwll.ch, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,
I like the direction in which you are going with the userspace
handling. This is almost exactly as I envisioned it. I have one
comment though:

On Thu, Jan 26, 2012 at 01:48, Tomasz Stanislawski
<t.stanislaws@samsung.com> wrote:

[snip]

>        /* setup polling */
>        struct pollfd fds[2] = {
>                { .fd = f_in, .events = POLLIN },
>                { .fd = f_out, .events = POLLOUT },
>        };
>
>        while ((ret = poll(fds, 2, 5000)) > 0) {
>                struct v4l2_buffer buf;
>                struct v4l2_plane plane;
>
>                memset(&buf, 0, sizeof buf);
>                memset(&plane, 0, sizeof plane);
>                buf.m.planes = &plane;
>                buf.length = 1;
>
>                if (fds[0].revents & POLLIN) {
>                        /* dequeue buffer */
>                        buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
>                        buf.memory = V4L2_MEMORY_MMAP;
>                        ret = ioctl(f_in, VIDIOC_DQBUF, &buf);
>                        BYE_ON(ret, "VIDIOC_DQBUF failed: %s\n", ERRSTR);
>
>                        /* enqueue buffer */
>                        buf.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
>                        buf.memory = V4L2_MEMORY_DMABUF;
>                        plane.m.fd = fd[buf.index];
>                        ret = ioctl(f_out, VIDIOC_QBUF, &buf);
>                        BYE_ON(ret, "VIDIOC_QBUF failed: %s\n", ERRSTR);
>                }

This passes fd, so the OUTPUT driver will get the correct buffer from dmabuf.

>                if (fds[1].revents & POLLOUT) {
>                        /* dequeue buffer */
>                        buf.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
>                        buf.memory = V4L2_MEMORY_DMABUF;
>                        ret = ioctl(f_out, VIDIOC_DQBUF, &buf);
>                        BYE_ON(ret, "VIDIOC_DQBUF failed: %s\n", ERRSTR);
>
>                        /* enqueue buffer */
>                        buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
>                        buf.memory = V4L2_MEMORY_MMAP;
>                        ret = ioctl(f_in, VIDIOC_QBUF, &buf);
>                        BYE_ON(ret, "VIDIOC_QBUF failed: %s\n", ERRSTR);
>                }

This, however, relies on the indexes to be equal for the same
buffers/planes in both drivers. I don't see why we should restrict
ourselves to that. In fact, we must not. You should have a reverse
mapping of fd->index for the INPUT device and use the fd returned in
buf by DQBUF from OUTPUT device to look-up the correct index to be
passed to the INPUT device.

>        }
>
>        BYE_ON(ret == 0, "polling timeout\n");
>        BYE_ON(1, "polling stopped: %s\n", ERRSTR);
>
>        return 0;
> }



-- 
Best regards,
Pawel Osciak
