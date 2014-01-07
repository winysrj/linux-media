Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:54010 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaAGNJ0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jan 2014 08:09:26 -0500
Received: by mail-oa0-f41.google.com with SMTP id j17so123014oag.14
        for <linux-media@vger.kernel.org>; Tue, 07 Jan 2014 05:09:26 -0800 (PST)
MIME-Version: 1.0
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 7 Jan 2014 14:09:05 +0100
Message-ID: <CAPybu_0fyzj45rhia71Qq+5QOps0EeuRNqcXDDo+D0HW7Exwdw@mail.gmail.com>
Subject: Question about videobuf2 with 0 buffers
To: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

  White testing a driver I have stepped into some strange behaviour
and I want to know if it is a feature or a bug.

   I am using yavta to test the system and I run this command:

yavta /dev/video0 -c -n 0

to start a capture with 0 buffers (Even if I dont know where this can be useful)

And I have found out that:

1) If the user does a streamon() and then  close() the descriptor,
streamoff is not called, this is because he has never been set as
owner of the queue. (on vb2_fop_release, queue_release is only called
if the owns the queue)

Is this expected? Shouldn't we leave the stream stopped?

I propose to set vdev->queue->owner to the current vdev on streamon if
it does not have an owner.

Or in vb2_fop_release set check for :
if (!vdev->queue->owner || file->private_data == vdev->queue->owner)
instead of
if (file->private_data == vdev->queue->owner)

Shall I post a patch?

2) the queue_setup handler of the driver is not called, this could be
expected, since it is commented on the code.
/*
* In case of REQBUFS(0) return immediately without calling
* driver's queue_setup() callback and allocating resources.
*/
But I find it strange, the driver could be doing some initialization there...


Thanks!



-- 
Ricardo Ribalda
