Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33466 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbcCGTXd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Mar 2016 14:23:33 -0500
Received: by mail-wm0-f65.google.com with SMTP id n186so12551726wmn.0
        for <linux-media@vger.kernel.org>; Mon, 07 Mar 2016 11:23:32 -0800 (PST)
From: Ulrik de Muelenaere <ulrikdem@gmail.com>
Date: Mon, 7 Mar 2016 21:23:21 +0200
To: Hans de Goede <hdegoede@redhat.com>
Cc: Ulrik de Muelenaere <ulrikdem@gmail.com>,
	linux-media@vger.kernel.org, Antonio Ospite <ao2@ao2.it>
Subject: Re: [PATCH 0/2] [media] gspca_kinect: enable both video and depth
 streams
Message-ID: <20160307192321.GA10220@ulrikdem.com>
References: <cover.1457262292.git.ulrikdem@gmail.com>
 <56DDCFDE.8020209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56DDCFDE.8020209@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Mar 07, 2016 at 08:00:46PM +0100, Hans de Goede wrote:
> Hi Ulrik,
> 
> On 06-03-16 14:50, Ulrik de Muelenaere wrote:
> >Hello,
> >
> >The Kinect produces both a video and depth stream, but the current implementation of the
> >gspca_kinect subdriver requires a depth_mode parameter at probe time to select one of
> >the streams which will be exposed as a v4l device. This patchset allows both streams to
> >be accessed as separate video nodes.
> >
> >A possible solution which has been discussed in the past is to call gspca_dev_probe()
> >multiple times in order to create multiple video nodes. See the following mails:
> >
> >http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/26194/focus=26213
> >http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/76715/focus=78344
> >
> >In the second mail linked above, it was mentioned that gspca_dev_probe() cannot be
> >called multiple times for the same USB interface, since gspca_dev_probe2() stores a
> >pointer to the new gspca_dev as the interface's private data. This is required for
> >gspca_disconnect(), gspca_suspend() and gspca_resume(). As far as I can tell, this is
> >the only reason gspca_dev_probe() cannot be called multiple times.
> >
> >The first patch fixes this by storing other devices linked to the same interface as a
> >linked list. The second patch then calls gspca_dev_probe() twice in the gspca_kinect
> >subdriver, to create a video node for each stream.
> >
> >Some notes on error handling, which I think should be reviewed:
> >
> >* I could not test the gspca_suspend() and gspca_resume() functions. From my evaluation
> >   of the code, it seems that the only effect of returning an error code from
> >   gspca_resume() is that a message is logged. Therefore I decided to attempt to resume
> >   each gspca_dev when the interface is resumed, even if one fails. Bitwise OR seems
> >   like the best way to combine potentially multiple error codes.
> >
> >* In the gspca_kinect subdriver, if the second call to gspca_dev_probe() fails, the
> >   first video node will still be available. I handle this case by calling
> >   gspca_disconnect(), which worked when I was testing, but I am not sure if this is the
> >   correct way to handle it.
> 
> Thanks for the patch-set overall I like it, one thing which worries is me is
> that sd_start_video and sd_start_depth may race, which is esp. problematic
> taking into account that both start/stop the depth stream (see the comment
> about this in sd_start_video()) this will require some coordination,
> so you like need to do something a bit more advanced and create a shared
> data struct somewhere for coordination (and with a lock in it).
> 
> Likewise the v4l2 core is designed to have only one struct v4l2_device per
> struct device, so you need to modify probe2 to not call
> v4l2_device_register when it is called a second time for the same intf,
> and to make gspca_dev->vdev.v4l2_dev point to the v4l2_dev of the
> first gspca_dev registered.
> 
> You will also need some changes for this in gspca_disconnect, as you will
> need to do all the calls on &gspca_dev->v4l2_dev only for the
> first registered device there, and you will need to do all the
> calls in gspca_release except for the v4l2_device_unregister() in
> a loop like you're using in disconnect.
> 
> Note since you need a shared data struct anyways it might be easier to
> just use that (add some shared pointer to struct gspca_dev) for the array
> of gspca_devs rather then using the linked list, as for disconnect /
> release you will want to use the first registered gspca_dev to get
> the v4l2_dev address, and your linked approach gives you the last.

Thanks for the input. I'll start working on your suggestions.

Regards,
Ulrik

> 
> Regards,
> 
> Hans
> 
> 
> >
> >Regards,
> >Ulrik
> >
> >Ulrik de Muelenaere (2):
> >   [media] gspca: allow multiple probes per USB interface
> >   [media] gspca_kinect: enable both video and depth streams
> >
> >  drivers/media/usb/gspca/gspca.c  | 129 +++++++++++++++++++++++----------------
> >  drivers/media/usb/gspca/gspca.h  |   1 +
> >  drivers/media/usb/gspca/kinect.c |  28 +++++----
> >  3 files changed, 91 insertions(+), 67 deletions(-)
> >
