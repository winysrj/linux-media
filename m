Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m73Ananh027576
	for <video4linux-list@redhat.com>; Sun, 3 Aug 2008 06:49:36 -0400
Received: from smtp8-g19.free.fr (smtp8-g19.free.fr [212.27.42.65])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m73AnPRf001763
	for <video4linux-list@redhat.com>; Sun, 3 Aug 2008 06:49:25 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <87d4krv0rd.fsf@free.fr>
	<1217694634-32756-1-git-send-email-robert.jarzmik@free.fr>
	<1217694634-32756-2-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0808022224490.27474@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Sun, 03 Aug 2008 12:49:23 +0200
In-Reply-To: <Pine.LNX.4.64.0808022224490.27474@axis700.grange> (Guennadi
	Liakhovetski's message of "Sat\,
	2 Aug 2008 22\:44\:03 +0200 \(CEST\)")
Message-ID: <87vdyipe4s.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 2/2] Add support for Micron MT9M111 camera.
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

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> Nice! Not knowing this specific camera, I can only provide a couple of 
> nitpicks:
> Please reformat this comment to
>
> /*
>  * mt9m111 i2c address is 0x5d or 0x48 (depending on SAddr pin)
>  * The platform has to define i2c_board_info
>  * and call i2c_register_board_info()
>  */
OK for next submit.

>> +#define MT9M111_OUTFMT_SWAP_YCbCr_Cb_Cr	(1<<0)
>
> Please, add spaces around the "<<" in all defines above (except where they 
> are already there, of course:-))
OK for next submit.
>

>> +static const struct soc_camera_data_format mt9m111_colour_formats[] = {
>> +	COL_FMT("YCrYCb 8 bit", 8, V4L2_PIX_FMT_YUYV, V4L2_COLORSPACE_JPEG),
>> +	RGB_FMT("RGB 565", 16, V4L2_PIX_FMT_RGB565),
>> +	RGB_FMT("RGB 555", 16, V4L2_PIX_FMT_RGB555),
>> +	RGB_FMT("Bayer (sRGB) 10 bit", 10, V4L2_PIX_FMT_SBGGR16),
>> +	RGB_FMT("Bayer (sRGB) 8 bit", 8, V4L2_PIX_FMT_SBGGR8),
>> +};
>
> This is where you would add all those swapped pixel formats.
Let's finish the dicussion in the other thread "[RFC] soc-camera: endianness
between camera and its host".

> Is it really a good idea to keep the camera active all the time? Maybe 
> only call enable / disable here, not on init / release?
Well, I think so.

The idea here is the camera evaluates its environment to adjust its internal
gain values. This a kind of PLL which provides Automatic White Balance,
Automatic Gamma, Automatic Defect Correction.
So, my idea is that once a user opens /dev/videoX, the camera gets activated and
calculates the values. In that case, when he submits buffers to the V4L2 stack,
the camera is really ready.

But I can change that to activate the camera only on capture, I'm not very set
on this. The user can start capturing, and then wait a couple of seconds for the
camera to settle. So what do you think, should I move camera activation into
start_capture / stop_capture ?
>> +		.maximum	= 63*2*2,
>> +		.step		= 1,
>> +		.default_value	= 32,
>> +		.flags		= V4L2_CTRL_FLAG_SLIDER,
>
> Come on, be generous, add a couple of spaces around that multiplication 
> above.
OK for next submit.

>
> [snip]
>> +	if ((gain >= 64*2) && (gain < 63*2*2))
>> +		val = (1 << 10) | (1 << 9) | (gain / 4);
>> +	else if ((gain >= 64) && (gain < 64*2))
> And here too, please.
OK for next submit.
>
> [snip]
>
>> +/* Interface active, can use i2c. If it fails, it can indeed mean, that
>> + * this wasn't our capture interface, so, we wait for the right one */
>
> Reformat the comment, please.
OK for next submit.

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
