Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:38417 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753828AbeGBIIn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2018 04:08:43 -0400
Received: by mail-yw0-f193.google.com with SMTP id w13-v6so6363428ywa.5
        for <linux-media@vger.kernel.org>; Mon, 02 Jul 2018 01:08:43 -0700 (PDT)
Received: from mail-yb0-f172.google.com (mail-yb0-f172.google.com. [209.85.213.172])
        by smtp.gmail.com with ESMTPSA id u4-v6sm2863165ywd.21.2018.07.02.01.08.41
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Jul 2018 01:08:41 -0700 (PDT)
Received: by mail-yb0-f172.google.com with SMTP id s8-v6so1173175ybe.8
        for <linux-media@vger.kernel.org>; Mon, 02 Jul 2018 01:08:41 -0700 (PDT)
MIME-Version: 1.0
References: <1522376100-22098-1-git-send-email-yong.zhi@intel.com> <1522376100-22098-13-git-send-email-yong.zhi@intel.com>
In-Reply-To: <1522376100-22098-13-git-send-email-yong.zhi@intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 2 Jul 2018 17:08:29 +0900
Message-ID: <CAAFQd5CdV2BxBnW4Z70q7Sm0j=e1eO0MTTScFs-zPnMH8JHELw@mail.gmail.com>
Subject: Re: [PATCH v6 12/12] intel-ipu3: Add imgu top level pci device driver
To: Yong Zhi <yong.zhi@intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

On Fri, Mar 30, 2018 at 11:15 AM Yong Zhi <yong.zhi@intel.com> wrote:
> +/*
> + * Queue as many buffers to CSS as possible. If all buffers don't fit into
> + * CSS buffer queues, they remain unqueued and will be queued later.
> + */
> +int imgu_queue_buffers(struct imgu_device *imgu, bool initial)
> +{
> +       unsigned int node;
> +       int r = 0;
> +       struct imgu_buffer *ibuf;
> +
> +       if (!ipu3_css_is_streaming(&imgu->css))
> +               return 0;
> +
> +       mutex_lock(&imgu->lock);
> +
> +       /* Buffer set is queued to FW only when input buffer is ready */
> +       if (!imgu_queue_getbuf(imgu, IMGU_NODE_IN)) {
> +               mutex_unlock(&imgu->lock);
> +               return 0;
> +       }
> +       for (node = IMGU_NODE_IN + 1; 1; node = (node + 1) % IMGU_NODE_NUM) {

Shouldn't we make (node != IMGU_NODE_IN || imgu_queue_getbuf(imgu,
IMGU_NODE_IN)) the condition here, rather than 1?

This would also let us remove the explicit call to imgu_queue_getbuf()
above the loop.

> +               if (node == IMGU_NODE_VF &&
> +                   (imgu->css.pipe_id == IPU3_CSS_PIPE_ID_CAPTURE ||
> +                    !imgu->nodes[IMGU_NODE_VF].enabled)) {
> +                       continue;
> +               } else if (node == IMGU_NODE_PV &&
> +                          (imgu->css.pipe_id == IPU3_CSS_PIPE_ID_VIDEO ||
> +                           !imgu->nodes[IMGU_NODE_PV].enabled)) {
> +                       continue;
> +               } else if (imgu->queue_enabled[node]) {
> +                       struct ipu3_css_buffer *buf =
> +                                       imgu_queue_getbuf(imgu, node);
> +                       int dummy;
> +
> +                       if (!buf)
> +                               break;
> +
> +                       r = ipu3_css_buf_queue(&imgu->css, buf);
> +                       if (r)
> +                               break;
> +                       dummy = imgu_dummybufs_check(imgu, buf);
> +                       if (!dummy)
> +                               ibuf = container_of(buf, struct imgu_buffer,
> +                                                   css_buf);
> +                       dev_dbg(&imgu->pci_dev->dev,
> +                               "queue %s %s buffer %d to css da: 0x%08x\n",
> +                               dummy ? "dummy" : "user",
> +                               imgu_node_map[node].name,
> +                               dummy ? 0 : ibuf->vid_buf.vbb.vb2_buf.index,
> +                               (u32)buf->daddr);
> +               }
> +               if (node == IMGU_NODE_IN &&
> +                   !imgu_queue_getbuf(imgu, IMGU_NODE_IN))
> +                       break;

My suggestion to the for loop condition is based on this.

> +       }
> +       mutex_unlock(&imgu->lock);
> +
> +       if (r && r != -EBUSY)
> +               goto failed;
> +
> +       return 0;
> +
> +failed:
> +       /*
> +        * On error, mark all buffers as failed which are not
> +        * yet queued to CSS
> +        */
> +       dev_err(&imgu->pci_dev->dev,
> +               "failed to queue buffer to CSS on queue %i (%d)\n",
> +               node, r);
> +
> +       if (initial)
> +               /* If we were called from streamon(), no need to finish bufs */
> +               return r;
> +
> +       for (node = 0; node < IMGU_NODE_NUM; node++) {
> +               struct imgu_buffer *buf, *buf0;
> +
> +               if (!imgu->queue_enabled[node])
> +                       continue;       /* Skip disabled queues */
> +
> +               mutex_lock(&imgu->lock);
> +               list_for_each_entry_safe(buf, buf0, &imgu->nodes[node].buffers,
> +                                        vid_buf.list) {
> +                       if (ipu3_css_buf_state(&buf->css_buf) ==
> +                                       IPU3_CSS_BUFFER_QUEUED)
> +                               continue;       /* Was already queued, skip */
> +
> +                       ipu3_v4l2_buffer_done(&buf->vid_buf.vbb.vb2_buf,
> +                                             VB2_BUF_STATE_ERROR);
> +               }
> +               mutex_unlock(&imgu->lock);
> +       }
> +
> +       return r;
> +}

[snip]

> +static irqreturn_t imgu_isr_threaded(int irq, void *imgu_ptr)
> +{
> +       struct imgu_device *imgu = imgu_ptr;
> +
> +       /* Dequeue / queue buffers */
> +       do {
> +               u64 ns = ktime_get_ns();
> +               struct ipu3_css_buffer *b;
> +               struct imgu_buffer *buf;
> +               unsigned int node;
> +               bool dummy;
> +
> +               do {
> +                       mutex_lock(&imgu->lock);
> +                       b = ipu3_css_buf_dequeue(&imgu->css);
> +                       mutex_unlock(&imgu->lock);
> +               } while (PTR_ERR(b) == -EAGAIN);
> +
> +               if (IS_ERR_OR_NULL(b)) {
> +                       if (!b || PTR_ERR(b) == -EBUSY) /* All done */
> +                               break;
> +                       dev_err(&imgu->pci_dev->dev,
> +                               "failed to dequeue buffers (%ld)\n",
> +                               PTR_ERR(b));
> +                       break;
> +               }
> +
> +               node = imgu_map_node(imgu, b->queue);
> +               dummy = imgu_dummybufs_check(imgu, b);
> +               if (!dummy)
> +                       buf = container_of(b, struct imgu_buffer, css_buf);
> +               dev_dbg(&imgu->pci_dev->dev,
> +                       "dequeue %s %s buffer %d from css\n",
> +                       dummy ? "dummy" : "user",
> +                       imgu_node_map[node].name,
> +                       dummy ? 0 : buf->vid_buf.vbb.vb2_buf.index);
> +
> +               if (dummy)
> +                       /* It was a dummy buffer, skip it */
> +                       continue;
> +
> +               /* Fill vb2 buffer entries and tell it's ready */
> +               if (!imgu->nodes[node].output) {
> +                       buf->vid_buf.vbb.vb2_buf.timestamp = ns;
> +                       buf->vid_buf.vbb.field = V4L2_FIELD_NONE;
> +                       buf->vid_buf.vbb.sequence =
> +                               atomic_inc_return(&imgu->nodes[node].sequence);
> +               }
> +               imgu_buffer_done(imgu, &buf->vid_buf.vbb.vb2_buf,
> +                                ipu3_css_buf_state(&buf->css_buf) ==
> +                                                   IPU3_CSS_BUFFER_DONE ?
> +                                                   VB2_BUF_STATE_DONE :
> +                                                   VB2_BUF_STATE_ERROR);
> +       } while (1);
> +
> +       /*
> +        * Try to queue more buffers for CSS.
> +        * qbuf_barrier is used to disable new buffers
> +        * to be queued to CSS.
> +        */
> +       if (!atomic_read(&imgu->qbuf_barrier))
> +               imgu_queue_buffers(imgu, false);
> +
> +       return IRQ_NONE;

This is a serious bug. An interrupt handler must not return IRQ_NONE
unless it's really sure that the device it handles did not generate
any interrupt. This threaded handler is called as a result of the
hardirq handler actually finding an interrupt to be handled, so we
must always return IRQ_HANDLED here.

[snip]

> +static int __maybe_unused imgu_suspend(struct device *dev)
> +{
> +       struct pci_dev *pci_dev = to_pci_dev(dev);
> +       struct imgu_device *imgu = pci_get_drvdata(pci_dev);
> +       unsigned long expire;
> +
> +       dev_dbg(dev, "enter %s\n", __func__);
> +       imgu->suspend_in_stream = ipu3_css_is_streaming(&imgu->css);
> +       if (!imgu->suspend_in_stream)
> +               goto out;
> +       /* Block new buffers to be queued to CSS. */
> +       atomic_set(&imgu->qbuf_barrier, 1);
> +       /*
> +        * Wait for currently running irq handler to be done so that
> +        * no new buffers will be queued to fw later.
> +        */
> +       synchronize_irq(pci_dev->irq);
> +       /* Wait until all buffers in CSS are done. */
> +       expire = jiffies + msecs_to_jiffies(1000);
> +       while (!ipu3_css_queue_empty(&imgu->css)) {
> +               if (time_is_before_jiffies(expire)) {
> +                       dev_err(dev, "wait buffer drain timeout.\n");
> +                       break;
> +               }
> +       }

Uhm. We struggle to save some power by suspending the device only to
end up with an ugly busy wait that could take even a second here. This
doesn't make any sense.

We had a working solution using a wait queue in previous revision [1].
What happened to it?

[1] https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/1029594/2/drivers/media/pci/intel/ipu3/ipu3.c#b913
(see the left side)

> +       ipu3_css_stop_streaming(&imgu->css);
> +       atomic_set(&imgu->qbuf_barrier, 0);
> +       imgu_powerdown(imgu);
> +       pm_runtime_force_suspend(dev);
> +out:
> +       dev_dbg(dev, "leave %s\n", __func__);
> +       return 0;
> +}

Best regards,
Tomasz
