Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f196.google.com ([209.85.219.196]:33322 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728065AbeIRU4A (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Sep 2018 16:56:00 -0400
Received: by mail-yb1-f196.google.com with SMTP id y9-v6so989717ybh.0
        for <linux-media@vger.kernel.org>; Tue, 18 Sep 2018 08:22:56 -0700 (PDT)
Received: from mail-yw1-f44.google.com (mail-yw1-f44.google.com. [209.85.161.44])
        by smtp.gmail.com with ESMTPSA id t124-v6sm1082317ywt.105.2018.09.18.08.22.54
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Sep 2018 08:22:55 -0700 (PDT)
Received: by mail-yw1-f44.google.com with SMTP id n21-v6so935498ywh.5
        for <linux-media@vger.kernel.org>; Tue, 18 Sep 2018 08:22:54 -0700 (PDT)
MIME-Version: 1.0
References: <1522376100-22098-1-git-send-email-yong.zhi@intel.com>
 <1522376100-22098-13-git-send-email-yong.zhi@intel.com> <CAAFQd5CdV2BxBnW4Z70q7Sm0j=e1eO0MTTScFs-zPnMH8JHELw@mail.gmail.com>
 <C193D76D23A22742993887E6D207B54D3DAFA2B2@ORSMSX103.amr.corp.intel.com>
In-Reply-To: <C193D76D23A22742993887E6D207B54D3DAFA2B2@ORSMSX103.amr.corp.intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 19 Sep 2018 00:22:42 +0900
Message-ID: <CAAFQd5AvejyUy_BurfA8uo5hXCVCXjPfj+-cNXYFduk77LuuSg@mail.gmail.com>
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

On Mon, Sep 17, 2018 at 5:20 AM Zhi, Yong <yong.zhi@intel.com> wrote:
>
> Hi, Tomasz,
>
> Thanks for the code review.
>
> > -----Original Message-----
> > From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> > owner@vger.kernel.org] On Behalf Of Tomasz Figa
> > Sent: Monday, July 2, 2018 3:08 AM
> > To: Zhi, Yong <yong.zhi@intel.com>
> > Cc: Linux Media Mailing List <linux-media@vger.kernel.org>; Sakari Ailus
> > <sakari.ailus@linux.intel.com>; Mani, Rajmohan
> > <rajmohan.mani@intel.com>; Toivonen, Tuukka
> > <tuukka.toivonen@intel.com>; Hu, Jerry W <jerry.w.hu@intel.com>; Zheng,
> > Jian Xu <jian.xu.zheng@intel.com>
> > Subject: Re: [PATCH v6 12/12] intel-ipu3: Add imgu top level pci device
> > driver
> >
> > Hi Yong,
> >
> > On Fri, Mar 30, 2018 at 11:15 AM Yong Zhi <yong.zhi@intel.com> wrote:
> > > +/*
> > > + * Queue as many buffers to CSS as possible. If all buffers don't fit
> > > +into
> > > + * CSS buffer queues, they remain unqueued and will be queued later.
> > > + */
> > > +int imgu_queue_buffers(struct imgu_device *imgu, bool initial) {
> > > +       unsigned int node;
> > > +       int r = 0;
> > > +       struct imgu_buffer *ibuf;
> > > +
> > > +       if (!ipu3_css_is_streaming(&imgu->css))
> > > +               return 0;
> > > +
> > > +       mutex_lock(&imgu->lock);
> > > +
> > > +       /* Buffer set is queued to FW only when input buffer is ready */
> > > +       if (!imgu_queue_getbuf(imgu, IMGU_NODE_IN)) {
> > > +               mutex_unlock(&imgu->lock);
> > > +               return 0;
> > > +       }
> > > +       for (node = IMGU_NODE_IN + 1; 1; node = (node + 1) %
> > > + IMGU_NODE_NUM) {
> >
> > Shouldn't we make (node != IMGU_NODE_IN || imgu_queue_getbuf(imgu,
> > IMGU_NODE_IN)) the condition here, rather than 1?
> >
> > This would also let us remove the explicit call to imgu_queue_getbuf()
> > above the loop.
> >
>
> Ack, will make the suggested changes regarding the loop condition evaluation.

Just to make sure, the suggestion also includes starting from
IMGU_NODE_IN (not + 1), i.e.

for (node = IMGU_NODE_IN;
     node != IMGU_NODE_IN || imgu_queue_getbuf(imgu, IMGU_NODE_IN);
     node = (node + 1) % IMGU_NODE_NUM) {
        // ...
}

> > > +static int __maybe_unused imgu_suspend(struct device *dev) {
> > > +       struct pci_dev *pci_dev = to_pci_dev(dev);
> > > +       struct imgu_device *imgu = pci_get_drvdata(pci_dev);
> > > +       unsigned long expire;
> > > +
> > > +       dev_dbg(dev, "enter %s\n", __func__);
> > > +       imgu->suspend_in_stream = ipu3_css_is_streaming(&imgu->css);
> > > +       if (!imgu->suspend_in_stream)
> > > +               goto out;
> > > +       /* Block new buffers to be queued to CSS. */
> > > +       atomic_set(&imgu->qbuf_barrier, 1);
> > > +       /*
> > > +        * Wait for currently running irq handler to be done so that
> > > +        * no new buffers will be queued to fw later.
> > > +        */
> > > +       synchronize_irq(pci_dev->irq);
> > > +       /* Wait until all buffers in CSS are done. */
> > > +       expire = jiffies + msecs_to_jiffies(1000);
> > > +       while (!ipu3_css_queue_empty(&imgu->css)) {
> > > +               if (time_is_before_jiffies(expire)) {
> > > +                       dev_err(dev, "wait buffer drain timeout.\n");
> > > +                       break;
> > > +               }
> > > +       }
> >
> > Uhm. We struggle to save some power by suspending the device only to
> > end up with an ugly busy wait that could take even a second here. This
> > doesn't make any sense.
> >
> > We had a working solution using a wait queue in previous revision [1].
> > What happened to it?
> >
> > [1] https://chromium-
> > review.googlesource.com/c/chromiumos/third_party/kernel/+/1029594/2
> > /drivers/media/pci/intel/ipu3/ipu3.c#b913
> > (see the left side)
> >
>
> The code here was based on an old version of patch "ipu3-imgu: Avoid might sleep operations in suspend callback" at submission, so it did have buf_drain_wq, sorry for the confusion.
>

I guess that means that v7 is going to have the workqueue back? :)

Best regards,
Tomasz
