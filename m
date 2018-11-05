Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00252a01.pphosted.com ([62.209.51.214]:33312 "EHLO
        mx07-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729549AbeKEXQr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Nov 2018 18:16:47 -0500
Received: from pps.filterd (m0102628.ppops.net [127.0.0.1])
        by mx07-00252a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id wA5Dqr7W005668
        for <linux-media@vger.kernel.org>; Mon, 5 Nov 2018 13:56:53 GMT
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
        by mx07-00252a01.pphosted.com with ESMTP id 2nh1y5h1hs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Mon, 05 Nov 2018 13:56:53 +0000
Received: by mail-pl1-f199.google.com with SMTP id b3-v6so9979590plr.17
        for <linux-media@vger.kernel.org>; Mon, 05 Nov 2018 05:56:53 -0800 (PST)
MIME-Version: 1.0
References: <CAAoAYcOuXvryXaXTMETDwKeVTooc2f6aCFp3u0FLvB=ETrgXow@mail.gmail.com>
 <085fa404-44ef-8391-3863-1fa90e48187c@xs4all.nl>
In-Reply-To: <085fa404-44ef-8391-3863-1fa90e48187c@xs4all.nl>
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
Date: Mon, 5 Nov 2018 13:56:40 +0000
Message-ID: <CAAoAYcOp+sxOkjDkXJDt8FCYXZqE2EgnDikF1M5PqvjnmQUq+Q@mail.gmail.com>
Subject: Re: VIDIOC_SUBSCRIBE_EVENT for V4L2_EVENT_CTRL regression?
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans

On Mon, 5 Nov 2018 at 13:18, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 11/05/2018 01:21 PM, Dave Stevenson wrote:
> > Hi All
> >
> > I'm testing with 4.19 and finding that testEvents in v4l2-compliance
> > is failing with ""failed to find event for control '%s' type %u", ie
> > it hasn't got the event for the inital values. This is with the
> > various BCM2835 drivers that I'm involved with.
> >
> > Having looked at the v4l2-core history I tried reverting "ad608fb
> > media: v4l: event: Prevent freeing event subscriptions while
> > accessed". The test passes again.
> >
> > Enabling all logging, and adding a couple of logging messages at the
> > beginning and end of v4l2_ctrl_add_event and __v4l2_event_queue_fh
> > error path, I get the following logs:
> >
> > [   90.629999] v4l2_ctrl_add_event: ctrl a2b86fa8 "User Controls" type
> > 6, flags 0001
> > [   90.630002] video0: VIDIOC_SUBSCRIBE_EVENT: type=0x3, id=0x980001, flags=0x1
> > [   91.630166] videodev: v4l2_poll: video0: poll: 00000000
> > [   91.630311] videodev: v4l2_poll: video0: poll: 00000000
> > [   91.630325] video0: VIDIOC_UNSUBSCRIBE_EVENT: type=0x3,
> > id=0x980001, flags=0x1
> > [   91.630396] v4l2_ctrl_add_event: ctrl 8f6fcc61 "Brightness" type 1,
> > flags 0001
> > [   91.630403] __v4l2_event_queue_fh: Not subscribed to event type 3 id 0x980001
> > [   91.630407] v4l2_ctrl_add_event: ctrl 8f6fcc61 "Brightness" type 1
> > - initial values queued
> > [   91.630409] video0: VIDIOC_SUBSCRIBE_EVENT: type=0x3, id=0x980900, flags=0x1
> > [   92.630513] videodev: v4l2_poll: video0: poll: 00000000
> > [   92.630660] videodev: v4l2_poll: video0: poll: 00000000
> > [   92.630729] videodev: v4l2_release: video0: release
> >
> > So __v4l2_event_queue_fh is dropping the event as we aren't subscribed
> > at the point that the initial values are queued.
> >
> > Sorry, I don't have any other devices that support subscribing for
> > events to hand (uvcvideo passes the test as it reports unsupported). I
> > don't have a media tree build immediately available either, but I
> > can't see anything related to this in the recent history. I can go
> > down that route if needed.
> > v4l-utils repo was synced today - head at "f9881444e8 cec-compliance:
> > wake-up on Active Source is warn for <2.0"
> >
> > Could someone test on other hardware to confirm that it's not the
> > drivers I'm using? I'm fairly certain it isn't as that patch does call
> > sev->ops->add(sev, elems); before list_add(&sev->list,
> > &fh->subscribed), and that is guaranteed to fail if sev->ops->add
> > immediately queues an event.
>
> Just to pitch in, I got similar issues when I tried to apply that commit
> to our Cisco code base. I've been away for a week and had no time to look
> into the cause, but it really appears that that commit was bad.
>
> Sakari, can you take a look at this?

Thanks for confirming that it's not just me!

Swapping around the order of the list_add and ops->add fixes the
issue, but I'm not clear enough on whether there is a chance for
events to have been raised and need clearing to propose a full patch.
I'm currently running with:
diff --git a/drivers/media/v4l2-core/v4l2-event.c
b/drivers/media/v4l2-core/v4l2-event.c
index a3ef1f5..a997d2e 100644
--- a/drivers/media/v4l2-core/v4l2-event.c
+++ b/drivers/media/v4l2-core/v4l2-event.c
@@ -232,18 +234,20 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
                goto out_unlock;
        }

+       spin_lock_irqsave(&fh->vdev->fh_lock, flags);
+       list_add(&sev->list, &fh->subscribed);
+       spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
+
        if (sev->ops && sev->ops->add) {
                ret = sev->ops->add(sev, elems);
                if (ret) {
+                       spin_lock_irqsave(&fh->vdev->fh_lock, flags);
+                       list_del(&sev->list);
+                       spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
                        kvfree(sev);
-                       goto out_unlock;
                }
        }

-       spin_lock_irqsave(&fh->vdev->fh_lock, flags);
-       list_add(&sev->list, &fh->subscribed);
-       spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
-
 out_unlock:
        mutex_unlock(&fh->subscribe_lock);

Is there a need to iterate the sev->events list and free any
potentially pending events there in the ops->add error path?
We still have the subscribe_lock held, so I don't think that it
reintroduces the issue that the patch was fixing of unsubscribing
before subscribed.

This patch has also been merged to stable, so 4.14 is affected as well.

  Dave
