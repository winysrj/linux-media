Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:34559 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751031AbdGZA0U (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Jul 2017 20:26:20 -0400
Received: by mail-qk0-f194.google.com with SMTP id q66so14150455qki.1
        for <linux-media@vger.kernel.org>; Tue, 25 Jul 2017 17:26:19 -0700 (PDT)
Date: Tue, 25 Jul 2017 21:26:14 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [PATCH 04/12] [media] uvc: enable subscriptions to other events
Message-ID: <20170726002614.GB15518@jade>
References: <20170616073915.5027-1-gustavo@padovan.org>
 <20170616073915.5027-5-gustavo@padovan.org>
 <c49b13ab-3fd9-e5f2-1a8f-59f72e2e12b8@osg.samsung.com>
 <20170710193828.GH10284@jade>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170710193828.GH10284@jade>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-07-10 Gustavo Padovan <gustavo@padovan.org>:

> 2017-07-07 Shuah Khan <shuahkh@osg.samsung.com>:
> 
> > On 06/16/2017 01:39 AM, Gustavo Padovan wrote:
> > > From: Gustavo Padovan <gustavo.padovan@collabora.com>
> > > 
> > > Call v4l2_ctrl_subscribe_event to subscribe to more events supported by
> > > v4l.
> > > 
> > > Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> > > ---
> > >  drivers/media/usb/uvc/uvc_v4l2.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
> > > index 3e7e283..dfa0ccd 100644
> > > --- a/drivers/media/usb/uvc/uvc_v4l2.c
> > > +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> > > @@ -1240,7 +1240,7 @@ static int uvc_ioctl_subscribe_event(struct v4l2_fh *fh,
> > >  	case V4L2_EVENT_CTRL:
> > >  		return v4l2_event_subscribe(fh, sub, 0, &uvc_ctrl_sub_ev_ops);
> > >  	default:
> > > -		return -EINVAL;
> > > +		return v4l2_ctrl_subscribe_event(fh, sub);
> > 
> > This looks incorrect. With this change driver will be subscribing to all
> > v4l2 events? Is this the intent?
> 
> The intent was to enable this driver to subscribe to BUF_QUEUED events. 
> It is the only one who can't at the moment. I'll review this.

This change do not enable all events, the only new event added is the
BUF_QUEUED. v4l2_ctrl_subscribe_event() only add V4L2_EVENT_CTRL and
V4L2_EVENT_BUF_QUEUED, but the V4L2_EVENT_CTRL case can't be accessed
tere is this situation.

	Gustavo
