Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m157GukA020193
	for <video4linux-list@redhat.com>; Tue, 5 Feb 2008 02:16:56 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.1/8.13.1) with SMTP id m157GNOM023201
	for <video4linux-list@redhat.com>; Tue, 5 Feb 2008 02:16:23 -0500
Date: Tue, 5 Feb 2008 08:16:22 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
To: Brandon Philips <brandon@ifup.org>
In-Reply-To: <20080205012451.GA31004@plankton.ifup.org>
Message-ID: <Pine.LNX.4.64.0802050815200.3863@axis700.grange>
References: <20080205012451.GA31004@plankton.ifup.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com,
	v4lm <v4l-dvb-maintainer@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: NACK NACK!  [PATCH] Add two new fourcc codes for 16bpp formats
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

On Mon, 4 Feb 2008, Brandon Philips wrote:

> On 15:31 Thu 31 Jan 2008, Guennadi Liakhovetski wrote:
> > From: Steven Whitehouse <steve@chygwyn.com>
> > 
> > This adds two new fourcc codes (as per info at fourcc.org)
> > for 16bpp mono and 16bpp Bayer formats.
> 
> This patch was merged in the following commit:
>  http://linuxtv.org/hg/v4l-dvb/rev/d002378ff8c2
> 
> I have a number of issues:
>  
> - Why was V4L2_CID_AUTOEXPOSURE added!  I am working to get an auto
>   exposure control into the spec but this was merged without discussion.
>   Please remove this and wait for my patch.
> 
> - Why was a SoC config option added with this commit?
> 
> - mailimport changes in this commit too!  Why is mailimport running
>   sudo!?! 
> 
> A mistake was obviously made here.

Yes, strange. In the original patch

http://marc.info/?l=linux-video&m=120179045830566&w=2

it was still ok.

Thanks
Guennadi

> 
> 	Brandon
> 
> 
> --- a/linux/drivers/media/video/Kconfig	Sun Jan 27 17:24:26 2008 +0000
> +++ b/linux/drivers/media/video/Kconfig	Mon Feb 04 16:32:42 2008 -0200
> @@ -836,4 +836,13 @@ config USB_STKWEBCAM
>  
>  endif # V4L_USB_DRIVERS
>  
> +config SOC_CAMERA
> +	tristate "SoC camera support"
> +	depends on VIDEO_V4L2
> +	select VIDEOBUF_DMA_SG
> +	help
> +	  SoC Camera is a common API to several cameras, not connecting
> +	  over a bus like PCI or USB. For example some i2c camera connected
> +	  directly to the data bus of an SoC.
> +
>  endif # VIDEO_CAPTURE_DRIVERS
> --- a/linux/include/linux/videodev2.h	Sun Jan 27 17:24:26 2008 +0000
> +++ b/linux/include/linux/videodev2.h	Mon Feb 04 16:32:42 2008 -0200
> @@ -281,6 +281,7 @@ struct v4l2_pix_format
>  #define V4L2_PIX_FMT_BGR32   v4l2_fourcc('B','G','R','4') /* 32  BGR-8-8-8-8   */
>  #define V4L2_PIX_FMT_RGB32   v4l2_fourcc('R','G','B','4') /* 32  RGB-8-8-8-8   */
>  #define V4L2_PIX_FMT_GREY    v4l2_fourcc('G','R','E','Y') /*  8  Greyscale     */
> +#define V4L2_PIX_FMT_Y16     v4l2_fourcc('Y','1','6',' ') /* 16  Greyscale     */
>  #define V4L2_PIX_FMT_PAL8    v4l2_fourcc('P','A','L','8') /*  8  8-bit palette */
>  #define V4L2_PIX_FMT_YVU410  v4l2_fourcc('Y','V','U','9') /*  9  YVU 4:1:0     */
>  #define V4L2_PIX_FMT_YVU420  v4l2_fourcc('Y','V','1','2') /* 12  YVU 4:2:0     */
> @@ -307,6 +308,7 @@ struct v4l2_pix_format
>  
>  /* see http://www.siliconimaging.com/RGB%20Bayer.htm */
>  #define V4L2_PIX_FMT_SBGGR8  v4l2_fourcc('B','A','8','1') /*  8  BGBG.. GRGR.. */
> +#define V4L2_PIX_FMT_SBGGR16 v4l2_fourcc('B','Y','R','2') /* 16  BGBG.. GRGR.. */
>  
>  /* compressed formats */
>  #define V4L2_PIX_FMT_MJPEG    v4l2_fourcc('M','J','P','G') /* Motion-JPEG   */
> @@ -862,7 +864,8 @@ struct v4l2_querymenu
>  #define V4L2_CID_VFLIP			(V4L2_CID_BASE+21)
>  #define V4L2_CID_HCENTER		(V4L2_CID_BASE+22)
>  #define V4L2_CID_VCENTER		(V4L2_CID_BASE+23)
> -#define V4L2_CID_LASTP1			(V4L2_CID_BASE+24) /* last CID + 1 */
> +#define V4L2_CID_AUTOEXPOSURE		(V4L2_CID_BASE+24)
> +#define V4L2_CID_LASTP1			(V4L2_CID_BASE+25) /* last CID + 1 */
>  
>  /*  MPEG-class control IDs defined by V4L2 */
>  #define V4L2_CID_MPEG_BASE 			(V4L2_CTRL_CLASS_MPEG | 0x900)
> --- a/mailimport	Sun Jan 27 17:24:26 2008 +0000
> +++ b/mailimport	Mon Feb 04 16:32:42 2008 -0200
> @@ -224,6 +224,10 @@ if [ -d "$NAME" ]; then
>  	else
>  		echo "Processing patches from tree $NAME"
>  		for i in $NAME/*; do
> +			if [ ! -r $i ]; then
> +				sudo chmod og+r $i
> +			fi
> +
>  			echo "$i"
>  			proccess_patch "$i"
>  		done
> 

---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
