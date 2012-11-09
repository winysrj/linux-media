Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:52113 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab2KIOBZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Nov 2012 09:01:25 -0500
Date: Fri, 9 Nov 2012 15:01:22 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?utf-8?B?5YaN5Zue6aaW?= <308123027@qq.com>
cc: =?utf-8?B?bGludXgtbWVkaWE=?= <linux-media@vger.kernel.org>
Subject: Re: =?utf-8?B?5Zue5aSN77yaIHNvYyBjYW1lcmEgZHJpdmVyIG1v?=
 =?utf-8?B?ZHVsZSBtYXkgY2FzZSBtZW1vcnkgbGVhaw==?=
In-Reply-To: <tencent_59FBB90B463B626440DF2EE3@qq.com>
Message-ID: <Pine.LNX.4.64.1211091456480.5481@axis700.grange>
References: <tencent_59FBB90B463B626440DF2EE3@qq.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

Well, I must confess, I'm surprised:-) It looks like you're right. This 
leak, if indeed there is one, has been there since the very first version 
of soc-camera. I've spent some time looking at the code and so far I don't 
find an explanation for the missing videobuf_mmap_free() call. I'll have 
another look and, unless I find an explanation, why it's not needed, I'll 
make a patch.

Also keep in mind, that this bug is only relevant for videobuf(1) drivers, 
which anyway have to be converted to videobuf2;-)

Thanks
Guennadi

On Wed, 7 Nov 2012, �~F~M�~[~^�~V wrote:

> Dear Guennadi
> 
> I'm sure it's a bug.In linux-2.6.x, we call open() will allocate a struct soc_camera_file which contains struct videobuf_queue;then usr will call request_buffer, soc_camera module will call videobuf_alloc_vb(q) which will be installed in q->bufs[i].
>              My question is how to free q->bufs[i] which is allocated from vb = kzalloc(size + sizeof(*mem), GFP_KERNEL) if we use videobuf-dma-contig memory model? 
>              videobuf_mmap_free()->kfree(q->bufs[i]) should call at every call close();we can't call kfree(q->bufs[i]) at q->ops->buf_release which is called in stream_off(), because q->bufs[i] reserve struct videobuf_mapping, unmap() will can't free videobuf which is used to store video data. Also can't call videobuf_mmap_free()->kfree(q->bufs[i]) at last close(), because in linux-2.6.x once open() allocates a videobuf_queue.
>                In linux-3.x.x, we should call videobuf_mmap_free()->kfree(q->bufs[i]) only once at module remove callbcak function.
>               You say, videobuf mmap allocations will be freed automatically. I want to known soc_camera module how to free q->bufs[i] automatically. 
>               If is there no bug in soc camera module , i'm sure all device driver use soc camera module have bugs, such as sh_mobile_ceu_caera.c, mx1_caera.c, mx3_caera.c etc. all of them donn't call videobuf_mmap_free()->kfree(q->bufs[i]).
> 
> Your reply will be higly appreciated! 
> 
> 
> ------------------ 原始邮件 ------------------
> 发件人: "Guennadi Liakhovetski"<g.liakhovetski@gmx.de>;
> 发送时间: 2012年11月6日(星期二) 晚上7:30
> 收件人: "再回首"<308123027@qq.com>; 
> 抄送: "linux-media"<linux-media@vger.kernel.org>; 
> 主题: Re: soc camera driver module may case memory leak
> 
> 
> Hi
> 
> On Mon, 5 Nov 2012,  ~F~M ~[~^ ~V wrote:
> 
> > Dear sir:
> > why not call "videobuf_mmap_free",when device close call "soc_camera_close" in linux-2.6.x;
> 
> I haven't found any version, where this has been done. I don't think this 
> is needed, because videobuf mmap allocations will be freed automatically 
> upon the last close(). Please, dismiss your bugzilla entry.
> 
> Thanks
> Guennadi
> 
> > do the same in linux-3.x.x?
> > video capture flow:
> > 1)open
> > 2)set fmt
> > 3)request buffer-->__videobuf_mmap_setup-->videobuf_alloc_vb(q)
> > 4)mmap
> > 5)enqueue, dequeue
> > 6)unmap
> > 7)close--->soc_camera_close-->?should call:videobuf_mmap_free
> > NOTE:
> > I have reviewed all the code, found:soc_camera_driver device driver coders has no way(callback function) to call videobuf_mmap_free; it will case memory leak.N r y b X ǧv ^ )޺{.n + { bj) w*jg ݢj/ z ޖ 2 ޙ & )ߡ a G h j:+v w ٥
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
