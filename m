Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:46028 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750791AbdALSIo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Jan 2017 13:08:44 -0500
Subject: Re: [PATCH v2 2/2] Support for DW CSI-2 Host IPK
To: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, mchehab@kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
References: <cover.1481548484.git.roliveir@synopsys.com>
 <bf2f0a6730e4a74d64e04575859d6b195f65b368.1481554324.git.roliveir@synopsys.com>
 <eb89af79-f868-ceba-ac69-558bac77613d@xs4all.nl>
 <8823670a-8456-87d0-3265-cb427e3445eb@synopsys.com>
Cc: davem@davemloft.net, gregkh@linuxfoundation.org,
        geert+renesas@glider.be, akpm@linux-foundation.org,
        linux@roeck-us.net, laurent.pinchart+renesas@ideasonboard.com,
        arnd@arndb.de, sudipm.mukherjee@gmail.com,
        tiffany.lin@mediatek.com, minghsiu.tsai@mediatek.com,
        jean-christophe.trotin@st.com, andrew-ct.chen@mediatek.com,
        simon.horman@netronome.com, songjun.wu@microchip.com,
        bparrot@ti.com, CARLOS.PALMINHA@synopsys.com,
        Sakari Ailus <sakari.ailus@iki.fi>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f1ea65b3-dbad-fd6c-d2c4-33abc3a66890@xs4all.nl>
Date: Thu, 12 Jan 2017 19:06:41 +0100
MIME-Version: 1.0
In-Reply-To: <8823670a-8456-87d0-3265-cb427e3445eb@synopsys.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/12/2017 06:43 PM, Ramiro Oliveira wrote:
> Hi Hans,
> 
> Thank you for your feedback.
> 
> On 1/11/2017 11:54 AM, Hans Verkuil wrote:
>> Hi Ramiro,
>>
>> See my review comments below:
>>
>> On 12/12/16 16:00, Ramiro Oliveira wrote:
>>> Add support for the DesignWare CSI-2 Host IP Prototyping Kit
>>>
>>> Signed-off-by: Ramiro Oliveira <roliveir@synopsys.com>
> 
> [snip]

>>> +
>>> +static int vid_dev_subdev_s_power(struct v4l2_subdev *sd, int on)
>>> +{
>>> +    return 0;
>>> +}
>>
>> Just drop this empty function, shouldn't be needed.
>>
> 
> When I start my system I'm hoping all the subdevs have s_power registered. If it
> doesn't exist should I change the way I handle it, or will the core handle it
> for me?

If it isn't provided, then it is just skipped. The general rule is that
you only provide these ops if they do something useful.

> 
>>> +
>>> +static int vid_dev_subdev_registered(struct v4l2_subdev *sd)
>>> +{
>>> +    struct video_device_dev *vid_dev = v4l2_get_subdevdata(sd);
>>> +    struct vb2_queue *q = &vid_dev->vb_queue;
>>> +    struct video_device *vfd = &vid_dev->ve.vdev;
>>> +    int ret;
>>> +
>>> +    memset(vfd, 0, sizeof(*vfd));
>>> +
>>> +    strlcpy(vfd->name, VIDEO_DEVICE_NAME, sizeof(vfd->name));
>>> +
>>> +    vfd->fops = &vid_dev_fops;
>>> +    vfd->ioctl_ops = &vid_dev_ioctl_ops;
>>> +    vfd->v4l2_dev = sd->v4l2_dev;
>>> +    vfd->minor = -1;
>>> +    vfd->release = video_device_release_empty;
>>> +    vfd->queue = q;
>>> +
>>> +    INIT_LIST_HEAD(&vid_dev->vidq.active);
>>> +    init_waitqueue_head(&vid_dev->vidq.wq);
>>> +    memset(q, 0, sizeof(*q));
>>> +    q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>>> +    q->io_modes = VB2_MMAP | VB2_USERPTR;
>>
>> Add VB2_DMABUF and VB2_READ.
>>
> 
> I'll add them, but I'm not using them, is it standard procedure to add them all
> even if they aren't used?

You may not use them, but others might. And it doesn't cost anything to add them.

> 
>>> +    q->ops = &vb2_video_qops;
>>> +    q->mem_ops = &vb2_vmalloc_memops;
>>
>> Why is vmalloc used? Can't you use dma_contig or dma_sg and avoid having to copy
>> the image data? That's a really bad design given the amount of video data that
>> you have to copy.
>>
> 
> When I started development, the arch I was using (ARC) didn't support
> dma_contig, so I was forced to use vmalloc.
> 
> Since then things have changed and I'm already using dma_contig, however it
> wasn't included in this patch. I'll add it to the next patch.

Ah, good. If you are switching to dma_contig, then remove VB2_USERPTR.
VB2_DMABUF should be used instead.

Regards,

	Hans
