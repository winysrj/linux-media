Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:33165 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754370AbdGJTmp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Jul 2017 15:42:45 -0400
Received: by mail-qt0-f195.google.com with SMTP id c20so13976799qte.0
        for <linux-media@vger.kernel.org>; Mon, 10 Jul 2017 12:42:45 -0700 (PDT)
Date: Mon, 10 Jul 2017 16:42:40 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [PATCH 05/12] [media] vivid: assign the specific device to the
 vb2_queue->dev
Message-ID: <20170710194240.GI10284@jade>
References: <20170616073915.5027-1-gustavo@padovan.org>
 <20170616073915.5027-6-gustavo@padovan.org>
 <c34cc77a-740f-3955-d6e6-2c04a778c190@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c34cc77a-740f-3955-d6e6-2c04a778c190@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-07-07 Shuah Khan <shuahkh@osg.samsung.com>:

> On 06/16/2017 01:39 AM, Gustavo Padovan wrote:
> > From: Gustavo Padovan <gustavo.padovan@collabora.com>
> > 
> > Instead of assigning the global v4l2 device, assign the specific device.
> > This was causing trouble when using using V4L2 events with vivid
> > devices. The device's queue should be the same we opened in userspace.
> > 
> > Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> > ---
> >  drivers/media/platform/vivid/vivid-core.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
> > index ef344b9..8843170 100644
> > --- a/drivers/media/platform/vivid/vivid-core.c
> > +++ b/drivers/media/platform/vivid/vivid-core.c
> > @@ -1070,7 +1070,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
> >  		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> >  		q->min_buffers_needed = 2;
> >  		q->lock = &dev->mutex;
> > -		q->dev = dev->v4l2_dev.dev;
> > +		q->dev = &dev->vid_cap_dev.dev;
> 
> Does this work in all cases? My concern is that in some code paths
> q->dev might be used to initiate release perhaps.
> 
> Fore example v4l2_dev.release is vivid_dev_release()
> dev->v4l2_dev.release = vivid_dev_release;
> 
> vid_cap_dev release is video_device_release_empty
> 
> This is one difference, but there might be others and the code paths
> that might depend on q->dev being the v4l2_dev.dev which is the global
> dev.

Sure, I'll check this again.

	Gustavo
