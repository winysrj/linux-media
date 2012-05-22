Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:11382 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab2EVLvw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 May 2012 07:51:52 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from eusync1.samsung.com ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M4F00H8MAAS3I70@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 22 May 2012 12:52:05 +0100 (BST)
Received: from [106.116.48.223] by eusync1.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0M4F00C27AADKB10@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 22 May 2012 12:51:50 +0100 (BST)
Message-id: <4FBB7DD2.10108@samsung.com>
Date: Tue, 22 May 2012 13:51:46 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, subashrp@gmail.com,
	mchehab@redhat.com
Subject: Re: [RFC 05/13] v4l: vb2-dma-contig: add support for DMABUF exporting
References: <1334063447-16824-1-git-send-email-t.stanislaws@samsung.com>
 <3143149.ZCeOjVLXgh@avalon> <4F8FEC04.3030700@samsung.com>
 <1813415.rG2izL3i2h@avalon>
In-reply-to: <1813415.rG2izL3i2h@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Sorry for the late reply.
Thank you very much for noticing the issue.

>>>> +static struct dma_buf *vb2_dc_get_dmabuf(void *buf_priv)
>>>> +{
>>>> +	struct vb2_dc_buf *buf = buf_priv;
>>>> +	struct dma_buf *dbuf;
>>>> +
>>>> +	if (buf->dma_buf)
>>>> +		return buf->dma_buf;
>>>
>>> Can't there be a race condition here if the user closes the DMABUF file
>>> handle before vb2 core calls dma_buf_fd() ?
>>
>> The user cannot access the file until it is associated with a file
>> descriptor. How can the user close it? Could you give me a more detailed
>> description of this potential race condition?
> 
> Let's assume the V4L2 buffer has already been exported once. buf->dma_buf is 
> set to a non-NULL value, and the application has an open file handle for the 
> buffer. The application then tries to export the buffer a second time. 
> vb2_dc_get_dmabuf() gets called, checks buf->dma_buf and returns it as it's 
> non-NULL. Right after that, before the vb2 core calls dma_buf_fd() on the 
> struct dma_buf, the application closes the file handle to the exported buffer. 
> The struct dma_buf object gets freed, as the reference count drops to 0.

I am not sure if reference counter drops to 0 in this case. Notice that after
first dma_buf_export the dma_buf's refcnt is 1, after first dma_buf_fd it goes
to 2. After closing a file handle the refcnt drops back to 1 so the file
(and dma_buf) is not released. Therefore IMO there no dangling pointer issue.

However it looks that there is a circular reference between vb2_dc_buf and dma_buf.
vb2_dc_buf::dma_buf is pointing to dma_buf with reference taken at dma_buf_export.
On the other hand the dma_buf->priv is pointing to vb2_dc_buf with reference
taken at atomic_inc(&buf->refcount) in vb2_dc_get_dmabuf.

The circular reference leads into resource leakage.
The problem could be fixed by dropping caching of dma_buf pointer.
The new dma_buf would be created and exported at every export event.
The dma_buf_put would be called in vb2_expbuf just after
successful dma_buf_fd.

Do you have any ideas how I could deal with resource leakage/dangling problems
without creating a new dma_buf instance at every export event?

Regards,
Tomasz Stanislawski


> vb2 core will then try to call dma_buf_fd() on a dma_buf object that has been 
> freed.
> 
>>>> +	/* dmabuf keeps reference to vb2 buffer */
>>>> +	atomic_inc(&buf->refcount);
>>>> +	dbuf = dma_buf_export(buf, &vb2_dc_dmabuf_ops, buf->size, 0);
>>>> +	if (IS_ERR(dbuf)) {
>>>> +		atomic_dec(&buf->refcount);
>>>> +		return NULL;
>>>> +	}
>>>> +
>>>> +	buf->dma_buf = dbuf;
>>>> +
>>>> +	return dbuf;
>>>> +}
> 

