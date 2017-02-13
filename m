Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f175.google.com ([209.85.216.175]:36588 "EHLO
        mail-qt0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752805AbdBMNHF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 08:07:05 -0500
Received: by mail-qt0-f175.google.com with SMTP id k15so82620596qtg.3
        for <linux-media@vger.kernel.org>; Mon, 13 Feb 2017 05:07:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <55ececb8-321a-226a-f89a-93262067d741@xs4all.nl>
References: <1429780973-22006-1-git-send-email-benjamin.gaignard@linaro.org> <55ececb8-321a-226a-f89a-93262067d741@xs4all.nl>
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Date: Mon, 13 Feb 2017 14:06:53 +0100
Message-ID: <CA+M3ks5-ksCyp=tAOPqZMzHpdcT+VBb9MiuQo==OAzxc0oDoCQ@mail.gmail.com>
Subject: Re: [PATCH] allow buffers allocation with DMABUF memory type
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-02-13 13:18 GMT+01:00 Hans Verkuil <hverkuil@xs4all.nl>:
> Hi Benjamin,
>
> This is a blast from the past since this patch is almost two years old an=
d it
> has been languishing in my TODO list for ages. Sorry about that.
>
> Obviously this patch no longer applies, but I was also wondering what exa=
ctly
> will go wrong if we don't attach to the dma buf.

Nothing goes wrong until you get a dmabuf importer which is checking
which devices
are attached to the dmabuf.
For example I was working on a way to secure buffer memory (i.e.
setting memory firewall)
so I need to know which devices are attached to the buffer either I
can't set the good
secure flags.

>
> If something would go wrong, then I would expect to see the attach happen=
 when
> the MMAP buffer is exported as a dmabuf fd. Until it is turned into a dma=
buf there
> is no need to attach at all.

Yes that could be the right way to do it

>
> It all looks very weird to me, but that might be the reason why you never=
 pursued
> this patch in the first place.

The other reason was to be able to allocate buffers when using
V4L2_MEMORY_DMABUF
memory type and not only been able to import dmabuf in v4l2

>
> Regards,
>
>         Hans
>
> On 04/23/2015 11:22 AM, Benjamin Gaignard wrote:
>> Until now the only way to make the driver allocate buffers and
>> share them using dma_buf was to use V4L2_MEMORY_MMAP memory type.
>> Use of MMAP memory type is a problem because vb2 never call
>> dma_buf_map_attachment() to attach itself while queuing the buffer
>> so dma_buf importer will not know that another device use this buffer.
>>
>> This patch allow to allocate buffer even for DMABUF memory type
>> and correctly manage dma_buf buffer attachment.
>>
>> vb2_mem_ops attach_dmabuf() prototype has been changed to be able
>> to distinguish if the attachment is done on a already existing
>> buffer or on imported one.
>>
>> Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
>> ---
>>  drivers/media/v4l2-core/videobuf2-core.c       | 76 +++++++++++++++++++=
+++++--
>>  drivers/media/v4l2-core/videobuf2-dma-contig.c | 10 ++--
>>  drivers/media/v4l2-core/videobuf2-dma-sg.c     |  8 ++-
>>  drivers/media/v4l2-core/videobuf2-vmalloc.c    |  8 ++-
>>  include/media/videobuf2-core.h                 |  5 +-
>>  5 files changed, 91 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4=
l2-core/videobuf2-core.c
>> index 1329dcc..c5968aa 100644
>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>> @@ -337,6 +337,67 @@ static void __setup_offsets(struct vb2_queue *q, un=
signed int n)
>>  }
>>
>>  /**
>> + * __setup_dmabufs() - setup dmabuf fd for every plane in
>> + * every buffer on the queue
>> + */
>> +static void __setup_dmabufs(struct vb2_queue *q, unsigned int n)
>> +{
>> +     unsigned int buffer, plane;
>> +     struct vb2_buffer *vb;
>> +     struct vb2_plane *vb_plane;
>> +     struct dma_buf *dbuf;
>> +     void *mem_priv;
>> +     int fd;
>> +     int write =3D !V4L2_TYPE_IS_OUTPUT(q->type);
>> +     int flags =3D write ? O_WRONLY : O_RDONLY;
>> +
>> +     for (buffer =3D q->num_buffers; buffer < q->num_buffers + n; ++buf=
fer) {
>> +             vb =3D q->bufs[buffer];
>> +             if (!vb)
>> +                     continue;
>> +
>> +             for (plane =3D 0; plane < vb->num_planes; ++plane) {
>> +                     vb_plane =3D &vb->planes[plane];
>> +
>> +                     dbuf =3D call_ptr_memop(vb, get_dmabuf,
>> +                                           vb_plane->mem_priv,
>> +                                           flags & O_ACCMODE);
>> +                     if (IS_ERR_OR_NULL(dbuf)) {
>> +                             dprintk(1, "Failed to export buffer %d, " =
\
>> +                                     "plane %d\n", buffer, plane);
>> +                             continue;
>> +                     }
>> +
>> +                     fd =3D dma_buf_fd(dbuf, flags & ~O_ACCMODE);
>> +                     if (fd < 0) {
>> +                             dprintk(3, "buffer %d, plane %d failed " \
>> +                                     "to export (%d)\n", buffer, plane,=
 fd);
>> +                             dma_buf_put(dbuf);
>> +                             continue;
>> +                     }
>> +
>> +                     /* Acquire each plane's memory */
>> +                     mem_priv =3D call_ptr_memop(vb, attach_dmabuf,
>> +                                               q->alloc_ctx[plane], dbu=
f,
>> +                                               vb->v4l2_planes[plane].l=
ength,
>> +                                               write, vb_plane->mem_pri=
v);
>> +                     if (IS_ERR(mem_priv)) {
>> +                             dprintk(1, "Buffer %d plane %d failed "\
>> +                                     "to attach dmabuf\n", buffer, plan=
e);
>> +                             dma_buf_put(dbuf);
>> +                             continue;
>> +                     }
>> +
>> +                     vb_plane->dbuf =3D dbuf;
>> +                     vb->v4l2_planes[plane].m.fd =3D fd;
>> +
>> +                     dprintk(3, "Buffer %d, plane %d fd %x\n",
>> +                             buffer, plane, fd);
>> +             }
>> +     }
>> +}
>> +
>> +/**
>>   * __vb2_queue_alloc() - allocate videobuf buffer structures and (for M=
MAP type)
>>   * video buffer memory for all buffers/planes on the queue and initiali=
zes the
>>   * queue
>> @@ -369,8 +430,9 @@ static int __vb2_queue_alloc(struct vb2_queue *q, en=
um v4l2_memory memory,
>>               vb->v4l2_buf.type =3D q->type;
>>               vb->v4l2_buf.memory =3D memory;
>>
>> -             /* Allocate video buffer memory for the MMAP type */
>> -             if (memory =3D=3D V4L2_MEMORY_MMAP) {
>> +             /* Allocate video buffer memory for the MMAP and DMABUF ty=
pes */
>> +             if (memory =3D=3D V4L2_MEMORY_MMAP ||
>> +                 memory =3D=3D V4L2_MEMORY_DMABUF) {
>>                       ret =3D __vb2_buf_mem_alloc(vb);
>>                       if (ret) {
>>                               dprintk(1, "failed allocating memory for "
>> @@ -400,6 +462,9 @@ static int __vb2_queue_alloc(struct vb2_queue *q, en=
um v4l2_memory memory,
>>       if (memory =3D=3D V4L2_MEMORY_MMAP)
>>               __setup_offsets(q, buffer);
>>
>> +     if (memory =3D=3D V4L2_MEMORY_DMABUF)
>> +             __setup_dmabufs(q, buffer);
>> +
>>       dprintk(1, "allocated %d buffers, %d plane(s) each\n",
>>                       buffer, num_planes);
>>
>> @@ -859,7 +924,7 @@ static int __verify_memory_type(struct vb2_queue *q,
>>   *    to be used during streaming,
>>   * 4) allocates internal buffer structures (struct vb2_buffer), accordi=
ng to
>>   *    the agreed parameters,
>> - * 5) for MMAP memory type, allocates actual video memory, using the
>> + * 5) for MMAP and DMABUF memory types, allocates actual video memory, =
using the
>>   *    memory handling/allocation routines provided during queue initial=
ization
>>   *
>>   * If req->count is 0, all the memory will be freed instead.
>> @@ -885,7 +950,8 @@ static int __reqbufs(struct vb2_queue *q, struct v4l=
2_requestbuffers *req)
>>                * are not in use and can be freed.
>>                */
>>               mutex_lock(&q->mmap_lock);
>> -             if (q->memory =3D=3D V4L2_MEMORY_MMAP && __buffers_in_use(=
q)) {
>> +             if ((q->memory =3D=3D V4L2_MEMORY_MMAP ||
>> +                  q->memory =3D=3D V4L2_MEMORY_DMABUF) && __buffers_in_=
use(q)) {
>>                       mutex_unlock(&q->mmap_lock);
>>                       dprintk(1, "memory in use, cannot free\n");
>>                       return -EBUSY;
>> @@ -1540,7 +1606,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, co=
nst struct v4l2_buffer *b)
>>
>>               /* Acquire each plane's memory */
>>               mem_priv =3D call_ptr_memop(vb, attach_dmabuf, q->alloc_ct=
x[plane],
>> -                     dbuf, planes[plane].length, dma_dir);
>> +                     dbuf, planes[plane].length, dma_dir, NULL);
>>               if (IS_ERR(mem_priv)) {
>>                       dprintk(1, "failed to attach dmabuf\n");
>>                       ret =3D PTR_ERR(mem_priv);
>> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/me=
dia/v4l2-core/videobuf2-dma-contig.c
>> index b481d20..8dc945e 100644
>> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
>> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
>> @@ -793,7 +793,7 @@ static void vb2_dc_detach_dmabuf(void *mem_priv)
>>       struct vb2_dc_buf *buf =3D mem_priv;
>>
>>       /* if vb2 works correctly you should never detach mapped buffer */
>> -     if (WARN_ON(buf->dma_addr))
>> +     if (WARN_ON(buf->dma_sgt))
>>               vb2_dc_unmap_dmabuf(buf);
>>
>>       /* detach this attachment */
>> @@ -802,16 +802,18 @@ static void vb2_dc_detach_dmabuf(void *mem_priv)
>>  }
>>
>>  static void *vb2_dc_attach_dmabuf(void *alloc_ctx, struct dma_buf *dbuf=
,
>> -     unsigned long size, enum dma_data_direction dma_dir)
>> +     unsigned long size, enum dma_data_direction dma_dir, void *buf_pri=
v)
>>  {
>>       struct vb2_dc_conf *conf =3D alloc_ctx;
>> -     struct vb2_dc_buf *buf;
>> +     struct vb2_dc_buf *buf =3D buf_priv;
>>       struct dma_buf_attachment *dba;
>>
>>       if (dbuf->size < size)
>>               return ERR_PTR(-EFAULT);
>>
>> -     buf =3D kzalloc(sizeof(*buf), GFP_KERNEL);
>> +     if (!buf)
>> +             buf =3D kzalloc(sizeof(*buf), GFP_KERNEL);
>> +
>>       if (!buf)
>>               return ERR_PTR(-ENOMEM);
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/=
v4l2-core/videobuf2-dma-sg.c
>> index b1838ab..b9855fd 100644
>> --- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
>> +++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
>> @@ -667,16 +667,18 @@ static void vb2_dma_sg_detach_dmabuf(void *mem_pri=
v)
>>  }
>>
>>  static void *vb2_dma_sg_attach_dmabuf(void *alloc_ctx, struct dma_buf *=
dbuf,
>> -     unsigned long size, enum dma_data_direction dma_dir)
>> +     unsigned long size, enum dma_data_direction dma_dir, void *buf_pri=
v)
>>  {
>>       struct vb2_dma_sg_conf *conf =3D alloc_ctx;
>> -     struct vb2_dma_sg_buf *buf;
>> +     struct vb2_dma_sg_buf *buf =3D buf_priv;
>>       struct dma_buf_attachment *dba;
>>
>>       if (dbuf->size < size)
>>               return ERR_PTR(-EFAULT);
>>
>> -     buf =3D kzalloc(sizeof(*buf), GFP_KERNEL);
>> +     if (!buf)
>> +             buf =3D kzalloc(sizeof(*buf), GFP_KERNEL);
>> +
>>       if (!buf)
>>               return ERR_PTR(-ENOMEM);
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media=
/v4l2-core/videobuf2-vmalloc.c
>> index bcde885..373294c 100644
>> --- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
>> +++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
>> @@ -416,14 +416,16 @@ static void vb2_vmalloc_detach_dmabuf(void *mem_pr=
iv)
>>  }
>>
>>  static void *vb2_vmalloc_attach_dmabuf(void *alloc_ctx, struct dma_buf =
*dbuf,
>> -     unsigned long size, enum dma_data_direction dma_dir)
>> +     unsigned long size, enum dma_data_direction dma_dir, void *buf_pri=
v)
>>  {
>> -     struct vb2_vmalloc_buf *buf;
>> +     struct vb2_vmalloc_buf *buf =3D buf_priv;
>>
>>       if (dbuf->size < size)
>>               return ERR_PTR(-EFAULT);
>>
>> -     buf =3D kzalloc(sizeof(*buf), GFP_KERNEL);
>> +     if (!buf)
>> +             buf =3D kzalloc(sizeof(*buf), GFP_KERNEL);
>> +
>>       if (!buf)
>>               return ERR_PTR(-ENOMEM);
>>
>> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-co=
re.h
>> index a5790fd..374b26b 100644
>> --- a/include/media/videobuf2-core.h
>> +++ b/include/media/videobuf2-core.h
>> @@ -49,6 +49,8 @@ struct vb2_threadio_data;
>>   *              used for DMABUF memory types; alloc_ctx is the alloc co=
ntext
>>   *              dbuf is the shared dma_buf; returns NULL on failure;
>>   *              allocator private per-buffer structure on success;
>> + *              if private per-buffer structure is provided reuse it
>> + *              instead of allocating a new one.
>>   *              this needs to be used for further accesses to the buffe=
r.
>>   * @detach_dmabuf: inform the exporter of the buffer that the current D=
MABUF
>>   *              buffer is no longer used; the buf_priv argument is the
>> @@ -98,7 +100,8 @@ struct vb2_mem_ops {
>>
>>       void            *(*attach_dmabuf)(void *alloc_ctx, struct dma_buf =
*dbuf,
>>                                         unsigned long size,
>> -                                       enum dma_data_direction dma_dir)=
;
>> +                                       enum dma_data_direction dma_dir,
>> +                                       void *buf_priv);
>>       void            (*detach_dmabuf)(void *buf_priv);
>>       int             (*map_dmabuf)(void *buf_priv);
>>       void            (*unmap_dmabuf)(void *buf_priv);
>>
>



--=20
Benjamin Gaignard

Graphic Study Group

Linaro.org =E2=94=82 Open source software for ARM SoCs

Follow Linaro: Facebook | Twitter | Blog
