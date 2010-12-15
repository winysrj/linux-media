Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:37654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755231Ab0LOUGA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Dec 2010 15:06:00 -0500
Message-ID: <4D0920CC.7060004@redhat.com>
Date: Wed, 15 Dec 2010 21:10:52 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Antonio Ospite <ospite@studenti.unina.it>
CC: linux-media@vger.kernel.org
Subject: Re: Question about libv4lconvert.
References: <20101215171139.b6c1f03a.ospite@studenti.unina.it>
In-Reply-To: <20101215171139.b6c1f03a.ospite@studenti.unina.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi,

On 12/15/2010 05:11 PM, Antonio Ospite wrote:
> Hi,
>
> I am taking a look at libv4lconvert, and I have a question about the
> logic in v4lconvert_convert_pixfmt(), in some conversion switches there
> is code like this:
>
> 	case V4L2_PIX_FMT_GREY:
> 		switch (dest_pix_fmt) {
> 		case V4L2_PIX_FMT_RGB24:
> 	        case V4L2_PIX_FMT_BGR24:
> 			v4lconvert_grey_to_rgb24(src, dest, width, height);
> 			break;
> 		case V4L2_PIX_FMT_YUV420:
> 		case V4L2_PIX_FMT_YVU420:
> 			v4lconvert_grey_to_yuv420(src, dest, fmt);
> 			break;
> 		}
> 		if (src_size<  (width * height)) {
> 			V4LCONVERT_ERR("short grey data frame\n");
> 			errno = EPIPE;
> 			result = -1;
> 		}
> 		break;
>
> However the conversion routines which are going to be called seem to
> assume that the buffers, in particular the source buffer, are of the
> correct full frame size when looping over them.
>

Correct, because they trust that the kernel drivers have allocated large
enough buffers to hold a valid frame which is a safe assumption.

 > My question is: shouldn't the size check now at the end of the case
 > block be at the _beginning_ of it instead, so to detect a short frame
 > before conversion and avoid a possible out of bound access inside the
 > conversion routine?

This is done this way deliberately, this has to do with how the EPIPE
errno variable is used in a special way.

An error return from v4lconvert_convert with an errno of EPIPE means
I managed to get some data for you but not an entire frame. The upper
layers of libv4l will respond to this by retrying (getting another frame),
but only a limited number of times. Once the retries are exceeded they
will simply pass along whatever they did manage to get.

The reason for this is that there can be bus errors or vsync issues (*),
which lead to a short frame, which are intermittent errors. So detecting
them and getting another frame is a good thing to do because usually the
next frame will be fine. However sometimes there are cases where every
single frame is a short frame, for example the zc3xx driver used to
deliver jpeg's with only 224 lines of data when running at 320x240 with
some sensors. Now one can argue that this is a driver issue, and it is
but it still happens in this case it is much better to pass along
the 224 lines which we did get, then to make this a fatal error.

Note that due to the retries the user will get a much lower framerate,
which together with the missing lines at the bottom + printing
of error messages will hopefully be enough for the user to report
a bug to us, despite him/her getting some picture.

I hope this explains.

Regards,

Hans


*) While starting the stream it may take several frames for vsync to
properly lock in some cases.


