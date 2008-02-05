Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m151rmZa004167
	for <video4linux-list@redhat.com>; Mon, 4 Feb 2008 20:53:48 -0500
Received: from rv-out-0910.google.com (rv-out-0910.google.com [209.85.198.185])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m151rBY9011135
	for <video4linux-list@redhat.com>; Mon, 4 Feb 2008 20:53:13 -0500
Received: by rv-out-0910.google.com with SMTP id k15so1722990rvb.51
	for <video4linux-list@redhat.com>; Mon, 04 Feb 2008 17:53:08 -0800 (PST)
Date: Mon, 4 Feb 2008 17:51:38 -0800
From: Brandon Philips <brandon@ifup.org>
To: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Message-ID: <20080205015138.GA9729@plankton.ifup.org>
References: <Pine.LNX.4.64.0801311531440.8478@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801311531440.8478@axis700.grange>
Cc: video4linux-list@redhat.com,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [NAK] Re: [PATCH] Add V4L2_CID_AUTOEXPOSURE control
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

On 15:34 Thu 31 Jan 2008, Guennadi Liakhovetski wrote:
> Add a new AUTOEXPOSURE V4L2 control, will be later used by mt9m001 and 
> mt9v022 camera drivers.

Nak.

I am adding V4L2_CID_EXPOSURE_AUTO to a newly created camera control
class.  The proposed API changes were sent to the list already.  It
hasn't been merged yet because of some discussion, but it will be merged
soon.

You can view the V4L2_CID_EXPOSURE_AUTO change here:
  http://ifup.org/hg/v4l-spec?cmd=changeset;node=88a377fb918b;style=gitweb

And the API changes here:
  http://ifup.org/~philips/review/v4l2-proposed/x784.htm#CAMERA-CLASS

Thanks,

	Brandon

> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
> 
> ---
> 
>  include/linux/videodev2.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 439474f..1e47f1c 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -864,7 +864,8 @@ struct v4l2_querymenu
>  #define V4L2_CID_VFLIP			(V4L2_CID_BASE+21)
>  #define V4L2_CID_HCENTER		(V4L2_CID_BASE+22)
>  #define V4L2_CID_VCENTER		(V4L2_CID_BASE+23)
> -#define V4L2_CID_LASTP1			(V4L2_CID_BASE+24) /* last CID + 1 */
> +#define V4L2_CID_AUTOEXPOSURE		(V4L2_CID_BASE+24)
> +#define V4L2_CID_LASTP1			(V4L2_CID_BASE+25) /* last CID + 1 */

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
