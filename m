Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30C63C43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 06:49:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0121A214D8
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 06:49:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfCLGtD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 02:49:03 -0400
Received: from mga04.intel.com ([192.55.52.120]:25067 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726218AbfCLGtD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 02:49:03 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Mar 2019 23:48:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,470,1544515200"; 
   d="scan'208";a="121895892"
Received: from ipu5-build.bj.intel.com (HELO [10.238.232.171]) ([10.238.232.171])
  by orsmga007.jf.intel.com with ESMTP; 11 Mar 2019 23:48:29 -0700
Subject: Re: [PATCH] media:staging/intel-ipu3: parameter buffer refactoring
To:     Tomasz Figa <tfiga@chromium.org>,
        Cao Bing Bu <bingbu.cao@intel.com>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Yeh, Andy" <andy.yeh@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>
References: <1550221729-29240-1-git-send-email-bingbu.cao@intel.com>
 <CAAFQd5BOJmE51nrbK+3KGeQWN88iOt--xervThtxrRx3AohFPw@mail.gmail.com>
From:   Bingbu Cao <bingbu.cao@linux.intel.com>
Message-ID: <bc3117f8-fd74-2b61-07c0-926fba898d5d@linux.intel.com>
Date:   Tue, 12 Mar 2019 14:55:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAAFQd5BOJmE51nrbK+3KGeQWN88iOt--xervThtxrRx3AohFPw@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 03/12/2019 01:33 PM, Tomasz Figa wrote:
> Hi Bingbu,
>
> On Fri, Feb 15, 2019 at 6:02 PM <bingbu.cao@intel.com> wrote:
>> From: Bingbu Cao <bingbu.cao@intel.com>
>>
>> Current ImgU driver processes and releases the parameter buffer
>> immediately after queued from user. This does not align with other
>> image buffers which are grouped in sets and used for the same frame.
>> If user queues multiple parameter buffers continuously, only the last
>> one will take effect.
>> To make consistent buffers usage, this patch changes the parameter
>> buffer handling and group parameter buffer with other image buffers
>> for each frame.
> Thanks for the patch. Please see my comments inline.
>
>> Signed-off-by: Tianshu Qiu <tian.shu.qiu@intel.com>
>> Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
>> ---
>>   drivers/staging/media/ipu3/ipu3-css.c  |  5 -----
>>   drivers/staging/media/ipu3/ipu3-v4l2.c | 41 ++++++++--------------------------
>>   drivers/staging/media/ipu3/ipu3.c      | 24 ++++++++++++++++++++
>>   3 files changed, 33 insertions(+), 37 deletions(-)
>>
>> diff --git a/drivers/staging/media/ipu3/ipu3-css.c b/drivers/staging/media/ipu3/ipu3-css.c
>> index b9354d2bb692..bcb1d436bc98 100644
>> --- a/drivers/staging/media/ipu3/ipu3-css.c
>> +++ b/drivers/staging/media/ipu3/ipu3-css.c
>> @@ -2160,11 +2160,6 @@ int ipu3_css_set_parameters(struct ipu3_css *css, unsigned int pipe,
>>          obgrid_size = ipu3_css_fw_obgrid_size(bi);
>>          stripes = bi->info.isp.sp.iterator.num_stripes ? : 1;
>>
>> -       /*
>> -        * TODO(b/118782861): If userspace queues more than 4 buffers, the
>> -        * parameters from previous buffers will be overwritten. Fix the driver
>> -        * not to allow this.
>> -        */
> Wouldn't this still happen even with current patch?
> imgu_queue_buffers() supposedly queues "as many buffers to CSS as
> possible". This means that if the userspace queues more than 4
> complete frames, we still end up overwriting the parameter buffers in
> the pool. Please correct me if I'm wrong.
The parameter buffers are queued to CSS sequentially and queue one
parameter along with one input buffer once ready, all the data and
parameter buffers are tied together to queue to the CSS. If userspace
queue more parameter buffers then input buffer, they are pending on the
buffer list.
The parameters pool actually was just used to keep the last valid
parameter, if necessary it will be used to copy and combine with latest
parameter to queue. When driver reach at ipu3_css_set_parameters(), driver
will queue the parameter soon, no buffers pending as one patch before
change the pool mechanism.
>
>>          ipu3_css_pool_get(&css_pipe->pool.parameter_set_info);
>>          param_set = ipu3_css_pool_last(&css_pipe->pool.parameter_set_info,
>>                                         0)->vaddr;
>> diff --git a/drivers/staging/media/ipu3/ipu3-v4l2.c b/drivers/staging/media/ipu3/ipu3-v4l2.c
>> index e758a650ad2b..7812c7324893 100644
>> --- a/drivers/staging/media/ipu3/ipu3-v4l2.c
>> +++ b/drivers/staging/media/ipu3/ipu3-v4l2.c
>> @@ -341,8 +341,9 @@ static void ipu3_vb2_buf_queue(struct vb2_buffer *vb)
>>          struct imgu_video_device *node =
>>                  container_of(vb->vb2_queue, struct imgu_video_device, vbq);
>>          unsigned int queue = imgu_node_to_queue(node->id);
>> +       struct imgu_buffer *buf = container_of(vb, struct imgu_buffer,
>> +                                              vid_buf.vbb.vb2_buf);
>>          unsigned long need_bytes;
>> -       unsigned int pipe = node->pipe;
>>
>>          if (vb->vb2_queue->type == V4L2_BUF_TYPE_META_CAPTURE ||
>>              vb->vb2_queue->type == V4L2_BUF_TYPE_META_OUTPUT)
>> @@ -350,42 +351,18 @@ static void ipu3_vb2_buf_queue(struct vb2_buffer *vb)
> Looks like this might need a rebase. This function seems to be called
> imgu_vb2_buf_queue() in current linux-next. Other functions seem to
> have been changed from ipu3_ to imgu_ as well.
Thanks, I will rebase it.
>
>>          else
>>                  need_bytes = node->vdev_fmt.fmt.pix_mp.plane_fmt[0].sizeimage;
>>
>> -       if (queue == IPU3_CSS_QUEUE_PARAMS) {
>> -               unsigned long payload = vb2_get_plane_payload(vb, 0);
>> -               struct vb2_v4l2_buffer *buf =
>> -                       container_of(vb, struct vb2_v4l2_buffer, vb2_buf);
>> -               int r = -EINVAL;
>> -
>> -               if (payload == 0) {
>> -                       payload = need_bytes;
>> -                       vb2_set_plane_payload(vb, 0, payload);
>> -               }
>> -               if (payload >= need_bytes)
>> -                       r = ipu3_css_set_parameters(&imgu->css, pipe,
>> -                                                   vb2_plane_vaddr(vb, 0));
>> -               buf->flags = V4L2_BUF_FLAG_DONE;
>> -               vb2_buffer_done(vb, r == 0 ? VB2_BUF_STATE_DONE
>> -                                          : VB2_BUF_STATE_ERROR);
> This patch removes the check of the buffer contents. We should
> probably check the payload size in the vb2 .buf_prepare callback and
> fail if it doesn't match the parameter struct size.
Thanks, will add the check in next patch.
>
>> -
>> -       } else {
>> -               struct imgu_buffer *buf = container_of(vb, struct imgu_buffer,
>> -                                                      vid_buf.vbb.vb2_buf);
>> -
>> -               mutex_lock(&imgu->lock);
>> +       mutex_lock(&imgu->lock);
>> +       if (queue != IPU3_CSS_QUEUE_PARAMS)
>>                  ipu3_css_buf_init(&buf->css_buf, queue, buf->map.daddr);
>> -               list_add_tail(&buf->vid_buf.list,
>> -                             &node->buffers);
>> -               mutex_unlock(&imgu->lock);
>> +       list_add_tail(&buf->vid_buf.list, &node->buffers);
>> +       mutex_unlock(&imgu->lock);
>>
>> -               vb2_set_plane_payload(&buf->vid_buf.vbb.vb2_buf, 0, need_bytes);
>> -
>> -               if (imgu->streaming)
>> -                       imgu_queue_buffers(imgu, false, pipe);
>> -       }
>> +       vb2_set_plane_payload(vb, 0, need_bytes);
> Uhm, the driver is expected to only set the payload for CAPTURE buffers.
Ack.
>
>> +       if (imgu->streaming)
>> +               imgu_queue_buffers(imgu, false, node->pipe);
>>
>>          dev_dbg(&imgu->pci_dev->dev, "%s for pipe %d node %d", __func__,
>>                  node->pipe, node->id);
>> -
>>   }
>>
>>   static int ipu3_vb2_queue_setup(struct vb2_queue *vq,
>> diff --git a/drivers/staging/media/ipu3/ipu3.c b/drivers/staging/media/ipu3/ipu3.c
>> index 839d9398f8e9..25e121eebee2 100644
>> --- a/drivers/staging/media/ipu3/ipu3.c
>> +++ b/drivers/staging/media/ipu3/ipu3.c
>> @@ -246,6 +246,30 @@ int imgu_queue_buffers(struct imgu_device *imgu, bool initial, unsigned int pipe
>>                          dev_warn(&imgu->pci_dev->dev,
>>                                   "Vf not enabled, ignore queue");
>>                          continue;
>> +               } else if (node == IMGU_NODE_PARAMS &&
>> +                          imgu_pipe->nodes[node].enabled) {
>> +                       struct vb2_buffer *vb;
>> +                       struct ipu3_vb2_buffer *ivb;
>> +
>> +                       if (list_empty(&imgu_pipe->nodes[node].buffers))
>> +                               /* No parameters for this frame. */
>> +                               continue;
>> +                       ivb = list_first_entry(&imgu_pipe->nodes[node].buffers,
>> +                                              struct ipu3_vb2_buffer, list);
>> +                       vb = &ivb->vbb.vb2_buf;
>> +                       r = ipu3_css_set_parameters(&imgu->css, pipe,
>> +                                                   vb2_plane_vaddr(vb, 0));
>> +                       if (r) {
>> +                               vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
>> +                               dev_err(&imgu->pci_dev->dev,
>> +                                       "set parameters failed.\n");
>> +                       } else {
>> +                               vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
>> +                               dev_dbg(&imgu->pci_dev->dev,
>> +                                       "queue user parameters %d to css.\n",
>> +                                       vb->index);
>> +                       }
>> +                       list_del(&ivb->list);
> nit: I'd rewrite the code as below, to maintain the kernel convention
> of using ifs to handle special cases and keep the regular code flow at
> the same level of indentation.
>
>                            r = ipu3_css_set_parameters(&imgu->css, pipe,
>                                                        vb2_plane_vaddr(vb, 0));
>                            list_del(&ivb->list);
>                            if (r) {
>                                    vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
>                                    dev_err(&imgu->pci_dev->dev,
>                                         "set parameters failed.\n");
>                                    continue;
>                            }
>
>                            vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
>                            dev_dbg(&imgu->pci_dev->dev,
>                                    "queue user parameters %d to css.\n",
>                                     vb->index);
Ack.
>
> Best regards,
> Tomasz
>

