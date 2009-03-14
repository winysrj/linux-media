Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3210 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbZCNN0t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2009 09:26:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [RFC 4/7] ARM: DaVinci: DM646x Video: Defintions for standards supported by display
Date: Sat, 14 Mar 2009 14:27:09 +0100
Cc: chaithrika@ti.com, linux-media@vger.kernel.org
References: <1236934897-32160-1-git-send-email-chaithrika@ti.com>
In-Reply-To: <1236934897-32160-1-git-send-email-chaithrika@ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903141427.09177.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 13 March 2009 10:01:37 chaithrika@ti.com wrote:
> From: Chaithrika U S <chaithrika@ti.com>
> 
> Add defintions for Digital TV Standards supported by display driver
> 
> Signed-off-by: Chaithrika U S <chaithrika@ti.com>
> ---
> Applies to v4l-dvb repository located at
> http://linuxtv.org/hg/v4l-dvb/rev/1fd54a62abde
> 
>  include/linux/videodev2.h |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 7a8eafd..df4a622 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -704,6 +704,18 @@ typedef __u64 v4l2_std_id;
>  #define V4L2_STD_ALL            (V4L2_STD_525_60	|\
>  				 V4L2_STD_625_50)
>  
> +#define V4L2_STD_720P_60        ((v4l2_std_id)(0x0001000000000000ULL))
> +#define V4L2_STD_1080I_30       ((v4l2_std_id)(0x0002000000000000ULL))
> +#define V4L2_STD_1080I_25       ((v4l2_std_id)(0x0004000000000000ULL))
> +#define V4L2_STD_480P_60        ((v4l2_std_id)(0x0008000000000000ULL))
> +#define V4L2_STD_576P_50        ((v4l2_std_id)(0x0010000000000000ULL))
> +#define V4L2_STD_720P_25        ((v4l2_std_id)(0x0020000000000000ULL))
> +#define V4L2_STD_720P_30        ((v4l2_std_id)(0x0040000000000000ULL))
> +#define V4L2_STD_720P_50        ((v4l2_std_id)(0x0080000000000000ULL))
> +#define V4L2_STD_1080P_25       ((v4l2_std_id)(0x0100000000000000ULL))
> +#define V4L2_STD_1080P_30       ((v4l2_std_id)(0x0200000000000000ULL))
> +#define V4L2_STD_1080P_24       ((v4l2_std_id)(0x0400000000000000ULL))
> +
>  struct v4l2_standard {
>  	__u32		     index;
>  	v4l2_std_id          id;

This requires an RFC. I'm not convinced that using v4l2_std_id is the best
approach. If you look at the CEA-861-D you see a lot more standards (and E
adds even more). Not to mention that when the DM646x is used in combination
with e.g. an FPGA then it should be possible to supply the driver with
custom timings as well. The v4l2_std_id type was never designed for that.

My gut feeling is that v4l2_std_id should be effectively frozen and used for
the old TV broadcast standards only, and that a new API should be created
to setup these digital formats.

I've discussed this with Manju in the past, and I suggest that TI should make
a proposal in the form of an RFC that we can then discuss on the mailinglists.
One of the disadvantages of being the first who needs these HDTV formats. The
advantage of being the first is that you can design it yourself, of course!

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
