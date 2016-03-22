Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:33122 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbcCVQQV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2016 12:16:21 -0400
Received: by mail-wm0-f41.google.com with SMTP id l68so199735263wml.0
        for <linux-media@vger.kernel.org>; Tue, 22 Mar 2016 09:16:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1458560481-16200-3-git-send-email-hverkuil@xs4all.nl>
References: <1458560481-16200-1-git-send-email-hverkuil@xs4all.nl>
	<1458560481-16200-3-git-send-email-hverkuil@xs4all.nl>
Date: Tue, 22 Mar 2016 13:16:19 -0300
Message-ID: <CAAEAJfASrkBHSfC=Y_Dr3fR8CmGTLEeE_QJk41j2Uy=DxtDqNA@mail.gmail.com>
Subject: Re: [PATCH 2/4] media: Support Intersil/Techwell TW686x-based video
 capture cards
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Krzysztof Halasa <khalasa@piap.pl>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 21 March 2016 at 08:41, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
>
> This commit introduces the support for the Techwell TW686x video
> capture IC. This hardware supports a few DMA modes, including
> scatter-gather and frame (contiguous).
>
> This commit makes little use of the DMA engine and instead has
> a memcpy based implementation. DMA frame and scatter-gather modes
> support may be added in the future.
>
> Currently supported chips:
> - TW6864 (4 video channels),
> - TW6865 (4 video channels, not tested, second generation chip),
> - TW6868 (8 video channels but only 4 first channels using
>            built-in video decoder are supported, not tested),
> - TW6869 (8 video channels, second generation chip).
>
> Cc: Krzysztof Halasa <khalasa@piap.pl>
> Signed-off-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
[..]
> +int tw686x_video_init(struct tw686x_dev *dev)
> +{
> +       unsigned int ch, val, pb;
> +       int err;
> +
> +       err = v4l2_device_register(&dev->pci_dev->dev, &dev->v4l2_dev);
> +       if (err)
> +               return err;
> +
> +       for (ch = 0; ch < max_channels(dev); ch++) {
> +               struct tw686x_video_channel *vc = &dev->video_channels[ch];
> +               struct video_device *vdev;
> +
> +               mutex_init(&vc->vb_mutex);
> +               spin_lock_init(&vc->qlock);
> +               INIT_LIST_HEAD(&vc->vidq_queued);
> +
> +               vc->dev = dev;
> +               vc->ch = ch;
> +
> +               /* default settings */
> +               vc->format = &formats[0];
> +               vc->video_standard = V4L2_STD_NTSC;
> +               vc->width = TW686X_VIDEO_WIDTH;
> +               vc->height = TW686X_VIDEO_HEIGHT(vc->video_standard);
> +               vc->input = 0;
> +
> +               reg_write(vc->dev, SDT[ch], 0);
> +               tw686x_set_framerate(vc, 30);
> +
> +               reg_write(dev, VDELAY_LO[ch], 0x14);
> +               reg_write(dev, HACTIVE_LO[ch], 0xd0);
> +               reg_write(dev, VIDEO_SIZE[ch], 0);
> +
> +               for (pb = 0; pb < 2; pb++) {
> +                       err = tw686x_alloc_dma(vc, pb);
> +                       if (err)
> +                               goto error;
> +               }
> +
> +               vc->vidq.io_modes = VB2_READ | VB2_MMAP | VB2_DMABUF;
> +               vc->vidq.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +               vc->vidq.drv_priv = vc;
> +               vc->vidq.buf_struct_size = sizeof(struct tw686x_v4l2_buf);
> +               vc->vidq.ops = &tw686x_video_qops;
> +               vc->vidq.mem_ops = &vb2_vmalloc_memops;
> +               vc->vidq.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +               vc->vidq.min_buffers_needed = 2;
> +               vc->vidq.lock = &vc->vb_mutex;
> +

I missed the GFP_DMA32 on vb2_queue.gfp_flags.

Feel free to amend it, unless you want me to submit a patch for you to pick.

Thanks,
-- 
Ezequiel García, VanguardiaSur
www.vanguardiasur.com.ar
