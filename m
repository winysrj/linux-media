Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.161.175]:35136 "EHLO
        mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753187AbdFPJDh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 05:03:37 -0400
Received: by mail-yw0-f175.google.com with SMTP id v7so16230427ywc.2
        for <linux-media@vger.kernel.org>; Fri, 16 Jun 2017 02:03:36 -0700 (PDT)
Received: from mail-yb0-f179.google.com (mail-yb0-f179.google.com. [209.85.213.179])
        by smtp.gmail.com with ESMTPSA id u187sm686764ywd.22.2017.06.16.02.03.34
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Jun 2017 02:03:35 -0700 (PDT)
Received: by mail-yb0-f179.google.com with SMTP id e201so6899406ybb.1
        for <linux-media@vger.kernel.org>; Fri, 16 Jun 2017 02:03:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170616084935.GJ12407@valkosipuli.retiisi.org.uk>
References: <1496695157-19926-1-git-send-email-yong.zhi@intel.com>
 <1496695157-19926-2-git-send-email-yong.zhi@intel.com> <CAAFQd5B6LiWgX+=-HJnO480FF-AXDa+UqtSs+SYUG=S+kGgNVg@mail.gmail.com>
 <CAAFQd5DpzAGBi_kevEBp05yC4ytM3Q8WU2owZucsE3AZ=s=OoA@mail.gmail.com>
 <20170606072519.GF15419@paasikivi.fi.intel.com> <1d067ac0-6265-4262-e59b-089d6055550b@xs4all.nl>
 <CAAFQd5CY7jUJEicQ79QLTYP65cWqMhtTXJvZD-VCnKN134Ypeg@mail.gmail.com>
 <CAAFQd5C1PQkMgu3QMJ=_J2-FCiUzVwGft6-U3JQRQNy4=1CgRg@mail.gmail.com>
 <20170616082510.GH12407@valkosipuli.retiisi.org.uk> <CAAFQd5CDG0QYDaD=4ono0Yahz+7+TJ_KLsc+K-bgN82yFr6qmg@mail.gmail.com>
 <20170616084935.GJ12407@valkosipuli.retiisi.org.uk>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 16 Jun 2017 18:03:13 +0900
Message-ID: <CAAFQd5DuQE5EyFejgVqsdEPgmcWmvU+7vRLC9Vwmkam4K8o6KA@mail.gmail.com>
Subject: Re: [PATCH 01/12] videodev2.h, v4l2-ioctl: add IPU3 meta buffer format
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 16, 2017 at 5:49 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Tomasz,
>
> On Fri, Jun 16, 2017 at 05:35:52PM +0900, Tomasz Figa wrote:
>> On Fri, Jun 16, 2017 at 5:25 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
>> > Hi Tomasz,
>> >
>> > On Fri, Jun 16, 2017 at 02:52:07PM +0900, Tomasz Figa wrote:
>> >> On Tue, Jun 6, 2017 at 7:09 PM, Tomasz Figa <tfiga@chromium.org> wrote:
>> >> Actually, there is one more thing, which would become possible with
>> >> switching to different queue types. If we have a device with queues
>> >> like this:
>> >> - video input,
>> >> - video output,
>> >> - parameters,
>> >> - statistics,
>> >> they could all be contained within one video node simply exposing 4
>> >> different queues. It would actually even allow an easy implementation
>> >
>> > The problem comes when you have multiple queues with the same type. I
>> > actually once proposed that (albeit for a slightly different purposes:
>> > streams) but the idea was rejected. It was decided to use separate video
>> > nodes instead.
>> >
>> >> of mem2mem, given that for mem2mem devices opening a video node means
>> >> creating a mem2mem context (while multiple video nodes would require
>> >> some special synchronization to map contexts together, which doesn't
>> >> exist as of today).
>> >
>> > V4L2 is very stream oriented and the mem2mem interface somewhat gets around
>> > that. There are cases where at least partially changing per-frame
>> > configuration is needed in streaming cases as well. The request API is
>> > supposed to resolve these issues but it has become evident that the
>> > implementation is far from trivial.
>> >
>> > I'd rather like to have a more generic solution than a number of
>> > framework-lets that have their own semantics of the generic V4L2 IOCTLs that
>> > only work with a particular kind of a device. Once there are new kind of
>> > devices, we'd need to implement another framework-let to support them.
>> >
>> > Add a CSI-2 receiver to the ImgU device and we'll need again something very
>> > different...
>>
>> I need to think if Request API alone is really capable of solving this
>> problem, but if so, it would make sense indeed.
>
> What comes to this driver --- the request API could be beneficial, but the
> driver does not strictly need it. If there were controls that would need to
> be changed during streaming or if the device contained a CSI-2 receiver,
> then it'd be more important to have the request API.

There is one use case, though, which can't be achieved easily with
current model - processing images for two cameras at the same time.
One could theoretically do all the S_FMT/S_WHATNOT magic every frame,
to process the cameras in a round robin fashion, but I'm not sure if
this would work really well in practice.

Best regards,
Tomasz
