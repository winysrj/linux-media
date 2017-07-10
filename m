Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:34735 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754550AbdGJTrz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Jul 2017 15:47:55 -0400
Received: by mail-qt0-f195.google.com with SMTP id m54so13991150qtb.1
        for <linux-media@vger.kernel.org>; Mon, 10 Jul 2017 12:47:54 -0700 (PDT)
Date: Mon, 10 Jul 2017 16:47:49 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [PATCH 09/12] [media] vivid: mark vivid queues as ordered
Message-ID: <20170710194749.GK10284@jade>
References: <20170616073915.5027-1-gustavo@padovan.org>
 <20170616073915.5027-10-gustavo@padovan.org>
 <f8f17191-6217-ef1b-3b55-0dfdb485a7fc@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8f17191-6217-ef1b-3b55-0dfdb485a7fc@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-07-07 Shuah Khan <shuahkh@osg.samsung.com>:

> On 06/16/2017 01:39 AM, Gustavo Padovan wrote:
> > From: Gustavo Padovan <gustavo.padovan@collabora.com>
> > 
> > To enable vivid to be used with explicit synchronization we need
> > to mark its queues as ordered.
> > 
> > Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> > ---
> >  drivers/media/platform/vivid/vivid-core.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
> > index 8843170..c7bef90 100644
> > --- a/drivers/media/platform/vivid/vivid-core.c
> > +++ b/drivers/media/platform/vivid/vivid-core.c
> > @@ -1063,6 +1063,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
> >  		q->type = dev->multiplanar ? V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE :
> >  			V4L2_BUF_TYPE_VIDEO_CAPTURE;
> >  		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ;
> > +		q->ordered = 1;
> 
> How will the driver ensure ordered buffers? Are there more changes needed
> in this driver?

The driver can't requeue a buffer if it mark itself as ordered. It has
to ensure that.

	Gustavo
