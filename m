Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:36019 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752088AbbFELMD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Jun 2015 07:12:03 -0400
Message-ID: <557183F6.4010600@xs4all.nl>
Date: Fri, 05 Jun 2015 13:11:50 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
CC: linux-media@vger.kernel.org,
	Michael Stegemann <michael@stegemann.it>,
	Dale Hamel <dale.hamel@srvthe.net>
Subject: Re: [PATCH] stk1160: Add frame scaling support
References: <1432851543-3576-1-git-send-email-ezequiel@vanguardiasur.com.ar>
In-Reply-To: <1432851543-3576-1-git-send-email-ezequiel@vanguardiasur.com.ar>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ezequiel,

As mentioned in irc: run v4l2-compliance -s and v4l2-compliance -f.
I quickly tried it and v4l2-compliance fails:

Test input 0:

        Control ioctls:
                test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
                test VIDIOC_QUERYCTRL: OK
                test VIDIOC_G/S_CTRL: OK
                test VIDIOC_G/S/TRY_EXT_CTRLS: OK
                test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
                test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
                Standard Controls: 7 Private Controls: 0

        Format ioctls:
                test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
                test VIDIOC_G/S_PARM: OK
                test VIDIOC_G_FBUF: OK (Not Supported)
                test VIDIOC_G_FMT: OK
                fail: v4l2-test-formats.cpp(422): !pix.width || !pix.height
                fail: v4l2-test-formats.cpp(726): Video Capture is valid, but TRY_FMT failed to return a format
                test VIDIOC_TRY_FMT: FAIL
                fail: v4l2-test-formats.cpp(422): !pix.width || !pix.height
                fail: v4l2-test-formats.cpp(942): Video Capture is valid, but no S_FMT was implemented
                test VIDIOC_S_FMT: FAIL
                test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
                test Cropping: OK (Not Supported)
                test Composing: OK (Not Supported)

and it ends with a segfault and this in the kernel log:

[  180.135178] stk1160: width 720, height 480
[  180.135187] stk1160: width 0, height 0
[  180.135240] stk1160: width 0, height 0
[  180.135317] stk1160: decimate 0x1f, column units -721, row units -481
[  180.135450] stk1160: width 1, height 1
[  180.135524] stk1160: decimate 0x1f, column units 719, row units 479
[  180.135572] stk1160: width 720, height 480
[  180.135701] stk1160: decimate 0x10, column units 0, row units 0
[  180.135750] divide error: 0000 [#1] PREEMPT SMP 
[  180.135773] Modules linked in: stk1160 ivtv_alsa tuner_simple tuner_types tda9887 tda8290 tuner msp3400 saa7127 ivtv saa7115 videobuf2_vmalloc tveeprom videobuf2_memops videobuf2_core cx2341x v4l2_common videodev media x86_pkg_temp_thermal processor button [last unloaded: stk1160]
[  180.135851] CPU: 2 PID: 7391 Comm: v4l2-compliance Not tainted 4.1.0-rc3-koryphon #837
[  180.135862] Hardware name: ASUSTeK COMPUTER INC. Z10PA-U8 Series/Z10PA-U8 Series, BIOS 0303 11/20/2014
[  180.135873] task: ffff8810364b1830 ti: ffff88100c794000 task.ti: ffff88100c794000
[  180.135882] RIP: 0010:[<ffffffffa003ed9a>]  [<ffffffffa003ed9a>] stk1160_try_fmt.isra.5+0x1ba/0x1e0 [stk1160]
[  180.135902] RSP: 0018:ffff88100c797bd8  EFLAGS: 00010202
[  180.135910] RAX: 00000000000002d0 RBX: 0000000000000000 RCX: ffff88100c797c14
[  180.135918] RDX: 0000000000000000 RSI: ffff8810364107c0 RDI: 00000000000001e0
[  180.135927] RBP: ffff88100c797bf8 R08: ffff881036537500 R09: 00000000000001e0
[  180.135939] R10: 0000000000000000 R11: 0000000000000005 R12: 0000000000000000
[  180.135948] R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000000
[  180.135958] FS:  00007f7acbad8740(0000) GS:ffff88107fc80000(0000) knlGS:0000000000000000
[  180.135968] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  180.135975] CR2: 00007faa881e4148 CR3: 000000102974d000 CR4: 00000000001406e0
[  180.135984] Stack:
[  180.136003]  ffff881036410000 0000000000000000 ffff881036537500 ffff881036536c00
[  180.136018]  ffff88100c797c48 ffffffffa003ee4b ffff88100c797c58 ffff000081a0dbc2
[  180.136033]  0000000100000001 0000000000000000 ffff88100c797c48 ffff881036537500
[  180.136048] Call Trace:
[  180.136057]  [<ffffffffa003ee4b>] vidioc_s_fmt_vid_cap+0x4b/0xf0 [stk1160]
[  180.136073]  [<ffffffffa074e163>] v4l_s_fmt+0x123/0x490 [videodev]
[  180.136086]  [<ffffffffa074d294>] __video_do_ioctl+0x274/0x310 [videodev]
[  180.136099]  [<ffffffffa074ee4a>] ? video_usercopy+0x2fa/0x4c0 [videodev]
[  180.136111]  [<ffffffffa074ee86>] video_usercopy+0x336/0x4c0 [videodev]
[  180.136122]  [<ffffffffa074d020>] ? v4l_querycap+0x60/0x60 [videodev]
[  180.136135]  [<ffffffff813dea63>] ? __this_cpu_preempt_check+0x13/0x20
[  180.136146]  [<ffffffff810d325f>] ? __srcu_read_lock+0x5f/0xa0
[  180.136157]  [<ffffffffa074f020>] video_ioctl2+0x10/0x20 [videodev]
[  180.136168]  [<ffffffffa07486a0>] v4l2_ioctl+0xd0/0xf0 [videodev]
[  180.136179]  [<ffffffff8118fc60>] do_vfs_ioctl+0x2e0/0x4e0
[  180.136187]  [<ffffffff8117bccc>] ? vfs_write+0x14c/0x1b0
[  180.136196]  [<ffffffff8118fee1>] SyS_ioctl+0x81/0xa0
[  180.136208]  [<ffffffff81a1266e>] system_call_fastpath+0x12/0x71
[  180.136216] Code: 31 d2 41 89 c1 41 89 40 0c e9 d0 fe ff ff 0f 1f 00 44 89 d0 41 be 01 00 00 00 45 31 ed c1 e8 1f 44 01 d0 d1 f8 05 d0 02 00 00 99 <41> f7 fa 31 d2 41 89 c2 44 8d 60 ff b8 d0 02 00 00 41 f7 f2 41 
[  180.136354] RIP  [<ffffffffa003ed9a>] stk1160_try_fmt.isra.5+0x1ba/0x1e0 [stk1160]
[  180.136366]  RSP <ffff88100c797bd8>
[  180.139977] ---[ end trace a699ade0cf2b43de ]---

So this needs a bit more work... Remember: v4l2-compliance is your friend! :-)

I didn't review the patch, this should be fixed first.

BTW, I noticed that this driver is logging a lot in the kernel log. Normal
operation of a driver shouldn't log anything, so can you fix this while you're
at it?

Thanks,

	Hans

On 05/29/2015 12:19 AM, Ezequiel Garcia wrote:
> This commit implements frame decimation for stk1160, which allows
> to support format changes instead of a static frame size.
> 
> The stk1160 supports independent row and column decimation, in two
> different modes:
>  * set a number of rows/columns units to skip for each unit sent.
>  * set a number of rows/columns units to send for each unit skipped.
> 
> This effectively allows to achieve different frame scaling ratios.
> 
> The unit number can be set to either two row/columns sent/skipped,
> or four row/columns sent/skipped. Since the video format (UYVY)
> has 4-bytes, using a unit number of two row/columns, results
> in frame color 'shifting'.
> 
> Signed-off-by: Michael Stegemann <michael@stegemann.it>
> Signed-off-by: Dale Hamel <dale.hamel@srvthe.net>
> Signed-off-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
> ---
>  drivers/media/usb/stk1160/stk1160-reg.h |  34 ++++++
>  drivers/media/usb/stk1160/stk1160-v4l.c | 178 +++++++++++++++++++++++++++-----
>  2 files changed, 184 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/media/usb/stk1160/stk1160-reg.h b/drivers/media/usb/stk1160/stk1160-reg.h
> index 3e49da6..81ff3a1 100644
> --- a/drivers/media/usb/stk1160/stk1160-reg.h
> +++ b/drivers/media/usb/stk1160/stk1160-reg.h
> @@ -33,6 +33,40 @@
>   */
>  #define STK1160_DCTRL			0x100
>  
> +/*
> + * Decimation Control Register:
> + * Byte 104: Horizontal Decimation Line Unit Count
> + * Byte 105: Vertical Decimation Line Unit Count
> + * Byte 106: Decimation Control
> + * Bit 0 - Horizontal Decimation Control
> + *   0 Horizontal decimation is disabled.
> + *   1 Horizontal decimation is enabled.
> + * Bit 1 - Decimates Half or More Column
> + *   0 Decimates less than half from original column,
> + *     send count unit (0x105) before each unit skipped.
> + *   1 Decimates half or more from original column,
> + *     skip count unit (0x105) before each unit sent.
> + * Bit 2 - Vertical Decimation Control
> + *   0 Vertical decimation is disabled.
> + *   1 Vertical decimation is enabled.
> + * Bit 3 - Vertical Greater or Equal to Half
> + *   0 Decimates less than half from original row,
> + *     send count unit (0x105) before each unit skipped.
> + *   1 Decimates half or more from original row,
> + *     skip count unit (0x105) before each unit sent.
> + * Bit 4 - Decimation Unit
> + *  0 Decimation will work with 2 rows or columns per unit.
> + *  1 Decimation will work with 4 rows or columns per unit.
> + */
> +#define STK1160_DMCTRL_H_UNITS		0x104
> +#define STK1160_DMCTRL_V_UNITS		0x105
> +#define STK1160_DMCTRL			0x106
> +#define  STK1160_H_DEC_EN		BIT(0)
> +#define  STK1160_H_DEC_MODE		BIT(1)
> +#define  STK1160_V_DEC_EN		BIT(2)
> +#define  STK1160_V_DEC_MODE		BIT(3)
> +#define  STK1160_DEC_UNIT_SIZE		BIT(4)
> +
>  /* Capture Frame Start Position */
>  #define STK116_CFSPO			0x110
>  #define STK116_CFSPO_STX_L		0x110
> diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
> index 749ad56..5b0a3ac 100644
> --- a/drivers/media/usb/stk1160/stk1160-v4l.c
> +++ b/drivers/media/usb/stk1160/stk1160-v4l.c
> @@ -42,6 +42,17 @@ static bool keep_buffers;
>  module_param(keep_buffers, bool, 0644);
>  MODULE_PARM_DESC(keep_buffers, "don't release buffers upon stop streaming");
>  
> +enum stk1160_decimate_mode {
> +	STK1160_DECIMATE_MORE_THAN_HALF,
> +	STK1160_DECIMATE_LESS_THAN_HALF,
> +};
> +
> +struct stk1160_decimate_ctrl {
> +	bool col_en, row_en;
> +	enum stk1160_decimate_mode col_mode, row_mode;
> +	unsigned int col_n, row_n;
> +};
> +
>  /* supported video standards */
>  static struct stk1160_fmt format[] = {
>  	{
> @@ -106,6 +117,37 @@ static void stk1160_set_std(struct stk1160 *dev)
>  
>  }
>  
> +static void stk1160_set_fmt(struct stk1160 *dev,
> +			    struct stk1160_decimate_ctrl *ctrl)
> +{
> +	u32 val = 0;
> +
> +	if (ctrl) {
> +		/*
> +		 * Since the format is UYVY, the device must skip or send
> +		 * a number of rows/columns multiple of four. This way, the
> +		 * colour format is preserved. The STK1160_DEC_UNIT_SIZE bit
> +		 * does exactly this.
> +		 */
> +		val |= STK1160_DEC_UNIT_SIZE;
> +		val |= ctrl->col_en ? STK1160_H_DEC_EN : 0;
> +		val |= ctrl->row_en ? STK1160_V_DEC_EN : 0;
> +		val |= ctrl->col_mode == STK1160_DECIMATE_MORE_THAN_HALF ? STK1160_H_DEC_MODE : 0;
> +		val |= ctrl->row_mode == STK1160_DECIMATE_MORE_THAN_HALF ? STK1160_V_DEC_MODE : 0;
> +
> +		/* Horizontal count units */
> +		stk1160_write_reg(dev, STK1160_DMCTRL_H_UNITS, ctrl->col_n);
> +		/* Vertical count units */
> +		stk1160_write_reg(dev, STK1160_DMCTRL_V_UNITS, ctrl->row_n);
> +
> +		stk1160_dbg("decimate 0x%x, column units %d, row units %d\n",
> +			    val, ctrl->col_n, ctrl->row_n);
> +	}
> +
> +	/* Decimation control */
> +	stk1160_write_reg(dev, STK1160_DMCTRL, val);
> +}
> +
>  /*
>   * Set a new alternate setting.
>   * Returns true is dev->max_pkt_size has changed, false otherwise.
> @@ -321,26 +363,111 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
>  	return 0;
>  }
>  
> -static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
> -			struct v4l2_format *f)
> +static void stk1160_try_fmt(struct stk1160 *dev, struct v4l2_format *f,
> +			    struct stk1160_decimate_ctrl *ctrl)
>  {
> -	struct stk1160 *dev = video_drvdata(file);
> +	int height = f->fmt.pix.height;
> +	int width = f->fmt.pix.width;
> +	int base_width, base_height;
> +	unsigned int col_n, row_n;
> +	enum stk1160_decimate_mode col_mode, row_mode;
> +	bool col_en, row_en;
> +
> +	base_width = 720;
> +	base_height = (dev->norm & V4L2_STD_525_60) ? 480 : 576;
> +
> +	if (width >= base_width) {
> +		col_en = false;
> +		col_mode = STK1160_DECIMATE_LESS_THAN_HALF;
> +		col_n = 0;
> +		f->fmt.pix.width = base_width;
> +	} else if (width > base_width / 2) {
> +		/*
> +		 * The device will send count units for each
> +		 * unit skipped. This means count unit is:
> +		 *
> +		 * n = width / (frame width - width)
> +		 *
> +		 * And the width is:
> +		 *
> +		 * width = (n / n + 1) * frame width
> +		 */
> +		col_en = true;
> +		col_mode = STK1160_DECIMATE_LESS_THAN_HALF;
> +		col_n = DIV_ROUND_CLOSEST(width, base_width - width);
> +		f->fmt.pix.width = (base_width * col_n) / (col_n + 1);
>  
> -	/*
> -	 * User can't choose size at his own will,
> -	 * so we just return him the current size chosen
> -	 * at standard selection.
> -	 * TODO: Implement frame scaling?
> -	 */
> +	} else if (width <= base_width / 2) {
> +
> +		/*
> +		 * The device will skip count units for each
> +		 * unit sent. This means count is:
> +		 *
> +		 * n = (frame width / width) - 1
> +		 *
> +		 * And the width is:
> +		 *
> +		 * width = frame width / (n + 1)
> +		 */
> +		col_en = true;
> +		col_mode = STK1160_DECIMATE_MORE_THAN_HALF;
> +		col_n = DIV_ROUND_CLOSEST(base_width, width) - 1;
> +		f->fmt.pix.width = base_width / (col_n + 1);
> +	} else {
> +		col_en = false;
> +		col_mode = STK1160_DECIMATE_LESS_THAN_HALF;
> +		col_n = 0;
> +		f->fmt.pix.width = base_width;
> +	}
> +
> +	if (height >= base_height) {
> +		row_en = false;
> +		row_mode = STK1160_DECIMATE_LESS_THAN_HALF;
> +		row_n = 0;
> +		f->fmt.pix.height = base_height;
> +	} else if (height > base_height / 2) {
> +		row_en = true;
> +		row_mode = STK1160_DECIMATE_LESS_THAN_HALF;
> +		row_n = DIV_ROUND_CLOSEST(height, base_height - height);
> +		f->fmt.pix.height = (base_height * row_n) / (row_n + 1);
> +
> +	} else if (height <= base_height / 2) {
> +		row_en = true;
> +		row_mode = STK1160_DECIMATE_MORE_THAN_HALF;
> +		row_n = DIV_ROUND_CLOSEST(base_height, height) - 1;
> +		f->fmt.pix.height = base_height / (row_n + 1);
> +	} else {
> +		row_en = false;
> +		row_mode = STK1160_DECIMATE_LESS_THAN_HALF;
> +		row_n = 0;
> +		f->fmt.pix.height = base_height;
> +	}
>  
>  	f->fmt.pix.pixelformat = dev->fmt->fourcc;
> -	f->fmt.pix.width = dev->width;
> -	f->fmt.pix.height = dev->height;
>  	f->fmt.pix.field = V4L2_FIELD_INTERLACED;
> -	f->fmt.pix.bytesperline = dev->width * 2;
> -	f->fmt.pix.sizeimage = dev->height * f->fmt.pix.bytesperline;
> +	f->fmt.pix.bytesperline = f->fmt.pix.width * 2;
> +	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
>  	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
>  
> +	if (ctrl) {
> +		ctrl->col_en = col_en;
> +		ctrl->col_n = col_n;
> +		ctrl->col_mode = col_mode;
> +		ctrl->row_en = row_en;
> +		ctrl->row_n = row_n;
> +		ctrl->row_mode = row_mode;
> +	}
> +
> +	stk1160_dbg("width %d, height %d\n",
> +		    f->fmt.pix.width, f->fmt.pix.height);
> +}
> +
> +static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
> +				  struct v4l2_format *f)
> +{
> +	struct stk1160 *dev = video_drvdata(file);
> +
> +	stk1160_try_fmt(dev, f, NULL);
>  	return 0;
>  }
>  
> @@ -349,13 +476,15 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
>  {
>  	struct stk1160 *dev = video_drvdata(file);
>  	struct vb2_queue *q = &dev->vb_vidq;
> +	struct stk1160_decimate_ctrl ctrl;
>  
>  	if (vb2_is_busy(q))
>  		return -EBUSY;
>  
> -	vidioc_try_fmt_vid_cap(file, priv, f);
> -
> -	/* We don't support any format changes */
> +	stk1160_try_fmt(dev, f, &ctrl);
> +	dev->width = f->fmt.pix.width;
> +	dev->height = f->fmt.pix.height;
> +	stk1160_set_fmt(dev, &ctrl);
>  
>  	return 0;
>  }
> @@ -391,22 +520,15 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id norm)
>  		return -ENODEV;
>  
>  	/* We need to set this now, before we call stk1160_set_std */
> +	dev->width = 720;
> +	dev->height = (norm & V4L2_STD_525_60) ? 480 : 576;
>  	dev->norm = norm;
>  
> -	/* This is taken from saa7115 video decoder */
> -	if (dev->norm & V4L2_STD_525_60) {
> -		dev->width = 720;
> -		dev->height = 480;
> -	} else if (dev->norm & V4L2_STD_625_50) {
> -		dev->width = 720;
> -		dev->height = 576;
> -	} else {
> -		stk1160_err("invalid standard\n");
> -		return -EINVAL;
> -	}
> -
>  	stk1160_set_std(dev);
>  
> +	/* Calling with NULL disables frame decimation */
> +	stk1160_set_fmt(dev, NULL);
> +
>  	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_std,
>  			dev->norm);
>  
> 

