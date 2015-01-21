Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:45803 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbbAUL2s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Jan 2015 06:28:48 -0500
MIME-Version: 1.0
In-Reply-To: <CAHG8p1DBJd8hf86ejOVWaqdf4GpL7zAUzXoc2zsH_sEPKD8VDQ@mail.gmail.com>
References: <1419072462-3168-1-git-send-email-prabhakar.csengg@gmail.com>
 <1419072462-3168-9-git-send-email-prabhakar.csengg@gmail.com> <CAHG8p1DBJd8hf86ejOVWaqdf4GpL7zAUzXoc2zsH_sEPKD8VDQ@mail.gmail.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Wed, 21 Jan 2015 11:28:16 +0000
Message-ID: <CA+V-a8sB_1DD63ch=VOp3iu6m73wKF+HUCqs+PR0y7LV+NKnOQ@mail.gmail.com>
Subject: Re: [PATCH 08/15] media: blackfin: bfin_capture: use vb2_ioctl_* helpers
To: Scott Jiang <scott.jiang.linux@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	adi-buildroot-devel@lists.sourceforge.net,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 21, 2015 at 10:55 AM, Scott Jiang
<scott.jiang.linux@gmail.com> wrote:
> 2014-12-20 18:47 GMT+08:00 Lad, Prabhakar <prabhakar.csengg@gmail.com>:
>> this patch adds support to vb2_ioctl_* helpers.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> ---
>>  drivers/media/platform/blackfin/bfin_capture.c | 107 +++++--------------------
>>  1 file changed, 22 insertions(+), 85 deletions(-)
>>
>> diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
>> index 30f1fe0..80a0efc 100644
>> --- a/drivers/media/platform/blackfin/bfin_capture.c
>> +++ b/drivers/media/platform/blackfin/bfin_capture.c
>> @@ -272,15 +272,28 @@ static int bcap_start_streaming(struct vb2_queue *vq, unsigned int count)
>>         struct ppi_if *ppi = bcap_dev->ppi;
>>         struct bcap_buffer *buf, *tmp;
>>         struct ppi_params params;
>> +       dma_addr_t addr;
>>         int ret;
>>
>>         /* enable streamon on the sub device */
>>         ret = v4l2_subdev_call(bcap_dev->sd, video, s_stream, 1);
>>         if (ret && (ret != -ENOIOCTLCMD)) {
>>                 v4l2_err(&bcap_dev->v4l2_dev, "stream on failed in subdev\n");
>> +               bcap_dev->cur_frm = NULL;
>>                 goto err;
>>         }
>>
>> +       /* get the next frame from the dma queue */
>> +       bcap_dev->cur_frm = list_entry(bcap_dev->dma_queue.next,
>> +                                       struct bcap_buffer, list);
>> +       /* remove buffer from the dma queue */
>> +       list_del_init(&bcap_dev->cur_frm->list);
>> +       addr = vb2_dma_contig_plane_dma_addr(&bcap_dev->cur_frm->vb, 0);
>> +       /* update DMA address */
>> +       ppi->ops->update_addr(ppi, (unsigned long)addr);
>> +       /* enable ppi */
>> +       ppi->ops->start(ppi);
>> +
>
> Absolutely wrong here. You can't start ppi before you set ppi params.
> In fact  vb2_streamon() is called before this in bcap_streamon().

Agreed need to move the  ppi->ops->start(ppi); call after
ret = ppi->ops->set_params(ppi, &params); that should fix it.

Thanks,
--Prabhakar Lad
