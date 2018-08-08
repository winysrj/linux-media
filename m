Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f67.google.com ([209.85.161.67]:43666 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbeHHGI3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Aug 2018 02:08:29 -0400
Received: by mail-yw1-f67.google.com with SMTP id l189-v6so583738ywb.10
        for <linux-media@vger.kernel.org>; Tue, 07 Aug 2018 20:50:53 -0700 (PDT)
Received: from mail-yw1-f48.google.com (mail-yw1-f48.google.com. [209.85.161.48])
        by smtp.gmail.com with ESMTPSA id y133-v6sm3708774ywy.31.2018.08.07.20.50.50
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Aug 2018 20:50:51 -0700 (PDT)
Received: by mail-yw1-f48.google.com with SMTP id j68-v6so604869ywg.1
        for <linux-media@vger.kernel.org>; Tue, 07 Aug 2018 20:50:50 -0700 (PDT)
MIME-Version: 1.0
References: <cover.3cb9065dabdf5d455da508fb4109201e626d5ee7.1522168131.git-series.kieran.bingham@ideasonboard.com>
 <cae511f90085701e7093ce39dc8dabf8fc16b844.1522168131.git-series.kieran.bingham@ideasonboard.com>
 <CAAFQd5CQEhmuLbs0dmGfu66x1Xq1V_kOT0bV_DoPitkkOX5Q4A@mail.gmail.com> <15196240.O2E9MK7q6s@avalon>
In-Reply-To: <15196240.O2E9MK7q6s@avalon>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 8 Aug 2018 12:50:37 +0900
Message-ID: <CAAFQd5B613JJLK4drTRYT=qP+wZriMt4afAgXKvBgEU4H0vtOA@mail.gmail.com>
Subject: Re: [PATCH v4 6/6] media: uvcvideo: Move decode processing to process context
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        olivier.braun@stereolabs.com, troy.kisky@boundarydevices.com,
        Randy Dunlap <rdunlap@infradead.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Wed, Aug 8, 2018 at 8:12 AM Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Tomasz,
>
> On Tuesday, 7 August 2018 12:54:02 EEST Tomasz Figa wrote:
> > On Wed, Mar 28, 2018 at 1:47 AM Kieran Bingham wrote:
>
> [snip]
>
> > In our testing, this function ends up being called twice
>
> In your testing, has this patch series brought noticeable performance
> improvements ? Is there a particular reason you tested it, beside general
> support of UVC devices in ChromeOS ?

Some of our older ARM devices have external USB ports wired to a low
end dwc2 controller, which puts quite strict timing requirements on
interrupt handling. For some cameras that produce bigger payloads (in
our testing that was Logitech BRIO, running at 1080p), almost half of
every frame would be dropped, due to the memcpy from uncached memory
taking too much time. With this series, it goes down to bottom ~10% of
only a part of the frames. With one more optimization from Keiichi
[1], the problem disappears almost completely.

[1] https://lore.kernel.org/patchwork/patch/956388/

Best regards,
Tomasz
