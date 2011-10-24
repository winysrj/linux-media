Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:62549 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab1JXTjb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Oct 2011 15:39:31 -0400
Date: Mon, 24 Oct 2011 21:39:23 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Angela Wan <angela.j.wan@gmail.com>
cc: pawel@osciak.com, m.szyprowski@samsung.com,
	linux-media@vger.kernel.org, leiwen@marvell.com,
	ytang5@marvell.com, qingx@marvell.com, jwan@marvell.com
Subject: Re: Reqbufs(0) need to release queued_list
In-Reply-To: <CABbt3s68q_jKf9bHPT8kuaB6donrAzmucJJseWNiX88qud273g@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1110242136510.8610@axis700.grange>
References: <CABbt3s68q_jKf9bHPT8kuaB6donrAzmucJJseWNiX88qud273g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 24 Oct 2011, Angela Wan wrote:

> Hi,
>    As I have used videobuf2+soc_camera architecture on my camera
> driver. I find a problem when I use Reqbuf(0), which only release
> buffer, but not clear queued_list.

Indeed, looks like vb2_reqbufs(p->count == 0) fails to clean up the queue?

Thanks
Guennadi

>    Problem description:
>    That is if upper layer uses qbuf then reqbuf0 directly, not having
> stream on/dqbuf/off, then next time when streamon, videobuf2 could
> still have the buffer from queued_list which having the buffer
> released in privious reqbuf0, and the camera driver could access the
> buffer already freed.
> The steps that could cause problem for USERPTR:
> Qbuf
> Qbuf
> Reqbuf 0
> Reqbuf 20
> Qbuf
> Qbuf
> Streamon   (queued_list still has the buffer already freed in the
> previous reqbuf0)
> .buf_queue (from camera driver, could access the buffer already freed)
> 
>    My question is if we could use __vb2_queue_release which calls
> __vb2_queue_cancle(clear queue_list) and __vb2_queue_free(release
> buffer) in Reqbuf(0), while not only use __vb2_queue_free.
> 
> Thank you
> 
> Angela Wan
> Best Regards
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
