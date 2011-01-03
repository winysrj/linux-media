Return-path: <mchehab@gaivota>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2750 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148Ab1ACNyu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jan 2011 08:54:50 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: David Ellingsworth <david@identd.dyndns.org>
Subject: v4l2_device release callback and dsbr100 unlocked_ioctl
Date: Mon,  3 Jan 2011 14:54:28 +0100
Message-Id: <1294062872-8312-1-git-send-email-hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>


This patch series adds reference counting to v4l2_device and a top-level
release callback. This is needed to correctly handle hotplug disconnects.

There are three reasons why this is needed:

1) drivers with multiple device nodes shouldn't call release() until all
   device nodes are no longer referenced. This is hard to implement without
   reference counting in struct v4l2_device.

2) The typical disconnect sequence is this (from radio-mr800.c):

static void usb_amradio_disconnect(struct usb_interface *intf)
{
        struct amradio_device *radio = to_amradio_dev(usb_get_intfdata(intf));

        mutex_lock(&radio->lock);
        /* increase the device node's refcount */
        get_device(&radio->videodev.dev);
        v4l2_device_disconnect(&radio->v4l2_dev);
        video_unregister_device(&radio->videodev);
        mutex_unlock(&radio->lock);
        /* decrease the device node's refcount, allowing it to be released */
        put_device(&radio->videodev.dev);
}

The low-level get/put_device calls are needed because otherwise the
video_unregister_device will cause the video_device's release callback to be
called which kfree()s the radio struct. So without the get_device the
mutex_unlock might access freed memory.

Using such low-level calls is very ugly though, and with the new API it can
be rewritten to:

static void usb_amradio_disconnect(struct usb_interface *intf)
{
        struct amradio_device *radio = to_amradio_dev(usb_get_intfdata(intf));

        mutex_lock(&radio->lock);
        v4l2_device_get(&radio->v4l2_dev);
        v4l2_device_disconnect(&radio->v4l2_dev);
        video_unregister_device(&radio->videodev);
        mutex_unlock(&radio->lock);
        v4l2_device_put(&radio->v4l2_dev);
}

3) drivers with a mix of v4l and dvb/alsa/... device nodes need a way to increase
   or decrease the v4l2_device refcount for every non-v4l2 device node that is
   created or removed. The purpose is the same: the top-level release should only
   be called when the last reference is gone.

The other two patches convert dsbr100 to .unlocked_ioctl using core-assisted
locking, and then simplify the code using the proper disconnect construct. The
radio->removed field is deleted since the v4l2 framework will guarantee that
once a device node is unregistered no ioctl can ever be made. So the 'removed'
check is now no longer needed.

The refcount patches have been posted before and are unchanged.

Regards,

	Hans
