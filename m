Return-path: <linux-media-owner@vger.kernel.org>
Received: from p3plsmtp18-06-2.prod.phx3.secureserver.net ([173.201.193.192]:51812
	"EHLO p3plwbeout18-06.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756967Ab3E1KVf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 May 2013 06:21:35 -0400
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Message-Id: <20130528032133.e7c3a0fec861aa4693105436139f36a5.a3209a91c0.wbe@email18.secureserver.net>
From: <leo@lumanate.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>,
	"Mauro Carvalho Chehab" <mchehab@redhat.com>
Cc: "Linux Media Mailing List" <linux-media@vger.kernel.org>
Subject: RE: [PATCH] [media] hdpvr: Simplify the logic that checks for error
Date: Tue, 28 May 2013 03:21:33 -0700
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Passing on the actual error code was intentional.
My main goal was to give user space ability to
distinguish between the "no-lock" and "usb failure"
conditions. HDPVR firmware instability usually
manifests itself as a "usb failure", and passing
the error code on gives the application ability,
for example to use this device
(https://sites.google.com/site/hdpvrkillerdevice/)
as soon as firmware crash is detected and not
loose the recording. Unfortunately today because
of inability to see the usb failures the failed
recording is only detected by the zero-length
file after it's too late...

If you remember I did a some research and testing
with MythTV (email from Apr 17):
***************
...I checked MythTV function that is
monitoring video signal (AnalogSignalMonitor::handleHDPVR() in
analogsignalmonitor.cpp). Please see below that the no-signal
condition is checked as both - the ioctl failure and
pix.width is equal to 0:

 if ((ioctl(videofd, VIDIOC_G_FMT, &vfmt) == 0) &&
 vfmt.fmt.pix.width &&...

Then I tested MythTV for no-signal condition in two cases:
 1. Loosing signal during live preview.
 2. Trying to enter preview with no signal.
Both cases showed the same behavior as with the current
driver...
***************

So based on this, returning the actual error code
will NOT break MythTV logic, it still will handle
it as a no-lock condition.

One thing I have not done though is I did not contact
MythTV to confirm the above conclusions, but I
wouldn't mind if that would help to shift the decision...


Everything else in the patches looks good to me!

Best regards,
-Leo.





-------- Original Message --------
Subject: Re: [PATCH] [media] hdpvr: Simplify the logic that checks for
error
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Mon, May 27, 2013 11:58 pm
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
leo@lumanate.com

On Mon May 27 2013 14:04:29 Mauro Carvalho Chehab wrote:
> At get_video_info, there's a somewhat complex logic that checks
> for error.
> 
> That logic can be highly simplified, as usb_control_msg will
> only return a negative value, or the buffer length, as it does
> the transfers via DMA.
> 
> While here, document why this particular driver is returning -EFAULT,
> instead of the USB error code.

Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>

The EFAULT comment is wrong. The way it is done today is that the error
return of this function is never passed on to userspace.

It's getting messy, so I think it is best if I make two patches based on
this
patch and on Leo's fourth patch and post those. If everyone agrees on my
solution,
then they can be merged.

Sorry Leo, I wasn't aware when we discussed the usb_control_msg return
values
before that usb_control_msg() will either return an error or the buffer
length,
and nothing else.

Your fourth patch introduced some bugs which I hadn't realized until
yesterday.
Which is why it wasn't merged. The main problem with your fourth patch
was that
it passed on the get_video_info error code to userspace, but that error
code was
for internal use only, and -EFAULT is an inappropriate error code to
pass on.

Regards,

 Hans

> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
> drivers/media/usb/hdpvr/hdpvr-control.c | 23 +++++++++++++----------
> 1 file changed, 13 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/usb/hdpvr/hdpvr-control.c b/drivers/media/usb/hdpvr/hdpvr-control.c
> index d1a3d84..a015a24 100644
> --- a/drivers/media/usb/hdpvr/hdpvr-control.c
> +++ b/drivers/media/usb/hdpvr/hdpvr-control.c
> @@ -56,12 +56,6 @@ int get_video_info(struct hdpvr_device *dev, struct hdpvr_video_info *vidinf)
> 0x1400, 0x0003,
> dev->usbc_buf, 5,
> 1000);
> - if (ret == 5) {
> - vidinf->width = dev->usbc_buf[1] << 8 | dev->usbc_buf[0];
> - vidinf->height = dev->usbc_buf[3] << 8 | dev->usbc_buf[2];
> - vidinf->fps = dev->usbc_buf[4];
> - }
> -
> #ifdef HDPVR_DEBUG
> if (hdpvr_debug & MSG_INFO) {
> char print_buf[15];
> @@ -73,11 +67,20 @@ int get_video_info(struct hdpvr_device *dev, struct hdpvr_video_info *vidinf)
> #endif
> mutex_unlock(&dev->usbc_mutex);
> 
> - if (ret > 0 && ret != 5) { /* fail if unexpected byte count returned */
> - ret = -EFAULT;
> - }
> + /*
> + * Returning EFAULT is wrong. Unfortunately, MythTV hdpvr
> + * handling code was written to expect this specific error,
> + * instead of accepting any error code. So, we can't fix it
> + * in Kernel without breaking userspace.
> + */
> + if (ret < 0)
> + return -EFAULT;
> 
> - return ret < 0 ? ret : 0;
> + vidinf->width = dev->usbc_buf[1] << 8 | dev->usbc_buf[0];
> + vidinf->height = dev->usbc_buf[3] << 8 | dev->usbc_buf[2];
> + vidinf->fps = dev->usbc_buf[4];
> +
> + return 0;
> }
> 
> int get_input_lines_info(struct hdpvr_device *dev)
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-media"
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at http://vger.kernel.org/majordomo-info.html
