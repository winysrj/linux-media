Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46618 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab1JXDZs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Oct 2011 23:25:48 -0400
Received: by gyb13 with SMTP id 13so5325230gyb.19
        for <linux-media@vger.kernel.org>; Sun, 23 Oct 2011 20:25:47 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 24 Oct 2011 11:25:47 +0800
Message-ID: <CABbt3s68q_jKf9bHPT8kuaB6donrAzmucJJseWNiX88qud273g@mail.gmail.com>
Subject: Reqbufs(0) need to release queued_list
From: Angela Wan <angela.j.wan@gmail.com>
To: pawel@osciak.com, m.szyprowski@samsung.com
Cc: linux-media@vger.kernel.org, leiwen@marvell.com,
	ytang5@marvell.com, qingx@marvell.com, jwan@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
   As I have used videobuf2+soc_camera architecture on my camera
driver. I find a problem when I use Reqbuf(0), which only release
buffer, but not clear queued_list.
   Problem description:
   That is if upper layer uses qbuf then reqbuf0 directly, not having
stream on/dqbuf/off, then next time when streamon, videobuf2 could
still have the buffer from queued_list which having the buffer
released in privious reqbuf0, and the camera driver could access the
buffer already freed.
The steps that could cause problem for USERPTR:
Qbuf
Qbuf
Reqbuf 0
Reqbuf 20
Qbuf
Qbuf
Streamon   (queued_list still has the buffer already freed in the
previous reqbuf0)
.buf_queue (from camera driver, could access the buffer already freed)

   My question is if we could use __vb2_queue_release which calls
__vb2_queue_cancle(clear queue_list) and __vb2_queue_free(release
buffer) in Reqbuf(0), while not only use __vb2_queue_free.

Thank you

Angela Wan
Best Regards
