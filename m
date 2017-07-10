Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:34760 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754097AbdGJTie (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Jul 2017 15:38:34 -0400
Received: by mail-qt0-f193.google.com with SMTP id m54so13959024qtb.1
        for <linux-media@vger.kernel.org>; Mon, 10 Jul 2017 12:38:34 -0700 (PDT)
Date: Mon, 10 Jul 2017 16:38:28 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [PATCH 04/12] [media] uvc: enable subscriptions to other events
Message-ID: <20170710193828.GH10284@jade>
References: <20170616073915.5027-1-gustavo@padovan.org>
 <20170616073915.5027-5-gustavo@padovan.org>
 <c49b13ab-3fd9-e5f2-1a8f-59f72e2e12b8@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c49b13ab-3fd9-e5f2-1a8f-59f72e2e12b8@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-07-07 Shuah Khan <shuahkh@osg.samsung.com>:

> On 06/16/2017 01:39 AM, Gustavo Padovan wrote:
> > From: Gustavo Padovan <gustavo.padovan@collabora.com>
> > 
> > Call v4l2_ctrl_subscribe_event to subscribe to more events supported by
> > v4l.
> > 
> > Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> > ---
> >  drivers/media/usb/uvc/uvc_v4l2.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
> > index 3e7e283..dfa0ccd 100644
> > --- a/drivers/media/usb/uvc/uvc_v4l2.c
> > +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> > @@ -1240,7 +1240,7 @@ static int uvc_ioctl_subscribe_event(struct v4l2_fh *fh,
> >  	case V4L2_EVENT_CTRL:
> >  		return v4l2_event_subscribe(fh, sub, 0, &uvc_ctrl_sub_ev_ops);
> >  	default:
> > -		return -EINVAL;
> > +		return v4l2_ctrl_subscribe_event(fh, sub);
> 
> This looks incorrect. With this change driver will be subscribing to all
> v4l2 events? Is this the intent?

The intent was to enable this driver to subscribe to BUF_QUEUED events. 
It is the only one who can't at the moment. I'll review this.

	Gustavo
