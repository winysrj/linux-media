Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f195.google.com ([209.85.213.195]:40562 "EHLO
        mail-yb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965592AbeFSNnl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Jun 2018 09:43:41 -0400
Received: by mail-yb0-f195.google.com with SMTP id v17-v6so7299541ybe.7
        for <linux-media@vger.kernel.org>; Tue, 19 Jun 2018 06:43:41 -0700 (PDT)
Received: from mail-yw0-f170.google.com (mail-yw0-f170.google.com. [209.85.161.170])
        by smtp.gmail.com with ESMTPSA id x66-v6sm5934392ywc.76.2018.06.19.06.43.39
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Jun 2018 06:43:40 -0700 (PDT)
Received: by mail-yw0-f170.google.com with SMTP id 81-v6so6891919ywb.6
        for <linux-media@vger.kernel.org>; Tue, 19 Jun 2018 06:43:39 -0700 (PDT)
MIME-Version: 1.0
References: <1522376100-22098-1-git-send-email-yong.zhi@intel.com>
 <1522376100-22098-5-git-send-email-yong.zhi@intel.com> <CAAFQd5C1nKr+hEVREF99sYBy7Nb8Y8TuimHVgn6r6Sz6b--+Dg@mail.gmail.com>
 <C193D76D23A22742993887E6D207B54D341DB176@ORSMSX106.amr.corp.intel.com>
In-Reply-To: <C193D76D23A22742993887E6D207B54D341DB176@ORSMSX106.amr.corp.intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 19 Jun 2018 22:43:27 +0900
Message-ID: <CAAFQd5CWK5E8zuRKcxsZSxY5OUkQ57iYZAewP6aN85bF6LJ-FA@mail.gmail.com>
Subject: Re: [PATCH v6 04/12] intel-ipu3: Implement DMA mapping functions
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

On Tue, Jun 19, 2018 at 12:42 AM Zhi, Yong <yong.zhi@intel.com> wrote:
>
> Hi, Tomasz,
>
> Thanks for the review.
>
> > -----Original Message-----
> > From: Tomasz Figa [mailto:tfiga@chromium.org]
> > Sent: Monday, June 18, 2018 12:09 AM
> > To: Zhi, Yong <yong.zhi@intel.com>
> > Cc: Linux Media Mailing List <linux-media@vger.kernel.org>; Sakari Ailus
> > <sakari.ailus@linux.intel.com>; Mani, Rajmohan
> > <rajmohan.mani@intel.com>; Toivonen, Tuukka
> > <tuukka.toivonen@intel.com>; Hu, Jerry W <jerry.w.hu@intel.com>; Zheng,
> > Jian Xu <jian.xu.zheng@intel.com>
> > Subject: Re: [PATCH v6 04/12] intel-ipu3: Implement DMA mapping
> > functions
> >
> > On Fri, Mar 30, 2018 at 11:15 AM Yong Zhi <yong.zhi@intel.com> wrote:
[snip]
> > > diff --git a/drivers/media/pci/intel/ipu3/ipu3.h
> > > b/drivers/media/pci/intel/ipu3/ipu3.h
> > > new file mode 100644
> > > index 000000000000..2ba6fa58e41c
> > > --- /dev/null
> > > +++ b/drivers/media/pci/intel/ipu3/ipu3.h
> > > @@ -0,0 +1,151 @@
> > > +/* SPDX-License-Identifier: GPL-2.0 */
> > > +/* Copyright (C) 2018 Intel Corporation */
> > > +
> > > +#ifndef __IPU3_H
> > > +#define __IPU3_H
> > > +
> > > +#include <linux/iova.h>
> > > +#include <linux/pci.h>
> > > +
> > > +#include <media/v4l2-device.h>
> > > +#include <media/videobuf2-dma-sg.h>
> > > +
> > > +#include "ipu3-css.h"
> > > +
> > > +#define IMGU_NAME                      "ipu3-imgu"
> > > +
> > > +/*
> > > + * The semantics of the driver is that whenever there is a buffer
> > > +available in
> > > + * master queue, the driver queues a buffer also to all other active
> > nodes.
> > > + * If user space hasn't provided a buffer to all other video nodes
> > > +first,
> > > + * the driver gets an internal dummy buffer and queues it.
> > > + */
> > > +#define IMGU_QUEUE_MASTER              IPU3_CSS_QUEUE_IN
> > > +#define IMGU_QUEUE_FIRST_INPUT         IPU3_CSS_QUEUE_OUT
> > > +#define IMGU_MAX_QUEUE_DEPTH           (2 + 2)
> > > +
> > > +#define IMGU_NODE_IN                   0 /* Input RAW image */
> > > +#define IMGU_NODE_PARAMS               1 /* Input parameters */
> > > +#define IMGU_NODE_OUT                  2 /* Main output for still or video
> > */
> > > +#define IMGU_NODE_VF                   3 /* Preview */
> > > +#define IMGU_NODE_PV                   4 /* Postview for still capture */
> > > +#define IMGU_NODE_STAT_3A              5 /* 3A statistics */
> > > +#define IMGU_NODE_NUM                  6
> >
> > Does this file really belong to this patch?
> >
>
> Included because ipu3-dmamap uses struct defined in this header.

It sounds like we should either move this patch later in the series or
have just the necessary minimum or only forward declarations added in
this patch.

Best regards,
Tomasz
