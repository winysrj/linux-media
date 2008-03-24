Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2O05aWl006596
	for <video4linux-list@redhat.com>; Sun, 23 Mar 2008 20:05:36 -0400
Received: from mailrelay004.isp.belgacom.be (mailrelay004.isp.belgacom.be
	[195.238.6.170])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2O056oN025196
	for <video4linux-list@redhat.com>; Sun, 23 Mar 2008 20:05:06 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Mon, 24 Mar 2008 01:12:16 +0100
References: <d758888cf4a466cd2d44.1206312200@liva.fdsoft.se>
In-Reply-To: <d758888cf4a466cd2d44.1206312200@liva.fdsoft.se>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803240112.16853.laurent.pinchart@skynet.be>
Cc: Frej Drejhammar <frej.drejhammar@gmail.com>,
	Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [PATCH 1 of 6] v4l2-api: Define a standard control for chroma
	AGC
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

On Sunday 23 March 2008, Frej Drejhammar wrote:
> 1 file changed, 3 insertions(+), 1 deletion(-)
> linux/include/linux/videodev2.h |    4 +++-
>
>
> # HG changeset patch
> # User "Frej Drejhammar <frej.drejhammar@gmail.com>"
> # Date 1206311496 -3600
> # Node ID d758888cf4a466cd2d44a54a0a9e9467d72267fa
> # Parent  9a2af878cbd551d1bfac6b19d085a1a83d675a66
> v4l2-api: Define a standard control for chroma AGC

Shouldn't a documentation patch be provided with each new control addition ?

> From: "Frej Drejhammar <frej.drejhammar@gmail.com>"
>
> Define a pre-defined control ID for chroma automatic gain control.
>
> Signed-off-by: "Frej Drejhammar <frej.drejhammar@gmail.com>"
>
> diff -r 9a2af878cbd5 -r d758888cf4a4 linux/include/linux/videodev2.h
> --- a/linux/include/linux/videodev2.h	Sat Mar 22 08:37:19 2008 -0300
> +++ b/linux/include/linux/videodev2.h	Sun Mar 23 23:31:36 2008 +0100
> @@ -879,7 +879,9 @@ enum v4l2_power_line_frequency {
>  #define V4L2_CID_WHITE_BALANCE_TEMPERATURE	(V4L2_CID_BASE+26)
>  #define V4L2_CID_SHARPNESS			(V4L2_CID_BASE+27)
>  #define V4L2_CID_BACKLIGHT_COMPENSATION 	(V4L2_CID_BASE+28)
> -#define V4L2_CID_LASTP1				(V4L2_CID_BASE+29) /* last CID + 1 */
> +#define V4L2_CID_CHROMA_AGC                     (V4L2_CID_BASE+29)
> +/* last CID + 1 */
> +#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+30)
>
>  /*  MPEG-class control IDs defined by V4L2 */
>  #define V4L2_CID_MPEG_BASE 			(V4L2_CTRL_CLASS_MPEG | 0x900)

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
