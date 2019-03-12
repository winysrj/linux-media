Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8555C43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 05:33:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 935B5214AE
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 05:33:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="laW7kipJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbfCLFd6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 01:33:58 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:33332 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbfCLFd5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 01:33:57 -0400
Received: by mail-oi1-f194.google.com with SMTP id z14so1116328oid.0
        for <linux-media@vger.kernel.org>; Mon, 11 Mar 2019 22:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yohpAgrqgWp3TH5v2ncxVUDGXVMhm7ZCjszOGqYMfyg=;
        b=laW7kipJ/RpS1VcwEtqbuu5HkpzizHDRIDJQ/W7yLJ4k1ySP1Ic2WhhSjGcU6SlXgp
         6JiTqjW/D2xafIKirTTk8FT0Ityhz4a1TQVRdjWxMRFa1lru22csetixzPNMhjS7IIPa
         7KoqOFgxMmvhmWjya4TwegzbbauYkBi5OOfeo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yohpAgrqgWp3TH5v2ncxVUDGXVMhm7ZCjszOGqYMfyg=;
        b=q1eGn2Evv06sG6c/Y9lJe5V1KRCEwEV+K57EBNpFwG5h/d51A3zrGbTvhchuTG551F
         orpNurx5oyCaO+ktW8UihMiC2jlwkf5GV8pEH1ReDYR7hrzyDtpugSdbhfZmV0f6NAkh
         MbdFBSfoLFbDPf03kN5rXJtOvRMKfHadSvjWZRZBdfBiADNo+OaYsV93HsDeGVATYcSW
         bnQWV99Olaz/dWPceFS53ncdYu1r/oEEvKjTn2v9iPGlvzMV2Pj4x5SAlIEwc+DcmrJB
         7LVpTaXOnw3qkfpmcClk1AQTXp+PCS6DGi3TPWhIfdLwWMzAro4IsmA+Js2OxnOEabdp
         09Bw==
X-Gm-Message-State: APjAAAWA5+23jDIqolxN9YJFgLNbrmea7cVU7XO8eYTCFem8ttPeX+P/
        AWn5kW4FOsPkoGgebkU3xaGJUJVzikA=
X-Google-Smtp-Source: APXvYqzuqsT583P/Z8dvNluQCrMkVvrlTMc5gCQ8s0Y6bFGjb2H74n8YH4jzEHImcLX3yXKgUNnasg==
X-Received: by 2002:aca:57d4:: with SMTP id l203mr265842oib.42.1552368834606;
        Mon, 11 Mar 2019 22:33:54 -0700 (PDT)
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com. [209.85.210.44])
        by smtp.gmail.com with ESMTPSA id c24sm3068122otl.67.2019.03.11.22.33.53
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Mar 2019 22:33:53 -0700 (PDT)
Received: by mail-ot1-f44.google.com with SMTP id z25so1431047otk.2
        for <linux-media@vger.kernel.org>; Mon, 11 Mar 2019 22:33:53 -0700 (PDT)
X-Received: by 2002:a9d:4c85:: with SMTP id m5mr22705297otf.367.1552368832755;
 Mon, 11 Mar 2019 22:33:52 -0700 (PDT)
MIME-Version: 1.0
References: <1550221729-29240-1-git-send-email-bingbu.cao@intel.com>
In-Reply-To: <1550221729-29240-1-git-send-email-bingbu.cao@intel.com>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Tue, 12 Mar 2019 14:33:41 +0900
X-Gmail-Original-Message-ID: <CAAFQd5BOJmE51nrbK+3KGeQWN88iOt--xervThtxrRx3AohFPw@mail.gmail.com>
Message-ID: <CAAFQd5BOJmE51nrbK+3KGeQWN88iOt--xervThtxrRx3AohFPw@mail.gmail.com>
Subject: Re: [PATCH] media:staging/intel-ipu3: parameter buffer refactoring
To:     Cao Bing Bu <bingbu.cao@intel.com>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Yeh, Andy" <andy.yeh@intel.com>,
        Bingbu Cao <bingbu.cao@linux.intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Bingbu,

On Fri, Feb 15, 2019 at 6:02 PM <bingbu.cao@intel.com> wrote:
>
> From: Bingbu Cao <bingbu.cao@intel.com>
>
> Current ImgU driver processes and releases the parameter buffer
> immediately after queued from user. This does not align with other
> image buffers which are grouped in sets and used for the same frame.
> If user queues multiple parameter buffers continuously, only the last
> one will take effect.
> To make consistent buffers usage, this patch changes the parameter
> buffer handling and group parameter buffer with other image buffers
> for each frame.

Thanks for the patch. Please see my comments inline.

>
> Signed-off-by: Tianshu Qiu <tian.shu.qiu@intel.com>
> Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
> ---
>  drivers/staging/media/ipu3/ipu3-css.c  |  5 -----
>  drivers/staging/media/ipu3/ipu3-v4l2.c | 41 ++++++++--------------------------
>  drivers/staging/media/ipu3/ipu3.c      | 24 ++++++++++++++++++++
>  3 files changed, 33 insertions(+), 37 deletions(-)
>
> diff --git a/drivers/staging/media/ipu3/ipu3-css.c b/drivers/staging/media/ipu3/ipu3-css.c
> index b9354d2bb692..bcb1d436bc98 100644
> --- a/drivers/staging/media/ipu3/ipu3-css.c
> +++ b/drivers/staging/media/ipu3/ipu3-css.c
> @@ -2160,11 +2160,6 @@ int ipu3_css_set_parameters(struct ipu3_css *css, unsigned int pipe,
>         obgrid_size = ipu3_css_fw_obgrid_size(bi);
>         stripes = bi->info.isp.sp.iterator.num_stripes ? : 1;
>
> -       /*
> -        * TODO(b/118782861): If userspace queues more than 4 buffers, the
> -        * parameters from previous buffers will be overwritten. Fix the driver
> -        * not to allow this.
> -        */

Wouldn't this still happen even with current patch?
imgu_queue_buffers() supposedly queues "as many buffers to CSS as
possible". This means that if the userspace queues more than 4
complete frames, we still end up overwriting the parameter buffers in
the pool. Please correct me if I'm wrong.

>         ipu3_css_pool_get(&css_pipe->pool.parameter_set_info);
>         param_set = ipu3_css_pool_last(&css_pipe->pool.parameter_set_info,
>                                        0)->vaddr;
> diff --git a/drivers/staging/media/ipu3/ipu3-v4l2.c b/drivers/staging/media/ipu3/ipu3-v4l2.c
> index e758a650ad2b..7812c7324893 100644
> --- a/drivers/staging/media/ipu3/ipu3-v4l2.c
> +++ b/drivers/staging/media/ipu3/ipu3-v4l2.c
> @@ -341,8 +341,9 @@ static void ipu3_vb2_buf_queue(struct vb2_buffer *vb)
>         struct imgu_video_device *node =
>                 container_of(vb->vb2_queue, struct imgu_video_device, vbq);
>         unsigned int queue = imgu_node_to_queue(node->id);
> +       struct imgu_buffer *buf = container_of(vb, struct imgu_buffer,
> +                                              vid_buf.vbb.vb2_buf);
>         unsigned long need_bytes;
> -       unsigned int pipe = node->pipe;
>
>         if (vb->vb2_queue->type == V4L2_BUF_TYPE_META_CAPTURE ||
>             vb->vb2_queue->type == V4L2_BUF_TYPE_META_OUTPUT)
> @@ -350,42 +351,18 @@ static void ipu3_vb2_buf_queue(struct vb2_buffer *vb)

Looks like this might need a rebase. This function seems to be called
imgu_vb2_buf_queue() in current linux-next. Other functions seem to
have been changed from ipu3_ to imgu_ as well.

>         else
>                 need_bytes = node->vdev_fmt.fmt.pix_mp.plane_fmt[0].sizeimage;
>
> -       if (queue == IPU3_CSS_QUEUE_PARAMS) {
> -               unsigned long payload = vb2_get_plane_payload(vb, 0);
> -               struct vb2_v4l2_buffer *buf =
> -                       container_of(vb, struct vb2_v4l2_buffer, vb2_buf);
> -               int r = -EINVAL;
> -
> -               if (payload == 0) {
> -                       payload = need_bytes;
> -                       vb2_set_plane_payload(vb, 0, payload);
> -               }
> -               if (payload >= need_bytes)
> -                       r = ipu3_css_set_parameters(&imgu->css, pipe,
> -                                                   vb2_plane_vaddr(vb, 0));
> -               buf->flags = V4L2_BUF_FLAG_DONE;
> -               vb2_buffer_done(vb, r == 0 ? VB2_BUF_STATE_DONE
> -                                          : VB2_BUF_STATE_ERROR);

This patch removes the check of the buffer contents. We should
probably check the payload size in the vb2 .buf_prepare callback and
fail if it doesn't match the parameter struct size.

> -
> -       } else {
> -               struct imgu_buffer *buf = container_of(vb, struct imgu_buffer,
> -                                                      vid_buf.vbb.vb2_buf);
> -
> -               mutex_lock(&imgu->lock);
> +       mutex_lock(&imgu->lock);
> +       if (queue != IPU3_CSS_QUEUE_PARAMS)
>                 ipu3_css_buf_init(&buf->css_buf, queue, buf->map.daddr);
> -               list_add_tail(&buf->vid_buf.list,
> -                             &node->buffers);
> -               mutex_unlock(&imgu->lock);
> +       list_add_tail(&buf->vid_buf.list, &node->buffers);
> +       mutex_unlock(&imgu->lock);
>
> -               vb2_set_plane_payload(&buf->vid_buf.vbb.vb2_buf, 0, need_bytes);
> -
> -               if (imgu->streaming)
> -                       imgu_queue_buffers(imgu, false, pipe);
> -       }
> +       vb2_set_plane_payload(vb, 0, need_bytes);

Uhm, the driver is expected to only set the payload for CAPTURE buffers.

> +       if (imgu->streaming)
> +               imgu_queue_buffers(imgu, false, node->pipe);
>
>         dev_dbg(&imgu->pci_dev->dev, "%s for pipe %d node %d", __func__,
>                 node->pipe, node->id);
> -
>  }
>
>  static int ipu3_vb2_queue_setup(struct vb2_queue *vq,
> diff --git a/drivers/staging/media/ipu3/ipu3.c b/drivers/staging/media/ipu3/ipu3.c
> index 839d9398f8e9..25e121eebee2 100644
> --- a/drivers/staging/media/ipu3/ipu3.c
> +++ b/drivers/staging/media/ipu3/ipu3.c
> @@ -246,6 +246,30 @@ int imgu_queue_buffers(struct imgu_device *imgu, bool initial, unsigned int pipe
>                         dev_warn(&imgu->pci_dev->dev,
>                                  "Vf not enabled, ignore queue");
>                         continue;
> +               } else if (node == IMGU_NODE_PARAMS &&
> +                          imgu_pipe->nodes[node].enabled) {
> +                       struct vb2_buffer *vb;
> +                       struct ipu3_vb2_buffer *ivb;
> +
> +                       if (list_empty(&imgu_pipe->nodes[node].buffers))
> +                               /* No parameters for this frame. */
> +                               continue;
> +                       ivb = list_first_entry(&imgu_pipe->nodes[node].buffers,
> +                                              struct ipu3_vb2_buffer, list);
> +                       vb = &ivb->vbb.vb2_buf;
> +                       r = ipu3_css_set_parameters(&imgu->css, pipe,
> +                                                   vb2_plane_vaddr(vb, 0));
> +                       if (r) {
> +                               vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
> +                               dev_err(&imgu->pci_dev->dev,
> +                                       "set parameters failed.\n");
> +                       } else {
> +                               vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
> +                               dev_dbg(&imgu->pci_dev->dev,
> +                                       "queue user parameters %d to css.\n",
> +                                       vb->index);
> +                       }
> +                       list_del(&ivb->list);

nit: I'd rewrite the code as below, to maintain the kernel convention
of using ifs to handle special cases and keep the regular code flow at
the same level of indentation.

                          r = ipu3_css_set_parameters(&imgu->css, pipe,
                                                      vb2_plane_vaddr(vb, 0));
                          list_del(&ivb->list);
                          if (r) {
                                  vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
                                  dev_err(&imgu->pci_dev->dev,
                                       "set parameters failed.\n");
                                  continue;
                          }

                          vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
                          dev_dbg(&imgu->pci_dev->dev,
                                  "queue user parameters %d to css.\n",
                                   vb->index);

Best regards,
Tomasz
