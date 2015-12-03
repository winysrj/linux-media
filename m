Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:37505 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757870AbbLCPQC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Dec 2015 10:16:02 -0500
Subject: Re: [git:media_tree/master] [media] UVC: Add support for ds4 depth
 camera
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greenberg@linuxtv.org, sakari.ailus@linux.intel.com
References: <E1a4Ulw-0006sI-Qq@www.linuxtv.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56605D52.9090600@xs4all.nl>
Date: Thu, 3 Dec 2015 16:18:42 +0100
MIME-Version: 1.0
In-Reply-To: <E1a4Ulw-0006sI-Qq@www.linuxtv.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro, Aviv,

On 12/03/15 14:37, Mauro Carvalho Chehab wrote:
> This is an automatic generated email to let you know that the following patch were queued at the 
> http://git.linuxtv.org/cgit.cgi/media_tree.git tree:
> 
> Subject: [media] UVC: Add support for ds4 depth camera
> Author:  Aviv Greenberg <avivgr@gmail.com>
> Date:    Fri Oct 16 08:48:51 2015 -0300
> 
> Add support for Intel DS4 depth camera in uvc driver.
> This includes adding new uvc GUIDs for the new pixel formats,
> adding new V4L pixel format definition to user api headers,
> and updating the uvc driver GUID-to-4cc tables with the new formats.
> 
> Change-Id: If240d95a7d4edc8dcc3e02d58cd8267a6bbf6fcb
> 
> Tested-by: Greenberg, Aviv D <aviv.d.greenberg@intel.com>
> Signed-off-by: Aviv Greenberg <aviv.d.greenberg@intel.com>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
>  drivers/media/usb/uvc/uvc_driver.c | 20 ++++++++++++++++++++
>  drivers/media/usb/uvc/uvcvideo.h   | 12 ++++++++++++
>  include/uapi/linux/videodev2.h     |  3 +++
>  3 files changed, 35 insertions(+)
> 
> ---
> 
> http://git.linuxtv.org/cgit.cgi/media_tree.git/commit/?id=120c41d3477a23c6941059401db63677736f1935

<snip>

> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index bd2dc9431ac1..0014529606e2 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -621,6 +621,9 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_JPGL	v4l2_fourcc('J', 'P', 'G', 'L') /* JPEG-Lite */
>  #define V4L2_PIX_FMT_SE401      v4l2_fourcc('S', '4', '0', '1') /* se401 janggu compressed rgb */
>  #define V4L2_PIX_FMT_S5C_UYVY_JPG v4l2_fourcc('S', '5', 'C', 'I') /* S5C73M3 interleaved UYVY/JPEG */
> +#define V4L2_PIX_FMT_Y8I      v4l2_fourcc('Y', '8', 'I', ' ') /* Greyscale 8-bit L/R interleaved */
> +#define V4L2_PIX_FMT_Y12I     v4l2_fourcc('Y', '1', '2', 'I') /* Greyscale 12-bit L/R interleaved */
> +#define V4L2_PIX_FMT_Z16      v4l2_fourcc('Z', '1', '6', ' ') /* Depth data 16-bit */
>  
>  /* SDR formats - used only for Software Defined Radio devices */
>  #define V4L2_SDR_FMT_CU8          v4l2_fourcc('C', 'U', '0', '8') /* IQ u8 */

I'm a bit surprised that this got accepted since there is no documentation for these new formats.
Building the DocBook should fail because of that.

Aviv, can you make a patch adding documentation for these new formats? If people don't know
what the format looks like, then it will be really hard to use :-)

Regards,

	Hans
