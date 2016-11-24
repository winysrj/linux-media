Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:34247 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965905AbcKXP6W (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Nov 2016 10:58:22 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Matt Ranostay <matt@ranostay.consulting>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Attila Kinali <attila@kinali.ch>, Marek Vasut <marex@denx.de>,
        Luca Barbato <lu_zero@gentoo.org>
Subject: Re: [PATCH v3] media: i2c-polling: add i2c-polling driver
Date: Thu, 24 Nov 2016 17:58:42 +0200
Message-ID: <2959136.pq40D4COK1@avalon>
In-Reply-To: <CAJ_EiSSsRjHO-BEArFA5BsyWQNnEtD024wwYrnFJ32p0SVNpqQ@mail.gmail.com>
References: <1479863920-14708-1-git-send-email-matt@ranostay.consulting> <CAJ_EiSSjjf9KDVzA=Qyd0BqXC30Hb89UgcJ7Oinr8bWCN=JmHg@mail.gmail.com> <CAJ_EiSSsRjHO-BEArFA5BsyWQNnEtD024wwYrnFJ32p0SVNpqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Matt,

On Thursday 24 Nov 2016 00:04:24 Matt Ranostay wrote:
> On Wed, Nov 23, 2016 at 10:31 PM, Matt Ranostay wrote:
> > On Wed, Nov 23, 2016 at 8:30 AM, Laurent Pinchart wrote:
> >> On Tuesday 22 Nov 2016 17:18:40 Matt Ranostay wrote:
> >>> There are several thermal sensors that only have a low-speed bus
> >>> interface but output valid video data. This patchset enables support
> >>> for the AMG88xx "Grid-Eye" sensor family.
> >>> 
> >>> Cc: Attila Kinali <attila@kinali.ch>
> >>> Cc: Marek Vasut <marex@denx.de>
> >>> Cc: Luca Barbato <lu_zero@gentoo.org>
> >>> Signed-off-by: Matt Ranostay <matt@ranostay.consulting>
> >>> ---
> >>> Changes from v1:
> >>> * correct i2c_polling_remove() operations
> >>> * fixed delay calcuation in buffer_queue()
> >>> * add include linux/slab.h
> >>> 
> >>> Changes from v2:
> >>> * fix build error due to typo in include of slab.h
> >>> 
> >>>  drivers/media/i2c/Kconfig       |   8 +
> >>>  drivers/media/i2c/Makefile      |   1 +
> >>>  drivers/media/i2c/i2c-polling.c | 469 +++++++++++++++++++++++++++++++++
> >> 
> >> Just looking at the driver name I believe a rename is needed. i2c-polling
> >> is a very generic name and would mislead many people into thinking about
> >> an I2C subsystem core feature instead of a video driver. "video-i2c" is
> >> one option, I'm open to other ideas.
> >> 
> >>>  3 files changed, 478 insertions(+)
> >>>  create mode 100644 drivers/media/i2c/i2c-polling.c

[snip]

> >>> diff --git a/drivers/media/i2c/i2c-polling.c
> >>> b/drivers/media/i2c/i2c-polling.c new file mode 100644
> >>> index 000000000000..46a4eecde2d2
> >>> --- /dev/null
> >>> +++ b/drivers/media/i2c/i2c-polling.c

[snip]

> >>> +static void buffer_queue(struct vb2_buffer *vb)
> >>> +{
> >>> +     struct i2c_polling_data *data = vb2_get_drv_priv(vb->vb2_queue);
> >>> +     unsigned int delay = 1000 / data->chip->max_fps;
> >>> +     int delta;
> >>> +
> >>> +     mutex_lock(&data->lock);
> >>> +
> >>> +     delta = jiffies - data->last_update;
> >>> +
> >>> +     if (delta < msecs_to_jiffies(delay)) {
> >>> +             int tmp = (delay - jiffies_to_msecs(delta)) * 1000;
> >>> +
> >>> +             usleep_range(tmp, tmp + 1000);
> >>> +     }
> >>> +     data->last_update = jiffies;
> >>> +
> >>> +     mutex_unlock(&data->lock);
> >>> +
> >>> +     vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
> >>> +}
> >>> +
> >>> +static void buffer_finish(struct vb2_buffer *vb)
> >>> +{
> >>> +     struct i2c_polling_data *data = vb2_get_drv_priv(vb->vb2_queue);
> >>> +     void *vbuf = vb2_plane_vaddr(vb, 0);
> >>> +     int size = vb2_plane_size(vb, 0);
> >>> +     int ret;
> >>> +
> >>> +     mutex_lock(&data->lock);
> >>> +
> >>> +     ret = data->chip->xfer(data, vbuf);
> >>> +     if (ret < 0)
> >>> +             vb->state = VB2_BUF_STATE_ERROR;
> >> 
> >> That's not nice, the status should be set through vb2_buffer_done().
> >> 
> >> You can't transfer data in the buffer_queue handler is that function
> >> can't sleep. Instead, I'm wondering whether it would make sense to
> >> perform transfers in a workqueue, to making timings less dependent on
> >> userspace.
> > 
> > About the workqueue how would one signal to that the buffer is written
> > to buffer_queue/buffer_finish?
> 
> Testing the workqueue way and it isn't fine enough... need to use some
> form of the high resolution timers. Need to figure the best way to do
> that with signaling back to the queue functions.. would completion
> queues make sense?

How about a kthread, as done in the vivid driver ?

> >>> +     mutex_unlock(&data->lock);
> >>> +
> >>> +     vb->timestamp = ktime_get_ns();
> >>> +     vb2_set_plane_payload(vb, 0, ret ? 0 : size);
> >>> +}

-- 
Regards,

Laurent Pinchart

