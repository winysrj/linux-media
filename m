Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f65.google.com ([209.85.161.65]:34308 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729326AbeKFPUl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Nov 2018 10:20:41 -0500
Received: by mail-yw1-f65.google.com with SMTP id v199-v6so4717138ywg.1
        for <linux-media@vger.kernel.org>; Mon, 05 Nov 2018 21:57:08 -0800 (PST)
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com. [209.85.219.173])
        by smtp.gmail.com with ESMTPSA id r5-v6sm18398533ywr.80.2018.11.05.21.57.06
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Nov 2018 21:57:06 -0800 (PST)
Received: by mail-yb1-f173.google.com with SMTP id i78-v6so4863838ybg.0
        for <linux-media@vger.kernel.org>; Mon, 05 Nov 2018 21:57:06 -0800 (PST)
MIME-Version: 1.0
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
 <1540851790-1777-7-git-send-email-yong.zhi@intel.com> <20181105115525.fuwuxnsyzsvl5oj7@kekkonen.localdomain>
 <C193D76D23A22742993887E6D207B54D3DB2F0EB@ORSMSX106.amr.corp.intel.com>
In-Reply-To: <C193D76D23A22742993887E6D207B54D3DB2F0EB@ORSMSX106.amr.corp.intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 6 Nov 2018 14:56:54 +0900
Message-ID: <CAAFQd5ARewBpE4GE96S+0CThtT7gCvYrD5qt8spchQimvLZg0A@mail.gmail.com>
Subject: Re: [PATCH v7 06/16] intel-ipu3: mmu: Implement driver
To: Yong Zhi <yong.zhi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        Cao Bing Bu <bingbu.cao@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 6, 2018 at 2:50 PM Zhi, Yong <yong.zhi@intel.com> wrote:
>
> Hi, Sakari,
>
> Thanks for the feedback.
>
> > -----Original Message-----
> > From: Sakari Ailus [mailto:sakari.ailus@linux.intel.com]
> > Sent: Monday, November 5, 2018 3:55 AM
> > To: Zhi, Yong <yong.zhi@intel.com>
> > Cc: linux-media@vger.kernel.org; tfiga@chromium.org;
> > mchehab@kernel.org; hans.verkuil@cisco.com;
> > laurent.pinchart@ideasonboard.com; Mani, Rajmohan
> > <rajmohan.mani@intel.com>; Zheng, Jian Xu <jian.xu.zheng@intel.com>; Hu,
> > Jerry W <jerry.w.hu@intel.com>; Toivonen, Tuukka
> > <tuukka.toivonen@intel.com>; Qiu, Tian Shu <tian.shu.qiu@intel.com>; Cao,
> > Bingbu <bingbu.cao@intel.com>
> > Subject: Re: [PATCH v7 06/16] intel-ipu3: mmu: Implement driver
> >
> > Hi Yong,
> >
> > On Mon, Oct 29, 2018 at 03:23:00PM -0700, Yong Zhi wrote:
> > > From: Tomasz Figa <tfiga@chromium.org>
> > >
> > > This driver translates IO virtual address to physical address based on
> > > two levels page tables.
> > >
> > > Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> > > Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> > > ---
> >
> > ...
> >
> > > +static void call_if_ipu3_is_powered(struct ipu3_mmu *mmu,
> > > +                               void (*func)(struct ipu3_mmu *mmu)) {
> > > +   pm_runtime_get_noresume(mmu->dev);
> > > +   if (pm_runtime_active(mmu->dev))
> > > +           func(mmu);
> > > +   pm_runtime_put(mmu->dev);
> >
> > How about:
> >
> >       if (!pm_runtime_get_if_in_use(mmu->dev))
> >               return;
> >
> >       func(mmu);
> >       pm_runtime_put(mmu->dev);
> >
>
> Ack, unless Tomasz has different opinion.

It's actually the proper way of doing it. Thanks for the suggestion.

Best regards,
Tomasz
