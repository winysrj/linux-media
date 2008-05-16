Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4G2pTfE023243
	for <video4linux-list@redhat.com>; Thu, 15 May 2008 22:51:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4G2pI6p029712
	for <video4linux-list@redhat.com>; Thu, 15 May 2008 22:51:18 -0400
Date: Thu, 15 May 2008 23:51:02 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Greg KH <greg@kroah.com>
Message-ID: <20080515235102.756407d3@gaivota>
In-Reply-To: <20080514205927.GA13134@kroah.com>
References: <20080514205927.GA13134@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org,
	linux-usb@vger.kernel.org, Dean Anderson <dean@sensoray.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: add Sensoray 2255 v4l driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Greg and Dean,

In general, the driver seems sane and almost ready for their kernel inclusion.
However, there were several videobuf changes affecting mostly the users of
videobuf-vmalloc during the last kernel development cycle, to fix lock issues.
The code should be reviewed at the light of the latest version, and tested. The
good news is that the videobuf handler will be simpler, but a lock is now required.

I have other comments to help improving the driver quality.

Btw, I noticed the lack of Dean's SOB. Is this intentional?

Cheers,
Mauro.

On Wed, 14 May 2008 13:59:27 -0700
Greg KH <greg@kroah.com> wrote:

> From: Dean Anderson <dean@sensoray.com>
> 
> This driver adds support for the Sensoray 2255 devices.
> 
> It was primarily developed by Dean Anderson with only a little bit of
> guidance and cleanup by Greg.

> +#define DIR_IN			0
> +#define DIR_OUT			1

It seems a little dangerous to use just DIR_IN/DIR_OUT, since a future change
on a kernel header could cause namespace conflict. IMO, the better is to rename
those macros to something more specific, like S2255_DIR_IN.

The same comment is also true to struct and other namespace definitions, like
"framei", "bufferi", etc.

> +
> +/* buffer for one video frame */
> +struct s2255_buffer {
> +	/* common v4l buffer stuff -- must be first */
> +	struct videobuf_buffer vb;
> +	const struct s2255_fmt *fmt;
> +	/* future use */
> +	int reserved[32];

Why to reserve 32 integers here? While this may have some sense at userspace
API, I can't see any reason to use this internally.

> +#define S2255_NORMS		(V4L2_STD_PAL_B | V4L2_STD_NTSC_M)

Just those two norms? Are you sure it doesn't support the other european PAL
variants (PAL/G, PAL/D, PAL/K)?

> +static DEFINE_MUTEX(usb_s2255_open_mutex);

Hmmm... what happens if the user plugs two or more of such devices?

> +/* supported controls */
> +static struct v4l2_queryctrl s2255_qctrl[] = {
> +	{
> +	.id = V4L2_CID_BRIGHTNESS,
> +	.type = V4L2_CTRL_TYPE_INTEGER,
> +	.name = "Brightness",
> +	.minimum = -127,
> +	.maximum = 128,
> +	.step = 1,
> +	.default_value = 0,
> +	.flags = 0,
> +	},
> +	{

This seems to be violating CodingStyle. It should be something like:
	{
		.id = foo,
<snip/>
	}, {

The same applies also to other structs. The better is to check the patch with
checkpatch.pl, since other violations might be present.

> +
> +/*
> + * convert from YUV(YCrCb) to RGB
> + * 65536 R = 76533(Y-16) + 104936 * (Cr-128)
> + * 65536 G = 76533(Y-16) - 53451(Cr-128) - 25703(Cb -128)
> + * 65536 B = 76533(Y-16) + 132677(Cb-128)
> + */

As already discussed, the driver should support only the video standards
supported by the hardware. colorspace conversion can happen at userspace apps.

> +/* this loads the firmware asynchronously.
> +   Originally this was done synchroously in probe.
> +   But it is better to load it asynchronously here than block
> +   inside the probe function. Blocking inside probe affects boot time.
> +   FW loading is triggered by the timer in the probe function
> +*/

I saw another discussion about this.

I like the idea of loading firmware asynchronously, provided that you block at
open() or at ioctl(), if the user requested to open before having the firmware
loaded.

> +static int restart_video_queue(struct s2255_dmaqueue *dma_q)

This is probably obsolete. We've cleaned up those code. The better is to take a
look at videobuf implementation at em28xx-video, where some lock bugs were fixed and the
code were simplified. I don't have your hardware to test, but I suspect that
the driver suffers some bugs at videobuf implementation that we've removed recently.

> +/* ------------------------------------------------------------------
> +   IOCTL vidioc handling
> +   ------------------------------------------------------------------*/
> +static int vidioc_querycap(struct file *file, void *priv,
> +			   struct v4l2_capability *cap)
> +{
> +	strcpy(cap->driver, "s2255");
> +	strcpy(cap->card, "s2255");
> +	cap->version = S2255_VERSION;
> +	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> +	return 0;
> +}

Better to use "strlcpy" instead of just "strcpy", to avoid the risk of buffer
overflow. Ok, currently, there's no risk, but, if tomorrow someone changes
something here, the bug will emerge.

Also, please fill bus info, with something like:

	strlcpy(cap->bus_info, dev->udev->dev.bus_id, sizeof(cap->bus_info));

This is required for some udev implementations to properly work.

> +/* FIXME: This seems to be generic enough to be at videodev2 */
> +static int vidioc_s_fmt_cap(struct file *file, void *priv,
> +			    struct v4l2_format *f)

The implementation you did is not generic enough for videodev2. I agree that we
may improve the implementation of try_fmt/s_fmt at videobuf2. Feel free to
propose such improvements.
> +#ifdef CONFIG_VIDEO_V4L1_COMPAT
> +static int vidiocgmbuf(struct file *file, void *priv, struct video_mbuf *mbuf)

There are now a videobuf method to implement vidiocgmbuf. The better is to use
it, instead of duplicating the code.

> +#define EP_NUM_CONFIG 2

This define here sounds strange. I would move it to the beginning at the
driver. Better to write a short comment about this magic number.

> +	s2255_stop_acquire(dev, fh->channel);
> +	/* give time for last frame to be received/flush in the usb
> +	   receive pipe*/
> +	msleep(50);

The sleep above seems a hack to my eyes. The better is to protect with a
spinlock. The current code, at vivi and em28xx already prevents such issues (at
least, it went fine at the tests we did).

> +	res = videobuf_streamoff(&fh->vb_vidq);
> +	res_free(dev, fh);
> +	/* expire the queue timer now in case still active */
> +	mod_timer(&dmaq->timeout, jiffies + HZ);

Also, the timeout is obsolete

> +	return res;
> +}
> +	if (*i == V4L2_STD_NTSC_M) {
> +		dprintk(4, "vidioc_s_std NTSC\n");
> +		mode->format = FORMAT_NTSC;

No. NTSC/M is just one variant of NTSC, used on US/Canada. There are other
variants at Asia, in Korea and Japan. The difference is at the audio carrier.

> +	} else if (*i == V4L2_STD_PAL_B) {
> +		dprintk(4, "vidioc_s_std PAL\n");

Also, PAL/B is just one variant. 

A proper code would be to do this:
	if (*i & V4L2_STD_PAL)

(notice that the equal operator were replaced by the logical operation _AND_.
This covers all european PAL. However, this mask doesn't cover PAL/N, PAL/Nc
and PAL/M.

If all you need is to check if the video mode is 50Hz/60Hz, the proper code would be, instead:

	if (*i & V4L2_STD_525_60)
		/* some logic for NTSC/M, PAL/M and PAL/60 */
	else
		/* some logic for the other PAL variations and SECAM */

> +/* Sensoray 2255 is a multiple channel capture device.
> +   It does not have a "crossbar" of inputs.
> +   We use one V4L device per channel. The user must
> +   be aware that certain combinations are not allowed.
> +   For instance, you cannot do full FPS on more than 2 channels(2 videodevs)
> +   at once in color(you can do full fps on 4 channels with greyscale.
> +*/

The invalid combinations should be tested, to avoid OOPSes and other bad behaviours.

> +			/* update the mode to the corresponding value */
> +			if (ctrl->id == V4L2_CID_BRIGHTNESS)
> +				mode->bright = ctrl->value;
> +			else if (ctrl->id == V4L2_CID_CONTRAST)
> +				mode->contrast = ctrl->value;
> +			else if (ctrl->id == V4L2_CID_HUE)
> +				mode->hue = ctrl->value;
> +			else if (ctrl->id == V4L2_CID_SATURATION)
> +				mode->saturation = ctrl->value;

You have just a few controls. However, the better would be to use a switch(),
since the compiler can reorder the operations to improve the code speed and
size.

> +	if (dev->fw_data->fw_state == FWSTATE_FAILED) {
> +		err("2255 firmware wasn't loaded\n");
> +		mutex_unlock(&usb_s2255_open_mutex);
> +		return -ENODEV;
> +	}

It seems too hard to return ENODEV. Couldn't the driver try again to load the
firmware here?

> +	if (dev->fw_data->fw_state == FWSTATE_NOTLOADED) {
> +		/* give 1 second for firmware to load in case
> +		   driver loaded and then device immediately opened */
> +		msleep(1000);

Argh. I would use a wait_event_timeout() instead, and use a higher timeout value. 

Also, it seems that fw_state needs to be atomic.

> +		if (dev->fw_data->fw_state == FWSTATE_NOTLOADED) {
> +			err("2255 firmware loading stalled\n");
> +			mutex_unlock(&usb_s2255_open_mutex);
> +			return -EAGAIN;

Hmm... I'm in doubt if we should return, instead, -EBUSY.

> +	/* if first open after firmware loaded, release the firmware */
> +	if (dev->fw_data->fw) {
> +		release_firmware(dev->fw_data->fw);
> +		dev->fw_data->fw = NULL;
> +	}

This seems weird. Why to release the firmware?

> +
> +	dev->users[cur_channel]++;
> +
> +	if (dev->users[cur_channel] > 1) {
> +		dev->users[cur_channel]--;
> +		dev_err(&dev->udev->dev, "one user at a time\n");
> +		mutex_unlock(&usb_s2255_open_mutex);
> +		return -EAGAIN;

In this case, it should return -EBUSY.

> +	}
> +
> +	dprintk(1, "open minor=%d type=%s users=%d\n",
> +		minor, v4l2_type_names[type], dev->users[cur_channel]);
> +
> +	/* allocate + initialize per filehandle data */
> +	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
> +	if (NULL == fh) {
> +		dev->users[cur_channel]--;
> +		mutex_unlock(&usb_s2255_open_mutex);
> +		return -ENOMEM;
> +	}


Instead of incrementing the usage, printing the open message just to discover
that you don't have enough memory, I would move the users increment and the
dprintk to happen after the allocation of fh.

> +	videobuf_queue_vmalloc_init(&fh->vb_vidq, &s2255_video_qops,
> +				    NULL, NULL,
> +				    fh->type,
> +				    V4L2_FIELD_INTERLACED,
> +				    sizeof(struct s2255_buffer), fh);

You'll need to define a spinlock for videoqueue, otherwise the kernel will now
complain. Please test your code against the latest development version (or the
latest code at mainstream).

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
