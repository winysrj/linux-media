Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:61441 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab2KFLbB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Nov 2012 06:31:01 -0500
Date: Tue, 6 Nov 2012 12:30:59 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?utf-8?B?5YaN5Zue6aaW?= <308123027@qq.com>
cc: =?utf-8?B?bGludXgtbWVkaWE=?= <linux-media@vger.kernel.org>
Subject: Re: soc camera driver module may case memory leak
In-Reply-To: <tencent_64608E82650520C00B66909A@qq.com>
Message-ID: <Pine.LNX.4.64.1211061229000.6451@axis700.grange>
References: <tencent_64608E82650520C00B66909A@qq.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

On Mon, 5 Nov 2012, å~F~Må~[~^é¦~V wrote:

> Dear sir:
> why not call "videobuf_mmap_free",when device close call "soc_camera_close" in linux-2.6.x;

I haven't found any version, where this has been done. I don't think this 
is needed, because videobuf mmap allocations will be freed automatically 
upon the last close(). Please, dismiss your bugzilla entry.

Thanks
Guennadi

> do the same in linux-3.x.x?
> video capture flow:
> 1)open
> 2)set fmt
> 3)request buffer-->__videobuf_mmap_setup-->videobuf_alloc_vb(q)
> 4)mmap
> 5)enqueue, dequeue
> 6)unmap
> 7)close--->soc_camera_close-->?should call:videobuf_mmap_free
> NOTE:
> I have reviewed all the code, found:soc_camera_driver device driver coders has no way(callback function) to call videobuf_mmap_free; it will case memory leak.N‹§²æìr¸›yúèšØb²X¬¶Ç§vØ^–)Şº{.nÇ+‰·¥Š{±™çbj)í…æèw*jg¬±¨¶‰šŠİ¢j/êäz¹Ş–Šà2ŠŞ™¨è­Ú&¢)ß¡«a¶Úşø®G«éh®æj:+v‰¨Šwè†Ù¥

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
