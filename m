Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2NND1Eq017787
	for <video4linux-list@redhat.com>; Mon, 23 Mar 2009 19:13:01 -0400
Received: from mail-qy0-f104.google.com (mail-qy0-f104.google.com
	[209.85.221.104])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n2NNBqiW025841
	for <video4linux-list@redhat.com>; Mon, 23 Mar 2009 19:12:27 -0400
Received: by qyk2 with SMTP id 2so2744548qyk.23
	for <video4linux-list@redhat.com>; Mon, 23 Mar 2009 16:11:51 -0700 (PDT)
From: Lamarque Vieira Souza <lamarque@gmail.com>
To: Alexey Klimov <klimov.linux@gmail.com>
Date: Mon, 23 Mar 2009 20:11:40 -0300
References: <200903231217.45740.lamarque@gmail.com>
	<1237842462.31041.81.camel@tux.localhost>
In-Reply-To: <1237842462.31041.81.camel@tux.localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903232011.41319.lamarque@gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: Patch implementing V4L2_CAP_STREAMING for zr364xx driver
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

Em Monday 23 March 2009, Alexey Klimov escreveu:
> Hello, Lamarque
> May i make few comments ?

	Sure, I am here for reading comments :-)

> On Mon, 2009-03-23 at 12:17 -0300, Lamarque Vieira Souza wrote:
> I inlined patch in e-mail to make it easy.

	Ok.

> --- zr364xx.c.orig	2009-03-21 08:51:41.289597517 -0300
> +++ zr364xx.c	2009-03-23 03:26:00.445999283 -0300
> @@ -1,15 +1,18 @@
>  /*
> - * Zoran 364xx based USB webcam module version 0.72
> + * Zoran 364xx based USB webcam module version 0.73
>   *
>   * Allows you to use your USB webcam with V4L2 applications
>   * This is still in heavy developpement !
>   *
> - * Copyright (C) 2004  Antoine Jacquet <royale@zerezo.com>
> + * Copyright (C) 2009  Antoine Jacquet <royale@zerezo.com>
>
> Maybe it's better not to touch the year here ?

	Ok.

> +struct zr364xx_dmaqueue {
> +	struct list_head	active;
> +	/* thread for acquisition */
> +	struct task_struct	*kthread;
>
> Is this member of struct used ?
> I can find only cam->vidq.kthread = NULL; in zr364xx_probe function..

	It is not used. The code is based on s2255drv.c, it is like this in 
s2255drv.c so I have hot changed it.

> +static int res_check(struct zr364xx_camera *cam)
> +{
> +	return cam->resources;
> +}
>
> You can make this function inline, right ?

	Probably. I think it is still possible to remove a lot of code. The s2255drv 
is a more complex driver than zr364xx (it uses four v4l devices), this 
resource field probably is not needed for zr364xx driver. I will check the 
code to see if it is possible to remove this.

> +
> +	cam->mode.color = V4L2_PIX_FMT_JPEG;
>  	DBG("ok!");
>
> \n ?

	Ok :-)

> To decrease amount of code here you can use something like this:
>
> struct zr364xx_camera *cam = video_drvdata(file);
>
> to get *cam from struct file directly(without vdev).

	Good point. 

> +static void read_pipe_completion(struct urb *purb)
> +{
> +	struct zr364xx_pipeinfo *pipe_info;
> +	struct zr364xx_camera *cam;
> +	int status;
> +	int pipe;
> +
> +	pipe_info = purb->context;
> +	DBG("%s %p, status %d\n", __func__, purb, purb->status);
> +	if (pipe_info == NULL) {
> +		err("no context!");
>
>
> +		return;
> +	}
> +
> +	cam = pipe_info->cam;
> +	if (cam == NULL) {
> +		err("no context!");
>
> Do you use err() macro from usb.h ?
> If yes - as i know it's better not to use this macros, because this macros
> can suddenly became deprecated. It's more comfortable to use printk or
> dev_err.

	Well, s2255drc.c uses it, since my changes are based on that I supposed it 
could be used. I will change them to printk's.


> +	for (i = 0; i < MAX_PIPE_BUFFERS; i++) {
> +		pipe_info->state = 1;
> +		pipe_info->buf_index = (u32) i;
> +		pipe_info->priority_set = 0;
> +		pipe_info->stream_urb = usb_alloc_urb(0, GFP_KERNEL);
> +		if (!pipe_info->stream_urb) {
> +			dev_err(&cam->udev->dev, "ReadStream: Unable to alloc URB");
>
> \n ?

	I will add it.


> +
> +	if (!res_get(cam)) {
> +		dev_err(&cam->udev->dev, "zr364xx: stream busy\n");
>
> As i understand the behavour of dev_err you don't need "zr364xx:" chars in
> this message.

	Ok. I have not reached this error during my tests so I do not know how the 
output looks like.

> +	DBG("%s\n", __func__);
> +	if (cam->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> +		printk(KERN_ERR "invalid fh type0\n");
>
> It's better to add module name here.

	I will use dev_err like in streamon.

> +		return -EINVAL;
> +	}
> +	if (cam->type != type) {
> +		printk(KERN_ERR "invalid type i\n");
>
> The same here.

	Ok.

> +	for (i = 0; i < FRAMES; i++) {
> +		/* allocate the frames */
> +		cam->buffer.frame[i].lpvbits = vmalloc(reqsize);
> +
> +		DBG("valloc %p, idx %lu, pdata %p\n",
> +			&cam->buffer.frame[i], i,
> +			cam->buffer.frame[i].lpvbits);
> +		cam->buffer.frame[i].size = reqsize;
> +		if (cam->buffer.frame[i].lpvbits == NULL) {
> +			printk(KERN_INFO "out of memory.  using less frames\n");
>
> Module name, please.

	Done.

> +	if (!cam->read_endpoint) {
> +		dev_err(&intf->dev, "Could not find bulk-in endpoint");
>
> \n ?

	Done.

>  static int __init zr364xx_init(void)
>  {
>  	int retval;
>
>
> Also, our current maillist is linux-media@vger.kernel.org.
> It's better to post patches there.

	Ok. When I finish to remove some code I will post the new patch there. That 
also explain why this list is so calm compared to the other kernel lists I 
have been to. By the way, do you understande something about pixelformats? I 
need to convert YUV 4:2:0 into YUV 4:2:2 (UYVY) in libv4l to make my webcam 
work with Skype. Actually the frame is decoded into uncompressed jpeg before 
it is converted to YUV 4:2:0, so maybe I do not need to YUV 4:2:0 into YUV 
4:2:2 (UYVY). I am just not used to the pixel format details.

-- 
Lamarque V. Souza
http://www.geographicguide.com/brazil.htm
Linux User #57137 - http://counter.li.org/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
