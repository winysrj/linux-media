Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00252a01.pphosted.com ([62.209.51.214]:21591 "EHLO
        mx07-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728184AbeIUTfh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Sep 2018 15:35:37 -0400
Received: from pps.filterd (m0102628.ppops.net [127.0.0.1])
        by mx07-00252a01.pphosted.com (8.16.0.23/8.16.0.23) with SMTP id w8LDXBIG000821
        for <linux-media@vger.kernel.org>; Fri, 21 Sep 2018 14:46:38 +0100
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
        by mx07-00252a01.pphosted.com with ESMTP id 2mmkmdr9vg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Fri, 21 Sep 2018 14:46:38 +0100
Received: by mail-pl1-f200.google.com with SMTP id n4-v6so6192389plk.7
        for <linux-media@vger.kernel.org>; Fri, 21 Sep 2018 06:46:37 -0700 (PDT)
MIME-Version: 1.0
References: <20180918014509.6394-1-niklas.soderlund+renesas@ragnatech.se>
 <1658112.YQ0khu1noY@avalon> <CAAoAYcPrEx9bsB0TZ87N8CqsHhWBDzLStOptv2nv6iyfWZqcZg@mail.gmail.com>
 <6518376.j8BxZoQUpz@avalon> <20180921120342.ku3ed3jkn5puavu6@valkosipuli.retiisi.org.uk>
In-Reply-To: <20180921120342.ku3ed3jkn5puavu6@valkosipuli.retiisi.org.uk>
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
Date: Fri, 21 Sep 2018 14:46:23 +0100
Message-ID: <CAAoAYcOQC37r=CC94qpGjaLu_R=QZoGF0z6A_zFOmMsG0AX_5A@mail.gmail.com>
Subject: Re: [PATCH 1/3] i2c: adv748x: store number of CSI-2 lanes described
 in device tree
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        kieran.bingham@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se, jacopo@jmondi.org,
        LMML <linux-media@vger.kernel.org>,
        linux-renesas-soc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari

On Fri, 21 Sep 2018 at 13:03, Sakari Ailus <sakari.ailus@iki.fi> wrote:
>
> Hi Laurent,
>
> On Fri, Sep 21, 2018 at 01:01:09PM +0300, Laurent Pinchart wrote:
> ...
> > > There is also the oddball one of the TC358743 which dynamically
> > > switches the number of lanes in use based on the data rate required.
> > > That's probably a separate discussion, but is currently dealt with via
> > > g_mbus_config as amended back in Sept 2017 [1].
> >
> > This falls into the case of dynamic configuration discovery and negotiation I
> > mentioned above, and we clearly need to make sure the v4l2_subdev API supports
> > this use case.
>
> This could be added to struct v4l2_mbus_frame_desc; Niklas has driver that
> uses the framework support here, so this would likely end up merged soon:
>
> <URL:https://git.linuxtv.org/sailus/media_tree.git/tree/include/media/v4l2-subdev.h?h=vc&id=0cbd2b25b37ef5b2e6a14340dbca6d2d2d5af98e>
>
> The CSI-2 bus parameters are missing there currently but nothing prevents
> adding them. The semantics of set_frame_desc() needs to be probably defined
> better than it currently is.

So which parameters are you thinking of putting in there? Just the
number of lanes, or clocking modes and all other parameters for the
CSI interface?
It sounds like this should take over from the receiver's DT
completely, other than for lane reordering.

Of course the $1million question is rough timescales? The last commit
on there appears to be March 2017.
I've had to backburner my CSI2 receiver driver due to other time
pressures, so it sounds like I may as well leave it there until this
all settles down, or start looking at Niklas' driver and what changes
infers.

Thanks,
  Dave
