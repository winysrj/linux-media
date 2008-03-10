Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2AHwKTm019923
	for <video4linux-list@redhat.com>; Mon, 10 Mar 2008 13:58:20 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2AHvnae013616
	for <video4linux-list@redhat.com>; Mon, 10 Mar 2008 13:57:49 -0400
Date: Mon, 10 Mar 2008 14:57:07 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Message-ID: <20080310145707.6815fbf0@gaivota>
In-Reply-To: <1205081266-18368-2-git-send-email-marcin.slusarz@gmail.com>
References: <1205081266-18368-1-git-send-email-marcin.slusarz@gmail.com>
	<1205081266-18368-2-git-send-email-marcin.slusarz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Jean Delvare <khali@linux-fr.org>, video4linux-list@redhat.com,
	v4l-dvb-maintainer@linuxtv.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] v4l: fix coding style violations in v4l1-compat.c
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

Hi Marcin,

On Sun,  9 Mar 2008 17:47:44 +0100
Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> fix most coding style violations found by checkpatch

This patch conflicted with other patches already applied at the development
tree. Could you please re-generate it?

The better would be if you could generate it against hg tree, at:
	http://linuxtv.org/hg/v4l-dvb

If you prefer to work with git, you can generate it against:
	http://www.kernel.org/git/?p=linux/kernel/git/mchehab/v4l-dvb.git

Cheers,
Mauro.

> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> ---
>  drivers/media/video/v4l1-compat.c |  202 ++++++++++++++++++-------------------
>  1 files changed, 99 insertions(+), 103 deletions(-)
> 
> diff --git a/drivers/media/video/v4l1-compat.c b/drivers/media/video/v4l1-compat.c
> index dcf22a3..d91f86b 100644
> --- a/drivers/media/video/v4l1-compat.c
> +++ b/drivers/media/video/v4l1-compat.c
> @@ -39,15 +39,18 @@
>  #include <linux/kmod.h>
>  #endif
>  
> -static unsigned int debug  = 0;
> +static unsigned int debug;
>  module_param(debug, int, 0644);
> -MODULE_PARM_DESC(debug,"enable debug messages");
> +MODULE_PARM_DESC(debug, "enable debug messages");
>  MODULE_AUTHOR("Bill Dirks");
>  MODULE_DESCRIPTION("v4l(1) compatibility layer for v4l2 drivers.");
>  MODULE_LICENSE("GPL");
>  
> -#define dprintk(fmt, arg...)	if (debug) \
> -	printk(KERN_DEBUG "v4l1-compat: " fmt , ## arg)
> +#define dprintk(fmt, arg...) \
> +	do { \
> +		if (debug) \
> +			printk(KERN_DEBUG "v4l1-compat: " fmt , ## arg);\
> +	} while (0)
>  
>  /*
>   *	I O C T L   T R A N S L A T I O N
> @@ -69,14 +72,12 @@ get_v4l_control(struct inode            *inode,
>  	qctrl2.id = cid;
>  	err = drv(inode, file, VIDIOC_QUERYCTRL, &qctrl2);
>  	if (err < 0)
> -		dprintk("VIDIOC_QUERYCTRL: %d\n",err);
> -	if (err == 0 &&
> -	    !(qctrl2.flags & V4L2_CTRL_FLAG_DISABLED))
> -	{
> +		dprintk("VIDIOC_QUERYCTRL: %d\n", err);
> +	if (err == 0 && !(qctrl2.flags & V4L2_CTRL_FLAG_DISABLED)) {
>  		ctrl2.id = qctrl2.id;
>  		err = drv(inode, file, VIDIOC_G_CTRL, &ctrl2);
>  		if (err < 0) {
> -			dprintk("VIDIOC_G_CTRL: %d\n",err);
> +			dprintk("VIDIOC_G_CTRL: %d\n", err);
>  			return 0;
>  		}
>  		return ((ctrl2.value - qctrl2.minimum) * 65535
> @@ -100,11 +101,10 @@ set_v4l_control(struct inode            *inode,
>  	qctrl2.id = cid;
>  	err = drv(inode, file, VIDIOC_QUERYCTRL, &qctrl2);
>  	if (err < 0)
> -		dprintk("VIDIOC_QUERYCTRL: %d\n",err);
> +		dprintk("VIDIOC_QUERYCTRL: %d\n", err);
>  	if (err == 0 &&
>  	    !(qctrl2.flags & V4L2_CTRL_FLAG_DISABLED) &&
> -	    !(qctrl2.flags & V4L2_CTRL_FLAG_GRABBED))
> -	{
> +	    !(qctrl2.flags & V4L2_CTRL_FLAG_GRABBED)) {
>  		if (value < 0)
>  			value = 0;
>  		if (value > 65535)
> @@ -119,7 +119,7 @@ set_v4l_control(struct inode            *inode,
>  		ctrl2.value += qctrl2.minimum;
>  		err = drv(inode, file, VIDIOC_S_CTRL, &ctrl2);
>  		if (err < 0)
> -			dprintk("VIDIOC_S_CTRL: %d\n",err);
> +			dprintk("VIDIOC_S_CTRL: %d\n", err);
>  	}
>  	return 0;
>  }
> @@ -157,8 +157,7 @@ static unsigned int __attribute_const__
>  pixelformat_to_palette(unsigned int pixelformat)
>  {
>  	int	palette = 0;
> -	switch (pixelformat)
> -	{
> +	switch (pixelformat) {
>  	case V4L2_PIX_FMT_GREY:
>  		palette = VIDEO_PALETTE_GREY;
>  		break;
> @@ -234,9 +233,9 @@ static int count_inputs(struct inode         *inode,
>  	int i;
>  
>  	for (i = 0;; i++) {
> -		memset(&input2,0,sizeof(input2));
> +		memset(&input2, 0, sizeof(input2));
>  		input2.index = i;
> -		if (0 != drv(inode,file,VIDIOC_ENUMINPUT, &input2))
> +		if (0 != drv(inode, file, VIDIOC_ENUMINPUT, &input2))
>  			break;
>  	}
>  	return i;
> @@ -250,18 +249,18 @@ static int check_size(struct inode         *inode,
>  	struct v4l2_fmtdesc desc2;
>  	struct v4l2_format  fmt2;
>  
> -	memset(&desc2,0,sizeof(desc2));
> -	memset(&fmt2,0,sizeof(fmt2));
> +	memset(&desc2, 0, sizeof(desc2));
> +	memset(&fmt2, 0, sizeof(fmt2));
>  
>  	desc2.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> -	if (0 != drv(inode,file,VIDIOC_ENUM_FMT, &desc2))
> +	if (0 != drv(inode, file, VIDIOC_ENUM_FMT, &desc2))
>  		goto done;
>  
>  	fmt2.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>  	fmt2.fmt.pix.width       = 10000;
>  	fmt2.fmt.pix.height      = 10000;
>  	fmt2.fmt.pix.pixelformat = desc2.pixelformat;
> -	if (0 != drv(inode,file,VIDIOC_TRY_FMT, &fmt2))
> +	if (0 != drv(inode, file, VIDIOC_TRY_FMT, &fmt2))
>  		goto done;
>  
>  	*maxw = fmt2.fmt.pix.width;
> @@ -303,19 +302,19 @@ v4l_compat_translate_ioctl(struct inode         *inode,
>  	{
>  		struct video_capability *cap = arg;
>  
> -		cap2 = kzalloc(sizeof(*cap2),GFP_KERNEL);
> +		cap2 = kzalloc(sizeof(*cap2), GFP_KERNEL);
>  		memset(cap, 0, sizeof(*cap));
>  		memset(&fbuf2, 0, sizeof(fbuf2));
>  
>  		err = drv(inode, file, VIDIOC_QUERYCAP, cap2);
>  		if (err < 0) {
> -			dprintk("VIDIOCGCAP / VIDIOC_QUERYCAP: %d\n",err);
> +			dprintk("VIDIOCGCAP / VIDIOC_QUERYCAP: %d\n", err);
>  			break;
>  		}
>  		if (cap2->capabilities & V4L2_CAP_VIDEO_OVERLAY) {
>  			err = drv(inode, file, VIDIOC_G_FBUF, &fbuf2);
>  			if (err < 0) {
> -				dprintk("VIDIOCGCAP / VIDIOC_G_FBUF: %d\n",err);
> +				dprintk("VIDIOCGCAP / VIDIOC_G_FBUF: %d\n", err);
>  				memset(&fbuf2, 0, sizeof(fbuf2));
>  			}
>  			err = 0;
> @@ -335,9 +334,9 @@ v4l_compat_translate_ioctl(struct inode         *inode,
>  		if (fbuf2.capability & V4L2_FBUF_CAP_LIST_CLIPPING)
>  			cap->type |= VID_TYPE_CLIPPING;
>  
> -		cap->channels  = count_inputs(inode,file,drv);
> -		check_size(inode,file,drv,
> -			   &cap->maxwidth,&cap->maxheight);
> +		cap->channels  = count_inputs(inode, file, drv);
> +		check_size(inode, file, drv,
> +			   &cap->maxwidth, &cap->maxheight);
>  		cap->audios    =  0; /* FIXME */
>  		cap->minwidth  = 48; /* FIXME */
>  		cap->minheight = 32; /* FIXME */
> @@ -352,7 +351,7 @@ v4l_compat_translate_ioctl(struct inode         *inode,
>  
>  		err = drv(inode, file, VIDIOC_G_FBUF, &fbuf2);
>  		if (err < 0) {
> -			dprintk("VIDIOCGFBUF / VIDIOC_G_FBUF: %d\n",err);
> +			dprintk("VIDIOCGFBUF / VIDIOC_G_FBUF: %d\n", err);
>  			break;
>  		}
>  		buffer->base   = fbuf2.base;
> @@ -382,8 +381,8 @@ v4l_compat_translate_ioctl(struct inode         *inode,
>  			buffer->bytesperline = fbuf2.fmt.bytesperline;
>  			if (!buffer->depth && buffer->width)
>  				buffer->depth   = ((fbuf2.fmt.bytesperline<<3)
> -						  + (buffer->width-1) )
> -						  /buffer->width;
> +						  + (buffer->width-1))
> +						  / buffer->width;
>  		} else {
>  			buffer->bytesperline =
>  				(buffer->width * buffer->depth + 7) & 7;
> @@ -419,20 +418,20 @@ v4l_compat_translate_ioctl(struct inode         *inode,
>  		fbuf2.fmt.bytesperline = buffer->bytesperline;
>  		err = drv(inode, file, VIDIOC_S_FBUF, &fbuf2);
>  		if (err < 0)
> -			dprintk("VIDIOCSFBUF / VIDIOC_S_FBUF: %d\n",err);
> +			dprintk("VIDIOCSFBUF / VIDIOC_S_FBUF: %d\n", err);
>  		break;
>  	}
>  	case VIDIOCGWIN: /*  get window or capture dimensions  */
>  	{
>  		struct video_window	*win = arg;
>  
> -		fmt2 = kzalloc(sizeof(*fmt2),GFP_KERNEL);
> -		memset(win,0,sizeof(*win));
> +		fmt2 = kzalloc(sizeof(*fmt2), GFP_KERNEL);
> +		memset(win, 0, sizeof(*win));
>  
>  		fmt2->type = V4L2_BUF_TYPE_VIDEO_OVERLAY;
>  		err = drv(inode, file, VIDIOC_G_FMT, fmt2);
>  		if (err < 0)
> -			dprintk("VIDIOCGWIN / VIDIOC_G_WIN: %d\n",err);
> +			dprintk("VIDIOCGWIN / VIDIOC_G_WIN: %d\n", err);
>  		if (err == 0) {
>  			win->x         = fmt2->fmt.win.w.left;
>  			win->y         = fmt2->fmt.win.w.top;
> @@ -447,7 +446,7 @@ v4l_compat_translate_ioctl(struct inode         *inode,
>  		fmt2->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>  		err = drv(inode, file, VIDIOC_G_FMT, fmt2);
>  		if (err < 0) {
> -			dprintk("VIDIOCGWIN / VIDIOC_G_FMT: %d\n",err);
> +			dprintk("VIDIOCGWIN / VIDIOC_G_FMT: %d\n", err);
>  			break;
>  		}
>  		win->x         = 0;
> @@ -462,14 +461,14 @@ v4l_compat_translate_ioctl(struct inode         *inode,
>  	case VIDIOCSWIN: /*  set window and/or capture dimensions  */
>  	{
>  		struct video_window	*win = arg;
> -		int err1,err2;
> +		int err1, err2;
>  
> -		fmt2 = kzalloc(sizeof(*fmt2),GFP_KERNEL);
> +		fmt2 = kzalloc(sizeof(*fmt2), GFP_KERNEL);
>  		fmt2->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>  		drv(inode, file, VIDIOC_STREAMOFF, &fmt2->type);
>  		err1 = drv(inode, file, VIDIOC_G_FMT, fmt2);
>  		if (err1 < 0)
> -			dprintk("VIDIOCSWIN / VIDIOC_G_FMT: %d\n",err);
> +			dprintk("VIDIOCSWIN / VIDIOC_G_FMT: %d\n", err);
>  		if (err1 == 0) {
>  			fmt2->fmt.pix.width  = win->width;
>  			fmt2->fmt.pix.height = win->height;
> @@ -483,7 +482,7 @@ v4l_compat_translate_ioctl(struct inode         *inode,
>  			win->height = fmt2->fmt.pix.height;
>  		}
>  
> -		memset(fmt2,0,sizeof(*fmt2));
> +		memset(fmt2, 0, sizeof(*fmt2));
>  		fmt2->type = V4L2_BUF_TYPE_VIDEO_OVERLAY;
>  		fmt2->fmt.win.w.left    = win->x;
>  		fmt2->fmt.win.w.top     = win->y;
> @@ -494,7 +493,7 @@ v4l_compat_translate_ioctl(struct inode         *inode,
>  		fmt2->fmt.win.clipcount = win->clipcount;
>  		err2 = drv(inode, file, VIDIOC_S_FMT, fmt2);
>  		if (err2 < 0)
> -			dprintk("VIDIOCSWIN / VIDIOC_S_FMT #2: %d\n",err);
> +			dprintk("VIDIOCSWIN / VIDIOC_S_FMT #2: %d\n", err);
>  
>  		if (err1 != 0 && err2 != 0)
>  			err = err1;
> @@ -512,19 +511,19 @@ v4l_compat_translate_ioctl(struct inode         *inode,
>  		}
>  		err = drv(inode, file, VIDIOC_OVERLAY, arg);
>  		if (err < 0)
> -			dprintk("VIDIOCCAPTURE / VIDIOC_PREVIEW: %d\n",err);
> +			dprintk("VIDIOCCAPTURE / VIDIOC_PREVIEW: %d\n", err);
>  		break;
>  	}
>  	case VIDIOCGCHAN: /*  get input information  */
>  	{
>  		struct video_channel	*chan = arg;
>  
> -		memset(&input2,0,sizeof(input2));
> +		memset(&input2, 0, sizeof(input2));
>  		input2.index = chan->channel;
>  		err = drv(inode, file, VIDIOC_ENUMINPUT, &input2);
>  		if (err < 0) {
>  			dprintk("VIDIOCGCHAN / VIDIOC_ENUMINPUT: "
> -				"channel=%d err=%d\n",chan->channel,err);
> +				"channel=%d err=%d\n", chan->channel, err);
>  			break;
>  		}
>  		chan->channel = input2.index;
> @@ -545,7 +544,7 @@ v4l_compat_translate_ioctl(struct inode         *inode,
>  		chan->norm = 0;
>  		err = drv(inode, file, VIDIOC_G_STD, &sid);
>  		if (err < 0)
> -			dprintk("VIDIOCGCHAN / VIDIOC_G_STD: %d\n",err);
> +			dprintk("VIDIOCGCHAN / VIDIOC_G_STD: %d\n", err);
>  		if (err == 0) {
>  			if (sid & V4L2_STD_PAL)
>  				chan->norm = VIDEO_MODE_PAL;
> @@ -563,7 +562,7 @@ v4l_compat_translate_ioctl(struct inode         *inode,
>  		sid = 0;
>  		err = drv(inode, file, VIDIOC_S_INPUT, &chan->channel);
>  		if (err < 0)
> -			dprintk("VIDIOCSCHAN / VIDIOC_S_INPUT: %d\n",err);
> +			dprintk("VIDIOCSCHAN / VIDIOC_S_INPUT: %d\n", err);
>  		switch (chan->norm) {
>  		case VIDEO_MODE_PAL:
>  			sid = V4L2_STD_PAL;
> @@ -578,7 +577,7 @@ v4l_compat_translate_ioctl(struct inode         *inode,
>  		if (0 != sid) {
>  			err = drv(inode, file, VIDIOC_S_STD, &sid);
>  			if (err < 0)
> -				dprintk("VIDIOCSCHAN / VIDIOC_S_STD: %d\n",err);
> +				dprintk("VIDIOCSCHAN / VIDIOC_S_STD: %d\n", err);
>  		}
>  		break;
>  	}
> @@ -587,7 +586,7 @@ v4l_compat_translate_ioctl(struct inode         *inode,
>  		struct video_picture	*pict = arg;
>  
>  		pict->brightness = get_v4l_control(inode, file,
> -						   V4L2_CID_BRIGHTNESS,drv);
> +						   V4L2_CID_BRIGHTNESS, drv);
>  		pict->hue = get_v4l_control(inode, file,
>  					    V4L2_CID_HUE, drv);
>  		pict->contrast = get_v4l_control(inode, file,
> @@ -597,17 +596,17 @@ v4l_compat_translate_ioctl(struct inode         *inode,
>  		pict->whiteness = get_v4l_control(inode, file,
>  						  V4L2_CID_WHITENESS, drv);
>  
> -		fmt2 = kzalloc(sizeof(*fmt2),GFP_KERNEL);
> +		fmt2 = kzalloc(sizeof(*fmt2), GFP_KERNEL);
>  		fmt2->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>  		err = drv(inode, file, VIDIOC_G_FMT, fmt2);
>  		if (err < 0) {
> -			dprintk("VIDIOCGPICT / VIDIOC_G_FMT: %d\n",err);
> +			dprintk("VIDIOCGPICT / VIDIOC_G_FMT: %d\n", err);
>  			break;
>  		}
>  
> -		pict->depth   = ((fmt2->fmt.pix.bytesperline<<3)
> -				 + (fmt2->fmt.pix.width-1) )
> -				 /fmt2->fmt.pix.width;
> +		pict->depth   = ((fmt2->fmt.pix.bytesperline << 3)
> +				 + (fmt2->fmt.pix.width - 1))
> +				 / fmt2->fmt.pix.width;
>  		pict->palette = pixelformat_to_palette(
>  			fmt2->fmt.pix.pixelformat);
>  		break;
> @@ -636,14 +635,14 @@ v4l_compat_translate_ioctl(struct inode         *inode,
>  		 * different pixel formats for memory vs overlay.
>  		 */
>  
> -		fmt2 = kzalloc(sizeof(*fmt2),GFP_KERNEL);
> +		fmt2 = kzalloc(sizeof(*fmt2), GFP_KERNEL);
>  		fmt2->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>  		err = drv(inode, file, VIDIOC_G_FMT, fmt2);
>  		/* If VIDIOC_G_FMT failed, then the driver likely doesn't
>  		   support memory capture.  Trying to set the memory capture
>  		   parameters would be pointless.  */
>  		if (err < 0) {
> -			dprintk("VIDIOCSPICT / VIDIOC_G_FMT: %d\n",err);
> +			dprintk("VIDIOCSPICT / VIDIOC_G_FMT: %d\n", err);
>  			mem_err = -1000;  /* didn't even try */
>  		} else if (fmt2->fmt.pix.pixelformat !=
>  			 palette_to_pixelformat(pict->palette)) {
> @@ -660,7 +659,7 @@ v4l_compat_translate_ioctl(struct inode         *inode,
>  		   support overlay.  Trying to set the overlay parameters
>  		   would be quite pointless.  */
>  		if (err < 0) {
> -			dprintk("VIDIOCSPICT / VIDIOC_G_FBUF: %d\n",err);
> +			dprintk("VIDIOCSPICT / VIDIOC_G_FBUF: %d\n", err);
>  			ovl_err = -1000;  /* didn't even try */
>  		} else if (fbuf2.fmt.pixelformat !=
>  			 palette_to_pixelformat(pict->palette)) {
> @@ -671,16 +670,15 @@ v4l_compat_translate_ioctl(struct inode         *inode,
>  				dprintk("VIDIOCSPICT / VIDIOC_S_FBUF: %d\n",
>  					ovl_err);
>  		}
> -		if (ovl_err < 0 && mem_err < 0)
> +		if (ovl_err < 0 && mem_err < 0) {
>  			/* ioctl failed, couldn't set either parameter */
> -			if (mem_err != -1000) {
> -			    err = mem_err;
> -			} else if (ovl_err == -EPERM) {
> -			    err = 0;
> -			} else {
> -			    err = ovl_err;
> -			}
> -		else
> +			if (mem_err != -1000)
> +				err = mem_err;
> +			else if (ovl_err == -EPERM)
> +				err = 0;
> +			else
> +				err = ovl_err;
> +		} else
>  			err = 0;
>  		break;
>  	}
> @@ -688,10 +686,10 @@ v4l_compat_translate_ioctl(struct inode         *inode,
>  	{
>  		struct video_tuner	*tun = arg;
>  
> -		memset(&tun2,0,sizeof(tun2));
> +		memset(&tun2, 0, sizeof(tun2));
>  		err = drv(inode, file, VIDIOC_G_TUNER, &tun2);
>  		if (err < 0) {
> -			dprintk("VIDIOCGTUNER / VIDIOC_G_TUNER: %d\n",err);
> +			dprintk("VIDIOCGTUNER / VIDIOC_G_TUNER: %d\n", err);
>  			break;
>  		}
>  		memcpy(tun->name, tun2.name,
> @@ -703,7 +701,7 @@ v4l_compat_translate_ioctl(struct inode         *inode,
>  		tun->mode = VIDEO_MODE_AUTO;
>  
>  		for (i = 0; i < 64; i++) {
> -			memset(&std2,0,sizeof(std2));
> +			memset(&std2, 0, sizeof(std2));
>  			std2.index = i;
>  			if (0 != drv(inode, file, VIDIOC_ENUMSTD, &std2))
>  				break;
> @@ -717,7 +715,7 @@ v4l_compat_translate_ioctl(struct inode         *inode,
>  
>  		err = drv(inode, file, VIDIOC_G_STD, &sid);
>  		if (err < 0)
> -			dprintk("VIDIOCGTUNER / VIDIOC_G_STD: %d\n",err);
> +			dprintk("VIDIOCGTUNER / VIDIOC_G_STD: %d\n", err);
>  		if (err == 0) {
>  			if (sid & V4L2_STD_PAL)
>  				tun->mode = VIDEO_MODE_PAL;
> @@ -738,25 +736,25 @@ v4l_compat_translate_ioctl(struct inode         *inode,
>  	{
>  		struct video_tuner	*tun = arg;
>  		struct v4l2_tuner	t;
> -		memset(&t,0,sizeof(t));
> +		memset(&t, 0, sizeof(t));
>  
> -		t.index=tun->tuner;
> +		t.index = tun->tuner;
>  
>  		err = drv(inode, file, VIDIOC_S_INPUT, &t);
>  		if (err < 0)
> -			dprintk("VIDIOCSTUNER / VIDIOC_S_INPUT: %d\n",err);
> +			dprintk("VIDIOCSTUNER / VIDIOC_S_INPUT: %d\n", err);
>  
>  		break;
>  	}
>  	case VIDIOCGFREQ: /*  get frequency  */
>  	{
>  		unsigned long *freq = arg;
> -		memset(&freq2,0,sizeof(freq2));
> +		memset(&freq2, 0, sizeof(freq2));
>  
>  		freq2.tuner = 0;
>  		err = drv(inode, file, VIDIOC_G_FREQUENCY, &freq2);
>  		if (err < 0)
> -			dprintk("VIDIOCGFREQ / VIDIOC_G_FREQUENCY: %d\n",err);
> +			dprintk("VIDIOCGFREQ / VIDIOC_G_FREQUENCY: %d\n", err);
>  		if (0 == err)
>  			*freq = freq2.frequency;
>  		break;
> @@ -764,23 +762,23 @@ v4l_compat_translate_ioctl(struct inode         *inode,
>  	case VIDIOCSFREQ: /*  set frequency  */
>  	{
>  		unsigned long *freq = arg;
> -		memset(&freq2,0,sizeof(freq2));
> +		memset(&freq2, 0, sizeof(freq2));
>  
>  		drv(inode, file, VIDIOC_G_FREQUENCY, &freq2);
>  		freq2.frequency = *freq;
>  		err = drv(inode, file, VIDIOC_S_FREQUENCY, &freq2);
>  		if (err < 0)
> -			dprintk("VIDIOCSFREQ / VIDIOC_S_FREQUENCY: %d\n",err);
> +			dprintk("VIDIOCSFREQ / VIDIOC_S_FREQUENCY: %d\n", err);
>  		break;
>  	}
>  	case VIDIOCGAUDIO: /*  get audio properties/controls  */
>  	{
>  		struct video_audio	*aud = arg;
> -		memset(&aud2,0,sizeof(aud2));
> +		memset(&aud2, 0, sizeof(aud2));
>  
>  		err = drv(inode, file, VIDIOC_G_AUDIO, &aud2);
>  		if (err < 0) {
> -			dprintk("VIDIOCGAUDIO / VIDIOC_G_AUDIO: %d\n",err);
> +			dprintk("VIDIOCGAUDIO / VIDIOC_G_AUDIO: %d\n", err);
>  			break;
>  		}
>  		memcpy(aud->name, aud2.name,
> @@ -821,10 +819,10 @@ v4l_compat_translate_ioctl(struct inode         *inode,
>  			aud->step = qctrl2.step;
>  		aud->mode = 0;
>  
> -		memset(&tun2,0,sizeof(tun2));
> +		memset(&tun2, 0, sizeof(tun2));
>  		err = drv(inode, file, VIDIOC_G_TUNER, &tun2);
>  		if (err < 0) {
> -			dprintk("VIDIOCGAUDIO / VIDIOC_G_TUNER: %d\n",err);
> +			dprintk("VIDIOCGAUDIO / VIDIOC_G_TUNER: %d\n", err);
>  			err = 0;
>  			break;
>  		}
> @@ -841,13 +839,13 @@ v4l_compat_translate_ioctl(struct inode         *inode,
>  	{
>  		struct video_audio	*aud = arg;
>  
> -		memset(&aud2,0,sizeof(aud2));
> -		memset(&tun2,0,sizeof(tun2));
> +		memset(&aud2, 0, sizeof(aud2));
> +		memset(&tun2, 0, sizeof(tun2));
>  
>  		aud2.index = aud->audio;
>  		err = drv(inode, file, VIDIOC_S_AUDIO, &aud2);
>  		if (err < 0) {
> -			dprintk("VIDIOCSAUDIO / VIDIOC_S_AUDIO: %d\n",err);
> +			dprintk("VIDIOCSAUDIO / VIDIOC_S_AUDIO: %d\n", err);
>  			break;
>  		}
>  
> @@ -864,7 +862,7 @@ v4l_compat_translate_ioctl(struct inode         *inode,
>  
>  		err = drv(inode, file, VIDIOC_G_TUNER, &tun2);
>  		if (err < 0)
> -			dprintk("VIDIOCSAUDIO / VIDIOC_G_TUNER: %d\n",err);
> +			dprintk("VIDIOCSAUDIO / VIDIOC_G_TUNER: %d\n", err);
>  		if (err == 0) {
>  			switch (aud->mode) {
>  			default:
> @@ -881,7 +879,7 @@ v4l_compat_translate_ioctl(struct inode         *inode,
>  			}
>  			err = drv(inode, file, VIDIOC_S_TUNER, &tun2);
>  			if (err < 0)
> -				dprintk("VIDIOCSAUDIO / VIDIOC_S_TUNER: %d\n",err);
> +				dprintk("VIDIOCSAUDIO / VIDIOC_S_TUNER: %d\n", err);
>  		}
>  		err = 0;
>  		break;
> @@ -890,20 +888,20 @@ v4l_compat_translate_ioctl(struct inode         *inode,
>  	{
>  		struct video_mmap	*mm = arg;
>  
> -		fmt2 = kzalloc(sizeof(*fmt2),GFP_KERNEL);
> -		memset(&buf2,0,sizeof(buf2));
> +		fmt2 = kzalloc(sizeof(*fmt2), GFP_KERNEL);
> +		memset(&buf2, 0, sizeof(buf2));
>  
>  		fmt2->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>  		err = drv(inode, file, VIDIOC_G_FMT, fmt2);
>  		if (err < 0) {
> -			dprintk("VIDIOCMCAPTURE / VIDIOC_G_FMT: %d\n",err);
> +			dprintk("VIDIOCMCAPTURE / VIDIOC_G_FMT: %d\n", err);
>  			break;
>  		}
>  		if (mm->width   != fmt2->fmt.pix.width  ||
>  		    mm->height  != fmt2->fmt.pix.height ||
>  		    palette_to_pixelformat(mm->format) !=
> -		    fmt2->fmt.pix.pixelformat)
> -		{/* New capture format...  */
> +		    fmt2->fmt.pix.pixelformat) {
> +			/* New capture format...  */
>  			fmt2->fmt.pix.width = mm->width;
>  			fmt2->fmt.pix.height = mm->height;
>  			fmt2->fmt.pix.pixelformat =
> @@ -912,7 +910,7 @@ v4l_compat_translate_ioctl(struct inode         *inode,
>  			fmt2->fmt.pix.bytesperline = 0;
>  			err = drv(inode, file, VIDIOC_S_FMT, fmt2);
>  			if (err < 0) {
> -				dprintk("VIDIOCMCAPTURE / VIDIOC_S_FMT: %d\n",err);
> +				dprintk("VIDIOCMCAPTURE / VIDIOC_S_FMT: %d\n", err);
>  				break;
>  			}
>  		}
> @@ -920,30 +918,30 @@ v4l_compat_translate_ioctl(struct inode         *inode,
>  		buf2.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>  		err = drv(inode, file, VIDIOC_QUERYBUF, &buf2);
>  		if (err < 0) {
> -			dprintk("VIDIOCMCAPTURE / VIDIOC_QUERYBUF: %d\n",err);
> +			dprintk("VIDIOCMCAPTURE / VIDIOC_QUERYBUF: %d\n", err);
>  			break;
>  		}
>  		err = drv(inode, file, VIDIOC_QBUF, &buf2);
>  		if (err < 0) {
> -			dprintk("VIDIOCMCAPTURE / VIDIOC_QBUF: %d\n",err);
> +			dprintk("VIDIOCMCAPTURE / VIDIOC_QBUF: %d\n", err);
>  			break;
>  		}
>  		err = drv(inode, file, VIDIOC_STREAMON, &captype);
>  		if (err < 0)
> -			dprintk("VIDIOCMCAPTURE / VIDIOC_STREAMON: %d\n",err);
> +			dprintk("VIDIOCMCAPTURE / VIDIOC_STREAMON: %d\n", err);
>  		break;
>  	}
>  	case VIDIOCSYNC: /*  wait for a frame  */
>  	{
>  		int			*i = arg;
>  
> -		memset(&buf2,0,sizeof(buf2));
> +		memset(&buf2, 0, sizeof(buf2));
>  		buf2.index = *i;
>  		buf2.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>  		err = drv(inode, file, VIDIOC_QUERYBUF, &buf2);
>  		if (err < 0) {
>  			/*  No such buffer */
> -			dprintk("VIDIOCSYNC / VIDIOC_QUERYBUF: %d\n",err);
> +			dprintk("VIDIOCSYNC / VIDIOC_QUERYBUF: %d\n", err);
>  			break;
>  		}
>  		if (!(buf2.flags & V4L2_BUF_FLAG_MAPPED)) {
> @@ -955,29 +953,28 @@ v4l_compat_translate_ioctl(struct inode         *inode,
>  		/* make sure capture actually runs so we don't block forever */
>  		err = drv(inode, file, VIDIOC_STREAMON, &captype);
>  		if (err < 0) {
> -			dprintk("VIDIOCSYNC / VIDIOC_STREAMON: %d\n",err);
> +			dprintk("VIDIOCSYNC / VIDIOC_STREAMON: %d\n", err);
>  			break;
>  		}
>  
>  		/*  Loop as long as the buffer is queued, but not done  */
>  		while ((buf2.flags &
>  			(V4L2_BUF_FLAG_QUEUED | V4L2_BUF_FLAG_DONE))
> -		       == V4L2_BUF_FLAG_QUEUED)
> -		{
> +		       == V4L2_BUF_FLAG_QUEUED) {
>  			err = poll_one(file);
>  			if (err < 0 ||	/* error or sleep was interrupted  */
>  			    err == 0)	/* timeout? Shouldn't occur.  */
>  				break;
>  			err = drv(inode, file, VIDIOC_QUERYBUF, &buf2);
>  			if (err < 0)
> -				dprintk("VIDIOCSYNC / VIDIOC_QUERYBUF: %d\n",err);
> +				dprintk("VIDIOCSYNC / VIDIOC_QUERYBUF: %d\n", err);
>  		}
>  		if (!(buf2.flags & V4L2_BUF_FLAG_DONE)) /* not done */
>  			break;
>  		do {
>  			err = drv(inode, file, VIDIOC_DQBUF, &buf2);
>  			if (err < 0)
> -				dprintk("VIDIOCSYNC / VIDIOC_DQBUF: %d\n",err);
> +				dprintk("VIDIOCSYNC / VIDIOC_DQBUF: %d\n", err);
>  		} while (err == 0 && buf2.index != *i);
>  		break;
>  	}
> @@ -986,7 +983,7 @@ v4l_compat_translate_ioctl(struct inode         *inode,
>  	{
>  		struct vbi_format      *fmt = arg;
>  
> -		fmt2 = kzalloc(sizeof(*fmt2),GFP_KERNEL);
> +		fmt2 = kzalloc(sizeof(*fmt2), GFP_KERNEL);
>  		fmt2->type = V4L2_BUF_TYPE_VBI_CAPTURE;
>  
>  		err = drv(inode, file, VIDIOC_G_FMT, fmt2);
> @@ -1018,7 +1015,7 @@ v4l_compat_translate_ioctl(struct inode         *inode,
>  			break;
>  		}
>  
> -		fmt2 = kzalloc(sizeof(*fmt2),GFP_KERNEL);
> +		fmt2 = kzalloc(sizeof(*fmt2), GFP_KERNEL);
>  
>  		fmt2->type = V4L2_BUF_TYPE_VBI_CAPTURE;
>  		fmt2->fmt.vbi.samples_per_line = fmt->samples_per_line;
> @@ -1061,7 +1058,6 @@ v4l_compat_translate_ioctl(struct inode         *inode,
>  	kfree(fmt2);
>  	return err;
>  }
> -
>  EXPORT_SYMBOL(v4l_compat_translate_ioctl);
>  
>  /*




Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
