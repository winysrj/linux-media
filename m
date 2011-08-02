Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:43633 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753348Ab1HBSJk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Aug 2011 14:09:40 -0400
Received: by mail-gx0-f175.google.com with SMTP id 3so21187gxk.20
        for <linux-media@vger.kernel.org>; Tue, 02 Aug 2011 11:09:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E37C841.7000709@samsung.com>
References: <4E37C7D7.40301@samsung.com>
	<4E37C841.7000709@samsung.com>
Date: Tue, 2 Aug 2011 13:09:39 -0500
Message-ID: <CAO8GWq=sMkm08L56rgc6xophAj_uGO9AE3bfK8D=oCOHBSmNRA@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH 1/6] drivers: base: add shared buffer framework
From: "Clark, Rob" <rob@ti.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linaro-mm-sig@lists.linaro.org,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 2, 2011 at 4:49 AM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> From: Tomasz Stanislawski <t.stanislaws@samsung.com>
>

> +/**
> + * shrbuf_import() - obtain shrbuf structure from a file descriptor
> + * @fd:        file descriptor
> + *
> + * The function obtains an instance of a  shared buffer from a file
> descriptor
> + * Call sb->put when imported buffer is not longer needed
> + *
> + * Returns pointer to a shared buffer or error pointer on failure
> + */
> +struct shrbuf *shrbuf_import(int fd)
> +{
> +    struct file *file;
> +    struct shrbuf *sb;
> +
> +    /* obtain a file, assure that it will not be released */
> +    file = fget(fd);
> +    /* check if descriptor is incorrect */
> +    if (!file)
> +        return ERR_PTR(-EBADF);
> +    /* check if dealing with shrbuf-file */
> +    if (file->f_op != &shrbuf_fops) {


Hmm.. I was liking the idea of letting the buffer allocator provide
the fops, so it could deal w/ mmap'ing and that sort of thing.
Although this reminds me that we would need a sane way to detect if
someone tries to pass in a non-<umm/dmabuf/shrbuf/whatever> fd.


> +        fput(file);
> +        return ERR_PTR(-EINVAL);
> +    }
> +    /* add user of shared buffer */
> +    sb = file->private_data;
> +    sb->get(sb);
> +    /* release the file */
> +    fput(file);
> +
> +    return sb;
> +}


> +/**
> + * struct shrbuf - shared buffer instance
> + * @get:    increase number of a buffer's users
> + * @put:    decrease number of a buffer's user, release resources if needed
> + * @dma_addr:    start address of a contiguous buffer
> + * @size:    size of a contiguous buffer
> + *
> + * Both get/put methods are required. The structure is dedicated for
> + * embedding. The fields dma_addr and size are used for proof-of-concept
> + * purpose. They will be substituted by scatter-gatter lists.
> + */
> +struct shrbuf {
> +    void (*get)(struct shrbuf *);
> +    void (*put)(struct shrbuf *);

Hmm, is fput()/fget() and fops->release() not enough?

Ie. original buffer allocator provides fops, incl the fops->release(),
which may in turn be decrementing an internal ref cnt used by the
allocating driver..  so if your allocating driver was the GPU, it's
release fxn might be calling drm_gem_object_unreference_unlocked()..
and I guess there must be something similar for videobuf2.

(Previous comment about letting the allocating driver implement fops
notwithstanding.. but I guess there must be some good way to deal with
that.)

BR,
-R
